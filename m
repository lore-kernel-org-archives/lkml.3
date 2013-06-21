Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030480Ab3FUEdy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 00:33:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53445 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030463Ab3FUEdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 00:33:52 -0400
Date: Thu, 20 Jun 2013 21:33:32 -0700
From: "tip-bot for H. Peter Anvin" <tipbot@zytor.com>
Message-ID: <tip-b76zi1gep39c0zs8fbvkhie9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        keescook@chromium.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        keescook@chromium.org, tglx@linutronix.de, hpa@linux.intel.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86, reloc:
  Use xorl instead of xorq in relocate_kernel_64.S
Git-Commit-ID: f037e416afb38b9ee8ac598d68733fcbaf665384
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 20 Jun 2013 21:33:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f037e416afb38b9ee8ac598d68733fcbaf665384
Gitweb:     http://git.kernel.org/tip/f037e416afb38b9ee8ac598d68733fcbaf665384
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Thu, 20 Jun 2013 21:16:00 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 20 Jun 2013 21:30:04 -0700

x86, reloc: Use xorl instead of xorq in relocate_kernel_64.S

There is no point in using "xorq" to clear a register... use "xorl" to
clear the bottom 32 bits, and the upper 32 bits get cleared by virtue
of zero extension.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Kees Cook <keescook@chromium.org>
Link: http://lkml.kernel.org/n/tip-b76zi1gep39c0zs8fbvkhie9@git.kernel.org
---
 arch/x86/kernel/relocate_kernel_64.S | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/relocate_kernel_64.S b/arch/x86/kernel/relocate_kernel_64.S
index f2bb9c9..3fd2c69 100644
--- a/arch/x86/kernel/relocate_kernel_64.S
+++ b/arch/x86/kernel/relocate_kernel_64.S
@@ -151,21 +151,21 @@ identity_mapped:
 
 	testq	%r11, %r11
 	jnz 1f
-	xorq	%rax, %rax
-	xorq	%rbx, %rbx
-	xorq    %rcx, %rcx
-	xorq    %rdx, %rdx
-	xorq    %rsi, %rsi
-	xorq    %rdi, %rdi
-	xorq    %rbp, %rbp
-	xorq	%r8,  %r8
-	xorq	%r9,  %r9
-	xorq	%r10, %r10
-	xorq	%r11, %r11
-	xorq	%r12, %r12
-	xorq	%r13, %r13
-	xorq	%r14, %r14
-	xorq	%r15, %r15
+	xorl	%eax, %eax
+	xorl	%ebx, %ebx
+	xorl    %ecx, %ecx
+	xorl    %edx, %edx
+	xorl    %esi, %esi
+	xorl    %edi, %edi
+	xorl    %ebp, %ebp
+	xorl	%r8d, %r8d
+	xorl	%r9d, %r9d
+	xorl	%r10d, %r10d
+	xorl	%r11d, %r11d
+	xorl	%r12d, %r12d
+	xorl	%r13d, %r13d
+	xorl	%r14d, %r14d
+	xorl	%r15d, %r15d
 
 	ret
 
@@ -212,8 +212,8 @@ virtual_mapped:
 	/* Do the copies */
 swap_pages:
 	movq	%rdi, %rcx 	/* Put the page_list in %rcx */
-	xorq	%rdi, %rdi
-	xorq	%rsi, %rsi
+	xorl	%edi, %edi
+	xorl	%esi, %esi
 	jmp	1f
 
 0:	/* top, read another word for the indirection page */
