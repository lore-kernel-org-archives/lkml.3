Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043AbaI2Qlz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 12:41:55 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:30942 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751921AbaI2Qlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 12:41:44 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvoNAGyLKVRbtA8r/2dsb2JhbABggw6BKrYYBQFyAZpWgRMXAXuEMS8jgRo3iEIBr2+PZYYSigyEUgWGKIsVi2uVXYNlOy+CSgEBAQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/affs/file.c: fix shadow warnings
Date: Mon, 29 Sep 2014 18:41:10 +0200
Message-Id: <1412008870-7200-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

4 functions declared variables twice resulting in shadow warnings.
This patch renames internal variables and adds blank line after declarations.

Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/affs/file.c | 39 ++++++++++++++++++++++++---------------
 1 file changed, 24 insertions(+), 15 deletions(-)

diff --git a/fs/affs/file.c b/fs/affs/file.c
index a7fe57d..1ed590a 100644
--- a/fs/affs/file.c
+++ b/fs/affs/file.c
@@ -584,11 +584,14 @@ affs_extent_file_ofs(struct inode *inode, u32 newsize)
 		bh->b_state &= ~(1UL << BH_New);
 		mark_buffer_dirty_inode(bh, inode);
 		if (prev_bh) {
-			u32 tmp = be32_to_cpu(AFFS_DATA_HEAD(prev_bh)->next);
-			if (tmp)
-				affs_warning(sb, "extent_file_ofs", "next block already set for %d (%d)", bidx, tmp);
+			u32 tmp_next = be32_to_cpu(AFFS_DATA_HEAD(prev_bh)->next);
+
+			if (tmp_next)
+				affs_warning(sb, "extent_file_ofs",
+					     "next block already set for %d (%d)",
+					     bidx, tmp_next);
 			AFFS_DATA_HEAD(prev_bh)->next = cpu_to_be32(bh->b_blocknr);
-			affs_adjust_checksum(prev_bh, bh->b_blocknr - tmp);
+			affs_adjust_checksum(prev_bh, bh->b_blocknr - tmp_next);
 			mark_buffer_dirty_inode(prev_bh, inode);
 			affs_brelse(prev_bh);
 		}
@@ -727,11 +730,14 @@ static int affs_write_end_ofs(struct file *file, struct address_space *mapping,
 			AFFS_DATA_HEAD(bh)->next = 0;
 			bh->b_state &= ~(1UL << BH_New);
 			if (prev_bh) {
-				u32 tmp = be32_to_cpu(AFFS_DATA_HEAD(prev_bh)->next);
-				if (tmp)
-					affs_warning(sb, "commit_write_ofs", "next block already set for %d (%d)", bidx, tmp);
+				u32 tmp_next = be32_to_cpu(AFFS_DATA_HEAD(prev_bh)->next);
+
+				if (tmp_next)
+					affs_warning(sb, "commit_write_ofs",
+						     "next block already set for %d (%d)",
+						     bidx, tmp_next);
 				AFFS_DATA_HEAD(prev_bh)->next = cpu_to_be32(bh->b_blocknr);
-				affs_adjust_checksum(prev_bh, bh->b_blocknr - tmp);
+				affs_adjust_checksum(prev_bh, bh->b_blocknr - tmp_next);
 				mark_buffer_dirty_inode(prev_bh, inode);
 			}
 		}
@@ -758,11 +764,14 @@ static int affs_write_end_ofs(struct file *file, struct address_space *mapping,
 			AFFS_DATA_HEAD(bh)->next = 0;
 			bh->b_state &= ~(1UL << BH_New);
 			if (prev_bh) {
-				u32 tmp = be32_to_cpu(AFFS_DATA_HEAD(prev_bh)->next);
-				if (tmp)
-					affs_warning(sb, "commit_write_ofs", "next block already set for %d (%d)", bidx, tmp);
+				u32 tmp_next = be32_to_cpu(AFFS_DATA_HEAD(prev_bh)->next);
+
+				if (tmp_next)
+					affs_warning(sb, "commit_write_ofs",
+						     "next block already set for %d (%d)",
+						     bidx, tmp_next);
 				AFFS_DATA_HEAD(prev_bh)->next = cpu_to_be32(bh->b_blocknr);
-				affs_adjust_checksum(prev_bh, bh->b_blocknr - tmp);
+				affs_adjust_checksum(prev_bh, bh->b_blocknr - tmp_next);
 				mark_buffer_dirty_inode(prev_bh, inode);
 			}
 		} else if (be32_to_cpu(AFFS_DATA_HEAD(bh)->size) < tmp)
@@ -842,12 +851,12 @@ affs_truncate(struct inode *inode)
 		struct address_space *mapping = inode->i_mapping;
 		struct page *page;
 		void *fsdata;
-		loff_t size = inode->i_size;
+		loff_t isize = inode->i_size;
 		int res;
 
-		res = mapping->a_ops->write_begin(NULL, mapping, size, 0, 0, &page, &fsdata);
+		res = mapping->a_ops->write_begin(NULL, mapping, isize, 0, 0, &page, &fsdata);
 		if (!res)
-			res = mapping->a_ops->write_end(NULL, mapping, size, 0, 0, page, fsdata);
+			res = mapping->a_ops->write_end(NULL, mapping, isize, 0, 0, page, fsdata);
 		else
 			inode->i_size = AFFS_I(inode)->mmu_private;
 		mark_inode_dirty(inode);
-- 
1.9.3

