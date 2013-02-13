Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759276Ab3BMANR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 19:13:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58584 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075Ab3BMANP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 19:13:15 -0500
Date: Tue, 12 Feb 2013 16:11:23 -0800
From: tip-bot for Borislav Petkov <bp@suse.de>
Message-ID: <tip-5e2a044daf0c6f897eb69de931e3b29020e874a9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bp@suse.de, hpa@linux.intel.com
In-Reply-To: <1360592538-10643-5-git-send-email-bp@alien8.de>
References: <1360592538-10643-5-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86, head_32: Give the 6 label a real name
Git-Commit-ID: 5e2a044daf0c6f897eb69de931e3b29020e874a9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 12 Feb 2013 16:11:28 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5e2a044daf0c6f897eb69de931e3b29020e874a9
Gitweb:     http://git.kernel.org/tip/5e2a044daf0c6f897eb69de931e3b29020e874a9
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Mon, 11 Feb 2013 15:22:18 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 12 Feb 2013 15:48:42 -0800

x86, head_32: Give the 6 label a real name

Jumping here we are about to enable paging so rename the label
accordingly.

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: http://lkml.kernel.org/r/1360592538-10643-5-git-send-email-bp@alien8.de
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/head_32.S | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 2e8532e..3c3f58a 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -329,7 +329,7 @@ default_entry:
 	pushfl
 	popl %eax			# get EFLAGS
 	testl $X86_EFLAGS_ID,%eax	# did EFLAGS.ID remained set?
-	jz 6f				# hw disallowed setting of ID bit
+	jz enable_paging		# hw disallowed setting of ID bit
 					# which means no CPUID and no CR4
 
 	xorl %eax,%eax
@@ -339,13 +339,13 @@ default_entry:
 	movl $1,%eax
 	cpuid
 	andl $~1,%edx			# Ignore CPUID.FPU
-	jz 6f				# No flags or only CPUID.FPU = no CR4
+	jz enable_paging		# No flags or only CPUID.FPU = no CR4
 
 	movl pa(mmu_cr4_features),%eax
 	movl %eax,%cr4
 
 	testb $X86_CR4_PAE, %al		# check if PAE is enabled
-	jz 6f
+	jz enable_paging
 
 	/* Check if extended functions are implemented */
 	movl $0x80000000, %eax
@@ -353,7 +353,7 @@ default_entry:
 	/* Value must be in the range 0x80000001 to 0x8000ffff */
 	subl $0x80000001, %eax
 	cmpl $(0x8000ffff-0x80000001), %eax
-	ja 6f
+	ja enable_paging
 
 	/* Clear bogus XD_DISABLE bits */
 	call verify_cpu
@@ -362,7 +362,7 @@ default_entry:
 	cpuid
 	/* Execute Disable bit supported? */
 	btl $(X86_FEATURE_NX & 31), %edx
-	jnc 6f
+	jnc enable_paging
 
 	/* Setup EFER (Extended Feature Enable Register) */
 	movl $MSR_EFER, %ecx
@@ -372,7 +372,7 @@ default_entry:
 	/* Make changes effective */
 	wrmsr
 
-6:
+enable_paging:
 
 /*
  * Enable paging
