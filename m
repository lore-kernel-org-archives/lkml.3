Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859AbaEMSW1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 14:22:27 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:53675 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751511AbaEMSWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 14:22:19 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqYVAOVhclNbtADP/2dsb2JhbABZgwaseAQBAQEBAQEFAZoZAgKBIxd0glMTHCMYgQIkE4hFAccphVSIeoRHBI8piiYBiwuIBYM4O4EzJA
Date: Tue, 13 May 2014 20:22:14 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Joel Becker <jlbec@evilplan.org>, akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/2] FS/CONFIGFS: convert printk to pr_foo()
Message-Id: <20140513202214.2143f9c062ad84891067aa11@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Cc: Joel Becker <jlbec@evilplan.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/configfs/dir.c   | 8 ++++----
 fs/configfs/inode.c | 5 ++---
 fs/configfs/mount.c | 2 +-
 3 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index e081acb..727d06e 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -940,9 +940,9 @@ static void client_drop_item(struct config_item *parent_item,
 #ifdef DEBUG
 static void configfs_dump_one(struct configfs_dirent *sd, int level)
 {
-	printk(KERN_INFO "%*s\"%s\":\n", level, " ", configfs_get_name(sd));
+	pr_info("%*s\"%s\":\n", level, " ", configfs_get_name(sd));
 
-#define type_print(_type) if (sd->s_type & _type) printk(KERN_INFO "%*s %s\n", level, " ", #_type);
+#define type_print(_type) if (sd->s_type & _type) pr_info("%*s %s\n", level, " ", #_type);
 	type_print(CONFIGFS_ROOT);
 	type_print(CONFIGFS_DIR);
 	type_print(CONFIGFS_ITEM_ATTR);
@@ -1699,7 +1699,7 @@ void configfs_unregister_subsystem(struct configfs_subsystem *subsys)
 	struct dentry *root = dentry->d_sb->s_root;
 
 	if (dentry->d_parent != root) {
-		printk(KERN_ERR "configfs: Tried to unregister non-subsystem!\n");
+		pr_err("configfs: Tried to unregister non-subsystem!\n");
 		return;
 	}
 
@@ -1709,7 +1709,7 @@ void configfs_unregister_subsystem(struct configfs_subsystem *subsys)
 	mutex_lock(&configfs_symlink_mutex);
 	spin_lock(&configfs_dirent_lock);
 	if (configfs_detach_prep(dentry, NULL)) {
-		printk(KERN_ERR "configfs: Tried to unregister non-empty subsystem!\n");
+		pr_err("configfs: Tried to unregister non-empty subsystem!\n");
 	}
 	spin_unlock(&configfs_dirent_lock);
 	mutex_unlock(&configfs_symlink_mutex);
diff --git a/fs/configfs/inode.c b/fs/configfs/inode.c
index a9d35b0..fbb30db 100644
--- a/fs/configfs/inode.c
+++ b/fs/configfs/inode.c
@@ -168,9 +168,8 @@ static void configfs_set_inode_lock_class(struct configfs_dirent *sd,
 			 * In practice the maximum level of locking depth is
 			 * already reached. Just inform about possible reasons.
 			 */
-			printk(KERN_INFO "configfs: Too many levels of inodes"
-			       " for the locking correctness validator.\n");
-			printk(KERN_INFO "Spurious warnings may appear.\n");
+			pr_info("configfs: Too many levels of inodes for the locking correctness validator.\n");
+			pr_info("Spurious warnings may appear.\n");
 		}
 	}
 }
diff --git a/fs/configfs/mount.c b/fs/configfs/mount.c
index 7f26c3c..af08de0 100644
--- a/fs/configfs/mount.c
+++ b/fs/configfs/mount.c
@@ -155,7 +155,7 @@ static int __init configfs_init(void)
 
 	return 0;
 out4:
-	printk(KERN_ERR "configfs: Unable to register filesystem!\n");
+	pr_err("configfs: Unable to register filesystem!\n");
 	configfs_inode_exit();
 out3:
 	kobject_put(config_kobj);
-- 
1.8.4.5

