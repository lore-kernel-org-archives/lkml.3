Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062AbaKEDTn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 22:19:43 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:61693 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251AbaKEDTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 22:19:38 -0500
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, yann.morin.1998@free.fr, mmarek@suse.cz,
        sassmann@kpanic.de, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [PATCH v2 11/13] backports: prefix c-file / h-file auto backport with BPAUTO
Date: Tue,  4 Nov 2014 19:18:35 -0800
Message-Id: <1415157517-15442-12-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415157517-15442-1-git-send-email-mcgrof@do-not-panic.com>
References: <1415157517-15442-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

Things we backport are now prefixed with BACKPORT_, when we copy
over libraries with the c-files / h-files trick on the compat/Kconfig
trick we prefix these with BACKPORT_ already so in order to help
distinguish them use BACKPORT_BPAUTO_ for them and prevent a double
BACKPORT_ prefix.

Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 backport/backport-include/asm/dma-mapping.h        |  4 +-
 backport/backport-include/backport/leds-disabled.h |  2 +-
 backport/compat/Kconfig                            | 74 +++++++++++-----------
 backport/compat/Makefile                           |  4 +-
 backport/compat/backports.h                        |  4 +-
 gentree.py                                         |  2 +-
 patches/backport-adjustments/devcoredump.patch     |  4 +-
 7 files changed, 47 insertions(+), 47 deletions(-)

diff --git a/backport/backport-include/asm/dma-mapping.h b/backport/backport-include/asm/dma-mapping.h
index 844fe3b..b73b7da 100644
--- a/backport/backport-include/asm/dma-mapping.h
+++ b/backport/backport-include/asm/dma-mapping.h
@@ -3,12 +3,12 @@
 #include_next <asm/dma-mapping.h>
 #include <linux/version.h>
 
-#if defined(CPTCFG_BACKPORT_BUILD_DMA_SHARED_HELPERS)
+#if defined(CPTCFG_BPAUTO_BUILD_DMA_SHARED_HELPERS)
 #define dma_common_get_sgtable LINUX_BACKPORT(dma_common_get_sgtable)
 int
 dma_common_get_sgtable(struct device *dev, struct sg_table *sgt,
 		       void *cpu_addr, dma_addr_t dma_addr, size_t size);
-#endif /* defined(CPTCFG_BACKPORT_BUILD_DMA_SHARED_HELPERS) */
+#endif /* defined(CPTCFG_BPAUTO_BUILD_DMA_SHARED_HELPERS) */
 
 #if LINUX_VERSION_CODE < KERNEL_VERSION(3,6,0)
 
diff --git a/backport/backport-include/backport/leds-disabled.h b/backport/backport-include/backport/leds-disabled.h
index 501f2a0..156d7fa 100644
--- a/backport/backport-include/backport/leds-disabled.h
+++ b/backport/backport-include/backport/leds-disabled.h
@@ -8,7 +8,7 @@
  * allows compilation.
  */
 
-#ifdef CPTCFG_BACKPORT_BUILD_LEDS
+#ifdef CPTCFG_BPAUTO_BUILD_LEDS
 #include <linux/list.h>
 #include <linux/spinlock.h>
 #include <linux/rwsem.h>
diff --git a/backport/compat/Kconfig b/backport/compat/Kconfig
index 49699bd..06ef8d5 100644
--- a/backport/compat/Kconfig
+++ b/backport/compat/Kconfig
@@ -1,16 +1,16 @@
 #
 # backport Kconfig
 #
-# Some options are user-selectable ("BACKPORT_USERSEL_*")
+# Some options are user-selectable ("BPAUTO_USERSEL_*")
 #
 # Most options, however, follow a few different schemes:
 #
 # A) An option that is selected by drivers ("select FOO") will be
-#    changed to "select BACKPORT_FOO" (if the option BACKPORT_FOO
-#    exists). The option BACKPORT_FOO then controls setting of the
-#    BACKPORT_BUILD_FOO option, which is a module, like this:
+#    changed to "select BPAUTO_FOO" (if the option BPAUTO_FOO
+#    exists). The option BPAUTO_FOO then controls setting of the
+#    BPAUTO_BUILD_FOO option, which is a module, like this:
 #
-# config BACKPORT_BUILD_FOO
+# config BPAUTO_BUILD_FOO
 #	tristate
 #	# or bool
 #
@@ -25,13 +25,13 @@
 #	# kernel version X.Z
 #	depends on !FOO || BACKPORT_KERNEL_X_Z
 #
-#	# build if driver needs it (it selects BACKPORT_FOO)
-#	default m if BACKPORT_FOO
+#	# build if driver needs it (it selects BPAUTO_FOO)
+#	default m if BPAUTO_FOO
 #
