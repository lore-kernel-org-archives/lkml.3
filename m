Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245AbaD3CgB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 22:36:01 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:9645 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbaD3Cf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 22:35:57 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-78-5360618bce39
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Chao Yu <chao2.yu@samsung.com>
Subject: [PATCH 1/4] f2fs: split grab_cache_page and wait_on_page_writeback for
 node pages
Date: Wed, 30 Apr 2014 11:33:40 +0900
Message-id: <1398825223-23062-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFLMWRmVeSWpSXmKPExsVy+t8zY93uxIRgg8//VCz+N31ks7i+6y+T
	xaVF7hZ79p5ksbi8aw6bA6vH7gWfmTz6tqxi9Pi8SS6AOYrLJiU1J7MstUjfLoEro6X/FWvB
	RI2KDV8fsDUwLlXsYuTkkBAwkWjr72WDsMUkLtxbD2RzcQgJLGOU6Ng6kw2maMGTrewQiUWM
	EvPf9jNBOJ1MEoc6eoEyHBxsAtoSm/cbgDSICDBLLJh6nhGkhllgE6PEgjfv2EESwgIxEh9f
	HAKbyiKgKvH+428wm1fAXWL15cfMENu0JbY9nwjWLCHwnE2iaW8vO0SDgMS3yYdYQJZJCMhK
	bDoAVS8pcXDFDZYJjIILGBlWMYqmFiQXFCelF5noFSfmFpfmpesl5+duYoSE44QdjPcOWB9i
	TAYaN5FZSjQ5HxjOeSXxhsZmRhamJqbGRuaWZqQJK4nzqj1KChISSE8sSc1OTS1ILYovKs1J
	LT7EyMTBKdXAmPC4UiS3IjjTem5zrcXsV1f0zzv96Xtis8+ZacviosNHayONFfL37WiJXiI8
	LWe/R8U1Ya3j05RFv4rx3ZcNE/+rMrnvWcDXUpOJs7bXb9rXuGzlO2fjlSekTtjvPNhx2qz4
	uPLX6t/FjybZrT37xuHxls8ndcT/zBFqOcq+PNTj8HYm+c3hi5RYijMSDbWYi4oTAYvAivld	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOIsWRmVeSWpSXmKPExsVy+t9jAd3uxIRgg09rFSz+N31ks7i+6y+T
	xaVF7hZ79p5ksbi8aw6bA6vH7gWfmTz6tqxi9Pi8SS6AOaqB0SYjNTEltUghNS85PyUzL91W
	yTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaKWSQlliTilQKCCxuFhJ3w7ThNAQN10L
	mMYIXd+QILgeIwM0kLCOMaOl/xVrwUSNig1fH7A1MC5V7GLk5JAQMJFY8GQrO4QtJnHh3nq2
	LkYuDiGBRYwS89/2M0E4nUwShzp6gao4ONgEtCU27zcAaRARYJZYMPU8I0gNs8AmRokFb96B
	TRIWiJH4+OIQG4jNIqAq8f7jbzCbV8BdYvXlx8wQ27Qltj2fyDiBkXsBI8MqRtHUguSC4qT0
	XCO94sTc4tK8dL3k/NxNjOBgfya9g3FVg8UhRgEORiUeXoGt8cFCrIllxZW5hxglOJiVRHiZ
	AxKChXhTEiurUovy44tKc1KLDzEmA22fyCwlmpwPjMS8knhDYxMzI0sjMwsjE3Nz0oSVxHkP
	tloHCgmkJ5akZqemFqQWwWxh4uCUamDsX5yet2aN4itOmZkuuyP4l9otvT9NQPAa2zqLq3Lt
	u7ruP1Xg/Dl/87aKtKqfqx7s3vlHdNM9jqMmS+993f9u5uFtfeevhc3d5nPlfvZbD5WeI/Me
	FKVIfNcKjH3Pc6mpLGvbzpy1X4XZ/6+u3XemY6nBH4ve+0esZMzFtzvzR5tN5Tq3Qsb8hhJL
	cUaioRZzUXEiANvl3Hy6AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch splits grab_cache_page_write_begin into grab_cache_page and
wait_on_page_writeback for node pages.

