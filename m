Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244Ab3L0EBw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 23:01:52 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:58421 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136Ab3L0EBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 23:01:37 -0500
X-AuditID: cbfee690-b7f266d00000287c-97-52bcfb9e3ff4
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 4/6] f2fs: refactor f2fs_convert_inline_data
Date: Fri, 27 Dec 2013 13:00:18 +0900
Message-id: <1388116820-15038-4-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
In-reply-to: <1388116820-15038-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1388116820-15038-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsVy+t8zY915v/cEGUyZzGVxfddfJotLi9wt
	9uw9yWJxedccNgcWj90LPjN59G1ZxejxeZNcAHMUl01Kak5mWWqRvl0CV8aGo6uZClZqViyc
	+Zy1gfGSYhcjJ4eEgInE+g8n2CBsMYkL99YD2VwcQgLLGCVefn3CBFN0+9QyJojEdEaJpmet
	YB1CAs1MEm0zebsYOTjYBLQlNu83AAmLCDBLLJh6nhGknllgAqPE/0XvWUASwgI2EnMvrGEE
	sVkEVCWerzgBFucVcJd48P41I8QybYltzyeC2ZwCHhLtP++zQ+xyl/i6/iDYERICv9kkDq78
	yQoxSEDi2+RDLCBHSAjISmw6wAwxR1Li4IobLBMYhRcwMqxiFE0tSC4oTkovMtErTswtLs1L
	10vOz93ECAnZCTsY7x2wPsSYDDRuIrOUaHI+MOTzSuINjc2MLExNTI2NzC3NSBNWEudVe5QU
	JCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoFxpurbkKWFIbwvV/7+IOpzef3v/i7VtOWXDz5Y
	Ncn/arnY9UDulHaGOPWziecXLzq2/1vJwYwji748z0qY5mMr+UXr/TIbqcPcPjxW62Jlue79
	Pl73bte09a8mTLoid2fCISPRzq+7H6poZUpcsyzIK6raMp3jW4gTT+jiglf/dtslmMw+YnVv
	lRJLcUaioRZzUXEiABFSgV9vAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t9jQd15v/cEGSz/xWpxfddfJotLi9wt
	9uw9yWJxedccNgcWj90LPjN59G1ZxejxeZNcAHNUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxz
	vKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtA2JYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+
	IUFwPUYGaCBhHWPGhqOrmQpWalYsnPmctYHxkmIXIyeHhICJxO1Ty5ggbDGJC/fWs3UxcnEI
	CUxnlGh61soGkhASaGaSaJvJ28XIwcEmoC2xeb8BSFhEgFliwdTzjCD1zAITGCX+L3rPApIQ
	FrCRmHthDSOIzSKgKvF8xQmwOK+Au8SD968ZIZZpS2x7PhHM5hTwkGj/eZ8dYpe7xNf1B5km
	MPIuYGRYxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREcEc+kdzCuarA4xCjAwajEw+uwYU+Q
	EGtiWXFl7iFGCQ5mJRHez1eAQrwpiZVVqUX58UWlOanFhxiTga6ayCwlmpwPjNa8knhDYxMz
	I0sjMwsjE3Nz0oSVxHkPtloHCgmkJ5akZqemFqQWwWxh4uCUamDsWuNXcERTSHWjnrGR9g3e
	df2OlV0T53Be0m1ZcEFlVpe6mJCFmpPgpFK3Dw/zxPesEk9qOL39xH+B249Ec2o+N+ZuXSx3
	rWD3tZ+fnUzK2d2ElffKJ57n/2ktNVt+tVQom+eB7ssrmv5xuFX/EVc4dlCiNq+16EdhQ/2q
	RYqLrqzwuSXsEKPEUpyRaKjFXFScCABy/n5uzAIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch refactors f2fs_convert_inline_data to check a couple of conditions
internally for deciding whether it needs to convert inline_data or not.

So, the new f2fs_convert_inline_data initially checks:
1) f2fs_has_inline_data(), and
2) the data size to be changed.

