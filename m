Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbaKKIPf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 03:15:35 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:64770 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644AbaKKIPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 03:15:32 -0500
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, yann.morin.1998@free.fr, mmarek@suse.cz,
        sassmann@kpanic.de, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [PATCH v3 03/21] backports: move packaging kconfig hacks to its own file
Date: Tue, 11 Nov 2014 00:14:54 -0800
Message-Id: <1415693712-23743-4-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415693712-23743-1-git-send-email-mcgrof@do-not-panic.com>
References: <1415693712-23743-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

Move packaging kconfig hacks to its own file, we'll be ignoring
this file later for postprocessing. Keeping this in a separate
file will make parsing much simpler.

Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 backport/Kconfig               | 9 ++-------
 backport/Kconfig.package.hacks | 8 ++++++++
 gentree.py                     | 3 ++-
 3 files changed, 12 insertions(+), 8 deletions(-)
 create mode 100644 backport/Kconfig.package.hacks

diff --git a/backport/Kconfig b/backport/Kconfig
index b14a268..a8f2867 100644
--- a/backport/Kconfig
+++ b/backport/Kconfig
@@ -14,13 +14,8 @@ config BACKPORTED_KERNEL_NAME
 source Kconfig.kernel
 source Kconfig.versions
 
-# some hacks ...
-config WIRELESS
-	def_bool y
-config NET_CORE
-	def_bool y
-config EXPERT
-	def_bool y
+# Packaging hacks
+source Kconfig.package.hacks
 
 # this has the configuration for the backport code
 source compat/Kconfig
diff --git a/backport/Kconfig.package.hacks b/backport/Kconfig.package.hacks
new file mode 100644
index 0000000..6a429dd
--- /dev/null
+++ b/backport/Kconfig.package.hacks
@@ -0,0 +1,8 @@
+# some hacks for when we use backports to generate a package
+# to build modules out of tree.
+config WIRELESS
+	def_bool y
+config NET_CORE
+	def_bool y
+config EXPERT
+	def_bool y
diff --git a/gentree.py b/gentree.py
index 59ae19d..7a6deef 100755
--- a/gentree.py
+++ b/gentree.py
@@ -731,7 +731,8 @@ def process(kerneldir, outdir, copy_list_file, git_revision=None,
 
     # do the copy
     backport_files = [(x, x) for x in [
-        'Kconfig', 'Makefile', 'Makefile.build', 'Makefile.kernel', '.gitignore',
+        'Kconfig', 'Kconfig.package.hacks',
+        'Makefile', 'Makefile.build', 'Makefile.kernel', '.gitignore',
         'Makefile.real', 'compat/', 'backport-include/', 'kconf/',
         'scripts/', '.blacklist.map',
     ]]
-- 
2.1.1

