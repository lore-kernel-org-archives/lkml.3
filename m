Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470Ab3ETDeX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 23:34:23 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:41635 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755434Ab3ETDdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 23:33:42 -0400
X-AuditID: cbfee690-b7efc6d000006d92-1b-5199998e30bb
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 08/15] f2fs: update inode page after creation
Date: Mon, 20 May 2013 12:32:22 +0900
Message-id: <1369020743-18520-8-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.1.3.566.gaa39828
In-reply-to: <1369020743-18520-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1369020743-18520-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsVy+t8zA92+mTMDDe48tLS4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK+PB4nesBTtsKprP
	vGBpYGw37GLk5JAQMJH43r2FFcIWk7hwbz0biC0ksIxR4sI6ni5GDrCa3VPNuxi5gMKLGCU2
	717GDuG0MUlsbDjCBlLEJqAtsXm/AUiviACzxIKp5xlBapgFJjBK/F/0ngUkISxgK/Hy/lom
	EJtFQFVi0sVjYMt4BdwlNkzdwQhxhK7E6v/P2UFsTgEPia13TzGCzBcCqnl9rgRkpoTAbzaJ
	O0s3skLMEZD4NvkQC8ShshKbDjBDjJGUOLjiBssERuEFjAyrGEVTC5ILipPSi0z0ihNzi0vz
	0vWS83M3MULCdcIOxnsHrA8xJgONm8gsJZqcDwz3vJJ4Q2MzIwtTE1NjI3NLM9KElcR51Vus
	A4UE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUw8kk++LrD92ZwzF1Zl9lKN4x/Mdgv9wtIuLKz
	6mXgzVPrl3WKm8+fvcbccIVZWd3ivtLbYnJ65ke/JPOc/rYob0p0eIre/yWBX+MaF33Kiv55
	jm1lZOVPmRmR7orMjIeyzcNOZh6ab8h/yVGx0OxiKpPEx+IJ8RbfLvQtmmRta7Tutq7E3hcx
	SizFGYmGWsxFxYkABsshc20CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsVy+t9jAd2+mTMDDZqaTC2u7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8x4sPgda8EOm4rmMy9YGhjbDbsYOTgkBEwkdk8172LkBDLFJC7cW8/WxcjF
	ISSwiFFi8+5l7BBOG5PExoYjbCANbALaEpv3G4A0iAgwSyyYep4RpIZZYAKjxP9F71lAEsIC
	thIv769lArFZBFQlJl08xgZi8wq4S2yYuoMRYpuuxOr/z9lBbE4BD4mtd08xgswXAqp5fa5k
	AiPvAkaGVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjB8fBMegfjqgaLQ4wCHIxKPLwCATMD
	hVgTy4orcw8xSnAwK4nwRncDhXhTEiurUovy44tKc1KLDzEmAx01kVlKNDkfGKt5JfGGxiZm
	RpZGZhZGJubmpAkrifMebLUOFBJITyxJzU5NLUgtgtnCxMEp1cBYU7Gk7dIuZl+V5czTC9j3
	zXt89+xlg5DXV7KcFOoWLNlS8nP/fK5mR6vlRxp38ul21FzRvOXA7bi+Pa228+QsvwMrnt98
	Iv+6+GaTUJKff4Rd6t10vqbiHDev8yvvzZePVhc4vk8xf229fbOabstUi8TCx2s+vTY9t3VV
	hOXt4DvRu3nNGCYosRRnJBpqMRcVJwIAy8QT4csCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found a bug when testing power-off-recovery as follows.

[Bug Scenario]
1. create a file
2. fsync the file
3. reboot w/o any sync
4. try to recover the file
 - found its fsync mark
 - found its dentry mark
   : try to recover its dentry
    - get its file name
    - get its parent inode number
     : here we got zero value

The reason why we get the wrong parent inode number is that we didn't
synchronize the inode page with its newly created inode information perfectly.

Especially, previous f2fs stores fi->i_pino and writes it to the cached
node page in a wrong order, which incurs the zero-valued i_pino during the
recovery.

