Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465AbaHDMMo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 08:12:44 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50105 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbaHDMMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 08:12:43 -0400
Date: Mon, 4 Aug 2014 14:12:38 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/debug change for v3.17
Message-ID: <20140804121238.GA26322@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-debug-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-debug-for-linus

   # HEAD: 3bab13b015a255b4b812c02670384d7d99a9ca34 x86/debug: Drop several unnecessary CFI annotations

 * Clean up our entry_64.S CFI annotations, by Jan Beulich.

 Thanks,

	Ingo

------------------>
Jan Beulich (1):
      x86/debug: Drop several unnecessary CFI annotations


 arch/x86/kernel/entry_64.S | 52 +++++++++++++++++++++++-----------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index b25ca96..f72c03a 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -207,7 +207,6 @@ ENDPROC(native_usergs_sysret64)
  */
 	.macro XCPT_FRAME start=1 offset=0
 	INTR_FRAME \start, RIP+\offset-ORIG_RAX
-	/*CFI_REL_OFFSET orig_rax, ORIG_RAX-ORIG_RAX*/
 	.endm
 
 /*
@@ -287,21 +286,21 @@ ENDPROC(native_usergs_sysret64)
 ENTRY(save_paranoid)
 	XCPT_FRAME 1 RDI+8
 	cld
-	movq_cfi rdi, RDI+8
-	movq_cfi rsi, RSI+8
+	movq %rdi, RDI+8(%rsp)
+	movq %rsi, RSI+8(%rsp)
 	movq_cfi rdx, RDX+8
 	movq_cfi rcx, RCX+8
 	movq_cfi rax, RAX+8
-	movq_cfi r8, R8+8
-	movq_cfi r9, R9+8
-	movq_cfi r10, R10+8
-	movq_cfi r11, R11+8
+	movq %r8, R8+8(%rsp)
+	movq %r9, R9+8(%rsp)
+	movq %r10, R10+8(%rsp)
+	movq %r11, R11+8(%rsp)
 	movq_cfi rbx, RBX+8
-	movq_cfi rbp, RBP+8
-	movq_cfi r12, R12+8
-	movq_cfi r13, R13+8
-	movq_cfi r14, R14+8
-	movq_cfi r15, R15+8
+	movq %rbp, RBP+8(%rsp)
+	movq %r12, R12+8(%rsp)
+	movq %r13, R13+8(%rsp)
+	movq %r14, R14+8(%rsp)
+	movq %r15, R15+8(%rsp)
 	movl $1,%ebx
 	movl $MSR_GS_BASE,%ecx
 	rdmsr
@@ -1395,21 +1394,21 @@ ENTRY(error_entry)
 	CFI_ADJUST_CFA_OFFSET 15*8
 	/* oldrax contains error code */
 	cld
-	movq_cfi rdi, RDI+8
-	movq_cfi rsi, RSI+8
-	movq_cfi rdx, RDX+8
-	movq_cfi rcx, RCX+8
-	movq_cfi rax, RAX+8
-	movq_cfi  r8,  R8+8
-	movq_cfi  r9,  R9+8
-	movq_cfi r10, R10+8
-	movq_cfi r11, R11+8
+	movq %rdi, RDI+8(%rsp)
+	movq %rsi, RSI+8(%rsp)
+	movq %rdx, RDX+8(%rsp)
+	movq %rcx, RCX+8(%rsp)
+	movq %rax, RAX+8(%rsp)
+	movq  %r8,  R8+8(%rsp)
+	movq  %r9,  R9+8(%rsp)
+	movq %r10, R10+8(%rsp)
+	movq %r11, R11+8(%rsp)
 	movq_cfi rbx, RBX+8
-	movq_cfi rbp, RBP+8
-	movq_cfi r12, R12+8
-	movq_cfi r13, R13+8
-	movq_cfi r14, R14+8
-	movq_cfi r15, R15+8
+	movq %rbp, RBP+8(%rsp)
+	movq %r12, R12+8(%rsp)
+	movq %r13, R13+8(%rsp)
+	movq %r14, R14+8(%rsp)
+	movq %r15, R15+8(%rsp)
 	xorl %ebx,%ebx
 	testl $3,CS+8(%rsp)
 	je error_kernelspace
@@ -1427,6 +1426,7 @@ error_sti:
  * compat mode. Check for these here too.
  */
 error_kernelspace:
+	CFI_REL_OFFSET rcx, RCX+8
 	incl %ebx
 	leaq irq_return_iret(%rip),%rcx
 	cmpq %rcx,RIP+8(%rsp)
