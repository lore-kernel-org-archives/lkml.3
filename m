Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218Ab3CXXlf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 19:41:35 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:57688 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872Ab3CXXlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 19:41:07 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-61-514f8f10e637
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 1/4] f2fs: fix the recovery flow to handle errors correctly
Date: Mon, 25 Mar 2013 08:40:11 +0900
Message-id: <1364168414-12815-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.1.3.566.gaa39828
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsVy+t8zI13Bfv9Ag5+9TBbXd/1lsri0yN1i
	z96TLBaXd81hc2Dx2L3gM5NH35ZVjB6fN8kFMEdx2aSk5mSWpRbp2yVwZVy8e5y5YKFOxew9
	P9gbGPcqdzFyckgImEg8PLSPBcIWk7hwbz1bFyMXh5DAMkaJjbv+MsIUHTnYxgKRmM4o0fhr
	O1RVG5NEw/2TTF2MHBxsAtoSm/cbgDSICDBLLJh6nhGkhllgAqPE/0XvwVYIC3hLHPizGmwq
	i4CqxNyHPcwgNq+Au8Tk3Z1QZ+hKrP7/nB2kWULgPpvE95bHUA0CEt8mH2IBWSYhICux6QAz
	RL2kxMEVN1gmMAouYGRYxSiaWpBcUJyUXmSqV5yYW1yal66XnJ+7iREShBN3MN4/YH2IMRlo
	3ERmKdHkfGAQ55XEGxqbGVmYmpgaG5lbmpEmrCTOq95iHSgkkJ5YkpqdmlqQWhRfVJqTWnyI
	kYmDU6qBkfHH6lkVgo2WKt8Elys6PD0ddWLmlji15aevZyktsPjtUnCu+626zVmXPV4T11W/
	nmtpcijwaXs1S4eTqt19nSnZQlyXdBftW9vrd+2GOlMIV7qsvtHWLJ1w5uIkBq8obvt53RsT
	bzIyJVl4Cu2s2eB67IYAz7aA7/v4E76HRQew1pbPnW2rxFKckWioxVxUnAgAcnIkblgCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsVy+t9jQV2Bfv9AgzcvLS2u7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8y4ePc4c8FCnYrZe36wNzDuVe5i5OSQEDCROHKwjQXCFpO4cG89WxcjF4eQ
	wHRGicZf26GcNiaJhvsnmboYOTjYBLQlNu83AGkQEWCWWDD1PCNIDbPABEaJ/4veg00SFvCW
	OPBnNSOIzSKgKjH3YQ8ziM0r4C4xeXcn1DZdidX/n7NPYORewMiwilE0tSC5oDgpPddIrzgx
	t7g0L10vOT93EyM4xJ9J72Bc1WBxiFGAg1GJh1egxj9QiDWxrLgy9xCjBAezkgjvmx6gEG9K
	YmVValF+fFFpTmrxIcZkoO0TmaVEk/OB8ZdXEm9obGJmZGlkZmFkYm5OmrCSOO/BVutAIYH0
	xJLU7NTUgtQimC1MHJxSDYyzVl+9cvez+P0SxtPPtNZOlb76RPSbAtfKB/vmebtH9MvY8Jhp
	+M6osJnjosy375DXqYfvzwkvuLT08u/IzyWmebLij9zS6lb2F9rnhGz3eqXTHat8gleTL932
	2JkfK8S/VYd9T1657If/Uo3/H+7dqjSU22V27iL7pN/J8oe3FQrfOaBvscpJiaU4I9FQi7mo
	OBEA2EMlMrUCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should handle errors during the recovery flow correctly.
For example, if we get -ENOMEM, we should report a mount failure instead of
conducting the remained mount procedure.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/f2fs.h     |  2 +-
 fs/f2fs/recovery.c | 46 ++++++++++++++++++++++++++++------------------
 fs/f2fs/super.c    |  9 +++++++--
 3 files changed, 36 insertions(+), 21 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 5bb87e0..109e12d 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1027,7 +1027,7 @@ void destroy_gc_caches(void);
 /*
  * recovery.c
  */
-void recover_fsync_data(struct f2fs_sb_info *);
+int recover_fsync_data(struct f2fs_sb_info *);
 bool space_for_roll_forward(struct f2fs_sb_info *);
 
 /*
diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index 2d86eb2..61bdaa7 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -118,10 +118,8 @@ static int find_fsync_dnodes(struct f2fs_sb_info *sbi, struct list_head *head)
 
 		lock_page(page);
 
-		if (cp_ver != cpver_of_node(page)) {
-			err = -EINVAL;
+		if (cp_ver != cpver_of_node(page))
 			goto unlock_out;
-		}
 
 		if (!is_fsync_dnode(page))
 			goto next;
@@ -134,10 +132,9 @@ static int find_fsync_dnodes(struct f2fs_sb_info *sbi, struct list_head *head)
 							FI_INC_LINK);
 		} else {
 			if (IS_INODE(page) && is_dent_dnode(page)) {
-				if (recover_inode_page(sbi, page)) {
-					err = -ENOMEM;
+				err = recover_inode_page(sbi, page);
+				if (err)
 					goto unlock_out;
-				}
 			}
 
 			/* add this fsync inode to the list */