This patch intends to enhance the latency to get node pages by alleviating
unnecessary wait_on_page_writeback.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/dir.c    | 2 ++
 fs/f2fs/inline.c | 6 ++++++
 fs/f2fs/node.c   | 8 ++++----
 fs/f2fs/node.h   | 2 +-
 fs/f2fs/xattr.c  | 3 +++
 5 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index 3581c2b..c3f1485 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -268,6 +268,8 @@ static void init_dent_inode(const struct qstr *name, struct page *ipage)
 {
 	struct f2fs_inode *ri;
 
+	f2fs_wait_on_page_writeback(ipage, NODE);
+
 	/* copy name info. to this inode page */
 	ri = F2FS_INODE(ipage);
 	ri->i_namelen = cpu_to_le32(name->len);
diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index d215dbb..8bf34f0 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -156,6 +156,7 @@ int f2fs_write_inline_data(struct inode *inode,
 		return err;
 	ipage = dn.inode_page;
 
+	f2fs_wait_on_page_writeback(ipage, NODE);
 	zero_user_segment(ipage, INLINE_DATA_OFFSET,
 				 INLINE_DATA_OFFSET + MAX_INLINE_DATA);
 	src_addr = kmap(page);
@@ -188,6 +189,8 @@ void truncate_inline_data(struct inode *inode, u64 from)
 	if (IS_ERR(ipage))
 		return;
 
+	f2fs_wait_on_page_writeback(ipage, NODE);
+
 	zero_user_segment(ipage, INLINE_DATA_OFFSET + from,
 				INLINE_DATA_OFFSET + MAX_INLINE_DATA);
 	set_page_dirty(ipage);
@@ -218,6 +221,8 @@ process_inline:
 		ipage = get_node_page(sbi, inode->i_ino);
 		f2fs_bug_on(IS_ERR(ipage));
 
+		f2fs_wait_on_page_writeback(ipage, NODE);
+
 		src_addr = inline_data_addr(npage);
 		dst_addr = inline_data_addr(ipage);
 		memcpy(dst_addr, src_addr, MAX_INLINE_DATA);
@@ -229,6 +234,7 @@ process_inline:
 	if (f2fs_has_inline_data(inode)) {
 		ipage = get_node_page(sbi, inode->i_ino);
 		f2fs_bug_on(IS_ERR(ipage));
+		f2fs_wait_on_page_writeback(ipage, NODE);
 		zero_user_segment(ipage, INLINE_DATA_OFFSET,
 				 INLINE_DATA_OFFSET + MAX_INLINE_DATA);
 		clear_inode_flag(F2FS_I(inode), FI_INLINE_DATA);
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 2803ef6..059aaf5 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -853,8 +853,7 @@ struct page *new_node_page(struct dnode_of_data *dn,
 	if (unlikely(is_inode_flag_set(F2FS_I(dn->inode), FI_NO_ALLOC)))
 		return ERR_PTR(-EPERM);
 
-	page = grab_cache_page_write_begin(NODE_MAPPING(sbi),
-					dn->nid, AOP_FLAG_NOFS);
+	page = grab_cache_page(NODE_MAPPING(sbi), dn->nid);
 	if (!page)
 		return ERR_PTR(-ENOMEM);
 
@@ -871,6 +870,7 @@ struct page *new_node_page(struct dnode_of_data *dn,
 	new_ni.ino = dn->inode->i_ino;
 	set_node_addr(sbi, &new_ni, NEW_ADDR, false);
 
+	f2fs_wait_on_page_writeback(page, NODE);
 	fill_node_footer(page, dn->nid, dn->inode->i_ino, ofs, true);
 	set_cold_node(dn->inode, page);
 	SetPageUptodate(page);
@@ -950,8 +950,7 @@ struct page *get_node_page(struct f2fs_sb_info *sbi, pgoff_t nid)
 	struct page *page;
 	int err;
 repeat:
-	page = grab_cache_page_write_begin(NODE_MAPPING(sbi),
-					nid, AOP_FLAG_NOFS);
+	page = grab_cache_page(NODE_MAPPING(sbi), nid);
 	if (!page)
 		return ERR_PTR(-ENOMEM);
 
@@ -1562,6 +1561,7 @@ static void recover_inline_xattr(struct inode *inode, struct page *page)
 	src_addr = inline_xattr_addr(page);
 	inline_size = inline_xattr_size(inode);
 
+	f2fs_wait_on_page_writeback(ipage, NODE);
 	memcpy(dst_addr, src_addr, inline_size);
 
 	update_inode(inode, ipage);
diff --git a/fs/f2fs/node.h b/fs/f2fs/node.h
index a076c88..4ee29d5 100644
--- a/fs/f2fs/node.h
+++ b/fs/f2fs/node.h
@@ -272,7 +272,7 @@ static inline void set_nid(struct page *p, int off, nid_t nid, bool i)
 {
 	struct f2fs_node *rn = F2FS_NODE(p);
 
-	wait_on_page_writeback(p);
+	f2fs_wait_on_page_writeback(p, NODE);
 
 	if (i)
 		rn->i.i_nid[off - NODE_DIR1_BLOCK] = cpu_to_le32(nid);
diff --git a/fs/f2fs/xattr.c b/fs/f2fs/xattr.c
index 6073f9f..1f546b4 100644
--- a/fs/f2fs/xattr.c
+++ b/fs/f2fs/xattr.c
@@ -349,6 +349,7 @@ static inline int write_all_xattrs(struct inode *inode, __u32 hsize,
 
 		if (ipage) {
 			inline_addr = inline_xattr_addr(ipage);
+			f2fs_wait_on_page_writeback(ipage, NODE);
 		} else {
 			page = get_node_page(sbi, inode->i_ino);
 			if (IS_ERR(page)) {
@@ -356,6 +357,7 @@ static inline int write_all_xattrs(struct inode *inode, __u32 hsize,
 				return PTR_ERR(page);
 			}
 			inline_addr = inline_xattr_addr(page);
+			f2fs_wait_on_page_writeback(page, NODE);
 		}
 		memcpy(inline_addr, txattr_addr, inline_size);
 		f2fs_put_page(page, 1);
@@ -376,6 +378,7 @@ static inline int write_all_xattrs(struct inode *inode, __u32 hsize,
 			return PTR_ERR(xpage);
 		}
 		f2fs_bug_on(new_nid);
+		f2fs_wait_on_page_writeback(xpage, NODE);
 	} else {
 		struct dnode_of_data dn;
 		set_new_dnode(&dn, inode, NULL, NULL, new_nid);
-- 
1.8.4.474.g128a96c

