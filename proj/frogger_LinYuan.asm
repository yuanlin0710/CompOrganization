#####################################################################
#
# CSC258H5S Fall 2021 Assembly Final Project
# University of Toronto, St. George
#
# Student: Lin Yuan, 1008690203
#
# Bitmap Display Configuration:
# - Unit width in pixels: 1
# - Unit height in pixels: 1
# - Display width in pixels: 256
# - Display height in pixels: 256
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestone is reached in this submission?
# (See the assignment handout for descriptions of the milestones)
# - Milestone 5 (choose the one the applies)
#
# Which approved additional features have been implemented?
# (See the assignment handout for the list of additional features)
# 1. Have objects in different rows move at different speeds. (Easy Feature)
# 2. Display the number of lives remaining (Easy)
# 3. Add a third row in each of the water and road sections. £¨Easy£©
# 4. Add sound effects for movement,collisions, game end and reaching the goal area. £¨Hard£©
# 5. Display the player¡¯s score at the top of the screen. (Hard)
#3E + 2H features totally finished
# if you like my design for the frog, then you can also treat "Make objects (frog, logs, turtles, vehicles, etc) look more like the arcade version." partially finished (though it is a really small part :D)

# ... (add more if necessary)
#
# Any additional information that the TA needs to know:
# - (write here, if any)
# Wish you have a nice day~
#####################################################################
.data
displayAddress: .word 0x10008000
frogPosition: .word 197056
# record the topleft coordinate of frog

wt1parameter1: .word 81920
wt1parameter2: .word 81984
wt1parameter3: .word 82368
wt1parameter4: .word 82432
wt1parameter5: .word 82880
wt2parameter1: .word 98304
wt2parameter2: .word 98432
wt2parameter3: .word 98496
wt2parameter4: .word 98624
wt3parameter1: .word 114688
wt3parameter2: .word 114752
wt3parameter3: .word 114816
wt3parameter4: .word 115072

rd1parameter1: .word 147456
rd1parameter2: .word 147520
rd1parameter3: .word 148096
rd1parameter4: .word 148160
rd2parameter1: .word 163840
rd2parameter2: .word 164800
rd2parameter3: .word 164672
rd2parameter4: .word 164608
rd3parameter1: .word 180224
rd3parameter2: .word 180288
rd3parameter3: .word 180352
rd3parameter4: .word 180608
life: .word 3
updateCounter1: .word 25
updateCounter2: .word 10
updateCounter3: .word 3
score: .word 0
printlifeparameter: .word 213056
scoreleft: .word 640
scoremiddle: .word 768
scoreright: .word 896


goalblock1: .word 49152
goalblock2: .word 49216
goalblock3: .word 49280
goalblock4: .word 49344
goalblock5: .word 49408
goalblock6: .word 49472
goalblock7: .word 49536
goalblock8: .word 49600
goalblock9: .word 49664
goalblock10: .word 49728
goalblock11: .word 49792
goalblock12: .word 49856
goalblock13: .word 49920
goalblock14: .word 49984
goalblock15: .word 50048
goalblock16: .word 50112


.text
lw $t0, displayAddress # $t0 stores the base address for display

Main:
DrawScreen:
lw $t8, 0xffff0000
bne $t8, 1, KeyboardEndOfResponse
lw $t9, 0xffff0004
beq $t9, 0x61, RespondToA
beq $t9, 0x64, RespondToD
beq $t9, 0x77, RespondToW
beq $t9, 0x73, RespondToS
KeyboardEndOfResponse: li $t8, 0 

Dectection:
#collision -- reset the position and -1 to life, else not change
collisionDetect:
lw $t1, frogPosition
add $t2, $t1, $t0
lw $t3, 0($t2)

#if frogposition = blue, then collision happens
beq $t3, 0x3399ff, collisionOperation
#if frogposition = car position, collision happens
lw $t5, rd1parameter1
beq $t1, $t5, collisionOperation
lw $t5, rd1parameter2
beq $t1, $t5, collisionOperation
lw $t5, rd1parameter3
beq $t1, $t5, collisionOperation
lw $t5, rd1parameter4
beq $t1, $t5, collisionOperation
lw $t5, rd2parameter1
beq $t1, $t5, collisionOperation
lw $t5, rd2parameter2
beq $t1, $t5, collisionOperation
lw $t5, rd2parameter3
beq $t1, $t5, collisionOperation
lw $t5, rd2parameter4
beq $t1, $t5, collisionOperation
lw $t5, rd3parameter1
beq $t1, $t5, collisionOperation
lw $t5, rd3parameter2
beq $t1, $t5, collisionOperation
lw $t5, rd3parameter3
beq $t1, $t5, collisionOperation
lw $t5, rd3parameter4
beq $t1, $t5, collisionOperation

j collisionDetectEnd

collisionOperation:
lw $t4, life
addi $t4, $t4, -1 
sw $t4, life #store the updated life value

lw $t4 frogPosition
addi $t4, $zero, 197056
sw $t4, frogPosition #make frog at starting position again

li $v0, 31 
li $a0, 65
li $a1, 300
li $a2, 16
li $a3, 100
syscall

li $v0, 31 
li $a0, 64
li $a1, 300
li $a2, 16
li $a3, 100
syscall


collisionDetectEnd:

#reachtop -- also should reset the position but will not -1 to life, and have a 16*16 block(black) on the reaching position to prevent a second frog reaching here
ReachtopDetect:
lw $t1, frogPosition
add $t2, $t1, $t0  #real address
lw $t3, 0($t2)
beq $t3, 0x66ff66, ReachtopOperation
j ReachtopDetectEnd

ReachtopOperation:

#this is for score addition
lw $t4, score
addi $t4, $t4, 10
sw $t4, score

