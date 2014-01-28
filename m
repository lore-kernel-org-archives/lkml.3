Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119AbaA1F4U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 00:56:20 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:44819 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbaA1Fzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 00:55:35 -0500
X-AuditID: cbfee690-b7f266d00000287c-a1-52e74655b97a
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 1/4] f2fs: update_inode_page should be done all the time
Date: Tue, 28 Jan 2014 14:54:04 +0900
Message-id: <1390888447-5258-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsVy+t8zI91Qt+dBBremmllc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAldHRsZm54KlExYo5
	gQ2MK0W6GDk5JARMJF7umsIIYYtJXLi3nq2LkYtDSGAZo8SH/5PZYYpet++DSixilNhxbQkj
	hNPEJHH870LWLkYODjYBbYnN+w1AGkQEmCUWTD0PVsMsMIFR4v+i9ywgCWEBD4lXX7+zg9Sz
	CKhKTN8qCBLmFXCT2P/iPxPEMm2Jbc8ngvVKCNxmk+jY2scGkmAREJD4NvkQC0ivhICsxKYD
	zBD1khIHV9xgmcAouICRYRWjaGpBckFxUnqRiV5xYm5xaV66XnJ+7iZGSABO2MF474D1IcZk
	oHETmaVEk/OBAZxXEm9obGZkYWpiamxkbmlGmrCSOK/ao6QgIYH0xJLU7NTUgtSi+KLSnNTi
	Q4xMHJxSDYydgZyrrA5c3P7E/Hj+n5uJcT8+fju+dGKTU/PfLVXqgRW1DgnBCo2F59bOtd0W
	xqzN8iuQ7eBm4U1193dapa5SuWfkn8z9VuVXCs9hf9GXGdfPqK/c+17ilOZ/lVdSv9VibJxf
	Z0av2+C+ZaN7Gs/HgOnWEza1Li41Cf/6Vspve1fgtl7TeFElluKMREMt5qLiRACE/HEDVgIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAIsWRmVeSWpSXmKPExsVy+t9jAd1Qt+dBBn1NRhbXd/1lsri0yN1i
	z96TLBaXd81hc2Dx2L3gM5NH35ZVjB6fN8kFMEc1MNpkpCampBYppOYl56dk5qXbKnkHxzvH
	m5oZGOoaWlqYKynkJeam2iq5+AToumXmAG1TUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesb
	EgTXY2SABhLWMWZ0dGxmLngqUbFiTmAD40qRLkZODgkBE4nX7fvYIGwxiQv31gPZXBxCAosY
	JXZcW8II4TQxSRz/u5C1i5GDg01AW2LzfgOQBhEBZokFU8+D1TALTGCU+L/oPQtIQljAQ+LV
	1+/sIPUsAqoS07cKgoR5Bdwk9r/4zwSxTFti2/OJjBMYuRcwMqxiFE0tSC4oTkrPNdIrTswt
	Ls1L10vOz93ECA7vZ9I7GFc1WBxiFOBgVOLhfdD9LEiINbGsuDL3EKMEB7OSCO/ZKUAh3pTE
	yqrUovz4otKc1OJDjMlAyycyS4km5wNjL68k3tDYxMzI0sjMwsjE3Jw0YSVx3oOt1oFCAumJ
	JanZqakFqUUwW5g4OKUaGLPvWAdeKNgf4h97aSanJ7O7tGGuzDeZsrvPKlQffAxhXjul81/t
	LY+Nt6rbNUVCvRheqC4IeH/Wg9GLeTZz5fu9n6/FLna7o5x0YntOvvbv5hp9Jd0dCxf9Yuc+
	5/Jhi66rs6tb2GyBSTb3Rc88cpjZ8MiEVWFGen/6vwqfFgvro+kyE2eXKbEUZyQaajEXFScC
	APsTlDuzAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to make fs consistency, update_inode_page should not be failed all
the time. Otherwise, it is possible to lose some metadata in the inode like
a link count.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/data.c  |  3 +--
 fs/f2fs/f2fs.h  |  8 +++++++-
 fs/f2fs/inode.c | 20 ++++++++++++--------
 3 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 0ae5587..6827359 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -62,8 +62,7 @@ static void f2fs_write_end_io(struct bio *bio, int err)
 		if (unlikely(!uptodate)) {
 			SetPageError(page);
 			set_bit(AS_EIO, &page->mapping->flags);
-			set_ckpt_flags(sbi->ckpt, CP_ERROR_FLAG);
-			sbi->sb->s_flags |= MS_RDONLY;
+			f2fs_stop_checkpoint(sbi);
 		}
 		end_page_writeback(page);
 		dec_page_count(sbi, F2FS_WRITEBACK);
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index af51a0b..42903c3 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1023,6 +1023,12 @@ static inline int f2fs_readonly(struct super_block *sb)
 	return sb->s_flags & MS_RDONLY;
 }
 
+static inline void f2fs_stop_checkpoint(struct f2fs_sb_info *sbi)
+{
+	set_ckpt_flags(sbi->ckpt, CP_ERROR_FLAG);
+	sbi->sb->s_flags |= MS_RDONLY;
+}
+
 /*
  * file.c
  */
@@ -1044,7 +1050,7 @@ void f2fs_set_inode_flags(struct inode *);
 struct inode *f2fs_iget(struct super_block *, unsigned long);
 int try_to_free_nats(struct f2fs_sb_info *, int);
 void update_inode(struct inode *, struct page *);
-int update_inode_page(struct inode *);
+void update_inode_page(struct inode *);
 int f2fs_write_inode(struct inode *, struct writeback_control *);
 void f2fs_evict_inode(struct inode *);
 
diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index 4d67ed7..1a4ba27 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -212,24 +212,28 @@ void update_inode(struct inode *inode, struct page *node_page)
 	clear_inode_flag(F2FS_I(inode), FI_DIRTY_INODE);
 }
 
-int update_inode_page(struct inode *inode)
+void update_inode_page(struct inode *inode)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
 	struct page *node_page;
-
+retry:
 	node_page = get_node_page(sbi, inode->i_ino);
-	if (IS_ERR(node_page))
-		return PTR_ERR(node_page);
+	if (IS_ERR(node_page)) {
+		if (PTR_ERR(node_page) == -ENOMEM) {
+			cond_resched();
+			goto retry;
+		} else {
+			f2fs_stop_checkpoint(sbi);
+		}
+	}
 
 	update_inode(inode, node_page);
 	f2fs_put_page(node_page, 1);
-	return 0;
 }
 
 int f2fs_write_inode(struct inode *inode, struct writeback_control *wbc)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
-	int ret;
 
 	if (inode->i_ino == F2FS_NODE_INO(sbi) ||
 			inode->i_ino == F2FS_META_INO(sbi))
@@ -243,13 +247,13 @@ int f2fs_write_inode(struct inode *inode, struct writeback_control *wbc)
 	 * during the urgent cleaning time when runing out of free sections.
 	 */
 	f2fs_lock_op(sbi);
-	ret = update_inode_page(inode);
+	update_inode_page(inode);
 	f2fs_unlock_op(sbi);
 
 	if (wbc)
 		f2fs_balance_fs(sbi);
 
-	return ret;
+	return 0;
 }
 
 /*
-- 
1.8.4.474.g128a96c

