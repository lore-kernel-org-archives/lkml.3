Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587Ab3GAJ6k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 05:58:40 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:56267 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087Ab3GAJ6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 05:58:39 -0400
Date: Mon, 1 Jul 2013 11:58:35 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/cleanups for v3.11
Message-ID: <20130701095835.GA16921@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-cleanups-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-cleanups-for-linus

   HEAD: f037e416afb38b9ee8ac598d68733fcbaf665384 x86, reloc: Use xorl instead of xorq in relocate_kernel_64.S

Misc x86 cleanups.

 Thanks,

	Ingo

------------------>
H. Peter Anvin (1):
      x86, reloc: Use xorl instead of xorq in relocate_kernel_64.S

Michael Wang (1):
      x86, cleanups: Remove extra tab in __flush_tlb_one()

Paul Bolle (1):
      x86/mce: Remove check for CONFIG_X86_MCE_P4THERMAL


 arch/x86/include/asm/tlbflush.h      |  2 +-
 arch/x86/kernel/apic/apic.c          |  2 +-
 arch/x86/kernel/relocate_kernel_64.S | 34 +++++++++++++++++-----------------
 3 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index 50a7fc0..cf51200 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -62,7 +62,7 @@ static inline void __flush_tlb_all(void)
 
 static inline void __flush_tlb_one(unsigned long addr)
 {
-		__flush_tlb_single(addr);
+	__flush_tlb_single(addr);
 }
 
 #define TLB_FLUSH_ALL	-1UL
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 904611b..1600b1c 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -2302,7 +2302,7 @@ static void lapic_resume(void)
 	apic_write(APIC_SPIV, apic_pm_state.apic_spiv);
 	apic_write(APIC_LVT0, apic_pm_state.apic_lvt0);
 	apic_write(APIC_LVT1, apic_pm_state.apic_lvt1);
-#if defined(CONFIG_X86_MCE_P4THERMAL) || defined(CONFIG_X86_MCE_INTEL)
+#if defined(CONFIG_X86_MCE_INTEL)
 	if (maxlvt >= 5)
 		apic_write(APIC_LVTTHMR, apic_pm_state.apic_thmr);
 #endif
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