@@ -237,13 +234,14 @@ static void check_index_in_prev_nodes(struct f2fs_sb_info *sbi,
 	iput(inode);
 }
 
-static void do_recover_data(struct f2fs_sb_info *sbi, struct inode *inode,
+static int do_recover_data(struct f2fs_sb_info *sbi, struct inode *inode,
 					struct page *page, block_t blkaddr)
 {
 	unsigned int start, end;
 	struct dnode_of_data dn;
 	struct f2fs_summary sum;
 	struct node_info ni;
+	int err = 0;
 
 	start = start_bidx_of_node(ofs_of_node(page));
 	if (IS_INODE(page))
@@ -252,8 +250,9 @@ static void do_recover_data(struct f2fs_sb_info *sbi, struct inode *inode,
 		end = start + ADDRS_PER_BLOCK;
 
 	set_new_dnode(&dn, inode, NULL, NULL, 0);
-	if (get_dnode_of_data(&dn, start, ALLOC_NODE))
-		return;
+	err = get_dnode_of_data(&dn, start, ALLOC_NODE);
+	if (err)
+		return err;
 
 	wait_on_page_writeback(dn.node_page);
 
@@ -298,14 +297,16 @@ static void do_recover_data(struct f2fs_sb_info *sbi, struct inode *inode,
 
 	recover_node_page(sbi, dn.node_page, &sum, &ni, blkaddr);
 	f2fs_put_dnode(&dn);
+	return 0;
 }
 
-static void recover_data(struct f2fs_sb_info *sbi,
+static int recover_data(struct f2fs_sb_info *sbi,
 				struct list_head *head, int type)
 {
 	unsigned long long cp_ver = le64_to_cpu(sbi->ckpt->checkpoint_ver);
 	struct curseg_info *curseg;
 	struct page *page;
+	int err = 0;
 	block_t blkaddr;
 
 	/* get node pages in the current segment */
@@ -315,13 +316,15 @@ static void recover_data(struct f2fs_sb_info *sbi,
 	/* read node page */
 	page = alloc_page(GFP_NOFS | __GFP_ZERO);
 	if (IS_ERR(page))
-		return;
+		return -ENOMEM;
+
 	lock_page(page);
 
 	while (1) {
 		struct fsync_inode_entry *entry;
 
-		if (f2fs_readpage(sbi, page, blkaddr, READ_SYNC))
+		err = f2fs_readpage(sbi, page, blkaddr, READ_SYNC);
+		if (err)
 			goto out;
 
 		lock_page(page);
@@ -333,7 +336,9 @@ static void recover_data(struct f2fs_sb_info *sbi,
 		if (!entry)
 			goto next;
 
-		do_recover_data(sbi, entry->inode, page, blkaddr);
+		err = do_recover_data(sbi, entry->inode, page, blkaddr);
+		if (err)
+			goto out;
 
 		if (entry->blkaddr == blkaddr) {
 			iput(entry->inode);
@@ -349,22 +354,26 @@ unlock_out:
 out:
 	__free_pages(page, 0);
 
-	allocate_new_segments(sbi);
+	if (!err)
+		allocate_new_segments(sbi);
+	return err;
 }
 
-void recover_fsync_data(struct f2fs_sb_info *sbi)
+int recover_fsync_data(struct f2fs_sb_info *sbi)
 {
 	struct list_head inode_list;
+	int err;
 
 	fsync_entry_slab = f2fs_kmem_cache_create("f2fs_fsync_inode_entry",
 			sizeof(struct fsync_inode_entry), NULL);
 	if (unlikely(!fsync_entry_slab))
-		return;
+		return -ENOMEM;
 
 	INIT_LIST_HEAD(&inode_list);
 
 	/* step #1: find fsynced inode numbers */
-	if (find_fsync_dnodes(sbi, &inode_list))
+	err = find_fsync_dnodes(sbi, &inode_list);
+	if (err)
 		goto out;
 
 	if (list_empty(&inode_list))
@@ -372,11 +381,12 @@ void recover_fsync_data(struct f2fs_sb_info *sbi)
 
 	/* step #2: recover data */
 	sbi->por_doing = 1;
-	recover_data(sbi, &inode_list, CURSEG_WARM_NODE);
+	err = recover_data(sbi, &inode_list, CURSEG_WARM_NODE);
 	sbi->por_doing = 0;
 	BUG_ON(!list_empty(&inode_list));
 out:
 	destroy_fsync_dnodes(sbi, &inode_list);
 	kmem_cache_destroy(fsync_entry_slab);
 	write_checkpoint(sbi, false);
+	return err;
 }
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index c9ef88d..252890e 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -642,8 +642,13 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 	}
 
 	/* recover fsynced data */
-	if (!test_opt(sbi, DISABLE_ROLL_FORWARD))
-		recover_fsync_data(sbi);
+	if (!test_opt(sbi, DISABLE_ROLL_FORWARD)) {
+		err = recover_fsync_data(sbi);
+		if (err) {
+			f2fs_msg(sb, KERN_ERR, "Failed to recover fsync data");
+			goto free_root_inode;
+		}
+	}
 
 	/* After POR, we can run background GC thread */
 	err = start_gc_thread(sbi);
-- 
1.8.1.3.566.gaa39828

