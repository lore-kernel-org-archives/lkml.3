Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751730AbaEVR6b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 13:58:31 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:64174 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750760AbaEVR6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 13:58:30 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuQLAAI6flNbsFZY/2dsb2JhbABZgwerCgoFAYM6lwGBDRd0glMTHCMYgQIkE4hFAdcOhVWIeYRHAQOPP4oxAYsXiA+DOjs
Date: Thu, 22 May 2014 19:58:27 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>, akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1 linux-next] FS/HFSPLUS: fix pr_foo() and hfs_dbg formats
Message-Id: <20140522195827.d09991a0c3b060802c9dea1c@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Suggested-By: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/hfsplus/extents.c | 7 +++----
 fs/hfsplus/super.c   | 3 ++-
 fs/hfsplus/xattr.c   | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/hfsplus/extents.c b/fs/hfsplus/extents.c
index a09fcb6..feca524 100644
--- a/fs/hfsplus/extents.c
+++ b/fs/hfsplus/extents.c
@@ -436,10 +436,9 @@ int hfsplus_file_extend(struct inode *inode, bool zeroout)
 	if (sbi->alloc_file->i_size * 8 <
 	    sbi->total_blocks - sbi->free_blocks + 8) {
 		/* extend alloc file */
-		pr_err("extend alloc file! "
-				"(%llu,%u,%u)\n",
-			sbi->alloc_file->i_size * 8,
-			sbi->total_blocks, sbi->free_blocks);
+		pr_err("extend alloc file! (%llu,%u,%u)\n",
+		       sbi->alloc_file->i_size * 8,
+		       sbi->total_blocks, sbi->free_blocks);
 		return -ENOSPC;
 	}
 
diff --git a/fs/hfsplus/super.c b/fs/hfsplus/super.c
index dcb4741..593af2f 100644
--- a/fs/hfsplus/super.c
+++ b/fs/hfsplus/super.c
@@ -131,9 +131,10 @@ static int hfsplus_system_write_inode(struct inode *inode)
 	hfsplus_inode_write_fork(inode, fork);
 	if (tree) {
 		int err = hfs_btree_write(tree);
+
 		if (err) {
 			pr_err("b-tree write err: %d, ino %lu\n",
-					err, inode->i_ino);
+			       err, inode->i_ino);
 			return err;
 		}
 	}
diff --git a/fs/hfsplus/xattr.c b/fs/hfsplus/xattr.c
index aab093c..744e261 100644
--- a/fs/hfsplus/xattr.c
+++ b/fs/hfsplus/xattr.c
@@ -70,7 +70,7 @@ static void hfsplus_init_header_node(struct inode *attr_file,
 	loff_t tmp;
 
 	hfs_dbg(ATTR_MOD, "init_hdr_attr_file: clump %u, node_size %u\n",
-				clump_size, node_size);
+		clump_size, node_size);
 
 	/* The end of the node contains list of record offsets */
 	rec_offsets = (__be16 *)(buf + node_size);
-- 
1.9.1

