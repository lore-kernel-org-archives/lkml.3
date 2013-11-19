Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751766Ab3KSHLe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 02:11:34 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:38770 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab3KSHLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 02:11:31 -0500
X-AuditID: cbfee691-b7f866d000001b8c-dc-528b0f216b1a
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 1/2] f2fs: disable the extent cache ops on high fragmented files
Date: Tue, 19 Nov 2013 16:10:36 +0900
Message-id: <1384845037-7872-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrILMWRmVeSWpSXmKPExsVy+t8zfV0l/u4gg5lbmCyu7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgytj1rYG14Lp0xdZp
	i9kaGFeIdTFyckgImEg87W1mhLDFJC7cW8/WxcjFISSwjFFi2cStQA4HWNHJzywgNUIC0xkl
	Jn83hahpZpJYOeUiO0gNm4C2xOb9BiA1IgLMEgumnmcEqWEWmMAo8X/RexaQGmGBAInPP3JB
	algEVCW29D9kBgnzCrhJnJ1iA3GCtsS25xPBWiUE7rNJXPlxhBGiXkDi2+RDLBDnyEpsOsAM
	US8pcXDFDZYJjIILGBlWMYqmFiQXFCelF5nqFSfmFpfmpesl5+duYoQE38QdjPcPWB9iTAYa
	N5FZSjQ5Hxi8eSXxhsZmRhamJqbGRuaWZqQJK4nzpj9KChISSE8sSc1OTS1ILYovKs1JLT7E
	yMTBKdXAOGehCNP21Lyl6xfJCZg0XN776MXyjHK1yS73nt79sn7WAuuewJuXfFkW/g6zTi+P
	Pn3gM+vJ/yK+kzx7s+WEU+OXnOLyCTa22nnxyy5m1QNd0zdp888MOFsld2IWG9/N6x+X3NQ8
	9lHp9I5Nrz8+WjOBJTZIOfP2lYYLUck571n51zdNK081KlNiKc5INNRiLipOBABvqFaeVAIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHIsWRmVeSWpSXmKPExsVy+t9jQV1F/u4gg+Zea4vru/4yWVxa5G6x
	Z+9JFovLu+awObB47F7wmcmjb8sqRo/Pm+QCmKMaGG0yUhNTUosUUvOS81My89JtlbyD453j
	Tc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgLYpKZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUN
	CYLrMTJAAwnrGDN2fWtgLbguXbF12mK2BsYVYl2MHBwSAiYSJz+zdDFyApliEhfurWcDsYUE
	pjNKTP5u2sXIBWQ3M0msnHKRHaSeTUBbYvN+A5AaEQFmiQVTzzOC1DALTGCU+L/oPQtIjbBA
	gMTnH7kgNSwCqhJb+h8yg4R5Bdwkzk6xgVilLbHt+UTGCYzcCxgZVjGKphYkFxQnpeca6RUn
	5haX5qXrJefnbmIEh/Yz6R2MqxosDjEKcDAq8fBOcO8KEmJNLCuuzD3EKMHBrCTCK3kFKMSb
	klhZlVqUH19UmpNafIgxGWj5RGYp0eR8YNzllcQbGpuYGVkamVkYmZibkyasJM57sNU6UEgg
	PbEkNTs1tSC1CGYLEwenVAOjuObk3/F/HP0PCYs22mbpGVe0uG6Je8/i+sf49L1bkgx/OA4d
	VMhkyt7CpuawXK6XZVLXXs6tHxm+sNm9y0l9sSiu99GB1KmcwdNZLt9z3uMo9mPKpOsvmVPt
	Li8VWDndVDpB32Miy/XD/+dbTknK1p527H7Lc5Wrf8qWztu/68WOa8H63jFRSizFGYmGWsxF
	xYkAI7DRA7ECAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The f2fs manages an extent cache to search a number of consecutive data blocks
very quickly.

