Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757942AbaGBUEG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 16:04:06 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:61328 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757821AbaGBUEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 16:04:04 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Am4IAJFktFNXQBPR/2dsb2JhbABagw2sZgUBAQEBAQEFAW4BmWeBBxd1hDEvI4EaN4hGAcd1hXCJMh2ELQWQBYpolAqDRTs
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/efs/namei.c: return is not a function
Date: Wed,  2 Jul 2014 22:02:43 +0200
Message-Id: <1404331363-3865-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch errors:

"ERROR: return is not a function, parentheses are not required"

Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/efs/namei.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/efs/namei.c b/fs/efs/namei.c
index 356c044..bbee8f0 100644
--- a/fs/efs/namei.c
+++ b/fs/efs/namei.c
@@ -12,7 +12,8 @@
 #include "efs.h"
 
 
-static efs_ino_t efs_find_entry(struct inode *inode, const char *name, int len) {
+static efs_ino_t efs_find_entry(struct inode *inode, const char *name, int len)
+{
 	struct buffer_head *bh;
 
 	int			slot, namelen;
@@ -40,10 +41,10 @@ static efs_ino_t efs_find_entry(struct inode *inode, const char *name, int len)
 		if (be16_to_cpu(dirblock->magic) != EFS_DIRBLK_MAGIC) {
 			pr_err("%s(): invalid directory block\n", __func__);
 			brelse(bh);
-			return(0);
+			return 0;
 		}
 
-		for(slot = 0; slot < dirblock->slots; slot++) {
+		for (slot = 0; slot < dirblock->slots; slot++) {
 			dirslot  = (struct efs_dentry *) (((char *) bh->b_data) + EFS_SLOTAT(dirblock, slot));
 
 			namelen  = dirslot->namelen;
@@ -52,12 +53,12 @@ static efs_ino_t efs_find_entry(struct inode *inode, const char *name, int len)
 			if ((namelen == len) && (!memcmp(name, nameptr, len))) {
 				inodenum = be32_to_cpu(dirslot->inode);
 				brelse(bh);
-				return(inodenum);
+				return inodenum;
 			}
 		}
 		brelse(bh);
 	}
-	return(0);
+	return 0;
 }
 
 struct dentry *efs_lookup(struct inode *dir, struct dentry *dentry, unsigned int flags)
-- 
1.8.4.5