So, this patch modifies the creation flow to fix the synchronization order of
inode page with its inode.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/data.c |  1 +
 fs/f2fs/dir.c  | 85 +++++++++++++++++++++++++++++++---------------------------
 fs/f2fs/f2fs.h |  3 +--
 fs/f2fs/node.c | 12 +++------
 4 files changed, 51 insertions(+), 50 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index af74549..c320f7f 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -279,6 +279,7 @@ repeat:
  *
  * Also, caller should grab and release a mutex by calling mutex_lock_op() and
  * mutex_unlock_op().
+ * Note that, npage is set only by make_empty_dir.
  */
 struct page *get_new_data_page(struct inode *inode,
 		struct page *npage, pgoff_t index, bool new_i_size)
diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index 7db6e58..fc1dacf 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -264,15 +264,10 @@ void f2fs_set_link(struct inode *dir, struct f2fs_dir_entry *de,
 	f2fs_put_page(page, 1);
 }
 
-void init_dent_inode(const struct qstr *name, struct page *ipage)
+static void init_dent_inode(const struct qstr *name, struct page *ipage)
 {
 	struct f2fs_node *rn;
 
-	if (IS_ERR(ipage))
-		return;
-
-	wait_on_page_writeback(ipage);
-
 	/* copy name info. to this inode page */
 	rn = (struct f2fs_node *)page_address(ipage);
 	rn->i.i_namelen = cpu_to_le32(name->len);
@@ -280,14 +275,15 @@ void init_dent_inode(const struct qstr *name, struct page *ipage)
 	set_page_dirty(ipage);
 }
 
-static int make_empty_dir(struct inode *inode, struct inode *parent)
+static int make_empty_dir(struct inode *inode,
+		struct inode *parent, struct page *page)
 {
 	struct page *dentry_page;
 	struct f2fs_dentry_block *dentry_blk;
 	struct f2fs_dir_entry *de;
 	void *kaddr;
 
-	dentry_page = get_new_data_page(inode, NULL, 0, true);
+	dentry_page = get_new_data_page(inode, page, 0, true);
 	if (IS_ERR(dentry_page))
 		return PTR_ERR(dentry_page);
 
@@ -317,42 +313,47 @@ static int make_empty_dir(struct inode *inode, struct inode *parent)
 	return 0;
 }
 
