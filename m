Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504AbaCKTlx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 15:41:53 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:39012 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755286AbaCKTlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 15:41:52 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgkOAJ5mH1NXQz0l/2dsb2JhbABagwaDRr8RAgKBIRd0glMTDQ8jGIECJBOHfQG0Op0DjlyEPwSYRAGKVodXgy48
Date: Tue, 11 Mar 2014 20:43:25 +0100
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>
Subject: [PATCH 1/1] BEFS: Global conversion to pr_foo()
Message-Id: <20140311204325.59e6a3a26fc38b2184a06315@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-All printk(KERN_foo converted to pr_foo().
-Add pr_fmt and remove redundant prefixes.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/befs/debug.c    | 14 +++++++-------
 fs/befs/linuxvfs.c | 27 +++++++++++++--------------
 2 files changed, 20 insertions(+), 21 deletions(-)

diff --git a/fs/befs/debug.c b/fs/befs/debug.c
index 622e737..ebe9a28 100644
--- a/fs/befs/debug.c
+++ b/fs/befs/debug.c
@@ -10,6 +10,7 @@
  * debug functions
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 #ifdef __KERNEL__
 
 #include <stdarg.h>
@@ -31,7 +32,7 @@ befs_error(const struct super_block *sb, const char *fmt, ...)
 	va_list args;
 	char *err_buf = kmalloc(ERRBUFSIZE, GFP_KERNEL);
 	if (err_buf == NULL) {
-		printk(KERN_ERR "could not allocate %d bytes\n", ERRBUFSIZE);
+		pr_err("could not allocate %d bytes\n", ERRBUFSIZE);
 		return;
 	}
 
@@ -39,7 +40,7 @@ befs_error(const struct super_block *sb, const char *fmt, ...)
 	vsnprintf(err_buf, ERRBUFSIZE, fmt, args);
 	va_end(args);
 
-	printk(KERN_ERR "BeFS(%s): %s\n", sb->s_id, err_buf);
+	pr_err("(%s): %s\n", sb->s_id, err_buf);
 	kfree(err_buf);
 }
 
@@ -49,7 +50,7 @@ befs_warning(const struct super_block *sb, const char *fmt, ...)
 	va_list args;
 	char *err_buf = kmalloc(ERRBUFSIZE, GFP_KERNEL);
 	if (err_buf == NULL) {
-		printk(KERN_ERR "could not allocate %d bytes\n", ERRBUFSIZE);
+		pr_err("could not allocate %d bytes\n", ERRBUFSIZE);
 		return;
 	}
 
@@ -57,7 +58,7 @@ befs_warning(const struct super_block *sb, const char *fmt, ...)
 	vsnprintf(err_buf, ERRBUFSIZE, fmt, args);
 	va_end(args);
 
-	printk(KERN_WARNING "BeFS(%s): %s\n", sb->s_id, err_buf);
+	pr_warn("(%s): %s\n", sb->s_id, err_buf);
 
 	kfree(err_buf);
 }
@@ -73,8 +74,7 @@ befs_debug(const struct super_block *sb, const char *fmt, ...)
 	if (BEFS_SB(sb)->mount_opts.debug) {
 		err_buf = kmalloc(ERRBUFSIZE, GFP_KERNEL);
 		if (err_buf == NULL) {
-			printk(KERN_ERR "could not allocate %d bytes\n",
-				ERRBUFSIZE);
+			pr_err("could not allocate %d bytes\n", ERRBUFSIZE);
 			return;
 		}
 
@@ -82,7 +82,7 @@ befs_debug(const struct super_block *sb, const char *fmt, ...)
 		vsnprintf(err_buf, ERRBUFSIZE, fmt, args);
 		va_end(args);
 
-		printk(KERN_DEBUG "BeFS(%s): %s\n", sb->s_id, err_buf);
+		pr_debug("(%s): %s\n", sb->s_id, err_buf);
 
 		kfree(err_buf);
 	}
diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
index 845d2d6..b762b30 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -5,6 +5,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/fs.h>
@@ -454,11 +456,9 @@ befs_init_inodecache(void)
 						SLAB_MEM_SPREAD),
 					      init_once);
 	if (befs_inode_cachep == NULL) {
-		printk(KERN_ERR "befs_init_inodecache: "
-		       "Couldn't initialize inode slabcache\n");
+		pr_err("%s: Couldn't initialize inode slabcache\n", __func__);
 		return -ENOMEM;
 	}
-
 	return 0;
 }
 
@@ -715,8 +715,8 @@ parse_options(char *options, befs_mount_options * opts)
 			if (option >= 0)
 				uid = make_kuid(current_user_ns(), option);
 			if (!uid_valid(uid)) {
-				printk(KERN_ERR "BeFS: Invalid uid %d, "
-						"using default\n", option);
+				pr_err("Invalid uid %d, "
+				       "using default\n", option);
 				break;
 			}
 			opts->uid = uid;
@@ -729,8 +729,8 @@ parse_options(char *options, befs_mount_options * opts)
 			if (option >= 0)
 				gid = make_kgid(current_user_ns(), option);
 			if (!gid_valid(gid)) {
-				printk(KERN_ERR "BeFS: Invalid gid %d, "
-						"using default\n", option);
+				pr_err("Invalid gid %d, "
+				       "using default\n", option);
 				break;
 			}
 			opts->gid = gid;
@@ -740,8 +740,8 @@ parse_options(char *options, befs_mount_options * opts)
 			kfree(opts->iocharset);
 			opts->iocharset = match_strdup(&args[0]);
 			if (!opts->iocharset) {
-				printk(KERN_ERR "BeFS: allocation failure for "
-						"iocharset string\n");
+				pr_err("allocation failure for "
+				       "iocharset string\n");
 				return 0;
 			}
 			break;
@@ -749,8 +749,8 @@ parse_options(char *options, befs_mount_options * opts)
 			opts->debug = 1;
 			break;
 		default:
-			printk(KERN_ERR "BeFS: Unrecognized mount option \"%s\" "
-					"or missing value\n", p);
+			pr_err("Unrecognized mount option \"%s\" "
+			       "or missing value\n", p);
 			return 0;
 		}
 	}
@@ -793,8 +793,7 @@ befs_fill_super(struct super_block *sb, void *data, int silent)
 
 	sb->s_fs_info = kmalloc(sizeof (*befs_sb), GFP_KERNEL);
 	if (sb->s_fs_info == NULL) {
-		printk(KERN_ERR
-		       "BeFS(%s): Unable to allocate memory for private "
+		pr_err("(%s): Unable to allocate memory for private "
 		       "portion of superblock. Bailing.\n", sb->s_id);
 		goto unacquire_none;
 	}
@@ -963,7 +962,7 @@ init_befs_fs(void)
 {
 	int err;
 
-	printk(KERN_INFO "BeFS version: %s\n", BEFS_VERSION);
+	pr_info("version: %s\n", BEFS_VERSION);
 
 	err = befs_init_inodecache();
 	if (err)
-- 
1.8.1.4

