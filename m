Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760578AbaCUCDM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 22:03:12 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:52341 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756619AbaCUCDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 22:03:08 -0400
X-AuditID: cbfee68f-b7f156d00000276c-79-532b9dda6783
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 2/3] f2fs: skip unnecessary node writes during fsync
Date: Fri, 21 Mar 2014 11:01:14 +0900
Message-id: <1395367275-1674-2-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
In-reply-to: <1395367275-1674-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1395367275-1674-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsVy+t8zY91bc7WDDab9Y7e4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK2Pa90mMBdv0Ku4/
	bWNqYNyv1sXIySEhYCJxc+MRFghbTOLCvfVsXYxcHEICyxgl5r7awghTdG7pFCaIxHRGiY67
	l6CqOpkkTt74xNrFyMHBJqAtsXm/AUiDiACzxIKp5xlBapgFJjBK/F/0HmyFsICLxOsVr9lB
	bBYBVYlVV9aAbeAVcJPYteIUM8Q2bYltzycygszkFHCX6N5aBxIWAiq5PmsDC8hMCYHvbBJ/
	9uxng5gjIPFt8iEWkHoJAVmJTQegxkhKHFxxg2UCo/ACRoZVjKKpBckFxUnpRcZ6xYm5xaV5
	6XrJ+bmbGCEh27+D8e4B60OMyUDjJjJLiSbnA0M+ryTe0NjMyMLUxNTYyNzSjDRhJXHe+w+T
	goQE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwpq69fYUjZWOz6cOXIhbrTzlNmjbdi+n1Ad3P
	lo7+kl394h4uWV9np8Qf3zrliyTnIsWvUzL+7/gkNLs0VO3Nszc7DFef+hOnulCsWMJto37P
	LLajshrnF9SdtpF60n1mzTJv/psGaV//Ha5If79k98VT17V/3tyx9PcLI9n9L4/w/dghe1Lp
	/U8lluKMREMt5qLiRACYgzSzbwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t9jQd1bc7WDDRobWCyu7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8yY9n0SY8E2vYr7T9uYGhj3q3UxcnJICJhInFs6hQnCFpO4cG89WxcjF4eQ
	wHRGiY67l6CcTiaJkzc+sXYxcnCwCWhLbN5vANIgIsAssWDqeUaQGmaBCYwS/xe9ZwFJCAu4
	SLxe8ZodxGYRUJVYdWUNI4jNK+AmsWvFKWaIbdoS255PZASZySngLtG9tQ4kLARUcn3WBpYJ
	jLwLGBlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgRHxDPpHYyrGiwOMQpwMCrx8FZwagcL
	sSaWFVfmHmKU4GBWEuF93Q0U4k1JrKxKLcqPLyrNSS0+xJgMdNREZinR5HxgtOaVxBsam5gZ
	WRqZWRiZmJuTJqwkznuw1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA6P9hh3+BxkXsTckJ3f03o2R
	CSj/YmD+Zg7/owOGVpaP9wSGdl5oOtHtNTdio0uLc+MB/9UGs4TWbHOQZj/MULzi8a7kf4Ld
	6+1Vvie3N7xK/p9r0zV1WnO+9bSChRbSR0tNzwkrG8XcqBVI4Q65+GHWzPT39nVevzjT3Cfs
	LHj5X3vCFIlD95RYijMSDbWYi4oTAXVcuaHMAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If multiple redundant fsync calls are triggered, we don't need to write its
node pages with fsync mark continuously.

So, this patch adds FI_NEED_FSYNC to track whether the latest node block is
written with the fsync mark or not.
If the mark was set, a new fsync doesn't need to write a node block.
Otherwise, we should do a new node block with the mark for roll-forward
recovery.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/f2fs.h |  1 +
 fs/f2fs/file.c |  2 ++
 fs/f2fs/node.c | 37 ++++++++++++++++++++++++++++---------
 fs/f2fs/node.h |  1 +
 4 files changed, 32 insertions(+), 9 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 469779a..f83433e 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1126,6 +1126,7 @@ struct dnode_of_data;
 struct node_info;
 
 int is_checkpointed_node(struct f2fs_sb_info *, nid_t);
+bool fsync_mark_done(struct f2fs_sb_info *, nid_t);
 void get_node_info(struct f2fs_sb_info *, nid_t, struct node_info *);
 int get_dnode_of_data(struct dnode_of_data *, pgoff_t, int);
 int truncate_inode_blocks(struct inode *, pgoff_t);
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index a9474cd..6ba2668 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -176,6 +176,8 @@ int f2fs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	} else {
 		/* if there is no written node page, write its inode page */
 		while (!sync_node_pages(sbi, inode->i_ino, &wbc)) {
+			if (fsync_mark_done(sbi, inode->i_ino))
+				goto out;
 			mark_inode_dirty_sync(inode);
 			ret = f2fs_write_inode(inode, NULL);
 			if (ret)
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index daf644c..eced8d7 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -133,6 +133,20 @@ int is_checkpointed_node(struct f2fs_sb_info *sbi, nid_t nid)
 	return is_cp;
 }
 
+bool fsync_mark_done(struct f2fs_sb_info *sbi, nid_t nid)
+{
+	struct f2fs_nm_info *nm_i = NM_I(sbi);
+	struct nat_entry *e;
+	bool fsync_done = false;
+
+	read_lock(&nm_i->nat_tree_lock);
+	e = __lookup_nat_cache(nm_i, nid);
+	if (e)
+		fsync_done = e->fsync_done;
+	read_unlock(&nm_i->nat_tree_lock);
+	return fsync_done;
+}
+
 static struct nat_entry *grab_nat_entry(struct f2fs_nm_info *nm_i, nid_t nid)
 {
 	struct nat_entry *new;
@@ -173,7 +187,7 @@ retry:
 }
 
 static void set_node_addr(struct f2fs_sb_info *sbi, struct node_info *ni,
-			block_t new_blkaddr)
+			block_t new_blkaddr, bool fsync_done)
 {
 	struct f2fs_nm_info *nm_i = NM_I(sbi);
 	struct nat_entry *e;
@@ -217,6 +231,11 @@ retry:
 	/* change address */
 	nat_set_blkaddr(e, new_blkaddr);
 	__set_nat_cache_dirty(nm_i, e);
+
+	/* update fsync_mark if its inode nat entry is still alive */
+	e = __lookup_nat_cache(nm_i, ni->ino);
+	if (e)
+		e->fsync_done = fsync_done;
 	write_unlock(&nm_i->nat_tree_lock);
 }
 
