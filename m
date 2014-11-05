Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191AbaKEDTr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 22:19:47 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:52939 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053AbaKEDTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 22:19:43 -0500
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, yann.morin.1998@free.fr, mmarek@suse.cz,
        sassmann@kpanic.de, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [PATCH v2 12/13] backports: remove extra BACKPORT_ prefix from kernel versioning
Date: Tue,  4 Nov 2014 19:18:36 -0800
Message-Id: <1415157517-15442-13-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415157517-15442-1-git-send-email-mcgrof@do-not-panic.com>
References: <1415157517-15442-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

The CPTCFG_ prefix already implies backport, when integration
is used we'd end up with a double BACKPORT_ prefix, so just
remove the existing one as its not needed.

Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 backport/Makefile                                  |  2 +-
 backport/compat/Kconfig                            | 10 +++----
 backport/compat/Makefile                           | 34 +++++++++++-----------
 devel/doc/kconfig-operation                        |  6 ++--
 gentree.py                                         |  2 +-
 .../media/0002-no_dmabuf/v4l2.patch                |  6 ++--
 6 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/backport/Makefile b/backport/Makefile
index fcf2f01..c21b813 100644
--- a/backport/Makefile
+++ b/backport/Makefile
@@ -93,7 +93,7 @@ mrproper:
 		print=0									;\
 		for v in $$kvers ; do							\
 			if [ "$$print" = "1" ] ; then					\
-				echo config BACKPORT_KERNEL_$$(echo $$v | tr . _)	;\
+				echo config KERNEL_$$(echo $$v | tr . _)	;\
 				echo "    def_bool y"					;\
 			fi								;\
 			if [ "$$v" = "$$kver" ] ; then print=1 ; fi			;\
diff --git a/backport/compat/Kconfig b/backport/compat/Kconfig
index 06ef8d5..aadf246 100644
--- a/backport/compat/Kconfig
+++ b/backport/compat/Kconfig
@@ -16,14 +16,14 @@
 #
 #	# not possible on kernel < X.Y, build will fail if any
 #	# drivers are allowed to build on kernels < X.Y
-#	depends on BACKPORT_KERNEL_X_Y
+#	depends on KERNEL_X_Y
 #
 #	# don't build the backport code if FOO is in the kernel
 #	# already, but only if the kernel version is also >= X.Z;
 #	# this is an example of backporting where the version of
 #	# the FOO subsystem that we need is only available from
 #	# kernel version X.Z
-#	depends on !FOO || BACKPORT_KERNEL_X_Z
+#	depends on !FOO || KERNEL_X_Z
 #
 #	# build if driver needs it (it selects BPAUTO_FOO)
 #	default m if BPAUTO_FOO
@@ -43,7 +43,7 @@
 #
 # config BPAUTO_BUILD_KFIFO
 #	def_bool y
-#	depends on BACKPORT_KERNEL_2_6_36
+#	depends on KERNEL_2_6_36
 #
 #
 # C) similarly, a kconfig symbol for an option, e.g.
@@ -83,9 +83,9 @@ config BPAUTO_BUILD_DMA_SHARED_HELPERS
 	depends on HAS_DMA
 	# Build on other kernels kernels < 3.9 if HAVE_GENERIC_DMA_COHERENT is
 	# not set. Kernels >= 3.8 have this if HAS_DMA is set.
-	depends on (!HAVE_GENERIC_DMA_COHERENT || BACKPORT_KERNEL_3_9)
+	depends on (!HAVE_GENERIC_DMA_COHERENT || KERNEL_3_9)
 	# Always build if on 3.3 - 3.5
-	default y if (BACKPORT_KERNEL_3_4 || BACKPORT_KERNEL_3_5 || BACKPORT_KERNEL_3_6)
+	default y if (KERNEL_3_4 || KERNEL_3_5 || KERNEL_3_6)
 	# build for testing
 	default y if BPAUTO_USERSEL_BUILD_ALL
 
diff --git a/backport/compat/Makefile b/backport/compat/Makefile
index 0dd69fe..e787763 100644
--- a/backport/compat/Makefile
+++ b/backport/compat/Makefile
@@ -3,23 +3,23 @@ obj-m += compat.o
 compat-y += main.o
 
 # Kernel backport compatibility code
