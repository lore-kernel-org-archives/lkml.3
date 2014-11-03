Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751284AbaKCINP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 03:13:15 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:58494 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751851AbaKCINJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 03:13:09 -0500
X-Sasl-enc: +EfV5AIX53MKgMyWZuFaj3XewUtUpmhp1c1zo9RtYQzD 1415002388
Subject: [PATCH 10/13] autofs - create autofs Kconfig and Makefile
From: Ian Kent <raven@themaw.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        autofs mailing list <autofs@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 03 Nov 2014 16:13:06 +0800
Message-ID: <20141103081305.6215.64958.stgit@perseus.themaw.net>
In-Reply-To: <20141103081218.6215.85903.stgit@perseus.themaw.net>
References: <20141103081218.6215.85903.stgit@perseus.themaw.net>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create Makefile and Kconfig for autofs module.

Signed-off-by: Ian Kent <raven@themaw.net>
---
 fs/Kconfig         |    1 +
 fs/Makefile        |    1 +
 fs/autofs/Kconfig  |   19 +++++++++++++++++++
 fs/autofs/Makefile |    7 +++++++
 4 files changed, 28 insertions(+)
 create mode 100644 fs/autofs/Kconfig
 create mode 100644 fs/autofs/Makefile

diff --git a/fs/Kconfig b/fs/Kconfig
index 664991a..18fa31d 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -65,6 +65,7 @@ source "fs/notify/Kconfig"
 
 source "fs/quota/Kconfig"
 
+source "fs/autofs/Kconfig"
 source "fs/autofs4/Kconfig"
 source "fs/fuse/Kconfig"
 source "fs/overlayfs/Kconfig"
diff --git a/fs/Makefile b/fs/Makefile
index 34a1b9de..7e1b396 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -101,6 +101,7 @@ obj-$(CONFIG_AFFS_FS)		+= affs/
 obj-$(CONFIG_ROMFS_FS)		+= romfs/
 obj-$(CONFIG_QNX4FS_FS)		+= qnx4/
 obj-$(CONFIG_QNX6FS_FS)		+= qnx6/
+obj-$(CONFIG_AUTOFS_FS)		+= autofs/
 obj-$(CONFIG_AUTOFS4_FS)	+= autofs4/
 obj-$(CONFIG_ADFS_FS)		+= adfs/
 obj-$(CONFIG_FUSE_FS)		+= fuse/
diff --git a/fs/autofs/Kconfig b/fs/autofs/Kconfig
new file mode 100644
index 0000000..17f77a6
--- /dev/null
+++ b/fs/autofs/Kconfig
@@ -0,0 +1,19 @@
+config AUTOFS_FS
+	tristate "Kernel automounter support (supports v3, v4 and v5)"
+	help
+	   The automounter is a tool to automatically mount remote file systems
+	   on demand. This implementation is partially kernel-based to reduce
+	   overhead in the already-mounted case; this is unlike the BSD
+	   automounter (amd), which is a pure user space daemon.
+
+	   To use the automounter you need the user-space tools from
+	   <ftp://ftp.kernel.org/pub/linux/daemons/autofs/>; you also want
+	   to answer Y to "NFS file system support", below.
+
+	   To compile this support as a module, choose M here: the module will be
+	   called autofs.
+
+	   If you are not a part of a fairly large, distributed network or
+	   don't have a laptop which needs to dynamically reconfigure to the
+	   local network, you probably do not need an automounter, and can say
+	   N here.
diff --git a/fs/autofs/Makefile b/fs/autofs/Makefile
new file mode 100644
index 0000000..43fedde
--- /dev/null
+++ b/fs/autofs/Makefile
@@ -0,0 +1,7 @@
+#
+# Makefile for the linux autofs-filesystem routines.
+#
+
+obj-$(CONFIG_AUTOFS_FS) += autofs.o
+
+autofs-objs := init.o inode.o root.o symlink.o waitq.o expire.o dev-ioctl.o