#this is for having the sound effects
li $v0, 31 
li $a0, 62
li $a1, 500
li $a2, 16
li $a3, 100
syscall

li $v0, 31
li $a0, 66
li $a1, 500
li $a2, 16
li $a3, 100
syscall

li $v0, 31 
li $a0, 69
li $a1, 500
li $a2, 16
li $a3, 100
syscall

li $v0, 31 
li $a0, 74
li $a1, 500
li $a2, 16
li $a3, 100
syscall

addi $t4, $t1, -16384
lw $t5, goalblock1
beq $t4, $t5, UDB1
lw $t5, goalblock2
beq $t4, $t5, UDB2
lw $t5, goalblock3
beq $t4, $t5, UDB3
lw $t5, goalblock4
beq $t4, $t5, UDB4
lw $t5, goalblock5
beq $t4, $t5, UDB5
lw $t5, goalblock6
beq $t4, $t5, UDB6
lw $t5, goalblock7
beq $t4, $t5, UDB7
lw $t5, goalblock8
beq $t4, $t5, UDB8
lw $t5, goalblock9
beq $t4, $t5, UDB9
lw $t5, goalblock10
beq $t4, $t5, UDB10
lw $t5, goalblock11
beq $t4, $t5, UDB11
lw $t5, goalblock12
beq $t4, $t5, UDB12
lw $t5, goalblock13
beq $t4, $t5, UDB13
lw $t5, goalblock14
beq $t4, $t5, UDB14
lw $t5, goalblock15
beq $t4, $t5, UDB15
lw $t5, goalblock16
beq $t4, $t5, UDB16



UDB1:
addi $t5, $t5, 16384
sw $t5, goalblock1
j UDBend
UDB2:
addi $t5, $t5, 16384
sw $t5, goalblock2
j UDBend
UDB3:
addi $t5, $t5, 16384
sw $t5, goalblock3
j UDBend
UDB4:
addi $t5, $t5, 16384
sw $t5, goalblock4
j UDBend
UDB5:
addi $t5, $t5, 16384
sw $t5, goalblock5
j UDBend
UDB6:
addi $t5, $t5, 16384
sw $t5, goalblock6
j UDBend
UDB7:
addi $t5, $t5, 16384
sw $t5, goalblock7
j UDBend
UDB8:
addi $t5, $t5, 16384
sw $t5, goalblock8
j UDBend
UDB9:
addi $t5, $t5, 16384
sw $t5, goalblock9
j UDBend
UDB10:
addi $t5, $t5, 16384
sw $t5, goalblock10
j UDBend
UDB11:
addi $t5, $t5, 16384
sw $t5, goalblock11
j UDBend
UDB12:
addi $t5, $t5, 16384
sw $t5, goalblock12
j UDBend
UDB13:
addi $t5, $t5, 16384
sw $t5, goalblock13
j UDBend
UDB14:
addi $t5, $t5, 16384
sw $t5, goalblock14
j UDBend
UDB15:
addi $t5, $t5, 16384
sw $t5, goalblock15
j UDBend
UDB16:
addi $t5, $t5, 16384
sw $t5, goalblock16

UDBend:

addi $t7, $zero, 197056
sw $t7, frogPosition
ReachtopDetectEnd:

#detection end




ObjectPositionUpdate:
#Frog Update If On Log
FrogOnLogUpdate:
lw $t1, frogPosition #get the frog position
#see whether it matches with any of the log position
lw $t2, wt1parameter1
beq $t1, $t2, FrogOnLogUpdate1
lw $t2, wt1parameter2
beq $t1, $t2, FrogOnLogUpdate1
lw $t2, wt1parameter3
beq $t1, $t2, FrogOnLogUpdate1
lw $t2, wt1parameter4
beq $t1, $t2, FrogOnLogUpdate1
lw $t2, wt1parameter5
beq $t1, $t2, FrogOnLogUpdate1

lw $t2, wt2parameter1
beq $t1, $t2, FrogOnLogUpdate2
lw $t2, wt2parameter2
beq $t1, $t2, FrogOnLogUpdate2
lw $t2, wt2parameter3
beq $t1, $t2, FrogOnLogUpdate2
lw $t2, wt2parameter4
beq $t1, $t2, FrogOnLogUpdate2

lw $t2, wt3parameter1
beq $t1, $t2, FrogOnLogUpdate3
lw $t2, wt3parameter2
beq $t1, $t2, FrogOnLogUpdate3
lw $t2, wt3parameter3
beq $t1, $t2, FrogOnLogUpdate3
lw $t2, wt3parameter4
beq $t1, $t2, FrogOnLogUpdate3
#if on log, jump to the operation of update

j FrogOnLogUpdateEnd #if not on any log, jump to the end

FrogOnLogUpdate1:
lw $t5, updateCounter1
bne $t5, 0, FOLU1End
#$a2 store for the block parameter, $v1 store for the updated parameter (to return)
lw $a2, frogPosition
jal UpdateLeft
sw $v1, frogPosition
FOLU1End: j FrogOnLogUpdateEnd

FrogOnLogUpdate2:
lw $t5, updateCounter2
bne $t5, 0, FOLU2End
lw $a2, frogPosition
jal UpdateRight
sw $v1, frogPosition
FOLU2End: j FrogOnLogUpdateEnd


FrogOnLogUpdate3:
lw $t5, updateCounter3
bne $t5, 0, FOLU3End
lw $a2, frogPosition
jal UpdateLeft
sw $v1, frogPosition
FOLU3End: 

FrogOnLogUpdateEnd:


#BlockUpdate
#waterroadlane1
WtRd1St:
lw $t7, updateCounter1
bne $t7, 0, WtRd1End
#$a2 store for the block parameter, $v1 store for the updated parameter (to return)
lw $a2, wt1parameter1
jal UpdateLeft
sw $v1, wt1parameter1
lw $a2, wt1parameter2
jal UpdateLeft
sw $v1, wt1parameter2
lw $a2, wt1parameter3
jal UpdateLeft
sw $v1, wt1parameter3
lw $a2, wt1parameter4
jal UpdateLeft
sw $v1, wt1parameter4
lw $a2, wt1parameter5
jal UpdateLeft
sw $v1, wt1parameter5

lw $a2, rd1parameter1
jal UpdateLeft
sw $v1, rd1parameter1
lw $a2, rd1parameter2
jal UpdateLeft
sw $v1, rd1parameter2
lw $a2, rd1parameter3
jal UpdateLeft
sw $v1, rd1parameter3
lw $a2, rd1parameter4
jal UpdateLeft
sw $v1, rd1parameter4
addi $t7, $zero, 26

WtRd1End: 
addi $t7, $t7, -1
sw $t7, updateCounter1


#water&roadlane2
WtRd2St:
lw $t7, updateCounter2
bne $t7, 0, WtRd2End

lw $a2, wt2parameter1
jal UpdateRight
sw $v1, wt2parameter1
lw $a2, wt2parameter2
jal UpdateRight
sw $v1, wt2parameter2
lw $a2, wt2parameter3
jal UpdateRight
sw $v1, wt2parameter3
lw $a2, wt2parameter4
jal UpdateRight
sw $v1, wt2parameter4

lw $a2, rd2parameter1
jal UpdateRight
sw $v1, rd2parameter1
lw $a2, rd2parameter2
jal UpdateRight
sw $v1, rd2parameter2
lw $a2, rd2parameter3
jal UpdateRight
sw $v1, rd2parameter3
lw $a2, rd2parameter4
jal UpdateRight
sw $v1, rd2parameter4

add $t7, $zero, 11
WtRd2End: addi $t7, $t7, -1
sw $t7, updateCounter2


#water&roadlane3
WtRd3St:
lw $t7, updateCounter3
bne $t7, 0, WtRd3End


lw $a2, wt3parameter1
jal UpdateLeft
sw $v1, wt3parameter1
lw $a2, wt3parameter2
jal UpdateLeft
sw $v1, wt3parameter2
lw $a2, wt3parameter3
jal UpdateLeft
sw $v1, wt3parameter3
lw $a2, wt3parameter4
jal UpdateLeft
sw $v1, wt3parameter4

lw $a2, rd3parameter1
jal UpdateLeft
sw $v1, rd3parameter1
lw $a2, rd3parameter2
jal UpdateLeft
sw $v1, rd3parameter2
lw $a2, rd3parameter3
jal UpdateLeft
sw $v1, rd3parameter3
lw $a2, rd3parameter4
jal UpdateLeft
sw $v1, rd3parameter4


add $t7, $zero, 4
WtRd3End: addi $t7, $t7, -1
sw $t7, updateCounter3




PrintBackground: 
li $a0, 0x000000 # $a0 stores the colour code
addi $a1, $t0, 0 #$a1 stores the address of current lane for painting
jal PrintLane
li $a0, 0x000000 # $a0 stores the colour code - green
addi $a1, $t0, 16384 #$a1 stores the address of current lane for painting
jal PrintLane


li $a0, 0x66ff66 # $a0 stores the colour code - green
addi $a1, $t0, 65536 #$a1 stores the address of current lane for painting
jal PrintLane
addi $a1, $a1, 16384
li $a0, 0x3399ff #blue - water 1
jal PrintLane 
addi $a1, $a1, 16384
li $a0, 0x3399ff #blue - water 2
jal PrintLane 
addi $a1, $a1, 16384
li $a0, 0x3399ff #blue -water 3
jal PrintLane 
addi $a1, $a1, 16384
li $a0, 0xb266ff #purple
jal PrintLane 
addi $a1, $a1, 16384
li $a0, 0x994c00 #brown
jal PrintLane 
addi $a1, $a1, 16384
li $a0, 0x994c00 #brown
jal PrintLane 
addi $a1, $a1, 16384
li $a0, 0x994c00 #brown
jal PrintLane 
addi $a1, $a1, 16384
li $a0, 0xb266ff #purple
jal PrintLane
addi $a1, $a1, 16384
li $a0, 0x000000 #black
jal PrintLane
addi $a1, $a1, 16384
li $a0, 0x000000 #black
jal PrintLane
addi $a1, $a1, 16384
li $a0, 0x000000 #black
jal PrintLane


PrintObject:
#this is for printing all objects (logs and cars) on the screen
lw $t1, wt1parameter1
add $t1, $t1, $t0
addi $a0, $zero, 0x664228
add $a1, $t1, $zero
jal PrintBlock
#PrintBlock function - $a0 for color to paint, $a1 for address of lefttop corner
lw $t1, wt1parameter2
add $t1, $t1, $t0
addi $a0, $zero, 0x664228
add $a1, $t1, $zero
jal PrintBlock
lw $t1, wt1parameter3
add $t1, $t1, $t0
addi $a0, $zero, 0x664228
add $a1, $t1, $zero
jal PrintBlock
lw $t1, wt1parameter4
add $t1, $t1, $t0
addi $a0, $zero, 0x664228
add $a1, $t1, $zero
jal PrintBlock
lw $t1, wt1parameter5
add $t1, $t1, $t0
addi $a0, $zero, 0x664228
add $a1, $t1, $zero
jal PrintBlock