However it conducts unnecessary cache operations if the file is highly
fragmented with no valid extent cache.

In such the case, we don't need to handle the extent cache, but just can disable
the cache facility.

Nevertheless, this patch gives one more chance to enable the extent cache.

For example,
1. create a file
2. write data sequentially which produces a large valid extent cache
3. update some data, resulting in a fragmented extent
4. if the fragmented extent is too small, then drop extent cache
5. close the file

6. open the file again
7. give another chance to make a new extent cache
8. write data sequentially again which creates another big extent cache.
...

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/data.c | 22 ++++++++++++++++++----
 fs/f2fs/f2fs.h |  3 +++
 2 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 5920639..2e54522 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -71,6 +71,9 @@ static int check_extent_cache(struct inode *inode, pgoff_t pgofs,
 	pgoff_t start_fofs, end_fofs;
 	block_t start_blkaddr;
 
+	if (is_inode_flag_set(fi, FI_NO_EXTENT))
+		return 0;
+
 	read_lock(&fi->ext.ext_lock);
 	if (fi->ext.len == 0) {
 		read_unlock(&fi->ext.ext_lock);
@@ -109,6 +112,7 @@ void update_extent_cache(block_t blk_addr, struct dnode_of_data *dn)
 	struct f2fs_inode_info *fi = F2FS_I(dn->inode);
 	pgoff_t fofs, start_fofs, end_fofs;
 	block_t start_blkaddr, end_blkaddr;
+	int need_update = true;
 
 	f2fs_bug_on(blk_addr == NEW_ADDR);
 	fofs = start_bidx_of_node(ofs_of_node(dn->node_page), fi) +
@@ -117,6 +121,9 @@ void update_extent_cache(block_t blk_addr, struct dnode_of_data *dn)
 	/* Update the page address in the parent node */
 	__set_data_blkaddr(dn, blk_addr);
 
+	if (is_inode_flag_set(fi, FI_NO_EXTENT))
+		return;
+
 	write_lock(&fi->ext.ext_lock);
 
 	start_fofs = fi->ext.fofs;
@@ -163,14 +170,21 @@ void update_extent_cache(block_t blk_addr, struct dnode_of_data *dn)
 					fofs - start_fofs + 1;
 			fi->ext.len -= fofs - start_fofs + 1;
 		}
-		goto end_update;
+	} else {
+		need_update = false;
 	}
-	write_unlock(&fi->ext.ext_lock);
-	return;
 
+	/* Finally, if the extent is very fragmented, let's drop the cache. */
+	if (fi->ext.len < F2FS_MIN_EXTENT_LEN) {
+		fi->ext.len = 0;
+		set_inode_flag(fi, FI_NO_EXTENT);
+		need_update = true;
+	}
 end_update:
 	write_unlock(&fi->ext.ext_lock);
-	sync_inode_page(dn);
+	if (need_update)
+		sync_inode_page(dn);
+	return;
 }
 
 struct page *find_data_page(struct inode *inode, pgoff_t index, bool sync)
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index c2de549..e9038bb 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -169,6 +169,8 @@ enum {
 #define F2FS_LINK_MAX		32000	/* maximum link count per file */
 
 /* for in-memory extent cache entry */
+#define F2FS_MIN_EXTENT_LEN	16	/* minimum extent length */
+
 struct extent_info {
 	rwlock_t ext_lock;	/* rwlock for consistency */
 	unsigned int fofs;	/* start offset in a file */
@@ -889,6 +891,7 @@ enum {
 	FI_NO_ALLOC,		/* should not allocate any blocks */
 	FI_UPDATE_DIR,		/* should update inode block for consistency */
 	FI_DELAY_IPUT,		/* used for the recovery */
+	FI_NO_EXTENT,		/* not to use the extent cache */
 	FI_INLINE_XATTR,	/* used for inline xattr */
 };
 
-- 
1.8.4.474.g128a96c