-#	# or for build-testing (BACKPORT_USERSEL_BUILD_ALL is enabled)
-#	default m if BACKPORT_USERSEL_BUILD_ALL
+#	# or for build-testing (BPAUTO_USERSEL_BUILD_ALL is enabled)
+#	default m if BPAUTO_USERSEL_BUILD_ALL
 #
-# config BACKPORT_FOO
+# config BPAUTO_FOO
 #	bool
 #
 # This only works as-is if the kernel code is usable on any version,
@@ -41,44 +41,44 @@
 # B) An option for code always present on some kernels (e.g. KFIFO).
 #    This simply depends on/sets the default based on the version:
 #
-# config BACKPORT_BUILD_KFIFO
+# config BPAUTO_BUILD_KFIFO
 #	def_bool y
 #	depends on BACKPORT_KERNEL_2_6_36
 #
 #
 # C) similarly, a kconfig symbol for an option, e.g.
-#    BACKPORT_OPTION_SOME_FIX (no examples provided) check git log
+#    BPAUTO_OPTION_SOME_FIX (no examples provided) check git log
 #
 #
 # Variations are obviously possible.
 #
 
-config BACKPORT_BUILD_CORDIC
+config BPAUTO_BUILD_CORDIC
 	tristate
 	depends on !CORDIC
-	default m if BACKPORT_CORDIC
-	default m if BACKPORT_USERSEL_BUILD_ALL
+	default m if BPAUTO_CORDIC
+	default m if BPAUTO_USERSEL_BUILD_ALL
 	#module-name cordic
 	#c-file lib/cordic.c
 
-config BACKPORT_CORDIC
+config BPAUTO_CORDIC
 	bool
 
-config BACKPORT_BUILD_AVERAGE
+config BPAUTO_BUILD_AVERAGE
 	bool
 	depends on !AVERAGE
-	default y if BACKPORT_USERSEL_BUILD_ALL
-	default y if BACKPORT_AVERAGE
+	default y if BPAUTO_USERSEL_BUILD_ALL
+	default y if BPAUTO_AVERAGE
 	#h-file linux/average.h
 	#c-file lib/average.c
 
-config BACKPORT_AVERAGE
+config BPAUTO_AVERAGE
 	bool
 
-config BACKPORT_MII
+config BPAUTO_MII
 	bool
 
-config BACKPORT_BUILD_DMA_SHARED_HELPERS
+config BPAUTO_BUILD_DMA_SHARED_HELPERS
 	bool
 	depends on HAS_DMA
 	# Build on other kernels kernels < 3.9 if HAVE_GENERIC_DMA_COHERENT is
@@ -87,25 +87,25 @@ config BACKPORT_BUILD_DMA_SHARED_HELPERS
 	# Always build if on 3.3 - 3.5
 	default y if (BACKPORT_KERNEL_3_4 || BACKPORT_KERNEL_3_5 || BACKPORT_KERNEL_3_6)
 	# build for testing
-	default y if BACKPORT_USERSEL_BUILD_ALL
+	default y if BPAUTO_USERSEL_BUILD_ALL
 
-config BACKPORT_BUILD_LEDS
+config BPAUTO_BUILD_LEDS
 	bool
 	depends on !NEW_LEDS || LEDS_CLASS=n || !LEDS_TRIGGERS
-	default y if BACKPORT_NEW_LEDS
-	default y if BACKPORT_LEDS_CLASS
-	default y if BACKPORT_LEDS_TRIGGERS
+	default y if BPAUTO_NEW_LEDS
+	default y if BPAUTO_LEDS_CLASS
+	default y if BPAUTO_LEDS_TRIGGERS
 
-config BACKPORT_NEW_LEDS
+config BPAUTO_NEW_LEDS
 	bool
 
-config BACKPORT_LEDS_CLASS
+config BPAUTO_LEDS_CLASS
 	bool
 
-config BACKPORT_LEDS_TRIGGERS
+config BPAUTO_LEDS_TRIGGERS
 	bool
 
-config BACKPORT_USERSEL_BUILD_ALL
+config BPAUTO_USERSEL_BUILD_ALL
 	bool "Build all compat code"
 	help
 	  This option selects all the compat code options
@@ -114,24 +114,24 @@ config BACKPORT_USERSEL_BUILD_ALL
 	  It's only really useful for compat testing, so
 	  you probably shouldn't enable it.
 
-config BACKPORT_CRYPTO_CCM
+config BPAUTO_CRYPTO_CCM
 	depends on CRYPTO_AEAD
 	depends on CRYPTO_CTR
 	bool
 
-config BACKPORT_BUILD_CRYPTO_CCM
+config BPAUTO_BUILD_CRYPTO_CCM
 	bool
 	default n if CRYPTO_CCM