lw $t1, wt2parameter1
add $t1, $t1, $t0
addi $a0, $zero, 0x664228
add $a1, $t1, $zero
jal PrintBlock
lw $t1, wt2parameter2
add $t1, $t1, $t0
addi $a0, $zero, 0x664228
add $a1, $t1, $zero
jal PrintBlock
lw $t1, wt2parameter3
add $t1, $t1, $t0
addi $a0, $zero, 0x664228
add $a1, $t1, $zero
jal PrintBlock
lw $t1, wt2parameter4
add $t1, $t1, $t0
addi $a0, $zero, 0x664228
add $a1, $t1, $zero
jal PrintBlock

lw $t1, wt3parameter1
add $t1, $t1, $t0
addi $a0, $zero, 0x664228
add $a1, $t1, $zero
jal PrintBlock
lw $t1, wt3parameter2
add $t1, $t1, $t0
addi $a0, $zero, 0x664228
add $a1, $t1, $zero
jal PrintBlock
lw $t1, wt3parameter3
add $t1, $t1, $t0
addi $a0, $zero, 0x664228
add $a1, $t1, $zero
jal PrintBlock
lw $t1, wt3parameter4
add $t1, $t1, $t0
addi $a0, $zero, 0x664228
add $a1, $t1, $zero
jal PrintBlock


lw $t1, rd1parameter1
add $t1, $t1, $t0
addi $a0, $zero, 0xffff00
add $a1, $t1, $zero
jal PrintBlock
lw $t1, rd1parameter2
add $t1, $t1, $t0
addi $a0, $zero, 0xffff00
add $a1, $t1, $zero
jal PrintBlock
lw $t1, rd1parameter3
add $t1, $t1, $t0
addi $a0, $zero, 0xffff00
add $a1, $t1, $zero
jal PrintBlock
lw $t1, rd1parameter4
add $t1, $t1, $t0
addi $a0, $zero, 0xffff00
add $a1, $t1, $zero
jal PrintBlock

lw $t1, rd2parameter1
add $t1, $t1, $t0
addi $a0, $zero, 0xffff00
add $a1, $t1, $zero
jal PrintBlock
lw $t1, rd2parameter2
add $t1, $t1, $t0
addi $a0, $zero, 0xffff00
add $a1, $t1, $zero
jal PrintBlock
lw $t1, rd2parameter3
add $t1, $t1, $t0
addi $a0, $zero, 0xffff00
add $a1, $t1, $zero
jal PrintBlock
lw $t1, rd2parameter4
add $t1, $t1, $t0
addi $a0, $zero, 0xffff00
add $a1, $t1, $zero
jal PrintBlock

lw $t1, rd3parameter1
add $t1, $t1, $t0
addi $a0, $zero, 0xffff00
add $a1, $t1, $zero
jal PrintBlock
lw $t1, rd3parameter2
add $t1, $t1, $t0
addi $a0, $zero, 0xffff00
add $a1, $t1, $zero
jal PrintBlock
lw $t1, rd3parameter3
add $t1, $t1, $t0
addi $a0, $zero, 0xffff00
add $a1, $t1, $zero
jal PrintBlock
lw $t1, rd3parameter4
add $t1, $t1, $t0
addi $a0, $zero, 0xffff00
add $a1, $t1, $zero
jal PrintBlock
#all things above are for drawing logs or cars

lw $t1, goalblock1
add $t1, $t1, $t0
addi $a0, $zero, 0x000000
add $a1, $t1, $zero
jal PrintBlock

lw $t1, goalblock2
add $t1, $t1, $t0
addi $a0, $zero, 0x000000
add $a1, $t1, $zero
jal PrintBlock
lw $t1, goalblock3
add $t1, $t1, $t0
addi $a0, $zero, 0x000000
add $a1, $t1, $zero
jal PrintBlock
lw $t1, goalblock4
add $t1, $t1, $t0
addi $a0, $zero, 0x000000
add $a1, $t1, $zero
jal PrintBlock
lw $t1, goalblock5
add $t1, $t1, $t0
addi $a0, $zero, 0x000000
add $a1, $t1, $zero
jal PrintBlock
lw $t1, goalblock6
add $t1, $t1, $t0
addi $a0, $zero, 0x000000
add $a1, $t1, $zero
jal PrintBlock
lw $t1, goalblock7
add $t1, $t1, $t0
addi $a0, $zero, 0x000000
add $a1, $t1, $zero
jal PrintBlock
lw $t1, goalblock8
add $t1, $t1, $t0
addi $a0, $zero, 0x000000
add $a1, $t1, $zero
jal PrintBlock
lw $t1, goalblock9
add $t1, $t1, $t0
addi $a0, $zero, 0x000000
add $a1, $t1, $zero
jal PrintBlock
lw $t1, goalblock10
add $t1, $t1, $t0
addi $a0, $zero, 0x000000
add $a1, $t1, $zero
jal PrintBlock
lw $t1, goalblock11
add $t1, $t1, $t0
addi $a0, $zero, 0x000000
add $a1, $t1, $zero
jal PrintBlock
lw $t1, goalblock12
add $t1, $t1, $t0
addi $a0, $zero, 0x000000
add $a1, $t1, $zero
jal PrintBlock
lw $t1, goalblock13
add $t1, $t1, $t0
addi $a0, $zero, 0x000000
add $a1, $t1, $zero
jal PrintBlock
lw $t1, goalblock14
add $t1, $t1, $t0
addi $a0, $zero, 0x000000
add $a1, $t1, $zero
jal PrintBlock
lw $t1, goalblock15
add $t1, $t1, $t0
addi $a0, $zero, 0x000000
add $a1, $t1, $zero
jal PrintBlock
lw $t1, goalblock16
add $t1, $t1, $t0
addi $a0, $zero, 0x000000
add $a1, $t1, $zero
jal PrintBlock

#codes above are for drawing the blocking in goal region if there has been a frog there

