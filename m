Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbaIKVfC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 17:35:02 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44720 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287AbaIKVfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 17:35:00 -0400
Date: Thu, 11 Sep 2014 14:34:46 -0700
From: tip-bot for Dave Hansen <tipbot@zytor.com>
Message-ID: <tip-9298b815efe500b272e4084ed05eeae7a92b5340@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        dave.hansen@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com,
        bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, dave.hansen@linux.intel.com, bp@suse.de,
        hpa@linux.intel.com
In-Reply-To: <20140911211524.C0EC332A@viggo.jf.intel.com>
References: <20140911211524.C0EC332A@viggo.jf.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpufeature] x86: Add more disabled features
Git-Commit-ID: 9298b815efe500b272e4084ed05eeae7a92b5340
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

Commit-ID:  9298b815efe500b272e4084ed05eeae7a92b5340
Gitweb:     http://git.kernel.org/tip/9298b815efe500b272e4084ed05eeae7a92b5340
Author:     Dave Hansen <dave.hansen@linux.intel.com>
AuthorDate: Thu, 11 Sep 2014 14:15:24 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 11 Sep 2014 14:30:17 -0700

x86: Add more disabled features

The original motivation for these patches was for an Intel CPU
feature called MPX.  The patch to add a disabled feature for it
will go in with the other parts of the support.

But, in the meantime, there are a few other features than MPX
that we can make assumptions about at compile-time based on
compile options.  Add them to disabled-features.h and check them
with cpu_feature_enabled().

Note that this gets rid of the last things that needed an #ifdef
CONFIG_X86_64 in cpufeature.h.  Yay!

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: http://lkml.kernel.org/r/20140911211524.C0EC332A@viggo.jf.intel.com
Acked-by: Borislav Petkov <bp@suse.de>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/cpufeature.h        | 20 --------------------
 arch/x86/include/asm/disabled-features.h | 16 ++++++++++++++--
 arch/x86/kernel/cpu/common.c             |  2 +-
 arch/x86/kernel/cpu/mtrr/main.c          |  6 +++---
 4 files changed, 18 insertions(+), 26 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 1492041..42db503 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -324,7 +324,6 @@ extern const char * const x86_bug_flags[NBUGINTS*32];
 } while (0)
 
 #define cpu_has_fpu		boot_cpu_has(X86_FEATURE_FPU)
-#define cpu_has_vme		boot_cpu_has(X86_FEATURE_VME)
 #define cpu_has_de		boot_cpu_has(X86_FEATURE_DE)
 #define cpu_has_pse		boot_cpu_has(X86_FEATURE_PSE)
 #define cpu_has_tsc		boot_cpu_has(X86_FEATURE_TSC)
@@ -343,9 +342,6 @@ extern const char * const x86_bug_flags[NBUGINTS*32];
 #define cpu_has_avx2		boot_cpu_has(X86_FEATURE_AVX2)
 #define cpu_has_ht		boot_cpu_has(X86_FEATURE_HT)
 #define cpu_has_nx		boot_cpu_has(X86_FEATURE_NX)
-#define cpu_has_k6_mtrr		boot_cpu_has(X86_FEATURE_K6_MTRR)
-#define cpu_has_cyrix_arr	boot_cpu_has(X86_FEATURE_CYRIX_ARR)
-#define cpu_has_centaur_mcr	boot_cpu_has(X86_FEATURE_CENTAUR_MCR)
 #define cpu_has_xstore		boot_cpu_has(X86_FEATURE_XSTORE)
 #define cpu_has_xstore_enabled	boot_cpu_has(X86_FEATURE_XSTORE_EN)
 #define cpu_has_xcrypt		boot_cpu_has(X86_FEATURE_XCRYPT)
@@ -380,22 +376,6 @@ extern const char * const x86_bug_flags[NBUGINTS*32];
 #define cpu_has_eager_fpu	boot_cpu_has(X86_FEATURE_EAGER_FPU)
 #define cpu_has_topoext		boot_cpu_has(X86_FEATURE_TOPOEXT)
 
