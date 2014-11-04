Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602AbaKDInq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 03:43:46 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:62818 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399AbaKDInl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 03:43:41 -0500
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, yann.morin.1998@free.fr, mmarek@suse.cz,
        sassmann@kpanic.de, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [PATCH v1 07/11] backports: split Kconfig into Kconfig.package and Kconfig.sources
Date: Tue,  4 Nov 2014 00:42:58 -0800
Message-Id: <1415090582-14129-8-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415090582-14129-1-git-send-email-mcgrof@do-not-panic.com>
References: <1415090582-14129-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

This splits up the Kconfig from things which are needed due to
our copy of code from the kernel and things which we need
specifically only for packaging backports. We will later then
share the Kconfig.souce for instance for kernel integration.

While at it, split up the list of files that we need to copy
into what we know could be shared for integration. The the
case of backport packaging Kconfig.package will be copied to
the package's Kconfig when building the package with gentree.py.

Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 backport/Kconfig         | 54 ------------------------------------------------
 backport/Kconfig.package | 32 ++++++++++++++++++++++++++++
 backport/Kconfig.sources | 23 +++++++++++++++++++++
 gentree.py               | 22 +++++++++++++++++---
 4 files changed, 74 insertions(+), 57 deletions(-)
 delete mode 100644 backport/Kconfig
 create mode 100644 backport/Kconfig.package
 create mode 100644 backport/Kconfig.sources