If the inode has inline_data but the size to fill is less than MAX_INLINE_DATA,
then we don't need to convert the inline_data with data allocation.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/data.c   | 16 ++++++----------
 fs/f2fs/f2fs.h   |  2 +-
 fs/f2fs/file.c   | 25 +++++++++----------------
 fs/f2fs/inline.c | 26 ++++++++++++--------------
 4 files changed, 28 insertions(+), 41 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 253e663..fc7a28c 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -906,21 +906,17 @@ static int f2fs_write_begin(struct file *file, struct address_space *mapping,
 
 	f2fs_balance_fs(sbi);
 repeat:
+	err = f2fs_convert_inline_data(inode, pos + len);
+	if (err)
+		return err;
+
 	page = grab_cache_page_write_begin(mapping, index, flags);
 	if (!page)
 		return -ENOMEM;
 	*pagep = page;
 
-	if ((pos + len) < MAX_INLINE_DATA) {
-		if (f2fs_has_inline_data(inode))
-			goto inline_data;
-	} else if (f2fs_has_inline_data(inode)) {
-		err = f2fs_convert_inline_data(inode, page, flags);
-		if (err) {
-			f2fs_put_page(page, 1);
-			return err;
-		}
-	}
+	if (f2fs_has_inline_data(inode) && (pos + len) <= MAX_INLINE_DATA)
+		goto inline_data;
 
 	f2fs_lock_op(sbi);
 	set_new_dnode(&dn, inode, NULL, NULL, 0);
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index b01ccaa..af35039 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1302,6 +1302,6 @@ extern const struct inode_operations f2fs_special_inode_operations;
 inline int f2fs_has_inline_data(struct inode *);
 bool f2fs_may_inline(struct inode *);
 int f2fs_read_inline_data(struct inode *, struct page *);
-int f2fs_convert_inline_data(struct inode *, struct page *, unsigned);
+int f2fs_convert_inline_data(struct inode *, pgoff_t);
 int f2fs_write_inline_data(struct inode *, struct page *, unsigned int);
 #endif
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index f64a1c8..68dd7bf 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -370,17 +370,12 @@ int f2fs_setattr(struct dentry *dentry, struct iattr *attr)
 
 	if ((attr->ia_valid & ATTR_SIZE) &&
 			attr->ia_size != i_size_read(inode)) {
-		if (f2fs_has_inline_data(inode) &&
-				(attr->ia_size > MAX_INLINE_DATA)) {
-			unsigned flags = AOP_FLAG_NOFS;
-			err = f2fs_convert_inline_data(inode, NULL, flags);
-			if (err)
-				return err;
-		}
+		err = f2fs_convert_inline_data(inode, attr->ia_size);
+		if (err)
+			return err;
 
 		truncate_setsize(inode, attr->ia_size);
-		if (!f2fs_has_inline_data(inode))
-			f2fs_truncate(inode);
+		f2fs_truncate(inode);
 		f2fs_balance_fs(F2FS_SB(inode->i_sb));
 	}
 
@@ -462,7 +457,7 @@ static int punch_hole(struct inode *inode, loff_t offset, loff_t len)
 	loff_t off_start, off_end;
 	int ret = 0;
 
-	ret = f2fs_convert_inline_data(inode, NULL, AOP_FLAG_NOFS);
+	ret = f2fs_convert_inline_data(inode, MAX_INLINE_DATA + 1);
 	if (ret)
 		return ret;
 
@@ -512,16 +507,14 @@ static int expand_inode_data(struct inode *inode, loff_t offset,
 	loff_t off_start, off_end;
 	int ret = 0;
 
-	if (f2fs_has_inline_data(inode) && (offset + len > MAX_INLINE_DATA)) {
-		ret = f2fs_convert_inline_data(inode, NULL, AOP_FLAG_NOFS);
-		if (ret)
-			return ret;
-	}
-
 	ret = inode_newsize_ok(inode, (len + offset));
 	if (ret)
 		return ret;
 
+	ret = f2fs_convert_inline_data(inode, offset + len);
+	if (ret)
+		return ret;
+
 	pg_start = ((unsigned long long) offset) >> PAGE_CACHE_SHIFT;
 	pg_end = ((unsigned long long) offset + len) >> PAGE_CACHE_SHIFT;
 
diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index 62c72aa..1843bc7 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -101,6 +101,7 @@ static int __f2fs_convert_inline_data(struct inode *inode, struct page *page)
 	dst_addr = kmap(page);
 	memcpy(dst_addr, src_addr, MAX_INLINE_DATA);
 	kunmap(page);
+	SetPageUptodate(page);
 
 	/* write data page to try to make data consistent */
 	set_page_writeback(page);
@@ -120,25 +121,22 @@ static int __f2fs_convert_inline_data(struct inode *inode, struct page *page)
 	return err;
 }
 
-int f2fs_convert_inline_data(struct inode *inode,
-			     struct page *p, unsigned flags)
+int f2fs_convert_inline_data(struct inode *inode, pgoff_t to_size)
 {
-	int err;
 	struct page *page;
+	int err;
 
-	if (!p || p->index) {
-		page = grab_cache_page_write_begin(inode->i_mapping, 0, flags);
-		if (IS_ERR(page))
-			return PTR_ERR(page);
-	} else {
-		page = p;
-	}
-
-	err = __f2fs_convert_inline_data(inode, page);
+	if (!f2fs_has_inline_data(inode))
+		return 0;
+	else if (to_size <= MAX_INLINE_DATA)
+		return 0;
 
-	if (!p || p->index)
-		f2fs_put_page(page, 1);
+	page = grab_cache_page_write_begin(inode->i_mapping, 0, AOP_FLAG_NOFS);
+	if (IS_ERR(page))
+		return PTR_ERR(page);
 
+	err = __f2fs_convert_inline_data(inode, page);
+	f2fs_put_page(page, 1);
 	return err;
 }
 
-- 
1.8.4.474.g128a96c

