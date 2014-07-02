Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658AbaGBUt3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 16:49:29 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:7611 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753381AbaGBUsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 16:48:46 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AicIANBvtFNXQBPR/2dsb2JhbABagw2sbgEBAQEBAQUBbgGZZwGBBhd1hAQBBScvIxBROR4ZiEYBx2QXhXCJMgeEQwWQBYpoi0qIQINFOw
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: tytso@mit.edu, sasha.levin@oracle.com, akpm@linux-foundation.org,
        Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 2/4] FS/CRAMFS: use pr_fmt
Date: Wed,  2 Jul 2014 22:47:13 +0200
Message-Id: <1404334035-7027-3-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1404334035-7027-1-git-send-email-fabf@skynet.be>
References: <1404334035-7027-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use module name for "cramfs: " prefix.
(note that uncompress.c printk had no prefix).

Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/cramfs/inode.c      | 18 ++++++++++--------
 fs/cramfs/uncompress.c |  2 ++
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/fs/cramfs/inode.c b/fs/cramfs/inode.c
index 480fcb8..fa5c759 100644
--- a/fs/cramfs/inode.c
+++ b/fs/cramfs/inode.c
@@ -11,6 +11,8 @@
  * The actual compression is based on zlib, see the other files.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/pagemap.h>
@@ -277,7 +279,7 @@ static int cramfs_fill_super(struct super_block *sb, void *data, int silent)
 		/* check for wrong endianness */
 		if (super.magic == CRAMFS_MAGIC_WEND) {
 			if (!silent)
-				pr_err("cramfs: wrong endianness\n");
+				pr_err("wrong endianness\n");
 			return -EINVAL;
 		}
 
@@ -287,22 +289,22 @@ static int cramfs_fill_super(struct super_block *sb, void *data, int silent)
 		mutex_unlock(&read_mutex);
 		if (super.magic != CRAMFS_MAGIC) {
 			if (super.magic == CRAMFS_MAGIC_WEND && !silent)
-				pr_err("cramfs: wrong endianness\n");
+				pr_err("wrong endianness\n");
 			else if (!silent)
-				pr_err("cramfs: wrong magic\n");
+				pr_err("wrong magic\n");
 			return -EINVAL;
 		}
 	}
 
 	/* get feature flags first */
 	if (super.flags & ~CRAMFS_SUPPORTED_FLAGS) {
-		pr_err("cramfs: unsupported filesystem features\n");
+		pr_err("unsupported filesystem features\n");
 		return -EINVAL;
 	}
 
 	/* Check that the root inode is in a sane state */
 	if (!S_ISDIR(super.root.mode)) {
-		pr_err("cramfs: root is not a directory\n");
+		pr_err("root is not a directory\n");
 		return -EINVAL;
 	}
 	/* correct strange, hard-coded permissions of mkcramfs */
@@ -321,12 +323,12 @@ static int cramfs_fill_super(struct super_block *sb, void *data, int silent)
 	sbi->magic=super.magic;
 	sbi->flags=super.flags;
 	if (root_offset == 0)
-		pr_info("cramfs: empty filesystem");
+		pr_info("empty filesystem");
 	else if (!(super.flags & CRAMFS_FLAG_SHIFTED_ROOT_OFFSET) &&
 		 ((root_offset != sizeof(struct cramfs_super)) &&
 		  (root_offset != 512 + sizeof(struct cramfs_super))))
 	{
-		pr_err("cramfs: bad root offset %lu\n", root_offset);
+		pr_err("bad root offset %lu\n", root_offset);
 		return -EINVAL;
 	}
 
@@ -511,7 +513,7 @@ static int cramfs_readpage(struct file *file, struct page * page)
 		if (compr_len == 0)
 			; /* hole */
 		else if (unlikely(compr_len > (PAGE_CACHE_SIZE << 1))) {
-			pr_err("cramfs: bad compressed blocksize %u\n",
+			pr_err("bad compressed blocksize %u\n",
 				compr_len);
 			goto err;
 		} else {
diff --git a/fs/cramfs/uncompress.c b/fs/cramfs/uncompress.c
index 76428cc..b7f030b 100644
--- a/fs/cramfs/uncompress.c
+++ b/fs/cramfs/uncompress.c
@@ -15,6 +15,8 @@
  * then is used by multiple filesystems.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/vmalloc.h>
-- 
1.8.4.5