-static int init_inode_metadata(struct inode *inode,
+static struct page *init_inode_metadata(struct inode *inode,
 		struct inode *dir, const struct qstr *name)
 {
+	struct page *page;
+	int err;
+
 	if (is_inode_flag_set(F2FS_I(inode), FI_NEW_INODE)) {
-		int err;
-		err = new_inode_page(inode, name);
-		if (err)
-			return err;
+		page = new_inode_page(inode, name);
+		if (IS_ERR(page))
+			return page;
 
 		if (S_ISDIR(inode->i_mode)) {
-			err = make_empty_dir(inode, dir);
-			if (err) {
-				remove_inode_page(inode);
-				return err;
-			}
+			err = make_empty_dir(inode, dir, page);
+			if (err)
+				goto error;
 		}
 
 		err = f2fs_init_acl(inode, dir);
-		if (err) {
-			remove_inode_page(inode);
-			return err;
-		}
+		if (err)
+			goto error;
+
+		wait_on_page_writeback(page);
 	} else {
-		struct page *ipage;
-		ipage = get_node_page(F2FS_SB(dir->i_sb), inode->i_ino);
-		if (IS_ERR(ipage))
-			return PTR_ERR(ipage);
-		set_cold_node(inode, ipage);
-		init_dent_inode(name, ipage);
-		f2fs_put_page(ipage, 1);
+		page = get_node_page(F2FS_SB(dir->i_sb), inode->i_ino);
+		if (IS_ERR(page))
+			return page;
+
+		wait_on_page_writeback(page);
+		set_cold_node(inode, page);
 	}
-	if (is_inode_flag_set(F2FS_I(inode), FI_INC_LINK)) {
+
+	init_dent_inode(name, page);
+
+	if (is_inode_flag_set(F2FS_I(inode), FI_INC_LINK))
 		inc_nlink(inode);
-		update_inode_page(inode);
-	}
-	return 0;
+	return page;
+
+error:
+	f2fs_put_page(page, 1);
+	remove_inode_page(inode);
+	return ERR_PTR(err);
 }
 
 static void update_parent_metadata(struct inode *dir, struct inode *inode,
@@ -423,6 +424,7 @@ int __f2fs_add_link(struct inode *dir, const struct qstr *name, struct inode *in
 	struct page *dentry_page = NULL;
 	struct f2fs_dentry_block *dentry_blk = NULL;
 	int slots = GET_DENTRY_SLOTS(namelen);
+	struct page *page;
 	int err = 0;
 	int i;
 
@@ -465,12 +467,13 @@ start:
 	++level;
 	goto start;
 add_dentry:
-	err = init_inode_metadata(inode, dir, name);
-	if (err)
-		goto fail;
-
 	wait_on_page_writeback(dentry_page);
 
+	page = init_inode_metadata(inode, dir, name);
+	if (IS_ERR(page)) {
+		err = PTR_ERR(page);
+		goto fail;
+	}
 	de = &dentry_blk->dentry[bit_pos];
 	de->hash_code = dentry_hash;
 	de->name_len = cpu_to_le16(namelen);
@@ -481,10 +484,12 @@ add_dentry:
 		test_and_set_bit_le(bit_pos + i, &dentry_blk->dentry_bitmap);
 	set_page_dirty(dentry_page);
 
-	update_parent_metadata(dir, inode, current_depth);
-
-	/* update parent inode number before releasing dentry page */
+	/* we don't need to mark_inode_dirty now */
 	F2FS_I(inode)->i_pino = dir->i_ino;
+	update_inode(inode, page);
+	f2fs_put_page(page, 1);
+
+	update_parent_metadata(dir, inode, current_depth);
 fail:
 	kunmap(dentry_page);
 	f2fs_put_page(dentry_page, 1);
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index cbae2b6..9360a03 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -914,7 +914,6 @@ struct f2fs_dir_entry *f2fs_parent_dir(struct inode *, struct page **);
 ino_t f2fs_inode_by_name(struct inode *, struct qstr *);
 void f2fs_set_link(struct inode *, struct f2fs_dir_entry *,
 				struct page *, struct inode *);
-void init_dent_inode(const struct qstr *, struct page *);
 int __f2fs_add_link(struct inode *, const struct qstr *, struct inode *);
 void f2fs_delete_entry(struct f2fs_dir_entry *, struct page *, struct inode *);
 int f2fs_make_empty(struct inode *, struct inode *);
@@ -949,7 +948,7 @@ void get_node_info(struct f2fs_sb_info *, nid_t, struct node_info *);
 int get_dnode_of_data(struct dnode_of_data *, pgoff_t, int);
 int truncate_inode_blocks(struct inode *, pgoff_t);
 int remove_inode_page(struct inode *);
-int new_inode_page(struct inode *, const struct qstr *);
+struct page *new_inode_page(struct inode *, const struct qstr *);
 struct page *new_node_page(struct dnode_of_data *, unsigned int);
 void ra_node_page(struct f2fs_sb_info *, nid_t);
 struct page *get_node_page(struct f2fs_sb_info *, pgoff_t);
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index f63f0a4..b41482d 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -806,19 +806,15 @@ int remove_inode_page(struct inode *inode)
 	return 0;
 }
 
-int new_inode_page(struct inode *inode, const struct qstr *name)
+struct page *new_inode_page(struct inode *inode, const struct qstr *name)
 {
-	struct page *page;
 	struct dnode_of_data dn;
 
 	/* allocate inode page for new inode */
 	set_new_dnode(&dn, inode, NULL, NULL, inode->i_ino);
-	page = new_node_page(&dn, 0);
-	init_dent_inode(name, page);
-	if (IS_ERR(page))
-		return PTR_ERR(page);
-	f2fs_put_page(page, 1);
-	return 0;
+
+	/* caller should f2fs_put_page(page, 1); */
+	return new_node_page(&dn, 0);
 }
 
 struct page *new_node_page(struct dnode_of_data *dn, unsigned int ofs)
-- 
1.8.1.3.566.gaa39828

