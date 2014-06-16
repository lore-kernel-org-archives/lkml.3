Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932678AbaFPS2a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 14:28:30 -0400
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:29806 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932105AbaFPS23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 14:28:29 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlUHAHASn1NbtAal/2dsb2JhbABagw2rFgUBAQEBAQEFAZkkgREXdYQxLyOBGjeIRgHPKheFY4hKSR2ELQSPbIpXizCIKINCO4Ey
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/3] fs/romfs/super.c: use pr_fmt in logging
Date: Mon, 16 Jun 2014 20:25:43 +0200
Message-Id: <1402943143-10724-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-Remove "Error" in format logging (already in pr_ level)
-Use modulename in pr_fmt instead of ROMFS: in each pr_ callsites.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/romfs/super.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/romfs/super.c b/fs/romfs/super.c
index c32006e..6e73879 100644
--- a/fs/romfs/super.c
+++ b/fs/romfs/super.c
@@ -56,6 +56,8 @@
  * 2 of the Licence, or (at your option) any later version.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/fs.h>
@@ -380,7 +382,7 @@ static struct inode *romfs_iget(struct super_block *sb, unsigned long pos)
 eio:
 	ret = -EIO;
 error:
-	pr_err("ROMFS: read error for inode 0x%lx\n", pos);
+	pr_err("read error for inode 0x%lx\n", pos);
 	return ERR_PTR(ret);
 }
 
@@ -513,8 +515,7 @@ static int romfs_fill_super(struct super_block *sb, void *data, int silent)
 	}
 
 	if (romfs_checksum(rsb, min_t(size_t, img_size, 512))) {
-		pr_err("ROMFS: bad initial checksum on dev %s.\n",
-		       sb->s_id);
+		pr_err("bad initial checksum on dev %s.\n", sb->s_id);
 		goto error_rsb_inval;
 	}
 
@@ -522,8 +523,8 @@ static int romfs_fill_super(struct super_block *sb, void *data, int silent)
 
 	len = strnlen(rsb->name, ROMFS_MAXFN);
 	if (!silent)
-		pr_notice("ROMFS: Mounting image '%*.*s' through %s\n",
-		       (unsigned) len, (unsigned) len, rsb->name, storage);
+		pr_notice("Mounting image '%*.*s' through %s\n",
+			  (unsigned) len, (unsigned) len, rsb->name, storage);
 
 	kfree(rsb);
 	rsb = NULL;
@@ -622,12 +623,12 @@ static int __init init_romfs_fs(void)
 				  romfs_i_init_once);
 
 	if (!romfs_inode_cachep) {
-		pr_err("ROMFS error: Failed to initialise inode cache\n");
+		pr_err("Failed to initialise inode cache\n");
 		return -ENOMEM;
 	}
 	ret = register_filesystem(&romfs_fs_type);
 	if (ret) {
-		pr_err("ROMFS error: Failed to register filesystem\n");
+		pr_err("Failed to register filesystem\n");
 		goto error_register;
 	}
 	return 0;
-- 
1.8.4.5

