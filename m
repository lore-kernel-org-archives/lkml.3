Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757504Ab3BKOWm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 09:22:42 -0500
Received: from mail.skyhub.de ([78.46.96.112]:45173 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757362Ab3BKOWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 09:22:24 -0500
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 4/4] x86, head_32: Give the 6 label a real name
Date: Mon, 11 Feb 2013 15:22:18 +0100
Message-Id: <1360592538-10643-5-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
In-Reply-To: <1360592538-10643-1-git-send-email-bp@alien8.de>
References: <1360592538-10643-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Jumping here we are about to enable paging so rename the label
accordingly.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/head_32.S | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index e893ac09ca03..73afd11799ca 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -340,7 +340,7 @@ default_entry:
 	pushfl
 	popl %eax			# get EFLAGS
 	testl $X86_EFLAGS_ID,%eax	# did EFLAGS.ID remained set?
-	jz 6f				# hw disallowed setting of ID bit
+	jz enable_paging		# hw disallowed setting of ID bit
 					# which means no CPUID and no CR4
 
 	xorl %eax,%eax
@@ -350,13 +350,13 @@ default_entry:
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
@@ -364,7 +364,7 @@ default_entry:
 	/* Value must be in the range 0x80000001 to 0x8000ffff */
 	subl $0x80000001, %eax
 	cmpl $(0x8000ffff-0x80000001), %eax
-	ja 6f
+	ja enable_paging
 
 	/* Clear bogus XD_DISABLE bits */
 	call verify_cpu
@@ -373,7 +373,7 @@ default_entry:
 	cpuid
 	/* Execute Disable bit supported? */
 	btl $(X86_FEATURE_NX & 31), %edx
-	jnc 6f
+	jnc enable_paging
 
 	/* Setup EFER (Extended Feature Enable Register) */
 	movl $MSR_EFER, %ecx
@@ -383,7 +383,7 @@ default_entry:
 	/* Make changes effective */
 	wrmsr
 
-6:
+enable_paging:
 
 /*
  * Enable paging
-- 
1.8.1.3.535.ga923c31

