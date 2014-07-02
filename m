Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458AbaGBUPc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 16:15:32 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:22076 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752704AbaGBUPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 16:15:31 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Am4IABZotFNXQBPR/2dsb2JhbABagw2saQUBAQEBAQEFAW4BmWeBBxd1hDEvI4EaN4hGAcdjF4VwiTIdhC0FkAWKaJQKg0U7Lw
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/hpfs/dnode.c: fix suspect code indent
Date: Wed,  2 Jul 2014 22:14:09 +0200
Message-Id: <1404332049-5021-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix 2 checkpatch warnings:
"WARNING: suspect code indent for conditional statements"

Cc: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/hpfs/dnode.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/hpfs/dnode.c b/fs/hpfs/dnode.c
index f36fc01..2923a7b 100644
--- a/fs/hpfs/dnode.c
+++ b/fs/hpfs/dnode.c
@@ -545,12 +545,13 @@ static void delete_empty_dnode(struct inode *i, dnode_secno dno)
 			struct dnode *d1;
 			struct quad_buffer_head qbh1;
 			if (hpfs_sb(i->i_sb)->sb_chk)
-			    if (up != i->i_ino) {
-				hpfs_error(i->i_sb,
-					"bad pointer to fnode, dnode %08x, pointing to %08x, should be %08lx",
-					dno, up, (unsigned long)i->i_ino);
-				return;
-			    }
+				if (up != i->i_ino) {
+					hpfs_error(i->i_sb,
+						   "bad pointer to fnode, dnode %08x, pointing to %08x, should be %08lx",
+						   dno, up,
+						   (unsigned long)i->i_ino);
+					return;
+				}
 			if ((d1 = hpfs_map_dnode(i->i_sb, down, &qbh1))) {
 				d1->up = cpu_to_le32(up);
 				d1->root_dnode = 1;
@@ -1061,8 +1062,8 @@ struct hpfs_dirent *map_fnode_dirent(struct super_block *s, fnode_secno fno,
 		hpfs_brelse4(qbh);
 		if (hpfs_sb(s)->sb_chk)
 			if (hpfs_stop_cycles(s, dno, &c1, &c2, "map_fnode_dirent #1")) {
-			kfree(name2);
-			return NULL;
+				kfree(name2);
+				return NULL;
 		}
 		goto go_down;
 	}
-- 
1.8.4.5