-	default y if BACKPORT_CRYPTO_CCM
+	default y if BPAUTO_CRYPTO_CCM
 	#c-file crypto/ccm.c
 
-config BACKPORT_WANT_DEV_COREDUMP
+config BPAUTO_WANT_DEV_COREDUMP
 	bool
 
-config BACKPORT_BUILD_WANT_DEV_COREDUMP
+config BPAUTO_BUILD_WANT_DEV_COREDUMP
 	bool
 	default n if DEV_COREDUMP
 	default n if DISABLE_DEV_COREDUMP
-	default y if BACKPORT_WANT_DEV_COREDUMP
+	default y if BPAUTO_WANT_DEV_COREDUMP
 	#h-file linux/devcoredump.h
 	#c-file drivers/base/devcoredump.c
diff --git a/backport/compat/Makefile b/backport/compat/Makefile
index 6d210b0..0dd69fe 100644
--- a/backport/compat/Makefile
+++ b/backport/compat/Makefile
@@ -21,5 +21,5 @@ compat-$(CPTCFG_BACKPORT_KERNEL_3_15) += backport-3.15.o
 compat-$(CPTCFG_BACKPORT_KERNEL_3_17) += backport-3.17.o
 compat-$(CPTCFG_BACKPORT_KERNEL_3_18) += backport-3.18.o
 
-compat-$(CPTCFG_BACKPORT_BUILD_CRYPTO_CCM) += crypto-ccm.o
-compat-$(CPTCFG_BACKPORT_BUILD_DMA_SHARED_HELPERS) += dma-shared-helpers.o
+compat-$(CPTCFG_BPAUTO_BUILD_CRYPTO_CCM) += crypto-ccm.o
+compat-$(CPTCFG_BPAUTO_BUILD_DMA_SHARED_HELPERS) += dma-shared-helpers.o
diff --git a/backport/compat/backports.h b/backport/compat/backports.h
index c9094ac..323c908 100644
--- a/backport/compat/backports.h
+++ b/backport/compat/backports.h
@@ -3,7 +3,7 @@
 
 #include <linux/version.h>
 
-#ifdef CPTCFG_BACKPORT_BUILD_CRYPTO_CCM
+#ifdef CPTCFG_BPAUTO_BUILD_CRYPTO_CCM
 int crypto_ccm_module_init(void);
 void crypto_ccm_module_exit(void);
 #else
@@ -13,7 +13,7 @@ static inline void crypto_ccm_module_exit(void)
 {}
 #endif
 
-#ifdef CPTCFG_BACKPORT_BUILD_WANT_DEV_COREDUMP
+#ifdef CPTCFG_BPAUTO_WANT_DEV_COREDUMP
 int devcoredump_init(void);
 void devcoredump_exit(void);
 #else
diff --git a/gentree.py b/gentree.py
index 55abe6d..e0618e5 100755
--- a/gentree.py
+++ b/gentree.py
@@ -205,7 +205,7 @@ def add_automatic_backports(args, bp_prefix):
     configtree = kconfig.ConfigTree(os.path.join(args.outdir, 'Kconfig'))
     all_selects = configtree.all_selects()
     for sym, vals in bpi.items():
-        if sym.startswith('BACKPORT_BUILD_'):
+        if sym.startswith('BPAUTO_BUILD_'):
             if not sym[15:] in all_selects:
                 disable_list.append(sym)
                 continue
diff --git a/patches/backport-adjustments/devcoredump.patch b/patches/backport-adjustments/devcoredump.patch
index 3378884..3bf35f9 100644
--- a/patches/backport-adjustments/devcoredump.patch
+++ b/patches/backport-adjustments/devcoredump.patch
@@ -107,7 +107,7 @@ index c0a360e99f64..da20e61f6c06 100644
  #include <linux/vmalloc.h>
  
 -#ifdef CONFIG_DEV_COREDUMP
-+#ifdef CPTCFG_BACKPORT_BUILD_WANT_DEV_COREDUMP
++#ifdef CPTCFG_BPAUTO_WANT_DEV_COREDUMP
  void dev_coredumpv(struct device *dev, const void *data, size_t datalen,
  		   gfp_t gfp);
  
@@ -116,6 +116,6 @@ index c0a360e99f64..da20e61f6c06 100644
  	free(data);
  }
 -#endif /* CONFIG_DEV_COREDUMP */
-+#endif /* CPTCFG_BACKPORT_BUILD_WANT_DEV_COREDUMP */
++#endif /* CPTCFG_BPAUTO_WANT_DEV_COREDUMP */
  
  #endif /* __DEVCOREDUMP_H */
-- 
2.1.1