-compat-$(CPTCFG_BACKPORT_KERNEL_3_0) += compat-3.0.o
-compat-$(CPTCFG_BACKPORT_KERNEL_3_1) += compat-3.1.o
-compat-$(CPTCFG_BACKPORT_KERNEL_3_2) += backport-3.2.o
-compat-$(CPTCFG_BACKPORT_KERNEL_3_3) += compat-3.3.o
-compat-$(CPTCFG_BACKPORT_KERNEL_3_4) += compat-3.4.o
-compat-$(CPTCFG_BACKPORT_KERNEL_3_5) += compat-3.5.o user_namespace.o
-compat-$(CPTCFG_BACKPORT_KERNEL_3_6) += compat-3.6.o
-compat-$(CPTCFG_BACKPORT_KERNEL_3_7) += compat-3.7.o
-compat-$(CPTCFG_BACKPORT_KERNEL_3_8) += compat-3.8.o
-compat-$(CPTCFG_BACKPORT_KERNEL_3_9) += compat-3.9.o
-compat-$(CPTCFG_BACKPORT_KERNEL_3_10) += backport-3.10.o
-compat-$(CPTCFG_BACKPORT_KERNEL_3_12) += backport-3.12.o
-compat-$(CPTCFG_BACKPORT_KERNEL_3_13) += backport-3.13.o
-compat-$(CPTCFG_BACKPORT_KERNEL_3_14) += backport-3.14.o
-compat-$(CPTCFG_BACKPORT_KERNEL_3_15) += backport-3.15.o
-compat-$(CPTCFG_BACKPORT_KERNEL_3_17) += backport-3.17.o
-compat-$(CPTCFG_BACKPORT_KERNEL_3_18) += backport-3.18.o
+compat-$(CPTCFG_KERNEL_3_0) += compat-3.0.o
+compat-$(CPTCFG_KERNEL_3_1) += compat-3.1.o
+compat-$(CPTCFG_KERNEL_3_2) += backport-3.2.o
+compat-$(CPTCFG_KERNEL_3_3) += compat-3.3.o
+compat-$(CPTCFG_KERNEL_3_4) += compat-3.4.o
+compat-$(CPTCFG_KERNEL_3_5) += compat-3.5.o user_namespace.o
+compat-$(CPTCFG_KERNEL_3_6) += compat-3.6.o
+compat-$(CPTCFG_KERNEL_3_7) += compat-3.7.o
+compat-$(CPTCFG_KERNEL_3_8) += compat-3.8.o
+compat-$(CPTCFG_KERNEL_3_9) += compat-3.9.o
+compat-$(CPTCFG_KERNEL_3_10) += backport-3.10.o
+compat-$(CPTCFG_KERNEL_3_12) += backport-3.12.o
+compat-$(CPTCFG_KERNEL_3_13) += backport-3.13.o
+compat-$(CPTCFG_KERNEL_3_14) += backport-3.14.o
+compat-$(CPTCFG_KERNEL_3_15) += backport-3.15.o
+compat-$(CPTCFG_KERNEL_3_17) += backport-3.17.o
+compat-$(CPTCFG_KERNEL_3_18) += backport-3.18.o
 
 compat-$(CPTCFG_BPAUTO_BUILD_CRYPTO_CCM) += crypto-ccm.o
 compat-$(CPTCFG_BPAUTO_BUILD_DMA_SHARED_HELPERS) += dma-shared-helpers.o
diff --git a/devel/doc/kconfig-operation b/devel/doc/kconfig-operation
index f1ecf60..ddb4de7 100644
--- a/devel/doc/kconfig-operation
+++ b/devel/doc/kconfig-operation
@@ -53,12 +53,12 @@ The second file (Kconfig.versions) is generated from just the version of
 the kernel and also contains invisible and unselectable boolean options
 like
 
-config BACKPORT_KERNEL_X
+config KERNEL_X
     def_bool y
 
 to indicate that APIs introduced in kernel version X (e.g. 3_3 for 3.3
 or 2_6_24 for 2.6.24) must be backported. Essentially, the presence of
-a symbol BACKPORT_KERNEL_X indicates that the kernel that the code is
+a symbol KERNEL_X indicates that the kernel that the code is
 being compiled against is older than X.
 
 All together, this allows the correct options to be selected by the user.
@@ -121,7 +121,7 @@ These are the problems and their solutions:
     requires at least 2.6.29 due to the shash crypto code. This cannot be
     determined easily automatically, so the 'dependencies' file is read
     and options that are listed there are rewritten to include
-        depends on !BACKPORT_KERNEL_X_Y
+        depends on !KERNEL_X_Y
     (where X_Y is the listed kernel version), which makes them available
     only on kernels >= X.Y.
 
diff --git a/gentree.py b/gentree.py
index e0618e5..989b6ea 100755
--- a/gentree.py
+++ b/gentree.py
@@ -930,7 +930,7 @@ def process(kerneldir, outdir, copy_list_file, git_revision=None,
             elif (dep == "DISABLE"):
                     new.append('BACKPORT_DISABLED_KCONFIG_OPTION')
             else:
-                    new.append('!BACKPORT_KERNEL_%s' % dep.replace('.', '_'))
+                    new.append('!KERNEL_%s' % dep.replace('.', '_'))
         deplist[sym] = new
     configtree.add_dependencies(deplist)
     git_debug_snapshot(args, "add kernel version dependencies")
diff --git a/patches/collateral-evolutions/media/0002-no_dmabuf/v4l2.patch b/patches/collateral-evolutions/media/0002-no_dmabuf/v4l2.patch
index 02d042a..7f88c3e 100644
--- a/patches/collateral-evolutions/media/0002-no_dmabuf/v4l2.patch
+++ b/patches/collateral-evolutions/media/0002-no_dmabuf/v4l2.patch
@@ -5,7 +5,7 @@
  # Used by drivers that need Videobuf2 modules
  config VIDEOBUF2_CORE
 -	select DMA_SHARED_BUFFER
-+	select DMA_SHARED_BUFFER if !BACKPORT_KERNEL_3_5
++	select DMA_SHARED_BUFFER if !KERNEL_3_5
  	tristate
  
  config VIDEOBUF2_MEMOPS
@@ -14,14 +14,14 @@
  	select VIDEOBUF2_CORE
  	select VIDEOBUF2_MEMOPS
 -	select DMA_SHARED_BUFFER
-+	select DMA_SHARED_BUFFER if !BACKPORT_KERNEL_3_5
++	select DMA_SHARED_BUFFER if !KERNEL_3_5
  
  config VIDEOBUF2_VMALLOC
  	tristate
  	select VIDEOBUF2_CORE
  	select VIDEOBUF2_MEMOPS
 -	select DMA_SHARED_BUFFER
-+	select DMA_SHARED_BUFFER if !BACKPORT_KERNEL_3_5
++	select DMA_SHARED_BUFFER if !KERNEL_3_5
  
  config VIDEOBUF2_DMA_SG
  	tristate
-- 
2.1.1

