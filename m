Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484AbaEMRfk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 13:35:40 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:31527 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751279AbaEMRfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 13:35:33 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqYVAORWclNbtADP/2dsb2JhbABZgwasdwQBAQEBAQEFAZoZAgKBIxd0glMTHCMYgQIkE4hFAcc1hVSIeoRHAQOPKYomAYsLiAWDODs
Date: Tue, 13 May 2014 19:35:28 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: tytso <tytso@mit.edu>, Joe Perches <joe@perches.com>,
        akpm <akpm@linux-foundation.org>
Subject: [PATCH V2] fs/devpts/inode.c: convert printk to pr_foo()
Message-Id: <20140513193528.61826f4c83d0b35e4eb94941@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also convert spaces to tabs (checkpatch warnings)
if (!dentry) KERN_NOTICE converted to pr_err
(like if (!inode) error process)

Cc: Joe Perches <joe@perches.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
v2:
  -error/pr_notice converted to pr_err
  -Adding pr_fmt
  
 fs/devpts/inode.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
index c710380..db4422c 100644
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -10,6 +10,8 @@
  *
  * ------------------------------------------------------------------------- */
 
+#define pr_fmt(fmt) "devpts: " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/fs.h>
@@ -148,10 +150,10 @@ static inline struct super_block *pts_sb_from_inode(struct inode *inode)
 
 /*
  * parse_mount_options():
- * 	Set @opts to mount options specified in @data. If an option is not
- * 	specified in @data, set it to its default value. The exception is
- * 	'newinstance' option which can only be set/cleared on a mount (i.e.
- * 	cannot be changed during remount).
+ *	Set @opts to mount options specified in @data. If an option is not
+ *	specified in @data, set it to its default value. The exception is
+ *	'newinstance' option which can only be set/cleared on a mount (i.e.
+ *	cannot be changed during remount).
  *
  * Note: @data may be NULL (in which case all options are set to default).
  */
@@ -225,7 +227,7 @@ static int parse_mount_options(char *data, int op, struct pts_mount_opts *opts)
 			break;
 #endif
 		default:
-			printk(KERN_ERR "devpts: called with bogus options\n");
+			pr_err("called with bogus options\n");
 			return -EINVAL;
 		}
 	}
@@ -261,7 +263,7 @@ static int mknod_ptmx(struct super_block *sb)
 
 	dentry = d_alloc_name(root, "ptmx");
 	if (!dentry) {
-		printk(KERN_NOTICE "Unable to alloc dentry for ptmx node\n");
+		pr_err("Unable to alloc dentry for ptmx node\n");
 		goto out;
 	}
 
@@ -270,7 +272,7 @@ static int mknod_ptmx(struct super_block *sb)
 	 */
 	inode = new_inode(sb);
 	if (!inode) {
-		printk(KERN_ERR "Unable to alloc inode for ptmx node\n");
+		pr_err("Unable to alloc inode for ptmx node\n");
 		dput(dentry);
 		goto out;
 	}
@@ -303,7 +305,7 @@ static void update_ptmx_mode(struct pts_fs_info *fsi)
 #else
 static inline void update_ptmx_mode(struct pts_fs_info *fsi)
 {
-       return;
+	return;
 }
 #endif
 
@@ -333,9 +335,11 @@ static int devpts_show_options(struct seq_file *seq, struct dentry *root)
 	struct pts_mount_opts *opts = &fsi->mount_opts;
 
 	if (opts->setuid)
-		seq_printf(seq, ",uid=%u", from_kuid_munged(&init_user_ns, opts->uid));
+		seq_printf(seq, ",uid=%u",
+			   from_kuid_munged(&init_user_ns, opts->uid));
 	if (opts->setgid)
-		seq_printf(seq, ",gid=%u", from_kgid_munged(&init_user_ns, opts->gid));
+		seq_printf(seq, ",gid=%u",
+			   from_kgid_munged(&init_user_ns, opts->gid));
 	seq_printf(seq, ",mode=%03o", opts->mode);
 #ifdef CONFIG_DEVPTS_MULTIPLE_INSTANCES
 	seq_printf(seq, ",ptmxmode=%03o", opts->ptmxmode);
@@ -396,7 +400,7 @@ devpts_fill_super(struct super_block *s, void *data, int silent)
 	if (s->s_root)
 		return 0;
 
-	printk(KERN_ERR "devpts: get root dentry failed\n");
+	pr_err("get root dentry failed\n");
 
 fail:
 	return -ENOMEM;
-- 
1.8.4.5

