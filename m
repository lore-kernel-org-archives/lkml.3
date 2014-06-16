Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932542AbaFPSZ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 14:25:27 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:32958 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932195AbaFPSZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 14:25:25 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlUHAHASn1NbtAal/2dsb2JhbABagw2rFgUBAQEBAQEFAZkkgREXdYQxLyOBGjeIRgHPKheFY4hKSR2ELQSPbIpXizCIKINCO4Ey
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/3] fs/romfs/super.c: convert printk to pr_foo()
Date: Mon, 16 Jun 2014 20:24:07 +0200
Message-Id: <1402943047-10653-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use current logging functions.
+coalesce formats

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/romfs/super.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/romfs/super.c b/fs/romfs/super.c
index ef90e8b..c32006e 100644
--- a/fs/romfs/super.c
+++ b/fs/romfs/super.c
@@ -380,7 +380,7 @@ static struct inode *romfs_iget(struct super_block *sb, unsigned long pos)
 eio:
 	ret = -EIO;
 error:
-	printk(KERN_ERR "ROMFS: read error for inode 0x%lx\n", pos);
+	pr_err("ROMFS: read error for inode 0x%lx\n", pos);
 	return ERR_PTR(ret);
 }
 
@@ -507,14 +507,13 @@ static int romfs_fill_super(struct super_block *sb, void *data, int silent)
 	if (rsb->word0 != ROMSB_WORD0 || rsb->word1 != ROMSB_WORD1 ||
 	    img_size < ROMFH_SIZE) {
 		if (!silent)
-			printk(KERN_WARNING "VFS:"
-			       " Can't find a romfs filesystem on dev %s.\n",
+			pr_warn("VFS: Can't find a romfs filesystem on dev %s.\n",
 			       sb->s_id);
 		goto error_rsb_inval;
 	}
 
 	if (romfs_checksum(rsb, min_t(size_t, img_size, 512))) {
-		printk(KERN_ERR "ROMFS: bad initial checksum on dev %s.\n",
+		pr_err("ROMFS: bad initial checksum on dev %s.\n",
 		       sb->s_id);
 		goto error_rsb_inval;
 	}
@@ -523,7 +522,7 @@ static int romfs_fill_super(struct super_block *sb, void *data, int silent)
 
 	len = strnlen(rsb->name, ROMFS_MAXFN);
 	if (!silent)
-		printk(KERN_NOTICE "ROMFS: Mounting image '%*.*s' through %s\n",
+		pr_notice("ROMFS: Mounting image '%*.*s' through %s\n",
 		       (unsigned) len, (unsigned) len, rsb->name, storage);
 
 	kfree(rsb);
@@ -614,7 +613,7 @@ static int __init init_romfs_fs(void)
 {
 	int ret;
 
-	printk(KERN_INFO "ROMFS MTD (C) 2007 Red Hat, Inc.\n");
+	pr_info("ROMFS MTD (C) 2007 Red Hat, Inc.\n");
 
 	romfs_inode_cachep =
 		kmem_cache_create("romfs_i",
@@ -623,13 +622,12 @@ static int __init init_romfs_fs(void)
 				  romfs_i_init_once);
 
 	if (!romfs_inode_cachep) {
-		printk(KERN_ERR
-		       "ROMFS error: Failed to initialise inode cache\n");
+		pr_err("ROMFS error: Failed to initialise inode cache\n");
 		return -ENOMEM;
 	}
 	ret = register_filesystem(&romfs_fs_type);
 	if (ret) {
-		printk(KERN_ERR "ROMFS error: Failed to register filesystem\n");
+		pr_err("ROMFS error: Failed to register filesystem\n");
 		goto error_register;
 	}
 	return 0;
-- 
1.8.4.5

