Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240Ab3JXH6c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 03:58:32 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:32513 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131Ab3JXH6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 03:58:25 -0400
X-AuditID: cbfee68f-b7f836d000001b39-ac-5268d31c2411
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Changman Lee <cm224.lee@samsung.com>
Subject: [PATCH 2/3] f2fs: introduce f2fs_balance_fs_bg for some background jobs
Date: Thu, 24 Oct 2013 16:57:41 +0900
Message-id: <1382601462-7989-2-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
In-reply-to: <1382601462-7989-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1382601462-7989-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrALMWRmVeSWpSXmKPExsVy+t8zQ12ZyxlBBjdem1pc29fIZHF9118m
	i0uL3C327D3JYnF51xw2B1aP3Qs+M3n0bVnF6PF5k1wAcxSXTUpqTmZZapG+XQJXxsfpzSwF
	NyUrZr9cxtjAuEW0i5GTQ0LAROLOr+fsELaYxIV769m6GLk4hASWMUo8P7aTDaboxP8PrBCJ
	6YwSradnMIIkhASamSROXkrqYuTgYBPQlti83wAkLCLALLFg6nlGkHpmgR2MEqcm7gGrFxYI
	kJhxfD4LiM0ioCrx9c4LdpBeXgE3iU99URC7tCW2PZ8IVs4p4C4xdd42ZohVbhLHPk1iAZkp
	IdDMLrHn6nxGiDkCEt8mH2IBmSMhICux6QAzxBxJiYMrbrBMYBRewMiwilE0tSC5oDgpvchY
	rzgxt7g0L10vOT93EyMkdPt3MN49YH2IMRlo3ERmKdHkfGDo55XEGxqbGVmYmpgaG5lbmpEm
	rCTOe/9hUpCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxqY1S4XL+ZZ2yOjbyNmc9Zn7Mjxp
	3eHgKTJnjH+/niqm9eJK5T859bLXbd+fLFoj9TRsz5egma/iI9o4HmpsWXc4jk3n88ajhr/v
	KKn96r1oY1B9V+t83F47N7kHps3NO14/kW5bJTVF/PQu3+Wel0xOKKtvemJyN1x/+73J91gW
	Bb24/O/21+dKLMUZiYZazEXFiQBX93OKcwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLIsWRmVeSWpSXmKPExsVy+t9jQV2ZyxlBBi+uG1hc29fIZHF9118m
	i0uL3C327D3JYnF51xw2B1aP3Qs+M3n0bVnF6PF5k1wAc1QDo01GamJKapFCal5yfkpmXrqt
	kndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0EolhbLEnFKgUEBicbGSvh2mCaEhbroW
	MI0Rur4hQXA9RgZoIGEdY8bH6c0sBTclK2a/XMbYwLhFtIuRk0NCwETixP8PrBC2mMSFe+vZ
	uhi5OIQEpjNKtJ6ewQiSEBJoZpI4eSmpi5GDg01AW2LzfgOQsIgAs8SCqecZQeqZBXYwSpya
	uAesXlggQGLG8fksIDaLgKrE1zsv2EF6eQXcJD71RUHs0pbY9nwiWDmngLvE1HnbmCFWuUkc
	+zSJZQIj7wJGhlWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwZHxTGoH48oGi0OMAhyMSjy8
	Gh/Sg4RYE8uKK3MPMUpwMCuJ8HpWZAQJ8aYkVlalFuXHF5XmpBYfYkwGOmois5Rocj4wavNK
	4g2NTcyMLI3MLIxMzM1JE1YS5z3Qah0oJJCeWJKanZpakFoEs4WJg1OqgbGzn4W785CNpLGm
	0zcxZ5Oq+RcXMqU7/c28/TZutoVK+Ias6Pgt5Rd/mR25J22llrb0jLvdpNIVXkcOytd77OGu
	vdo3p1Kz78WxSPd33IELf1+Ue6ks9fDrp5f6vSnvpt3jLXwn/u/k9ujoRVn+ay9fe9+Vt2jb
	k9fTvl/kXyYXFMfFNe3b2jQlluKMREMt5qLiRAAl9I+E0AIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch merges some background jobs into this new function.

