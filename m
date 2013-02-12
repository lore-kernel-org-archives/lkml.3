Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761248Ab3BLO4s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 09:56:48 -0500
Received: from georges.telenet-ops.be ([195.130.137.68]:40425 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760693Ab3BLOxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 09:53:10 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>
Cc: linux-cris-kernel@axis.com, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 01/10] cris/kgdb: Properly split long lines in asm
Date: Tue, 12 Feb 2013 15:52:48 +0100
Message-Id: <1360680777-12622-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1360680777-12622-1-git-send-email-geert@linux-m68k.org>
References: <1360680777-12622-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/cris/arch-v10/kernel/kgdb.c:1273:6: warning: missing terminating " character [enabled by default]
arch/cris/arch-v10/kernel/kgdb.c:1359:1: warning: missing terminating " character [enabled by default]
arch/cris/arch-v10/kernel/kgdb.c:1370:6: warning: missing terminating " character [enabled by default]
arch/cris/arch-v10/kernel/kgdb.c:1457:1: warning: missing terminating " character [enabled by default]
arch/cris/arch-v10/kernel/kgdb.c:1273:6: warning: missing terminating " character [enabled by default]
arch/cris/arch-v10/kernel/kgdb.c:1273:1: error: missing terminating " character
arch/cris/arch-v10/kernel/kgdb.c:1274:3: error: expected string literal before '.' token
arch/cris/arch-v10/kernel/kgdb.c:1359:1: warning: missing terminating " character [enabled by default]
arch/cris/arch-v10/kernel/kgdb.c:1359:1: error: missing terminating " character
arch/cris/arch-v10/kernel/kgdb.c:1370:6: warning: missing terminating " character [enabled by default]
arch/cris/arch-v10/kernel/kgdb.c:1370:1: error: missing terminating " character
arch/cris/arch-v10/kernel/kgdb.c:1457:1: warning: missing terminating " character [enabled by default]
arch/cris/arch-v10/kernel/kgdb.c:1457:1: error: missing terminating " character

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/cris/arch-v10/kernel/kgdb.c |  350 +++++++++++++++++++-------------------
 1 files changed, 175 insertions(+), 175 deletions(-)

diff --git a/arch/cris/arch-v10/kernel/kgdb.c b/arch/cris/arch-v10/kernel/kgdb.c
index 37e6d2c..0a42033 100644
--- a/arch/cris/arch-v10/kernel/kgdb.c
+++ b/arch/cris/arch-v10/kernel/kgdb.c
@@ -1270,93 +1270,93 @@ kill_restart ()
 
 void kgdb_handle_breakpoint(void);
 