PrintFrog:
lw $t1, frogPosition
add $t3, $t0, $t1 #$t3 for coordinate of frog(topleft corner), $t1/2 for calculation intermediate,$t4 for colour
li $t4, 0x000000 #$a0 stores the colour code - white
sw $t4, 0($t3) #white colour for drawing the frog's eyes
sw $t4, 4($t3)
sw $t4, 8($t3)
sw $t4, 12($t3)
sw $t4, 16($t3)

sw $t4, 44($t3)
sw $t4, 48($t3)
sw $t4, 52($t3)
sw $t4, 56($t3)
sw $t4, 60($t3)

li $t4, 0x000000
sw $t4, 1024($t3)
li $t4, 0xffffff
sw $t4, 1028($t3)
sw $t4, 1032($t3)
sw $t4, 1036($t3)
li $t4, 0x000000
sw $t4, 1040($t3)
sw $t4, 1068($t3)
li $t4, 0xffffff
sw $t4, 1072($t3)
sw $t4, 1076($t3)
sw $t4, 1080($t3)
li $t4, 0x000000
sw $t4, 1084($t3)


sw $t4, 2048($t3)
li $t4, 0xffffff
sw $t4, 2052($t3)
li $t4, 0x000000 #black for drawing the pupils of frog eyes
sw $t4, 2056($t3)
li $t4, 0xffffff
sw $t4, 2060($t3)
li $t4, 0x000000
sw $t4, 2064($t3)
sw $t4, 2092($t3)
li $t4, 0xffffff
sw $t4, 2096($t3)
li $t4, 0x000000
sw $t4, 2100($t3)
li $t4, 0xffffff
sw $t4, 2104($t3)
li $t4, 0x000000
sw $t4, 2108($t3)

sw $t4, 3072($t3)
li $t4, 0xffffff
sw $t4, 3076($t3)
sw $t4, 3080($t3)
sw $t4, 3084($t3)
li $t4, 0x000000
sw $t4, 3088($t3)
sw $t4, 3116($t3)
li $t4, 0xffffff
sw $t4, 3120($t3)
sw $t4, 3124($t3)
sw $t4, 3128($t3)
li $t4, 0x000000
sw $t4, 3132($t3)


sw $t4, 4096($t3)
sw $t4, 4100($t3)
sw $t4, 4104($t3)
sw $t4, 4108($t3)
sw $t4, 4112($t3)
sw $t4, 4140($t3)
sw $t4, 4144($t3)
sw $t4, 4148($t3)
sw $t4, 4152($t3)
sw $t4, 4156($t3)

addi $a1, $t3, 5120
li $a0, 0x008000 # $stores the colour code - green for drawing frog's body
#$a0 for color to paint, $a1 for address of lefttop corner, 
jal PrintHelper
addi $a1, $a1, 1024
jal PrintHelper
addi $a1, $a1, 1024
jal PrintHelper
addi $a1, $a1, 1024
jal PrintHelper
addi $a1, $a1, 1024
jal PrintHelper
addi $a1, $a1, 1024
jal PrintHelper
addi $a1, $a1, 1024
jal PrintHelper
addi $a1, $a1, 1024
jal PrintHelper
addi $a1, $a1, 1024
jal PrintHelper
addi $a1, $a1, 1024
jal PrintHelper
addi $a1, $a1, 1024
jal PrintHelper


li $t4, 0x000000
sw $t4, 5120($t3)
sw $t4, 5124($t3)
sw $t4, 5128($t3)
sw $t4, 5172($t3)
sw $t4, 5176($t3)
sw $t4, 5180($t3)
sw $t4, 6144($t3)
sw $t4, 6148($t3)
sw $t4, 6200($t3)
sw $t4, 6204($t3)
sw $t4, 7168($t3)
sw $t4, 7228($t3)

sw $t4, 12316($t3)
sw $t4, 12320($t3)


sw $t4, 13312($t3)
sw $t4, 13372($t3)
sw $t4, 14336($t3)
sw $t4, 14340($t3)
sw $t4, 14392($t3)
sw $t4, 14396($t3)
sw $t4, 15360($t3)
sw $t4, 15364($t3)
sw $t4, 15368($t3)
sw $t4, 15412($t3)
sw $t4, 15416($t3)
sw $t4, 15420($t3)
#all things above are for drawing my frog

PrintLife:
lw $t7, life
addi $a0, $zero, 0xffffff

#$a0 for color to paint, $a1 for address of lefttop corner
beq $t7, 0, PrintLife0
beq $t7, 1, PrintLife1
beq $t7, 2, PrintLife2
beq $t7, 3, PrintLife3
j PrintLifeEnd


PrintLife0:
#$a3 indicate the relative address of the topleft corner of the whole number display
lw $a3, printlifeparameter
jal Print0
j PrintLifeEnd

PrintLife1:
lw $a3, printlifeparameter
jal Print1
#$a3 indicate the relative address of the topleft corner of the whole number display
j PrintLifeEnd
PrintLife2:
lw $a3, printlifeparameter
jal Print2
j PrintLifeEnd
PrintLife3:
lw $a3, printlifeparameter
jal Print3

PrintLifeEnd:


PrintScore:

lw $t1, score
div $t2, $t1, 100 #$t2 stores the hundred digit
rem  $t1, $t1, 100
div $t3, $t1, 10 #$t3 stores the ten digit
rem $t4, $t1, 10 #$t4 store the one digit

LeftDig:
beq $t2, 0, LeftDig0
beq $t2, 1, LeftDig1
beq $t2, 2, LeftDig2
beq $t2, 3, LeftDig3
beq $t2, 4, LeftDig4
beq $t2, 5, LeftDig5
beq $t2, 6, LeftDig6
beq $t2, 7, LeftDig7
beq $t2, 8, LeftDig8
beq $t2, 9, LeftDig9
j LeftDigEnd


