Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750774AbaBGFqV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 00:46:21 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:61342 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbaBGFqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 00:46:19 -0500
X-AuditID: cbfee690-b7f266d00000287c-f5-52f473215cbc
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH] f2fs: clean up redundant function call
Date: Fri, 07 Feb 2014 14:44:37 +0900
Message-id: <1391751877-21388-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrELMWRmVeSWpSXmKPExsVy+t8zfV3F4i9BBmsn8Flc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlXHrSk7BfOWKayc+
	sDQwTpTtYuTkkBAwkZg0ayEjhC0mceHeerYuRi4OIYFljBJtRzewwhTNmHGACSIxnVFi0+Gt
	LBBOE5PEjjOdQBkODjYBbYnN+w1AGkQEmCUWTD3PCFLDLDCBUeL/ovcsIAlhAXOJY4u+s4PU
	swioSpx8KgoS5hVwl3i4/xkLxDJtiW3PJ0JddJ9N4vx8JRCbRUBA4tvkQywgrRICshKbDjBD
	lEhKHFxxg2UCo+ACRoZVjKKpBckFxUnpRSZ6xYm5xaV56XrJ+bmbGCHhN2EH470D1ocYk4HG
	TWSWEk3OB4ZvXkm8obGZkYWpiamxkbmlGWnCSuK8ao+SgoQE0hNLUrNTUwtSi+KLSnNSiw8x
	MnFwSjUw2ra/eS7+vFDETe9hWh1nxc3fojcWuxk0velbE+qg9f6h97L2wsiLSapRXD9Zmpas
	/3c2ymeB0AzpeWf8ZhrpHX81+cOHmRo/s3aEcCbxGN56+X3nUeGc/h7vaPULB4rqnE6sTetz
	toufkGX+QOB+T3HKv2930rQ4BQ5YuGUExrUwNl5qDJ6hxFKckWioxVxUnAgAE7m8DlUCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAIsWRmVeSWpSXmKPExsVy+t9jQV3F4i9BBl+PcVpc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5hx60pOwXzlimsnPrA0ME6U7WLk5JAQMJGYMeMAE4QtJnHh3nq2LkYuDiGB
	6YwSmw5vZYFwmpgkdpzpBKri4GAT0JbYvN8ApEFEgFliwdTzjCA1zAITGCX+L3rPApIQFjCX
	OLboOztIPYuAqsTJp6IgYV4Bd4mH+5+xQCzTltj2fCLjBEbuBYwMqxhFUwuSC4qT0nMN9YoT
	c4tL89L1kvNzNzGCw/uZ1A7GlQ0WhxgFOBiVeHhPLP0cJMSaWFZcmXuIUYKDWUmElzvhS5AQ
	b0piZVVqUX58UWlOavEhxmSg5ROZpUST84Gxl1cSb2hsYmZkaWRmYWRibk6asJI474FW60Ah
	gfTEktTs1NSC1CKYLUwcnFINjBY+8a/aVBatPdLl8DuI1Vls1mxx2/N7rtwTrF/Uvmb5+Ybq
	Srb1a/zaWxvWue/aG/rA0iU97FtM2N8VbF+3vNbrWL2gamG7SZrg8hXM/7bo6L+7uOZPVuFs
	dX9meecAz0k1Fvnr/Uv5Gn1uz2bQUOZ8sn7tddvYDF+HCVHPo2L2rmBqT5+tr8RSnJFoqMVc
	VJwIAImORS+zAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch integrates inode_[inc|dec]_dirty_dents with inc_page_count to remove
redundant calls.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/checkpoint.c |  1 -
 fs/f2fs/data.c       | 11 ++---------
 fs/f2fs/dir.c        |  4 ++--
 fs/f2fs/f2fs.h       |  5 +++++
 fs/f2fs/gc.c         |  7 +------
 5 files changed, 10 insertions(+), 18 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 8f5dff1..427dd55 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -508,7 +508,6 @@ void set_dirty_dir_page(struct inode *inode, struct page *page)
 	if (__add_dirty_inode(inode, new))
 		kmem_cache_free(inode_entry_slab, new);
 
