Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158AbaEMSYk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 14:24:40 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:26390 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752364AbaEMSYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 14:24:32 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqYVACZeclNbtADP/2dsb2JhbABZgwaseAQBAQEBAQEFAZoZAgKBIxd0glMTHCMYgQIkE4hFAccrhVSIeoRHBI8piiYBiwuIBYM4O4EzJA
Date: Tue, 13 May 2014 20:24:28 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Joel Becker <jlbec@evilplan.org>
Subject: [PATCH 2/2] FS/CONFIGFS: Use pr_fmt
Message-Id: <20140513202428.77c59d530a2c2154a9902cb3@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-Adding pr_fmt based on module name.

Cc: Joel Becker <jlbec@evilplan.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/configfs/configfs_internal.h | 6 ++++++
 fs/configfs/dir.c               | 4 ++--
 fs/configfs/inode.c             | 2 +-
 fs/configfs/mount.c             | 4 ++--
 4 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/configfs/configfs_internal.h b/fs/configfs/configfs_internal.h
index b5f0a3b..bd4a3c1 100644
--- a/fs/configfs/configfs_internal.h
+++ b/fs/configfs/configfs_internal.h
@@ -24,6 +24,12 @@
  * configfs Copyright (C) 2005 Oracle.  All rights reserved.
  */
 
+#ifdef pr_fmt
+#undef pr_fmt
+#endif
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/slab.h>
 #include <linux/list.h>
 #include <linux/spinlock.h>
diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index 727d06e..668dcab 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -1699,7 +1699,7 @@ void configfs_unregister_subsystem(struct configfs_subsystem *subsys)
 	struct dentry *root = dentry->d_sb->s_root;
 
 	if (dentry->d_parent != root) {
-		pr_err("configfs: Tried to unregister non-subsystem!\n");
+		pr_err("Tried to unregister non-subsystem!\n");
 		return;
 	}
 
@@ -1709,7 +1709,7 @@ void configfs_unregister_subsystem(struct configfs_subsystem *subsys)
 	mutex_lock(&configfs_symlink_mutex);
 	spin_lock(&configfs_dirent_lock);
 	if (configfs_detach_prep(dentry, NULL)) {
-		pr_err("configfs: Tried to unregister non-empty subsystem!\n");
+		pr_err("Tried to unregister non-empty subsystem!\n");
 	}
 	spin_unlock(&configfs_dirent_lock);
 	mutex_unlock(&configfs_symlink_mutex);
diff --git a/fs/configfs/inode.c b/fs/configfs/inode.c
index fbb30db..5946ad9 100644
--- a/fs/configfs/inode.c
+++ b/fs/configfs/inode.c
@@ -168,7 +168,7 @@ static void configfs_set_inode_lock_class(struct configfs_dirent *sd,
 			 * In practice the maximum level of locking depth is
 			 * already reached. Just inform about possible reasons.
 			 */
-			pr_info("configfs: Too many levels of inodes for the locking correctness validator.\n");
+			pr_info("Too many levels of inodes for the locking correctness validator.\n");
 			pr_info("Spurious warnings may appear.\n");
 		}
 	}
diff --git a/fs/configfs/mount.c b/fs/configfs/mount.c
index af08de0..f6c2858 100644
--- a/fs/configfs/mount.c
+++ b/fs/configfs/mount.c
@@ -85,7 +85,7 @@ static int configfs_fill_super(struct super_block *sb, void *data, int silent)
 		/* directory inodes start off with i_nlink == 2 (for "." entry) */
 		inc_nlink(inode);
 	} else {
-		pr_debug("configfs: could not get root inode\n");
+		pr_debug("could not get root inode\n");
 		return -ENOMEM;
 	}
 
@@ -155,7 +155,7 @@ static int __init configfs_init(void)
 
 	return 0;
 out4:
-	pr_err("configfs: Unable to register filesystem!\n");
+	pr_err("Unable to register filesystem!\n");
 	configfs_inode_exit();
 out3:
 	kobject_put(config_kobj);
-- 
1.8.4.5