LeftDig0:
lw $a3, scoreleft
jal Print0
j LeftDigEnd

LeftDig1:
lw $a3, scoreleft
jal Print1
j LeftDigEnd

LeftDig2:
lw $a3, scoreleft
jal Print2
j LeftDigEnd

LeftDig3:
lw $a3, scoreleft
jal Print3
j LeftDigEnd

LeftDig4:
lw $a3, scoreleft
jal Print4
j LeftDigEnd

LeftDig5:
lw $a3, scoreleft
jal Print5
j LeftDigEnd
LeftDig6:
lw $a3, scoreleft
jal Print6
j LeftDigEnd
LeftDig7:
lw $a3, scoreleft
jal Print7
j LeftDigEnd
LeftDig8:
lw $a3, scoreleft
jal Print8
j LeftDigEnd
LeftDig9:
lw $a3, scoreleft
jal Print9

LeftDigEnd:


MidDig:
beq $t3, 0, MidDig0
beq $t3, 1, MidDig1
beq $t3, 2, MidDig2
beq $t3, 3, MidDig3
beq $t3, 4, MidDig4
beq $t3, 5, MidDig5
beq $t3, 6, MidDig6
beq $t3, 7, MidDig7
beq $t3, 8, MidDig8
beq $t3, 9, MidDig9
j MidDigEnd


MidDig0:
lw $a3, scoremiddle
jal Print0
j MidDigEnd
MidDig1:
lw $a3, scoremiddle
jal Print1
j MidDigEnd
MidDig2:
lw $a3, scoremiddle
jal Print2
j MidDigEnd
MidDig3:
lw $a3, scoremiddle
jal Print3
j MidDigEnd

MidDig4:
lw $a3, scoremiddle
jal Print4
j MidDigEnd
MidDig5:
lw $a3, scoremiddle
jal Print5
j MidDigEnd
MidDig6:
lw $a3, scoremiddle
jal Print6
j MidDigEnd
MidDig7:
lw $a3, scoremiddle
jal Print7
j MidDigEnd
MidDig8:
lw $a3, scoremiddle
jal Print8
j MidDigEnd
MidDig9:
lw $a3, scoremiddle
jal Print9

MidDigEnd:

RightDig:
beq $t4, 0, RightDig0
beq $t4, 1, RightDig1
beq $t4, 2, RightDig2
beq $t4, 3, RightDig3
beq $t4, 4, RightDig4
beq $t4, 5, RightDig5
beq $t4, 6, RightDig6
beq $t4, 7, RightDig7
beq $t4, 8, RightDig8
beq $t4, 9, RightDig9
j RightDigEnd


RightDig0:
lw $a3, scoreright
jal Print0
j RightDigEnd
RightDig1:
lw $a3, scoreright
jal Print1
j RightDigEnd
RightDig2:
lw $a3, scoreright
jal Print2
j RightDigEnd
RightDig3:
lw $a3, scoreright
jal Print3
j RightDigEnd
RightDig4:
lw $a3, scoreright
jal Print4
j RightDigEnd
RightDig5:
lw $a3, scoreright
jal Print5
j RightDigEnd
RightDig6:
lw $a3, scoreright
jal Print6
j RightDigEnd
RightDig7:
lw $a3, scoreright
jal Print7
j RightDigEnd
RightDig8:
lw $a3, scoreright
jal Print8
j RightDigEnd
RightDig9:
lw $a3, scoreright
jal Print9

RightDigEnd:

PrintScoreEnd:



Sleep:
li $v0, 32
li $a0, 15 
syscall




lw $t7, life
beq $t7, 0, Exit #judge whether to leave the game or not
j DrawScreen




Exit:

li $v0, 33 
li $a0, 74
li $a1, 500
li $a2, 16
li $a3, 100
syscall

li $v0, 33
li $a0, 69
li $a1, 500
li $a2, 16
li $a3, 100
syscall

li $v0, 33 
li $a0, 66
li $a1, 500
li $a2, 16
li $a3, 100
syscall

li $v0, 33 
li $a0, 62
li $a1, 500
li $a2, 16
li $a3, 100
syscall

li $v0, 10 # terminate the program gracefully
syscall







PrintLane: #$a0 for color to paint, $a1 for address of lefttop corner
add $t1, $a1, $zero #$t1 stores current address to paint
addi $t2, $a1, 16384
PrintLaneLoop1Start: beq $t1, $t2, PrintLaneLoop1End #while address < 16384, continue painting the pixel with the colour given
sw $a0, 0($t1)
addi $t1, $t1, 4
j PrintLaneLoop1Start
PrintLaneLoop1End: jr $ra


PrintBlock: #$a0 for color to paint, $a1 for address of lefttop corner
add $t1, $a1, $zero
addi $t2, $a1, 16384
PrintBlockYloopSt: 
beq $t1, $t2, PrintBlockYloopEnd
addi $t3, $t1, 64
PrintBlockXloopSt: 
beq $t1, $t3, PrintBlockXloopEnd
sw $a0, 0($t1)
addi $t1, $t1, 4
j PrintBlockXloopSt
PrintBlockXloopEnd: 
addi $t1, $t1, 960
j PrintBlockYloopSt
PrintBlockYloopEnd: 
jr $ra


PrintHelper: #$a0 for color to paint, $a1 for address of lefttop corner, print a 16-pixel band of given colour
add $t5, $a1, $zero #$t5 stores current address to paint
addi $t6, $a1, 64
PrintHelperStart: beq $t5, $t6, PrintHelperEnd #while address < 16384, continue painting the pixel with the colour given
sw $a0, 0($t5)
addi $t5, $t5, 4
j PrintHelperStart
PrintHelperEnd: jr $ra





