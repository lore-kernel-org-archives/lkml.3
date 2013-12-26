Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab3LZITI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 03:19:08 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:63768 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715Ab3LZISk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 03:18:40 -0500
X-AuditID: cbfee68f-b7f156d00000276c-ba-52bbe659e9cc
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 1/2] f2fs: introduce F2FS_INODE macro to get f2fs_inode
Date: Thu, 26 Dec 2013 17:17:20 +0900
Message-id: <1388045841-32165-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t8zA93IZ7uDDLZs17C4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK6N9g0DBY52Kjr27
	2BsYJ6t0MXJySAiYSBx5N4UNwhaTuHBvPZDNxSEksIxR4vjEfUwwReseHWKCSCxilOhZvguq
	qplJ4nLrIfYuRg4ONgFtic37DUAaRASYJRZMPc8IUsMsMIFR4v+i9ywgCWEBd4mWxd3MIDaL
	gKrE419P2EFsXqB4/7efrBDbtCW2PZ8I1iwhcJ9NYvafBewQDQIS3yYfYgFZJiEgK7HpADNE
	vaTEwRU3WCYwCi5gZFjFKJpakFxQnJReZKxXnJhbXJqXrpecn7uJERKC/TsY7x6wPsSYDDRu
	IrOUaHI+MITzSuINjc2MLExNTI2NzC3NSBNWEue9/zApSEggPbEkNTs1tSC1KL6oNCe1+BAj
	EwenVANjUUbbocSqGfNPXk3bePxV45+kBU4a5+dOe7zhfFJQsORFUZP0Q7O5lnRK9j5Tni50
	S+6P9VGJV6pvijKyo2c8ry5af8okwTbJ+MS14KVWF3dPLVJhdo1b/a3j53axmy2rL2pybJ9y
	r/mLwOckn6et2UEvsq82XK+XaVy3wcdT87DbR51pbeuXKrEUZyQaajEXFScCAPu8fXFXAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t9jAd3IZ7uDDBbdVLa4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON45
	3tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2ibkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3f
	kCC4HiMDNJCwjjGjfYNAwWOdio69u9gbGCerdDFyckgImEise3SICcIWk7hwbz1bFyMXh5DA
	IkaJnuW7oJxmJonLrYfYuxg5ONgEtCU27zcAaRARYJZYMPU8I0gNs8AERon/i96zgCSEBdwl
	WhZ3M4PYLAKqEo9/PWEHsXmB4v3ffrJCbNOW2PZ8IuMERu4FjAyrGEVTC5ILipPScw31ihNz
	i0vz0vWS83M3MYID/JnUDsaVDRaHGAU4GJV4eDt0dwcJsSaWFVfmHmKU4GBWEuHd1Q0U4k1J
	rKxKLcqPLyrNSS0+xJgMtH0is5Rocj4w+vJK4g2NTcyMLI3MLIxMzM1JE1YS5z3Qah0oJJCe
	WJKanZpakFoEs4WJg1OqgdFo7pZj99tmhXHND5T/8mXTI7bFRyMVzpg8OTt35puitf9WfTke
	Ucw+8dGbgnmyAdvlk2KOvWF8/XttyIR1JW8DG9tepojezf/Mve6GdeG7pB9lSt23Jb68tT73
	a3N4U81MtRXzyzXabPuuXc7w+rp52f2Q6I3fnjt9b3u2qnyv+n3veaszhBRjlFiKMxINtZiL
	ihMBZGtZfrQCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces F2FS_INODE that returns struct f2fs_inode * from the inode
page.
By using this macro, we can remove unnecessary casting codes like below.

   struct f2fs_inode *ri = &F2FS_NODE(inode_page)->i;
-> struct f2fs_inode *ri = F2FS_INODE(inode_page);

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/dir.c      |  8 ++++----
 fs/f2fs/f2fs.h     |  5 +++++
 fs/f2fs/inode.c    |  8 ++------
 fs/f2fs/node.c     | 14 +++++++-------
 fs/f2fs/recovery.c |  6 ++----
 5 files changed, 20 insertions(+), 21 deletions(-)

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index f0b4630..6da77e5 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -261,12 +261,12 @@ void f2fs_set_link(struct inode *dir, struct f2fs_dir_entry *de,
 
 static void init_dent_inode(const struct qstr *name, struct page *ipage)
 {
-	struct f2fs_node *rn;
+	struct f2fs_inode *ri;
 
 	/* copy name info. to this inode page */
-	rn = F2FS_NODE(ipage);
-	rn->i.i_namelen = cpu_to_le32(name->len);
-	memcpy(rn->i.i_name, name->name, name->len);
+	ri = F2FS_INODE(ipage);
+	ri->i_namelen = cpu_to_le32(name->len);
+	memcpy(ri->i_name, name->name, name->len);
 	set_page_dirty(ipage);
 }
 
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index ba91186..1a06f0a 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -498,6 +498,11 @@ static inline struct f2fs_node *F2FS_NODE(struct page *page)
 	return (struct f2fs_node *)page_address(page);
 }
 