diff --git a/backport/Kconfig b/backport/Kconfig
deleted file mode 100644
index c523323..0000000
--- a/backport/Kconfig
+++ /dev/null
@@ -1,54 +0,0 @@
-mainmenu "Linux Backports from $BACKPORTED_KERNEL_NAME $BACKPORTED_KERNEL_VERSION (with backports $BACKPORTS_VERSION)"
-
-config BACKPORT_DIR
-	string
-	option env="BACKPORT_DIR"
-config BACKPORTS_VERSION
-	string
-	option env="BACKPORTS_VERSION"
-config BACKPORTED_KERNEL_VERSION
-	string
-	option env="BACKPORTED_KERNEL_VERSION"
-config BACKPORTED_KERNEL_NAME
-	string
-	option env="BACKPORTED_KERNEL_NAME"
-
-# these will be generated
-source "$BACKPORT_DIR/Kconfig.kernel"
-source "$BACKPORT_DIR/Kconfig.versions"
-
-# some hacks for when we use backports to generate a package
-# to build modules out of tree.
-#ignore-parser-package
-config WIRELESS
-	def_bool y
-#ignore-parser-package
-config NET_CORE
-	def_bool y
-#ignore-parser-package
-config EXPERT
-	def_bool y
-
-# this has the configuration for the backport code
-source "$BACKPORT_DIR/compat/Kconfig"
-
-# these are copied from the kernel
-source "$BACKPORT_DIR/net/wireless/Kconfig"
-source "$BACKPORT_DIR/net/mac80211/Kconfig"
-source "$BACKPORT_DIR/net/bluetooth/Kconfig"
-source "$BACKPORT_DIR/drivers/net/wireless/Kconfig"
-source "$BACKPORT_DIR/drivers/net/ethernet/Kconfig"
-source "$BACKPORT_DIR/drivers/net/usb/Kconfig"
-
-source "$BACKPORT_DIR/drivers/ssb/Kconfig"
-source "$BACKPORT_DIR/drivers/bcma/Kconfig"
-
-source "$BACKPORT_DIR/net/nfc/Kconfig"
-
-source "$BACKPORT_DIR/drivers/media/Kconfig"
-
-source "$BACKPORT_DIR/net/ieee802154/Kconfig"
-source "$BACKPORT_DIR/net/mac802154/Kconfig"
-source "$BACKPORT_DIR/drivers/net/ieee802154/Kconfig"
-
-source "$BACKPORT_DIR/drivers/usb/class/Kconfig"
diff --git a/backport/Kconfig.package b/backport/Kconfig.package
new file mode 100644
index 0000000..c507de4
--- /dev/null
+++ b/backport/Kconfig.package
@@ -0,0 +1,32 @@
+mainmenu "Backports from $BACKPORTED_KERNEL_NAME $BACKPORTED_KERNEL_VERSION (backports $BACKPORTS_VERSION)"
+
+config BACKPORT_DIR
+	string
+	option env="BACKPORT_DIR"
+config BACKPORTS_VERSION
+	string
+	option env="BACKPORTS_VERSION"
+config BACKPORTED_KERNEL_VERSION
+	string
+	option env="BACKPORTED_KERNEL_VERSION"
+config BACKPORTED_KERNEL_NAME
+	string
+	option env="BACKPORTED_KERNEL_NAME"
+
+# some hacks for when we use backports to generate a package
+# to build modules out of tree.
+#ignore-parser-package
+config WIRELESS
+	def_bool y
+#ignore-parser-package
+config NET_CORE
+	def_bool y
+#ignore-parser-package
+config EXPERT
+	def_bool y
+
+source "$BACKPORT_DIR/Kconfig.sources"
+
+# these will be generated
+source "$BACKPORT_DIR/Kconfig.kernel"
+source "$BACKPORT_DIR/Kconfig.versions"
diff --git a/backport/Kconfig.sources b/backport/Kconfig.sources
new file mode 100644
index 0000000..cdf993c
--- /dev/null
+++ b/backport/Kconfig.sources
@@ -0,0 +1,23 @@
+# this has the configuration for the backport code
+source "$BACKPORT_DIR/compat/Kconfig"
+
+# these are copied from the kernel
+source "$BACKPORT_DIR/net/wireless/Kconfig"
+source "$BACKPORT_DIR/net/mac80211/Kconfig"
+source "$BACKPORT_DIR/net/bluetooth/Kconfig"
+source "$BACKPORT_DIR/drivers/net/wireless/Kconfig"
+source "$BACKPORT_DIR/drivers/net/ethernet/Kconfig"
+source "$BACKPORT_DIR/drivers/net/usb/Kconfig"
+
+source "$BACKPORT_DIR/drivers/ssb/Kconfig"
+source "$BACKPORT_DIR/drivers/bcma/Kconfig"
+
+source "$BACKPORT_DIR/net/nfc/Kconfig"
+
+source "$BACKPORT_DIR/drivers/media/Kconfig"
+
+source "$BACKPORT_DIR/net/ieee802154/Kconfig"
+source "$BACKPORT_DIR/net/mac802154/Kconfig"
+source "$BACKPORT_DIR/drivers/net/ieee802154/Kconfig"
+
+source "$BACKPORT_DIR/drivers/usb/class/Kconfig"
diff --git a/gentree.py b/gentree.py
index 3d4a8b4..860bb71 100755
--- a/gentree.py
+++ b/gentree.py
@@ -746,11 +746,27 @@ def process(kerneldir, outdir, copy_list_file, git_revision=None,
     check_output_dir(args.outdir, args.clean)
 
     # do the copy
+    backport_package_files = [(x, x) for x in [
+        'Makefile',
+        'kconf/',
+        'Makefile.real',
+        'Makefile.kernel',
+        'scripts/',
+        '.blacklist.map',
+        '.gitignore',
+        'Makefile.build'] ]
+    backport_package_files += [
+            ('Kconfig.package', 'Kconfig'),
+            ]
     backport_files = [(x, x) for x in [
-        'Kconfig', 'Makefile', 'Makefile.build', 'Makefile.kernel', '.gitignore',
-        'Makefile.real', 'compat/', 'backport-include/', 'kconf/',
-        'scripts/', '.blacklist.map',
+        'Kconfig.sources',
+        'compat/',
+        'backport-include/',
     ]]
+
+    if not integrate:
+        backport_files += backport_package_files
+
     if not args.git_revision:
         logwrite('Copy original source files ...')
     else:
-- 
2.1.1

