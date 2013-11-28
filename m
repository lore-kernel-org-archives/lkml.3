Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759693Ab3K1UC6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 15:02:58 -0500
Received: from mail-qe0-f50.google.com ([209.85.128.50]:47249 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932309Ab3K1TzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 14:55:04 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 07/34] sysfs, kernfs: move sysfs_open_file to include/linux/kernfs.h
Date: Thu, 28 Nov 2013 14:54:20 -0500
Message-Id: <1385668487-10181-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1385668487-10181-1-git-send-email-tj@kernel.org>
References: <20131128060518.GA5291@kroah.com>
 <1385668487-10181-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sysfs_open_file will be used as the primary handle for kernfs methods.
Move its definition from fs/sysfs/file.c to include/linux/kernfs.h and
mark the public and private fields.

This is pure relocation.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/sysfs/file.c        | 11 -----------
 include/linux/kernfs.h | 18 ++++++++++++++++++
 2 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index a43df04..acba583 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -47,17 +47,6 @@ struct sysfs_open_dirent {
 	struct list_head	files; /* goes through sysfs_open_file.list */
 };
 
-struct sysfs_open_file {
-	struct sysfs_dirent	*sd;
-	struct file		*file;
-	struct mutex		mutex;
-	int			event;
-	struct list_head	list;
-
-	bool			mmapped;
-	const struct vm_operations_struct *vm_ops;
-};
-
 static bool sysfs_is_bin(struct sysfs_dirent *sd)
 {
 	return sysfs_type(sd) == SYSFS_KOBJ_BIN_ATTR;
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index e8b73d4..b923052 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -9,12 +9,30 @@
 
 #include <linux/kernel.h>
 #include <linux/err.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
 
 struct file;
 struct iattr;
+struct seq_file;
+struct vm_area_struct;
 
 struct sysfs_dirent;
 
+struct sysfs_open_file {
+	/* published fields */
+	struct sysfs_dirent	*sd;
+	struct file		*file;
+
+	/* private fields, do not use outside kernfs proper */
+	struct mutex		mutex;
+	int			event;
+	struct list_head	list;
+
+	bool			mmapped;
+	const struct vm_operations_struct *vm_ops;
+};
+
 #ifdef CONFIG_SYSFS
 
 struct sysfs_dirent *kernfs_create_dir_ns(struct sysfs_dirent *parent,
-- 
1.8.4.2