-	inc_page_count(sbi, F2FS_DIRTY_DENTS);
 	inode_inc_dirty_dents(inode);
 	SetPagePrivate(page);
 	spin_unlock(&sbi->dir_inode_lock);
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index d175ae3..b401be7 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -799,10 +799,7 @@ static int f2fs_write_data_page(struct page *page,
 	 */
 	offset = i_size & (PAGE_CACHE_SIZE - 1);
 	if ((page->index >= end_index + 1) || !offset) {
-		if (S_ISDIR(inode->i_mode)) {
-			dec_page_count(sbi, F2FS_DIRTY_DENTS);
-			inode_dec_dirty_dents(inode);
-		}
+		inode_dec_dirty_dents(inode);
 		goto out;
 	}
 
@@ -815,7 +812,6 @@ write:
 
 	/* Dentry blocks are controlled by checkpoint */
 	if (S_ISDIR(inode->i_mode)) {
-		dec_page_count(sbi, F2FS_DIRTY_DENTS);
 		inode_dec_dirty_dents(inode);
 		err = do_write_data_page(page, &fio);
 	} else {
@@ -1033,11 +1029,8 @@ static void f2fs_invalidate_data_page(struct page *page, unsigned int offset,
 				      unsigned int length)
 {
 	struct inode *inode = page->mapping->host;
-	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
-	if (S_ISDIR(inode->i_mode) && PageDirty(page)) {
-		dec_page_count(sbi, F2FS_DIRTY_DENTS);
+	if (PageDirty(page))
 		inode_dec_dirty_dents(inode);
-	}
 	ClearPagePrivate(page);
 }
 
diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index 92ce1db..e095a4f 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -531,7 +531,6 @@ void f2fs_delete_entry(struct f2fs_dir_entry *dentry, struct page *page,
 	unsigned int bit_pos;
 	struct address_space *mapping = page->mapping;
 	struct inode *dir = mapping->host;
-	struct f2fs_sb_info *sbi = F2FS_SB(dir->i_sb);
 	int slots = GET_DENTRY_SLOTS(le16_to_cpu(dentry->name_len));
 	void *kaddr = page_address(page);
 	int i;
@@ -554,6 +553,8 @@ void f2fs_delete_entry(struct f2fs_dir_entry *dentry, struct page *page,
 	dir->i_ctime = dir->i_mtime = CURRENT_TIME;
 
 	if (inode) {
+		struct f2fs_sb_info *sbi = F2FS_SB(dir->i_sb);
+
 		if (S_ISDIR(inode->i_mode)) {
 			drop_nlink(dir);
 			update_inode_page(dir);
@@ -576,7 +577,6 @@ void f2fs_delete_entry(struct f2fs_dir_entry *dentry, struct page *page,
 		truncate_hole(dir, page->index, page->index + 1);
 		clear_page_dirty_for_io(page);
 		ClearPageUptodate(page);
-		dec_page_count(sbi, F2FS_DIRTY_DENTS);
 		inode_dec_dirty_dents(dir);
 	}
 	f2fs_put_page(page, 1);
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index aeff132..4841d12 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -662,6 +662,7 @@ static inline void inc_page_count(struct f2fs_sb_info *sbi, int count_type)
 
 static inline void inode_inc_dirty_dents(struct inode *inode)
 {
+	inc_page_count(F2FS_SB(inode->i_sb), F2FS_DIRTY_DENTS);
 	atomic_inc(&F2FS_I(inode)->dirty_dents);
 }
 
@@ -672,6 +673,10 @@ static inline void dec_page_count(struct f2fs_sb_info *sbi, int count_type)
 
 static inline void inode_dec_dirty_dents(struct inode *inode)
 {
+	if (!S_ISDIR(inode->i_mode))
+		return;
+
+	dec_page_count(F2FS_SB(inode->i_sb), F2FS_DIRTY_DENTS);
 	atomic_dec(&F2FS_I(inode)->dirty_dents);
 }
 
diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index b0f5762..b161db4 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -531,15 +531,10 @@ static void move_data_page(struct inode *inode, struct page *page, int gc_type)
 		set_page_dirty(page);
 		set_cold_data(page);
 	} else {
-		struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
-
 		f2fs_wait_on_page_writeback(page, DATA);
 
-		if (clear_page_dirty_for_io(page) &&
-			S_ISDIR(inode->i_mode)) {
-			dec_page_count(sbi, F2FS_DIRTY_DENTS);
+		if (clear_page_dirty_for_io(page))
 			inode_dec_dirty_dents(inode);
-		}
 		set_cold_data(page);
 		do_write_data_page(page, &fio);
 		clear_cold_data(page);
-- 
1.8.4.474.g128a96c

