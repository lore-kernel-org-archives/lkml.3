Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099Ab3FYWzT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 18:55:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49271 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065Ab3FYWzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 18:55:15 -0400
Date: Tue, 25 Jun 2013 15:55:05 -0700
From: "tip-bot for H. Peter Anvin" <tipbot@zytor.com>
Message-ID: <tip-um7za1nzf6brb17o0h4om6e3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86, asm, cleanup:
  Replace open-coded control register values with symbolic
Git-Commit-ID: 7d9b69263e883c4e69fbc1511cd80520369ed02f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 25 Jun 2013 15:55:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7d9b69263e883c4e69fbc1511cd80520369ed02f
Gitweb:     http://git.kernel.org/tip/7d9b69263e883c4e69fbc1511cd80520369ed02f
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Sat, 27 Apr 2013 16:22:32 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 25 Jun 2013 15:50:05 -0700

x86, asm, cleanup: Replace open-coded control register values with symbolic

Clean up an unnecessary open-coded control register values.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/n/tip-um7za1nzf6brb17o0h4om6e3@git.kernel.org
---
 arch/x86/kernel/cpu/mtrr/cyrix.c     | 2 +-
 arch/x86/kernel/cpu/mtrr/generic.c   | 2 +-
 arch/x86/kernel/relocate_kernel_32.S | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/cyrix.c b/arch/x86/kernel/cpu/mtrr/cyrix.c
index 68a3343..9e451b0 100644
--- a/arch/x86/kernel/cpu/mtrr/cyrix.c
+++ b/arch/x86/kernel/cpu/mtrr/cyrix.c
@@ -167,7 +167,7 @@ static void post_set(void)
 	setCx86(CX86_CCR3, ccr3);
 
 	/* Enable caches */
-	write_cr0(read_cr0() & 0xbfffffff);
+	write_cr0(read_cr0() & ~X86_CR0_CD);
 
 	/* Restore value of CR4 */
 	if (cpu_has_pge)
diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index fa72a39..00f557b 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -701,7 +701,7 @@ static void post_set(void) __releases(set_atomicity_lock)
 	mtrr_wrmsr(MSR_MTRRdefType, deftype_lo, deftype_hi);
 
 	/* Enable caches */
-	write_cr0(read_cr0() & 0xbfffffff);
+	write_cr0(read_cr0() & ~X86_CR0_CD);
 
 	/* Restore value of CR4 */
 	if (cpu_has_pge)
diff --git a/arch/x86/kernel/relocate_kernel_32.S b/arch/x86/kernel/relocate_kernel_32.S
index 36818f8..e13f8e7 100644
--- a/arch/x86/kernel/relocate_kernel_32.S
+++ b/arch/x86/kernel/relocate_kernel_32.S
@@ -186,7 +186,7 @@ identity_mapped:
 	movl	CP_PA_PGD(%ebx), %eax
 	movl	%eax, %cr3
 	movl	%cr0, %eax
-	orl	$(1<<31), %eax
+	orl	$X86_CR0_PG, %eax
 	movl	%eax, %cr0
 	lea	PAGE_SIZE(%edi), %esp
 	movl	%edi, %eax
