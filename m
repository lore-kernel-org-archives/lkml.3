Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052AbaCaMwN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 08:52:13 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:32893 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565AbaCaMwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 08:52:12 -0400
Date: Mon, 31 Mar 2014 14:52:08 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/cleanups for v3.15
Message-ID: <20140331125208.GA9690@gmail.com>
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

   # HEAD: b82ad3d3944193e5f95319c30fd24e39d0d7b510 x86, pageattr: Correct WBINVD spelling in comment

Various smaller cleanups.

 Thanks,

	Ingo

------------------>
Borislav Petkov (3):
      x86, boot: Correct max ramdisk size name
      x86, crash: Unify ifdef
      x86, pageattr: Correct WBINVD spelling in comment


 Documentation/x86/boot.txt | 4 ++--
 arch/x86/boot/header.S     | 2 +-
 arch/x86/kernel/crash.c    | 2 --
 arch/x86/mm/pageattr.c     | 6 +++---
 4 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/Documentation/x86/boot.txt b/Documentation/x86/boot.txt
index cb81741d..a75e3ad 100644
--- a/Documentation/x86/boot.txt
+++ b/Documentation/x86/boot.txt
@@ -182,7 +182,7 @@ Offset	Proto	Name		Meaning
 0226/1	2.02+(3 ext_loader_ver	Extended boot loader version
 0227/1	2.02+(3	ext_loader_type	Extended boot loader ID
 0228/4	2.02+	cmd_line_ptr	32-bit pointer to the kernel command line
-022C/4	2.03+	ramdisk_max	Highest legal initrd address
+022C/4	2.03+	initrd_addr_max	Highest legal initrd address
 0230/4	2.05+	kernel_alignment Physical addr alignment required for kernel
 0234/1	2.05+	relocatable_kernel Whether kernel is relocatable or not
 0235/1	2.10+	min_alignment	Minimum alignment, as a power of two
@@ -534,7 +534,7 @@ Protocol:	2.02+
   zero, the kernel will assume that your boot loader does not support
   the 2.02+ protocol.
 
-Field name:	ramdisk_max
+Field name:	initrd_addr_max
 Type:		read
 Offset/size:	0x22c/4
 Protocol:	2.03+
diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
index ec3b8ba..46f5a22 100644
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -350,7 +350,7 @@ cmd_line_ptr:	.long	0		# (Header version 0x0202 or later)
 					# can be located anywhere in
 					# low memory 0x10000 or higher.
 
-ramdisk_max:	.long 0x7fffffff
+initrd_addr_max: .long 0x7fffffff
 					# (Header version 0x0203 or later)
 					# The highest safe address for
 					# the contents of an initrd
diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index a57902e..507de80 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -57,9 +57,7 @@ static void kdump_nmi_callback(int cpu, struct pt_regs *regs)
 {
 #ifdef CONFIG_X86_32
 	struct pt_regs fixed_regs;
-#endif
 
-#ifdef CONFIG_X86_32
 	if (!user_mode_vm(regs)) {
 		crash_fixup_ss_esp(&fixed_regs, regs);
 		regs = &fixed_regs;
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index b3b19f4..ba957c9 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -1377,10 +1377,10 @@ static int change_page_attr_set_clr(unsigned long *addr, int numpages,
 	cache = cache_attr(mask_set);
 
 	/*
-	 * On success we use clflush, when the CPU supports it to
-	 * avoid the wbindv. If the CPU does not support it and in the
+	 * On success we use CLFLUSH, when the CPU supports it to
+	 * avoid the WBINVD. If the CPU does not support it and in the
 	 * error case we fall back to cpa_flush_all (which uses
-	 * wbindv):
+	 * WBINVD):
 	 */
 	if (!ret && cpu_has_clflush) {
 		if (cpa.flags & (CPA_PAGES_ARRAY | CPA_ARRAY)) {