Signed-off-by: Changman Lee <cm224.lee@samsung.com>
Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/f2fs.h    |  2 ++
 fs/f2fs/gc.c      |  5 ++---
 fs/f2fs/node.c    | 10 +++-------
 fs/f2fs/segment.c |  8 ++++++++
 4 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 3c95d35..602a41d 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -965,6 +965,7 @@ long f2fs_compat_ioctl(struct file *, unsigned int, unsigned long);
  */
 void f2fs_set_inode_flags(struct inode *);
 struct inode *f2fs_iget(struct super_block *, unsigned long);
+int try_to_free_nats(struct f2fs_sb_info *, int);
 void update_inode(struct inode *, struct page *);
 int update_inode_page(struct inode *);
 int f2fs_write_inode(struct inode *, struct writeback_control *);
@@ -1045,6 +1046,7 @@ void destroy_node_manager_caches(void);
  * segment.c
  */
 void f2fs_balance_fs(struct f2fs_sb_info *);
+void f2fs_balance_fs_bg(struct f2fs_sb_info *);
 void invalidate_blocks(struct f2fs_sb_info *, block_t);
 void clear_prefree_segments(struct f2fs_sb_info *);
 int npages_for_summary_flush(struct f2fs_sb_info *);
diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 783c6cc..b7ad1ec 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -83,9 +83,8 @@ static int gc_thread_func(void *data)
 		if (f2fs_gc(sbi))
 			wait_ms = gc_th->no_gc_sleep_time;
 
-		/* balancing prefree segments */
-		if (excess_prefree_segs(sbi))
-			f2fs_sync_fs(sbi->sb, true);
+		/* balancing f2fs's metadata periodically */
+		f2fs_balance_fs_bg(sbi);
 
 	} while (!kthread_should_stop());
 	return 0;
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 89dd8a5..7bac481 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -240,7 +240,7 @@ retry:
 	write_unlock(&nm_i->nat_tree_lock);
 }
 
-static int try_to_free_nats(struct f2fs_sb_info *sbi, int nr_shrink)
+int try_to_free_nats(struct f2fs_sb_info *sbi, int nr_shrink)
 {
 	struct f2fs_nm_info *nm_i = NM_I(sbi);
 
@@ -1205,12 +1205,8 @@ static int f2fs_write_node_pages(struct address_space *mapping,
 	struct f2fs_sb_info *sbi = F2FS_SB(mapping->host->i_sb);
 	long nr_to_write = wbc->nr_to_write;
 
-	/* First check balancing cached NAT entries */
-	if (try_to_free_nats(sbi, NAT_ENTRY_PER_BLOCK) ||
-				excess_prefree_segs(sbi)) {
-		f2fs_sync_fs(sbi->sb, true);
-		return 0;
-	}
+	/* balancing f2fs's metadata in background */
+	f2fs_balance_fs_bg(sbi);
 
 	/* collect a number of dirty node pages and write together */
 	if (get_pages(sbi, F2FS_DIRTY_NODES) < COLLECT_DIRTY_NODES)
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 43ee91e..77aee83 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -36,6 +36,14 @@ void f2fs_balance_fs(struct f2fs_sb_info *sbi)
 	}
 }
 
+void f2fs_balance_fs_bg(struct f2fs_sb_info *sbi)
+{
+	/* check the # of cached NAT entries and prefree segments */
+	if (try_to_free_nats(sbi, NAT_ENTRY_PER_BLOCK) ||
+				excess_prefree_segs(sbi))
+		f2fs_sync_fs(sbi->sb, true);
+}
+
 static void __locate_dirty_segment(struct f2fs_sb_info *sbi, unsigned int segno,
 		enum dirty_type dirty_type)
 {
-- 
1.8.4.474.g128a96c

