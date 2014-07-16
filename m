Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135AbaGPTZv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 15:25:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44636 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754787AbaGPTZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 15:25:47 -0400
Date: Wed, 16 Jul 2014 12:25:33 -0700
From: tip-bot for Jan Beulich <tipbot@zytor.com>
Message-ID: <tip-3bab13b015a255b4b812c02670384d7d99a9ca34@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jbeulich@suse.com, JBeulich@suse.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        JBeulich@suse.com, jbeulich@suse.com, tglx@linutronix.de
In-Reply-To: <53AAE69A020000780001D3C7@mail.emea.novell.com>
References: <53AAE69A020000780001D3C7@mail.emea.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/debug] x86/debug:
  Drop several unnecessary CFI annotations
Git-Commit-ID: 3bab13b015a255b4b812c02670384d7d99a9ca34
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3bab13b015a255b4b812c02670384d7d99a9ca34
Gitweb:     http://git.kernel.org/tip/3bab13b015a255b4b812c02670384d7d99a9ca34
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Wed, 25 Jun 2014 14:11:22 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 16 Jul 2014 15:23:06 +0200

x86/debug: Drop several unnecessary CFI annotations

With the conversion of the register saving code from macros to
functions, and with those functions not clobbering most of the
registers they spill, there's no need to annotate most of the
spill operations; the only exceptions being %rbx (always
modified) and %rcx (modified on the error_kernelspace: path).

Also remove a bogus commented out annotation - there's no
register %orig_rax after all.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Link: http://lkml.kernel.org/r/53AAE69A020000780001D3C7@mail.emea.novell.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
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