RespondToA:
lw $t1, frogPosition #t1 = frog relative position to leftmost of bitmap
add $t2, $t1, $t0   #t2 = real frogPosition
rem $t3, $t1, 16384 # get remainder to know the x postion
beq $t3, 0, EndA #if already at leftmost, no reaction to keyboard input A
addi $t1, $t1, -64 #else, move left 
sw $t1, frogPosition

#for having sound
li $v0, 31 
li $a0, 62
li $a1, 500
li $a2, 1
li $a3, 100
syscall

EndA: j KeyboardEndOfResponse

RespondToD:
lw $t1, frogPosition #t1 = frog relative position to leftmost of bitmap
add $t2, $t1, $t0   #t2 = real frogPosition
rem $t3, $t1, 16384
beq $t3, 960, EndA
addi $t1, $t1, 64
sw $t1, frogPosition

li $v0, 31 
li $a0, 63
li $a1, 500
li $a2, 1
li $a3, 100
syscall

EndD: j KeyboardEndOfResponse


RespondToW:
lw $t1, frogPosition #t1 = frog relative position to leftmost of bitmap
add $t2, $t1, $t0   #t2 = real frogPosition
div $t3, $t1, 16384
beq $t3, 4, EndW #if at top, no reaction to keyboard input, directly end the response
addi $t4, $zero, 0x000000 #check whether a frog has already been there
lw $t5, -16384($t2)
beq $t4, $t5, EndW # if already has a frog there, end with no response
addi $t1, $t1, -16384 #else, move up
sw $t1, frogPosition

li $v0, 31 
li $a0, 64
li $a1, 500
li $a2, 1
li $a3, 100
syscall

lw $t6, score
addi $t6, $t6, 1
sw $t6 score

EndW: j KeyboardEndOfResponse


RespondToS:
lw $t1, frogPosition #t1 = frog relative position to leftmost of bitmap
add $t2, $t1, $t0   #t2 = real frogPosition
div $t3, $t1, 16384
beq $t3, 12, EndS #if at top, no reaction to keyboard input, directly end the response
addi $t1, $t1, 16384 #else, move down
sw $t1, frogPosition

li $v0, 31 
li $a0, 65
li $a1, 500
li $a2, 1
li $a3, 100
syscall

lw $t6, score
addi $t6, $t6, -1
sw $t6 score

EndS: j KeyboardEndOfResponse




UpdateRight: #$a2 store for the block parameter, $v1 store for the updated parameter (to return)
rem $t6, $a2, 16384
beq $t6, 960, RightmostUD # = rightmost
#else: position+64
addi $v1, $a2, 64
j EndUDR
RightmostUD: 
#rightmost: update to leftmost
addi $v1, $a2, -960
EndUDR: jr $ra


UpdateLeft: #$a2 store for the block parameter, $v1 store for the updated parameter (to return)
rem $t6, $a2, 16384
beq $t6, 0, LeftmostUD # = rightmost
#else: position-64
addi $v1, $a2, -64
j EndUDL
LeftmostUD: 
#leftmost: update to rightmost
addi $v1, $a2, 960
EndUDL: jr $ra



SegmentH:
#$a1 pass the topleft of display relative address, $t0 for bitmap address, $t1 for real address of topleft bit on bitmap, $t2 for color, 
add $t1, $t0, $a1
addi $t2, $zero, 0xffffff

add $t5, $t1, $zero #$t5 stores current address to paint
addi $t6, $t1, 64
SegHStart1: beq $t5, $t6, SegHEnd1 
sw $t2, 0($t5)
addi $t5, $t5, 4
j SegHStart1
SegHEnd1: 

addi $t5, $t1, 1024 #$t5 stores current address to paint
addi $t6, $t5, 64
SegHStart2: beq $t5, $t6, SegHEnd2 
sw $t2, 0($t5)
addi $t5, $t5, 4
j SegHStart2
SegHEnd2: 

addi $t5, $t1, 2048 #$t5 stores current address to paint
addi $t6, $t5, 64
SegHStart3: beq $t5, $t6, SegHEnd3 
sw $t2, 0($t5)
addi $t5, $t5, 4
j SegHStart3
SegHEnd3: 

addi $t5, $t1, 3072 #$t5 stores current address to paint
addi $t6, $t5, 64
SegHStart4: beq $t5, $t6, SegHEnd4 
sw $t2, 0($t5)
addi $t5, $t5, 4
j SegHStart4
SegHEnd4: 
jr $ra






SegmentV:
#$a1 pass the topleft of display relative address, $t0 for bitmap address, $t1 for real address of topleft bit on bitmap, $t2 for color, 
add $t1, $t0, $a1
addi $t2, $zero, 0xffffff

add $t5, $t1, $zero #$t5 stores current address to paint
addi $t6, $t1, 16384
SegVStart1: beq $t5, $t6, SegVEnd1 
sw $t2, 0($t5)
addi $t5, $t5, 1024
j SegVStart1
SegVEnd1: 

addi $t5, $t1, 4 #$t5 stores current address to paint
addi $t6, $t5, 16384
SegVStart2: beq $t5, $t6, SegVEnd2 
sw $t2, 0($t5)
addi $t5, $t5, 1024
j SegVStart2
SegVEnd2: 

addi $t5, $t1, 8 #$t5 stores current address to paint
addi $t6, $t5, 16384
SegVStart3: beq $t5, $t6, SegVEnd3 
sw $t2, 0($t5)
addi $t5, $t5, 1024
j SegVStart3
SegVEnd3: 

addi $t5, $t1, 12 #$t5 stores current address to paint
addi $t6, $t5, 16384
SegVStart4: beq $t5, $t6, SegVEnd4 
sw $t2, 0($t5)
addi $t5, $t5, 1024
j SegVStart4
SegVEnd4: 
jr $ra


