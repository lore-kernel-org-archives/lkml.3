Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841AbaFTQRl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 12:17:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:1749 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756796AbaFTQRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 12:17:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,514,1400050800"; 
   d="scan'208";a="531619202"
Subject: [RFC][PATCH 2/3] x86: add more disabled features
To: linux-kernel@vger.kernel.org
Cc: bp@alien8.de, x86@kernel.org, hpa@zytor.com, Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Fri, 20 Jun 2014 09:17:38 -0700
References: <20140620161736.D6AC16FD@viggo.jf.intel.com>
In-Reply-To: <20140620161736.D6AC16FD@viggo.jf.intel.com>
Message-Id: <20140620161738.3ADE37A7@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There are a few other features than MPX that we can make
assumptions about at compile-time based on compile options.
Add them to disabled-features.h

---

 b/arch/x86/include/asm/cpufeature.h        |   18 ------------------
 b/arch/x86/include/asm/disabled-features.h |   16 ++++++++++++++--
 2 files changed, 14 insertions(+), 20 deletions(-)

diff -puN arch/x86/include/asm/cpufeature.h~x86-disabled_features-addmore arch/x86/include/asm/cpufeature.h
--- a/arch/x86/include/asm/cpufeature.h~x86-disabled_features-addmore	2014-06-20 09:16:08.420317511 -0700
+++ b/arch/x86/include/asm/cpufeature.h	2014-06-20 09:16:08.425317736 -0700
@@ -357,32 +357,14 @@ extern const char * const x86_power_flag
 #define cpu_has_eager_fpu	boot_cpu_has(X86_FEATURE_EAGER_FPU)
 #define cpu_has_topoext		boot_cpu_has(X86_FEATURE_TOPOEXT)
 
-#ifdef CONFIG_X86_INTEL_MPX
-#define cpu_has_mpx boot_cpu_has(X86_FEATURE_MPX)
-#else
-#define cpu_has_mpx 0
-#endif /* CONFIG_X86_INTEL_MPX */
-
 #ifdef CONFIG_X86_64
 
-#undef  cpu_has_vme
-#define cpu_has_vme		0
-
 #undef  cpu_has_pae
 #define cpu_has_pae		___BUG___
 
 #undef  cpu_has_mp
 #define cpu_has_mp		1
 
-#undef  cpu_has_k6_mtrr
-#define cpu_has_k6_mtrr		0
-
-#undef  cpu_has_cyrix_arr
-#define cpu_has_cyrix_arr	0
-
-#undef  cpu_has_centaur_mcr
-#define cpu_has_centaur_mcr	0
-
 #endif /* CONFIG_X86_64 */
 
 #if __GNUC__ >= 4
diff -puN arch/x86/include/asm/disabled-features.h~x86-disabled_features-addmore arch/x86/include/asm/disabled-features.h
--- a/arch/x86/include/asm/disabled-features.h~x86-disabled_features-addmore	2014-06-20 09:16:08.422317600 -0700
+++ b/arch/x86/include/asm/disabled-features.h	2014-06-20 09:16:08.426317782 -0700
@@ -16,13 +16,25 @@
 # define HAVE_MPX	0
 #endif
 
+#ifdef CONFIG_X86_64
+# define HAVE_VME		(1<<(X86_FEATURE_VME & 31))
+# define HAVE_K6_MTRR		(1<<(X86_FEATURE_K6_MTRR & 31))
+# define HAVE_CYRIX_ARR		(1<<(X86_FEATURE_CYRIX_ARR & 31))
+# define HAVE_CENTAUR_MCR	(1<<(X86_FEATURE_CENTAUR_MCR & 31))
+#else
+# define HAVE_VME		0
+# define HAVE_K6_MTRR		0
+# define HAVE_CYRIX_ARR		0
+# define HAVE_CENTAUR_MCR	0
+#endif /* CONFIG_X86_64 */
+
 /*
  * Make sure to add features to the correct mask
  */
-#define DISABLED_MASK0	0
+#define DISABLED_MASK0	(HAVE_VME|HAVE_K6_MTRR)
 #define DISABLED_MASK1	0
 #define DISABLED_MASK2	0
-#define DISABLED_MASK3	0
+#define DISABLED_MASK3	(HAVE_CYRIX_ARR|HAVE_CENTAUR_MCR)
 #define DISABLED_MASK4	0
 #define DISABLED_MASK5	0
 #define DISABLED_MASK6	0
_