@@ -483,7 +502,7 @@ static void truncate_node(struct dnode_of_data *dn)
 	/* Deallocate node address */
 	invalidate_blocks(sbi, ni.blk_addr);
 	dec_valid_node_count(sbi, dn->inode);
-	set_node_addr(sbi, &ni, NULL_ADDR);
+	set_node_addr(sbi, &ni, NULL_ADDR, false);
 
 	if (dn->nid == dn->inode->i_ino) {
 		remove_orphan_inode(sbi, dn->nid);
@@ -846,7 +865,7 @@ struct page *new_node_page(struct dnode_of_data *dn,
 	f2fs_bug_on(old_ni.blk_addr != NULL_ADDR);
 	new_ni = old_ni;
 	new_ni.ino = dn->inode->i_ino;
-	set_node_addr(sbi, &new_ni, NEW_ADDR);
+	set_node_addr(sbi, &new_ni, NEW_ADDR, false);
 
 	fill_node_footer(page, dn->nid, dn->inode->i_ino, ofs, true);
 	set_cold_node(dn->inode, page);
@@ -1202,7 +1221,7 @@ static int f2fs_write_node_page(struct page *page,
 	mutex_lock(&sbi->node_write);
 	set_page_writeback(page);
 	write_node_page(sbi, page, &fio, nid, ni.blk_addr, &new_addr);
-	set_node_addr(sbi, &ni, new_addr);
+	set_node_addr(sbi, &ni, new_addr, is_fsync_dnode(page));
 	dec_page_count(sbi, F2FS_DIRTY_NODES);
 	mutex_unlock(&sbi->node_write);
 	unlock_page(page);
@@ -1503,7 +1522,7 @@ void recover_node_page(struct f2fs_sb_info *sbi, struct page *page,
 		block_t new_blkaddr)
 {
 	rewrite_node_page(sbi, page, sum, ni->blk_addr, new_blkaddr);
-	set_node_addr(sbi, ni, new_blkaddr);
+	set_node_addr(sbi, ni, new_blkaddr, false);
 	clear_node_page_dirty(page);
 }
 
@@ -1559,7 +1578,7 @@ bool recover_xattr_data(struct inode *inode, struct page *page, block_t blkaddr)
 	f2fs_bug_on(ni.blk_addr == NULL_ADDR);
 	invalidate_blocks(sbi, ni.blk_addr);
 	dec_valid_node_count(sbi, inode);
-	set_node_addr(sbi, &ni, NULL_ADDR);
+	set_node_addr(sbi, &ni, NULL_ADDR, false);
 
 recover_xnid:
 	/* 2: allocate new xattr nid */
@@ -1569,12 +1588,12 @@ recover_xnid:
 	remove_free_nid(NM_I(sbi), new_xnid);
 	get_node_info(sbi, new_xnid, &ni);
 	ni.ino = inode->i_ino;
-	set_node_addr(sbi, &ni, NEW_ADDR);
+	set_node_addr(sbi, &ni, NEW_ADDR, false);
 	F2FS_I(inode)->i_xattr_nid = new_xnid;
 
 	/* 3: update xattr blkaddr */
 	refresh_sit_entry(sbi, NEW_ADDR, blkaddr);
-	set_node_addr(sbi, &ni, blkaddr);
+	set_node_addr(sbi, &ni, blkaddr, false);
 
 	update_inode_page(inode);
 	return true;
@@ -1612,7 +1631,7 @@ int recover_inode_page(struct f2fs_sb_info *sbi, struct page *page)
 
 	if (unlikely(!inc_valid_node_count(sbi, NULL)))
 		WARN_ON(1);
-	set_node_addr(sbi, &new_ni, NEW_ADDR);
+	set_node_addr(sbi, &new_ni, NEW_ADDR, false);
 	inc_valid_inode_count(sbi);
 	f2fs_put_page(ipage, 1);
 	return 0;
diff --git a/fs/f2fs/node.h b/fs/f2fs/node.h
index c2015b7..5decc1a 100644
--- a/fs/f2fs/node.h
+++ b/fs/f2fs/node.h
@@ -42,6 +42,7 @@ struct node_info {
 struct nat_entry {
 	struct list_head list;	/* for clean or dirty nat list */
 	bool checkpointed;	/* whether it is checkpointed or not */
+	bool fsync_done;	/* whether the latest node has fsync mark */
 	struct node_info ni;	/* in-memory node information */
 };
 
-- 
1.8.4.474.g128a96c