-asm ("
-  .global kgdb_handle_breakpoint
-kgdb_handle_breakpoint:
-;;
-;; Response to the break-instruction
-;;
-;; Create a register image of the caller
-;;
-  move     $dccr,[reg+0x5E] ; Save the flags in DCCR before disable interrupts
-  di                        ; Disable interrupts
-  move.d   $r0,[reg]        ; Save R0
-  move.d   $r1,[reg+0x04]   ; Save R1
-  move.d   $r2,[reg+0x08]   ; Save R2
-  move.d   $r3,[reg+0x0C]   ; Save R3
-  move.d   $r4,[reg+0x10]   ; Save R4
-  move.d   $r5,[reg+0x14]   ; Save R5
-  move.d   $r6,[reg+0x18]   ; Save R6
-  move.d   $r7,[reg+0x1C]   ; Save R7
-  move.d   $r8,[reg+0x20]   ; Save R8
-  move.d   $r9,[reg+0x24]   ; Save R9
-  move.d   $r10,[reg+0x28]  ; Save R10
-  move.d   $r11,[reg+0x2C]  ; Save R11
-  move.d   $r12,[reg+0x30]  ; Save R12
-  move.d   $r13,[reg+0x34]  ; Save R13
-  move.d   $sp,[reg+0x38]   ; Save SP (R14)
-;; Due to the old assembler-versions BRP might not be recognized
-  .word 0xE670              ; move brp,$r0
-  subq     2,$r0             ; Set to address of previous instruction.
-  move.d   $r0,[reg+0x3c]   ; Save the address in PC (R15)
-  clear.b  [reg+0x40]      ; Clear P0
-  move     $vr,[reg+0x41]   ; Save special register P1
-  clear.w  [reg+0x42]      ; Clear P4
-  move     $ccr,[reg+0x44]  ; Save special register CCR
-  move     $mof,[reg+0x46]  ; P7
-  clear.d  [reg+0x4A]      ; Clear P8
-  move     $ibr,[reg+0x4E]  ; P9,
-  move     $irp,[reg+0x52]  ; P10,
-  move     $srp,[reg+0x56]  ; P11,
-  move     $dtp0,[reg+0x5A] ; P12, register BAR, assembler might not know BAR
-                            ; P13, register DCCR already saved
-;; Due to the old assembler-versions BRP might not be recognized
-  .word 0xE670              ; move brp,r0
-;; Static (compiled) breakpoints must return to the next instruction in order
-;; to avoid infinite loops. Dynamic (gdb-invoked) must restore the instruction
-;; in order to execute it when execution is continued.
-  test.b   [is_dyn_brkp]    ; Is this a dynamic breakpoint?
-  beq      is_static         ; No, a static breakpoint
-  nop
-  subq     2,$r0              ; rerun the instruction the break replaced
-is_static:
-  moveq    1,$r1
-  move.b   $r1,[is_dyn_brkp] ; Set the state variable to dynamic breakpoint
-  move.d   $r0,[reg+0x62]    ; Save the return address in BRP
-  move     $usp,[reg+0x66]   ; USP
-;;
-;; Handle the communication
-;;
-  move.d   internal_stack+1020,$sp ; Use the internal stack which grows upward
-  moveq    5,$r10                   ; SIGTRAP
-  jsr      handle_exception       ; Interactive routine
-;;
-;; Return to the caller
-;;
-   move.d  [reg],$r0         ; Restore R0
-   move.d  [reg+0x04],$r1    ; Restore R1
-   move.d  [reg+0x08],$r2    ; Restore R2
-   move.d  [reg+0x0C],$r3    ; Restore R3
-   move.d  [reg+0x10],$r4    ; Restore R4
-   move.d  [reg+0x14],$r5    ; Restore R5
-   move.d  [reg+0x18],$r6    ; Restore R6
-   move.d  [reg+0x1C],$r7    ; Restore R7
-   move.d  [reg+0x20],$r8    ; Restore R8
-   move.d  [reg+0x24],$r9    ; Restore R9
-   move.d  [reg+0x28],$r10   ; Restore R10
-   move.d  [reg+0x2C],$r11   ; Restore R11
-   move.d  [reg+0x30],$r12   ; Restore R12
-   move.d  [reg+0x34],$r13   ; Restore R13
-;;
-;; FIXME: Which registers should be restored?
-;;
-   move.d  [reg+0x38],$sp    ; Restore SP (R14)
-   move    [reg+0x56],$srp   ; Restore the subroutine return pointer.
-   move    [reg+0x5E],$dccr  ; Restore DCCR
-   move    [reg+0x66],$usp   ; Restore USP
-   jump    [reg+0x62]       ; A jump to the content in register BRP works.
-   nop                       ;
-");
+asm ("\n"
+"  .global kgdb_handle_breakpoint\n"
+"kgdb_handle_breakpoint:\n"
+";;\n"
+";; Response to the break-instruction\n"
+";;\n"
+";; Create a register image of the caller\n"
+";;\n"
+"  move     $dccr,[reg+0x5E] ; Save the flags in DCCR before disable interrupts\n"
+"  di                        ; Disable interrupts\n"
+"  move.d   $r0,[reg]        ; Save R0\n"
+"  move.d   $r1,[reg+0x04]   ; Save R1\n"
+"  move.d   $r2,[reg+0x08]   ; Save R2\n"
+"  move.d   $r3,[reg+0x0C]   ; Save R3\n"
+"  move.d   $r4,[reg+0x10]   ; Save R4\n"
+"  move.d   $r5,[reg+0x14]   ; Save R5\n"
+"  move.d   $r6,[reg+0x18]   ; Save R6\n"
+"  move.d   $r7,[reg+0x1C]   ; Save R7\n"
+"  move.d   $r8,[reg+0x20]   ; Save R8\n"
+"  move.d   $r9,[reg+0x24]   ; Save R9\n"
+"  move.d   $r10,[reg+0x28]  ; Save R10\n"
+"  move.d   $r11,[reg+0x2C]  ; Save R11\n"
+"  move.d   $r12,[reg+0x30]  ; Save R12\n"
+"  move.d   $r13,[reg+0x34]  ; Save R13\n"
+"  move.d   $sp,[reg+0x38]   ; Save SP (R14)\n"
+";; Due to the old assembler-versions BRP might not be recognized\n"
+"  .word 0xE670              ; move brp,$r0\n"
+"  subq     2,$r0             ; Set to address of previous instruction.\n"
+"  move.d   $r0,[reg+0x3c]   ; Save the address in PC (R15)\n"
+"  clear.b  [reg+0x40]      ; Clear P0\n"
+"  move     $vr,[reg+0x41]   ; Save special register P1\n"
+"  clear.w  [reg+0x42]      ; Clear P4\n"
+"  move     $ccr,[reg+0x44]  ; Save special register CCR\n"
+"  move     $mof,[reg+0x46]  ; P7\n"
+"  clear.d  [reg+0x4A]      ; Clear P8\n"
+"  move     $ibr,[reg+0x4E]  ; P9,\n"
+"  move     $irp,[reg+0x52]  ; P10,\n"
+"  move     $srp,[reg+0x56]  ; P11,\n"
+"  move     $dtp0,[reg+0x5A] ; P12, register BAR, assembler might not know BAR\n"
+"                            ; P13, register DCCR already saved\n"
+";; Due to the old assembler-versions BRP might not be recognized\n"
+"  .word 0xE670              ; move brp,r0\n"
+";; Static (compiled) breakpoints must return to the next instruction in order\n"
+";; to avoid infinite loops. Dynamic (gdb-invoked) must restore the instruction\n"
+";; in order to execute it when execution is continued.\n"
+"  test.b   [is_dyn_brkp]    ; Is this a dynamic breakpoint?\n"
+"  beq      is_static         ; No, a static breakpoint\n"
+"  nop\n"
+"  subq     2,$r0              ; rerun the instruction the break replaced\n"
+"is_static:\n"
+"  moveq    1,$r1\n"
+"  move.b   $r1,[is_dyn_brkp] ; Set the state variable to dynamic breakpoint\n"
+"  move.d   $r0,[reg+0x62]    ; Save the return address in BRP\n"
+"  move     $usp,[reg+0x66]   ; USP\n"
+";;\n"
+";; Handle the communication\n"
+";;\n"
+"  move.d   internal_stack+1020,$sp ; Use the internal stack which grows upward\n"
+"  moveq    5,$r10                   ; SIGTRAP\n"
+"  jsr      handle_exception       ; Interactive routine\n"
+";;\n"
+";; Return to the caller\n"
+";;\n"
+"   move.d  [reg],$r0         ; Restore R0\n"
+"   move.d  [reg+0x04],$r1    ; Restore R1\n"
+"   move.d  [reg+0x08],$r2    ; Restore R2\n"
+"   move.d  [reg+0x0C],$r3    ; Restore R3\n"
+"   move.d  [reg+0x10],$r4    ; Restore R4\n"
+"   move.d  [reg+0x14],$r5    ; Restore R5\n"
+"   move.d  [reg+0x18],$r6    ; Restore R6\n"
+"   move.d  [reg+0x1C],$r7    ; Restore R7\n"
+"   move.d  [reg+0x20],$r8    ; Restore R8\n"
+"   move.d  [reg+0x24],$r9    ; Restore R9\n"
+"   move.d  [reg+0x28],$r10   ; Restore R10\n"
+"   move.d  [reg+0x2C],$r11   ; Restore R11\n"
+"   move.d  [reg+0x30],$r12   ; Restore R12\n"
+"   move.d  [reg+0x34],$r13   ; Restore R13\n"
+";;\n"
+";; FIXME: Which registers should be restored?\n"
+";;\n"
+"   move.d  [reg+0x38],$sp    ; Restore SP (R14)\n"
+"   move    [reg+0x56],$srp   ; Restore the subroutine return pointer.\n"
+"   move    [reg+0x5E],$dccr  ; Restore DCCR\n"
+"   move    [reg+0x66],$usp   ; Restore USP\n"
+"   jump    [reg+0x62]       ; A jump to the content in register BRP works.\n"
+"   nop                       ;\n"
+"\n");
 
 /* The hook for an interrupt generated by GDB. An internal stack is used
    by the stub. The register image of the caller is stored in the structure
@@ -1367,94 +1367,94 @@ is_static:
 
 void kgdb_handle_serial(void);
 
-asm ("
-  .global kgdb_handle_serial
-kgdb_handle_serial:
-;;
-;; Response to a serial interrupt
-;;
-
-  move     $dccr,[reg+0x5E] ; Save the flags in DCCR
-  di                        ; Disable interrupts
-  move.d   $r0,[reg]        ; Save R0
-  move.d   $r1,[reg+0x04]   ; Save R1
-  move.d   $r2,[reg+0x08]   ; Save R2
-  move.d   $r3,[reg+0x0C]   ; Save R3
-  move.d   $r4,[reg+0x10]   ; Save R4
-  move.d   $r5,[reg+0x14]   ; Save R5
-  move.d   $r6,[reg+0x18]   ; Save R6
-  move.d   $r7,[reg+0x1C]   ; Save R7
-  move.d   $r8,[reg+0x20]   ; Save R8
-  move.d   $r9,[reg+0x24]   ; Save R9
-  move.d   $r10,[reg+0x28]  ; Save R10
-  move.d   $r11,[reg+0x2C]  ; Save R11
-  move.d   $r12,[reg+0x30]  ; Save R12
-  move.d   $r13,[reg+0x34]  ; Save R13
-  move.d   $sp,[reg+0x38]   ; Save SP (R14)
-  move     $irp,[reg+0x3c]  ; Save the address in PC (R15)
-  clear.b  [reg+0x40]      ; Clear P0
-  move     $vr,[reg+0x41]   ; Save special register P1,
-  clear.w  [reg+0x42]      ; Clear P4
-  move     $ccr,[reg+0x44]  ; Save special register CCR
-  move     $mof,[reg+0x46]  ; P7
-  clear.d  [reg+0x4A]      ; Clear P8
-  move     $ibr,[reg+0x4E]  ; P9,
-  move     $irp,[reg+0x52]  ; P10,
-  move     $srp,[reg+0x56]  ; P11,
-  move     $dtp0,[reg+0x5A] ; P12, register BAR, assembler might not know BAR
-                            ; P13, register DCCR already saved
-;; Due to the old assembler-versions BRP might not be recognized
-  .word 0xE670              ; move brp,r0
-  move.d   $r0,[reg+0x62]   ; Save the return address in BRP
-  move     $usp,[reg+0x66]  ; USP
-
-;; get the serial character (from debugport.c) and check if it is a ctrl-c
-
-  jsr getDebugChar
-  cmp.b 3, $r10
-  bne goback
-  nop
-
-  move.d  [reg+0x5E], $r10		; Get DCCR
-  btstq	   8, $r10			; Test the U-flag.
-  bmi	   goback
-  nop
-
-;;
-;; Handle the communication
-;;
-  move.d   internal_stack+1020,$sp ; Use the internal stack
-  moveq    2,$r10                   ; SIGINT
-  jsr      handle_exception       ; Interactive routine
-
-goback:
-;;
-;; Return to the caller
-;;
-   move.d  [reg],$r0         ; Restore R0
-   move.d  [reg+0x04],$r1    ; Restore R1
-   move.d  [reg+0x08],$r2    ; Restore R2
-   move.d  [reg+0x0C],$r3    ; Restore R3
-   move.d  [reg+0x10],$r4    ; Restore R4
-   move.d  [reg+0x14],$r5    ; Restore R5
-   move.d  [reg+0x18],$r6    ; Restore R6
-   move.d  [reg+0x1C],$r7    ; Restore R7
-   move.d  [reg+0x20],$r8    ; Restore R8
-   move.d  [reg+0x24],$r9    ; Restore R9
-   move.d  [reg+0x28],$r10   ; Restore R10
-   move.d  [reg+0x2C],$r11   ; Restore R11
-   move.d  [reg+0x30],$r12   ; Restore R12
-   move.d  [reg+0x34],$r13   ; Restore R13
-;;
-;; FIXME: Which registers should be restored?
-;;
-   move.d  [reg+0x38],$sp    ; Restore SP (R14)
-   move    [reg+0x56],$srp   ; Restore the subroutine return pointer.
-   move    [reg+0x5E],$dccr  ; Restore DCCR
-   move    [reg+0x66],$usp   ; Restore USP
-   reti                      ; Return from the interrupt routine
-   nop
-");
+asm ("\n"
+"  .global kgdb_handle_serial\n"
+"kgdb_handle_serial:\n"
+";;\n"
+";; Response to a serial interrupt\n"
+";;\n"
+"\n"
+"  move     $dccr,[reg+0x5E] ; Save the flags in DCCR\n"
+"  di                        ; Disable interrupts\n"
+"  move.d   $r0,[reg]        ; Save R0\n"
+"  move.d   $r1,[reg+0x04]   ; Save R1\n"
+"  move.d   $r2,[reg+0x08]   ; Save R2\n"
+"  move.d   $r3,[reg+0x0C]   ; Save R3\n"
+"  move.d   $r4,[reg+0x10]   ; Save R4\n"
+"  move.d   $r5,[reg+0x14]   ; Save R5\n"
+"  move.d   $r6,[reg+0x18]   ; Save R6\n"
+"  move.d   $r7,[reg+0x1C]   ; Save R7\n"
+"  move.d   $r8,[reg+0x20]   ; Save R8\n"
+"  move.d   $r9,[reg+0x24]   ; Save R9\n"
+"  move.d   $r10,[reg+0x28]  ; Save R10\n"
+"  move.d   $r11,[reg+0x2C]  ; Save R11\n"
+"  move.d   $r12,[reg+0x30]  ; Save R12\n"
+"  move.d   $r13,[reg+0x34]  ; Save R13\n"
+"  move.d   $sp,[reg+0x38]   ; Save SP (R14)\n"
+"  move     $irp,[reg+0x3c]  ; Save the address in PC (R15)\n"
+"  clear.b  [reg+0x40]      ; Clear P0\n"
+"  move     $vr,[reg+0x41]   ; Save special register P1,\n"
+"  clear.w  [reg+0x42]      ; Clear P4\n"
+"  move     $ccr,[reg+0x44]  ; Save special register CCR\n"
+"  move     $mof,[reg+0x46]  ; P7\n"
+"  clear.d  [reg+0x4A]      ; Clear P8\n"
+"  move     $ibr,[reg+0x4E]  ; P9,\n"
+"  move     $irp,[reg+0x52]  ; P10,\n"
+"  move     $srp,[reg+0x56]  ; P11,\n"
+"  move     $dtp0,[reg+0x5A] ; P12, register BAR, assembler might not know BAR\n"
+"                            ; P13, register DCCR already saved\n"
+";; Due to the old assembler-versions BRP might not be recognized\n"
+"  .word 0xE670              ; move brp,r0\n"
+"  move.d   $r0,[reg+0x62]   ; Save the return address in BRP\n"
+"  move     $usp,[reg+0x66]  ; USP\n"
+"\n"
+";; get the serial character (from debugport.c) and check if it is a ctrl-c\n"
+"\n"
+"  jsr getDebugChar\n"
+"  cmp.b 3, $r10\n"
+"  bne goback\n"
+"  nop\n"
+"\n"
+"  move.d  [reg+0x5E], $r10		; Get DCCR\n"
+"  btstq	   8, $r10			; Test the U-flag.\n"
+"  bmi	   goback\n"
+"  nop\n"
+"\n"
+";;\n"
+";; Handle the communication\n"
+";;\n"
+"  move.d   internal_stack+1020,$sp ; Use the internal stack\n"
+"  moveq    2,$r10                   ; SIGINT\n"
+"  jsr      handle_exception       ; Interactive routine\n"
+"\n"
+"goback:\n"
+";;\n"
+";; Return to the caller\n"
+";;\n"
+"   move.d  [reg],$r0         ; Restore R0\n"
+"   move.d  [reg+0x04],$r1    ; Restore R1\n"
+"   move.d  [reg+0x08],$r2    ; Restore R2\n"
+"   move.d  [reg+0x0C],$r3    ; Restore R3\n"
+"   move.d  [reg+0x10],$r4    ; Restore R4\n"
+"   move.d  [reg+0x14],$r5    ; Restore R5\n"
+"   move.d  [reg+0x18],$r6    ; Restore R6\n"
+"   move.d  [reg+0x1C],$r7    ; Restore R7\n"
+"   move.d  [reg+0x20],$r8    ; Restore R8\n"
+"   move.d  [reg+0x24],$r9    ; Restore R9\n"
+"   move.d  [reg+0x28],$r10   ; Restore R10\n"
+"   move.d  [reg+0x2C],$r11   ; Restore R11\n"
+"   move.d  [reg+0x30],$r12   ; Restore R12\n"
+"   move.d  [reg+0x34],$r13   ; Restore R13\n"
+";;\n"
+";; FIXME: Which registers should be restored?\n"
+";;\n"
+"   move.d  [reg+0x38],$sp    ; Restore SP (R14)\n"
+"   move    [reg+0x56],$srp   ; Restore the subroutine return pointer.\n"
+"   move    [reg+0x5E],$dccr  ; Restore DCCR\n"
+"   move    [reg+0x66],$usp   ; Restore USP\n"
+"   reti                      ; Return from the interrupt routine\n"
+"   nop\n"
+"\n");
 
 /* Use this static breakpoint in the start-up only. */
 
-- 
1.7.0.4