+static inline struct f2fs_inode *F2FS_INODE(struct page *page)
+{
+	return &((struct f2fs_node *)page_address(page))->i;
+}
+
 static inline struct f2fs_nm_info *NM_I(struct f2fs_sb_info *sbi)
 {
 	return (struct f2fs_nm_info *)(sbi->nm_info);
diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index d0eaa9f..a91f451 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -67,7 +67,6 @@ static int do_read_inode(struct inode *inode)
 	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
 	struct f2fs_inode_info *fi = F2FS_I(inode);
 	struct page *node_page;
-	struct f2fs_node *rn;
 	struct f2fs_inode *ri;
 
 	/* Check if ino is within scope */
@@ -81,8 +80,7 @@ static int do_read_inode(struct inode *inode)
 	if (IS_ERR(node_page))
 		return PTR_ERR(node_page);
 
-	rn = F2FS_NODE(node_page);
-	ri = &(rn->i);
+	ri = F2FS_INODE(node_page);
 
 	inode->i_mode = le16_to_cpu(ri->i_mode);
 	i_uid_write(inode, le32_to_cpu(ri->i_uid));
@@ -175,13 +173,11 @@ bad_inode:
 
 void update_inode(struct inode *inode, struct page *node_page)
 {
-	struct f2fs_node *rn;
 	struct f2fs_inode *ri;
 
 	f2fs_wait_on_page_writeback(node_page, NODE, false);
 
-	rn = F2FS_NODE(node_page);
-	ri = &(rn->i);
+	ri = F2FS_INODE(node_page);
 
 	ri->i_mode = cpu_to_le16(inode->i_mode);
 	ri->i_advise = F2FS_I(inode)->i_advise;
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index e8fe52d..6fdd88c 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -684,7 +684,7 @@ int truncate_inode_blocks(struct inode *inode, pgoff_t from)
 	int err = 0, cont = 1;
 	int level, offset[4], noffset[4];
 	unsigned int nofs = 0;
-	struct f2fs_node *rn;
+	struct f2fs_inode *ri;
 	struct dnode_of_data dn;
 	struct page *page;
 
@@ -701,7 +701,7 @@ restart:
 	set_new_dnode(&dn, inode, page, NULL, 0);
 	unlock_page(page);
 
-	rn = F2FS_NODE(page);
+	ri = F2FS_INODE(page);
 	switch (level) {
 	case 0:
 	case 1:
@@ -711,7 +711,7 @@ restart:
 		nofs = noffset[1];
 		if (!offset[level - 1])
 			goto skip_partial;
-		err = truncate_partial_nodes(&dn, &rn->i, offset, level);
+		err = truncate_partial_nodes(&dn, ri, offset, level);
 		if (err < 0 && err != -ENOENT)
 			goto fail;
 		nofs += 1 + NIDS_PER_BLOCK;
@@ -720,7 +720,7 @@ restart:
 		nofs = 5 + 2 * NIDS_PER_BLOCK;
 		if (!offset[level - 1])
 			goto skip_partial;
-		err = truncate_partial_nodes(&dn, &rn->i, offset, level);
+		err = truncate_partial_nodes(&dn, ri, offset, level);
 		if (err < 0 && err != -ENOENT)
 			goto fail;
 		break;
@@ -730,7 +730,7 @@ restart:
 
 skip_partial:
 	while (cont) {
-		dn.nid = le32_to_cpu(rn->i.i_nid[offset[0] - NODE_DIR1_BLOCK]);
+		dn.nid = le32_to_cpu(ri->i_nid[offset[0] - NODE_DIR1_BLOCK]);
 		switch (offset[0]) {
 		case NODE_DIR1_BLOCK:
 		case NODE_DIR2_BLOCK:
@@ -753,14 +753,14 @@ skip_partial:
 		if (err < 0 && err != -ENOENT)
 			goto fail;
 		if (offset[1] == 0 &&
-				rn->i.i_nid[offset[0] - NODE_DIR1_BLOCK]) {
+				ri->i_nid[offset[0] - NODE_DIR1_BLOCK]) {
 			lock_page(page);
 			if (unlikely(page->mapping != node_mapping)) {
 				f2fs_put_page(page, 1);
 				goto restart;
 			}
 			wait_on_page_writeback(page);
-			rn->i.i_nid[offset[0] - NODE_DIR1_BLOCK] = 0;
+			ri->i_nid[offset[0] - NODE_DIR1_BLOCK] = 0;
 			set_page_dirty(page);
 			unlock_page(page);
 		}
diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index 4d411a2..96e690b6 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -40,8 +40,7 @@ static struct fsync_inode_entry *get_fsync_inode(struct list_head *head,
 
 static int recover_dentry(struct page *ipage, struct inode *inode)
 {
-	struct f2fs_node *raw_node = F2FS_NODE(ipage);
-	struct f2fs_inode *raw_inode = &(raw_node->i);
+	struct f2fs_inode *raw_inode = F2FS_INODE(ipage);
 	nid_t pino = le32_to_cpu(raw_inode->i_pino);
 	struct f2fs_dir_entry *de;
 	struct qstr name;
@@ -105,8 +104,7 @@ out:
 
 static int recover_inode(struct inode *inode, struct page *node_page)
 {
-	struct f2fs_node *raw_node = F2FS_NODE(node_page);
-	struct f2fs_inode *raw_inode = &(raw_node->i);
+	struct f2fs_inode *raw_inode = F2FS_INODE(node_page);
 
 	if (!IS_INODE(node_page))
 		return 0;
-- 
1.8.4.474.g128a96c