-#ifdef CONFIG_X86_64
-
-#undef  cpu_has_vme
-#define cpu_has_vme		0
-
-#undef  cpu_has_k6_mtrr
-#define cpu_has_k6_mtrr		0
-
-#undef  cpu_has_cyrix_arr
-#define cpu_has_cyrix_arr	0
-
-#undef  cpu_has_centaur_mcr
-#define cpu_has_centaur_mcr	0
-
-#endif /* CONFIG_X86_64 */
-
 #if __GNUC__ >= 4
 extern void warn_pre_alternatives(void);
 extern bool __static_cpu_has_safe(u16 bit);
diff --git a/arch/x86/include/asm/disabled-features.h b/arch/x86/include/asm/disabled-features.h
index 1a9955d..97534a7 100644
--- a/arch/x86/include/asm/disabled-features.h
+++ b/arch/x86/include/asm/disabled-features.h
@@ -10,13 +10,25 @@
  * cpu_feature_enabled().
  */
 
+#ifdef CONFIG_X86_64
+# define DISABLE_VME		(1<<(X86_FEATURE_VME & 31))
+# define DISABLE_K6_MTRR	(1<<(X86_FEATURE_K6_MTRR & 31))
+# define DISABLE_CYRIX_ARR	(1<<(X86_FEATURE_CYRIX_ARR & 31))
+# define DISABLE_CENTAUR_MCR	(1<<(X86_FEATURE_CENTAUR_MCR & 31))
+#else
+# define DISABLE_VME		0
+# define DISABLE_K6_MTRR	0
+# define DISABLE_CYRIX_ARR	0
+# define DISABLE_CENTAUR_MCR	0
+#endif /* CONFIG_X86_64 */
+
 /*
  * Make sure to add features to the correct mask
  */
-#define DISABLED_MASK0	0
+#define DISABLED_MASK0	(DISABLE_VME)
 #define DISABLED_MASK1	0
 #define DISABLED_MASK2	0
-#define DISABLED_MASK3	0
+#define DISABLED_MASK3	(DISABLE_CYRIX_ARR|DISABLE_CENTAUR_MCR|DISABLE_K6_MTRR)
 #define DISABLED_MASK4	0
 #define DISABLED_MASK5	0
 #define DISABLED_MASK6	0
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index e4ab2b4..724d221 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1391,7 +1391,7 @@ void cpu_init(void)
 
 	printk(KERN_INFO "Initializing CPU#%d\n", cpu);
 
-	if (cpu_has_vme || cpu_has_tsc || cpu_has_de)
+	if (cpu_feature_enabled(X86_FEATURE_VME) || cpu_has_tsc || cpu_has_de)
 		clear_in_cr4(X86_CR4_VME|X86_CR4_PVI|X86_CR4_TSD|X86_CR4_DE);
 
 	load_current_idt();
diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index f961de9..ea5f363 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -707,7 +707,7 @@ void __init mtrr_bp_init(void)
 	} else {
 		switch (boot_cpu_data.x86_vendor) {
 		case X86_VENDOR_AMD:
-			if (cpu_has_k6_mtrr) {
+			if (cpu_feature_enabled(X86_FEATURE_K6_MTRR)) {
 				/* Pre-Athlon (K6) AMD CPU MTRRs */
 				mtrr_if = mtrr_ops[X86_VENDOR_AMD];
 				size_or_mask = SIZE_OR_MASK_BITS(32);
@@ -715,14 +715,14 @@ void __init mtrr_bp_init(void)
 			}
 			break;
 		case X86_VENDOR_CENTAUR:
-			if (cpu_has_centaur_mcr) {
+			if (cpu_feature_enabled(X86_FEATURE_CENTAUR_MCR)) {
 				mtrr_if = mtrr_ops[X86_VENDOR_CENTAUR];
 				size_or_mask = SIZE_OR_MASK_BITS(32);
 				size_and_mask = 0;
 			}
 			break;
 		case X86_VENDOR_CYRIX:
-			if (cpu_has_cyrix_arr) {
+			if (cpu_feature_enabled(X86_FEATURE_CYRIX_ARR)) {
 				mtrr_if = mtrr_ops[X86_VENDOR_CYRIX];
 				size_or_mask = SIZE_OR_MASK_BITS(32);
 				size_and_mask = 0;
