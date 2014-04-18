Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751622AbaDRNfQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 09:35:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34135 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbaDRNfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 09:35:14 -0400
From: Denys Vlasenko <dvlasenk@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH] x86: comment in x86-opcode-map.txt on CALLW discrepancy between Intel and AMD
Date: Fri, 18 Apr 2014 15:34:55 +0200
Message-Id: <1397828095-5356-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In 64-bit mode, AMD and Intel CPUs treat 0x66 prefix before branch
insns differently. For near branches, it affects decode too since
immediate offset's width is different.

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
CC: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/lib/x86-opcode-map.txt | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/lib/x86-opcode-map.txt b/arch/x86/lib/x86-opcode-map.txt
index 1a2be7c..816488c 100644
--- a/arch/x86/lib/x86-opcode-map.txt
+++ b/arch/x86/lib/x86-opcode-map.txt
@@ -273,6 +273,9 @@ dd: ESC
 de: ESC
 df: ESC
 # 0xe0 - 0xef
+# Note: "forced64" is Intel CPU behavior: they ignore 0x66 prefix
+# in 64-bit mode. AMD CPUs accept 0x66 prefix, it causes RIP truncation
+# to 16 bits. In 32-bit mode, 0x66 is accepted by both Intel and AMD.
 e0: LOOPNE/LOOPNZ Jb (f64)
 e1: LOOPE/LOOPZ Jb (f64)
 e2: LOOP Jb (f64)
@@ -281,6 +284,10 @@ e4: IN AL,Ib
 e5: IN eAX,Ib
 e6: OUT Ib,AL
 e7: OUT Ib,eAX
+# With 0x66 prefix in 64-bit mode, for AMD CPUs immediate offset
+# in "near" jumps and calls is 16-bit. For CALL,
+# push of return address is 16-bit wide, RSP is decremented by 2
+# but is not truncated to 16 bits, unlike RIP.
 e8: CALL Jz (f64)
 e9: JMP-near Jz (f64)
 ea: JMP-far Ap (i64)
@@ -456,6 +463,7 @@ AVXcode: 1
 7e: movd/q Ey,Pd | vmovd/q Ey,Vy (66),(v1) | vmovq Vq,Wq (F3),(v1)
 7f: movq Qq,Pq | vmovdqa Wx,Vx (66) | vmovdqu Wx,Vx (F3)
 # 0x0f 0x80-0x8f
+# Note: "forced64" is Intel CPU behavior (see comment about CALL insn).
 80: JO Jz (f64)
 81: JNO Jz (f64)
 82: JB/JC/JNAE Jz (f64)
@@ -842,6 +850,7 @@ EndTable
 GrpTable: Grp5
 0: INC Ev
 1: DEC Ev
+# Note: "forced64" is Intel CPU behavior (see comment about CALL insn).
 2: CALLN Ev (f64)
 3: CALLF Ep
 4: JMPN Ev (f64)
-- 
1.8.1.4