Print0: #$a3 indicate the relative address of the topleft corner of the whole number display
add $s0, $zero, $ra
add $s1, $zero, $a3
addi $a1, $s1, 0 
#$a1 pass the topleft of display relative address
jal SegmentV
addi $a1, $s1, 48 
jal SegmentV
addi $a1, $s1, 16384 
jal SegmentV
addi $a1, $s1, 16432 
jal SegmentV
addi $a1, $s1, 0
jal SegmentH
addi $a1, $s1, 29696
jal SegmentH
add $ra, $zero, $s0
jr $ra


Print1: #$a3 indicate the relative address of the topleft corner of the whole number display
add $s0, $zero, $ra
add $s1, $zero, $a3
addi $a1, $s1, 48 
#$a1 pass the topleft of display relative address
jal SegmentV
addi $a1, $s1, 16432
#$a1 pass the topleft of display relative address
jal SegmentV
add $ra, $zero, $s0
jr $ra

Print2: #$a3 indicate the relative address of the topleft corner of the whole number display
add $s0, $zero, $ra
add $s1, $zero, $a3
addi $a1, $s1, 48
#$a1 pass the topleft of display relative address
jal SegmentV
addi $a1, $s1, 16384
#$a1 pass the topleft of display relative address
jal SegmentV

addi $a1, $s1, 0
#$a1 pass the topleft of display relative address
jal SegmentH
addi $a1, $s1, 14336
#$a1 pass the topleft of display relative address
jal SegmentH
addi $a1, $s1, 29696
#$a1 pass the topleft of display relative address
jal SegmentH
add $ra, $zero, $s0
jr $ra


Print3: #$a3 indicate the relative address of the topleft corner of the whole number display
add $s0, $zero, $ra
add $s1, $zero, $a3

addi $a1, $s1, 48 
#$a1 pass the topleft of display relative address
jal SegmentV
addi $a1, $s1, 16432
#$a1 pass the topleft of display relative address
jal SegmentV

addi $a1, $s1, 0
#$a1 pass the topleft of display relative address
jal SegmentH
addi $a1, $s1, 14336
#$a1 pass the topleft of display relative address
jal SegmentH
addi $a1, $s1, 29696
#$a1 pass the topleft of display relative address
jal SegmentH
add $ra, $zero, $s0
jr $ra

Print4:
add $s0, $zero, $ra
add $s1, $zero, $a3

addi $a1, $s1, 0 
#$a1 pass the topleft of display relative address
jal SegmentV
addi $a1, $s1, 48 
#$a1 pass the topleft of display relative address
jal SegmentV
addi $a1, $s1, 16432
#$a1 pass the topleft of display relative address
jal SegmentV
addi $a1, $s1, 14336
#$a1 pass the topleft of display relative address
jal SegmentH
add $ra, $zero, $s0
jr $ra




Print5:
add $s0, $zero, $ra
add $s1, $zero, $a3

addi $a1, $s1, 0 
#$a1 pass the topleft of display relative address
jal SegmentV
addi $a1, $s1, 16432
#$a1 pass the topleft of display relative address
jal SegmentV

addi $a1, $s1, 0
#$a1 pass the topleft of display relative address
jal SegmentH
addi $a1, $s1, 14336
#$a1 pass the topleft of display relative address
jal SegmentH
addi $a1, $s1, 29696
#$a1 pass the topleft of display relative address
jal SegmentH
add $ra, $zero, $s0
jr $ra

Print6:
add $s0, $zero, $ra
add $s1, $zero, $a3

addi $a1, $s1, 0 
#$a1 pass the topleft of display relative address
jal SegmentV
addi $a1, $s1, 16384 
#$a1 pass the topleft of display relative address
jal SegmentV
addi $a1, $s1, 16432
#$a1 pass the topleft of display relative address
jal SegmentV

addi $a1, $s1, 0
#$a1 pass the topleft of display relative address
jal SegmentH
addi $a1, $s1, 14336
#$a1 pass the topleft of display relative address
jal SegmentH
addi $a1, $s1, 29696
#$a1 pass the topleft of display relative address
jal SegmentH
add $ra, $zero, $s0
jr $ra

Print7:
add $s0, $zero, $ra
add $s1, $zero, $a3
addi $a1, $s1, 0 
jal SegmentH
addi $a1, $s1, 48 
#$a1 pass the topleft of display relative address
jal SegmentV
addi $a1, $s1, 16432
#$a1 pass the topleft of display relative address
jal SegmentV
add $ra, $zero, $s0
jr $ra


Print8: #$a3 indicate the relative address of the topleft corner of the whole number display
add $s0, $zero, $ra
add $s1, $zero, $a3
addi $a1, $s1, 0 
#$a1 pass the topleft of display relative address
jal SegmentV
addi $a1, $s1, 48 
jal SegmentV
addi $a1, $s1, 16384 
jal SegmentV
addi $a1, $s1, 16432 
jal SegmentV
addi $a1, $s1, 0
jal SegmentH
addi $a1, $s1, 14336
jal SegmentH
addi $a1, $s1, 29696
jal SegmentH
add $ra, $zero, $s0
jr $ra


Print9:
add $s0, $zero, $ra
add $s1, $zero, $a3
addi $a1, $s1, 0 
#$a1 pass the topleft of display relative address
jal SegmentV
addi $a1, $s1, 48 
jal SegmentV
addi $a1, $s1, 16432 
jal SegmentV
addi $a1, $s1, 0
jal SegmentH
addi $a1, $s1, 14336
jal SegmentH
addi $a1, $s1, 29696
jal SegmentH
add $ra, $zero, $s0
jr $ra


