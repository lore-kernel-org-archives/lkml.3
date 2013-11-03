Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab3KCJxa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 04:53:30 -0500
Received: from mail-qe0-f49.google.com ([209.85.128.49]:62880 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300Ab3KCJxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 04:53:25 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/39] sysfs, kernfs: add skeletons for kernfs
Date: Sun,  3 Nov 2013 04:52:41 -0500
Message-Id: <1383472398-17812-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1383472398-17812-1-git-send-email-tj@kernel.org>
References: <1383472398-17812-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Core sysfs implementation will be separated into kernfs so that it can
be used by other non-kobject users.

This patch creates fs/kernfs/ directory and makes boilerplate changes.
kernfs interface will be directly based on sysfs_dirent and its
forward declaration is moved to include/linux/kernfs.h which is
included from include/linux/sysfs.h.  sysfs core implementation will
be gradually separated out and moved to kernfs.

This patch doesn't introduce any functional changes.

v2: mount.c added.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/Makefile            |  2 +-
 fs/kernfs/Makefile     |  5 +++++
 fs/kernfs/dir.c        |  9 +++++++++
 fs/kernfs/file.c       |  9 +++++++++
 fs/kernfs/inode.c      |  9 +++++++++
 fs/kernfs/mount.c      |  9 +++++++++
 fs/kernfs/symlink.c    |  9 +++++++++
 include/linux/kernfs.h | 12 ++++++++++++
 include/linux/sysfs.h  |  3 +--
 9 files changed, 64 insertions(+), 3 deletions(-)
 create mode 100644 fs/kernfs/Makefile
 create mode 100644 fs/kernfs/dir.c
 create mode 100644 fs/kernfs/file.c
 create mode 100644 fs/kernfs/inode.c
 create mode 100644 fs/kernfs/mount.c
 create mode 100644 fs/kernfs/symlink.c
 create mode 100644 include/linux/kernfs.h

diff --git a/fs/Makefile b/fs/Makefile
index 4fe6df3..39a824f 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -53,7 +53,7 @@ obj-$(CONFIG_FHANDLE)		+= fhandle.o
 obj-y				+= quota/
 
 obj-$(CONFIG_PROC_FS)		+= proc/
-obj-$(CONFIG_SYSFS)		+= sysfs/
+obj-$(CONFIG_SYSFS)		+= sysfs/ kernfs/
 obj-$(CONFIG_CONFIGFS_FS)	+= configfs/
 obj-y				+= devpts/
 
diff --git a/fs/kernfs/Makefile b/fs/kernfs/Makefile
new file mode 100644
index 0000000..674337c
--- /dev/null
+++ b/fs/kernfs/Makefile
@@ -0,0 +1,5 @@
+#
+# Makefile for the kernfs pseudo filesystem
+#
+
+obj-y		:= mount.o inode.o dir.o file.o symlink.o
diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
new file mode 100644
index 0000000..1061602
--- /dev/null
+++ b/fs/kernfs/dir.c
@@ -0,0 +1,9 @@
+/*
+ * fs/kernfs/dir.c - kernfs directory implementation
+ *
+ * Copyright (c) 2001-3 Patrick Mochel
+ * Copyright (c) 2007 SUSE Linux Products GmbH
+ * Copyright (c) 2007, 2013 Tejun Heo <tj@kernel.org>
+ *
+ * This file is released under the GPLv2.
+ */
diff --git a/fs/kernfs/file.c b/fs/kernfs/file.c
new file mode 100644
index 0000000..90b1e88
--- /dev/null
+++ b/fs/kernfs/file.c
@@ -0,0 +1,9 @@
+/*
+ * fs/kernfs/file.c - kernfs file implementation
+ *
+ * Copyright (c) 2001-3 Patrick Mochel
+ * Copyright (c) 2007 SUSE Linux Products GmbH
+ * Copyright (c) 2007, 2013 Tejun Heo <tj@kernel.org>
+ *
+ * This file is released under the GPLv2.
+ */
diff --git a/fs/kernfs/inode.c b/fs/kernfs/inode.c
new file mode 100644
index 0000000..86bfeea
--- /dev/null
+++ b/fs/kernfs/inode.c
@@ -0,0 +1,9 @@
+/*
+ * fs/kernfs/inode.c - kernfs inode implementation
+ *
+ * Copyright (c) 2001-3 Patrick Mochel
+ * Copyright (c) 2007 SUSE Linux Products GmbH
+ * Copyright (c) 2007, 2013 Tejun Heo <tj@kernel.org>
+ *
+ * This file is released under the GPLv2.
+ */
diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
new file mode 100644
index 0000000..872e262
--- /dev/null
+++ b/fs/kernfs/mount.c
@@ -0,0 +1,9 @@
+/*
+ * fs/kernfs/mount.c - kernfs mount implementation
+ *
+ * Copyright (c) 2001-3 Patrick Mochel
+ * Copyright (c) 2007 SUSE Linux Products GmbH
+ * Copyright (c) 2007, 2013 Tejun Heo <tj@kernel.org>
+ *
+ * This file is released under the GPLv2.
+ */
diff --git a/fs/kernfs/symlink.c b/fs/kernfs/symlink.c
new file mode 100644
index 0000000..2578715
--- /dev/null
+++ b/fs/kernfs/symlink.c
@@ -0,0 +1,9 @@
+/*
+ * fs/kernfs/symlink.c - kernfs symlink implementation
+ *
+ * Copyright (c) 2001-3 Patrick Mochel
+ * Copyright (c) 2007 SUSE Linux Products GmbH
+ * Copyright (c) 2007, 2013 Tejun Heo <tj@kernel.org>
+ *
+ * This file is released under the GPLv2.
+ */
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
new file mode 100644
index 0000000..254b9e8
--- /dev/null
+++ b/include/linux/kernfs.h
@@ -0,0 +1,12 @@
+/*
+ * kernfs.h - pseudo filesystem decoupled from vfs locking
+ *
+ * This file is released under the GPLv2.
+ */
+
+#ifndef __LINUX_KERNFS_H
+#define __LINUX_KERNFS_H
+
+struct sysfs_dirent;
+
+#endif	/* __LINUX_KERNFS_H */
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 6695040..2bc735d 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -12,6 +12,7 @@
 #ifndef _SYSFS_H_
 #define _SYSFS_H_
 
+#include <linux/kernfs.h>
 #include <linux/compiler.h>
 #include <linux/errno.h>
 #include <linux/list.h>
@@ -175,8 +176,6 @@ struct sysfs_ops {
 	ssize_t	(*store)(struct kobject *, struct attribute *, const char *, size_t);
 };
 
-struct sysfs_dirent;
-
 #ifdef CONFIG_SYSFS
 
 int sysfs_schedule_callback(struct kobject *kobj, void (*func)(void *),
-- 
1.8.3.1

