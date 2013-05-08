Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab3EHA5p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 20:57:45 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:11983 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643Ab3EHA5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 20:57:20 -0400
X-AuditID: cbfee68f-b7f066d000003683-51-5189a2ed727c
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 2/2] f2fs: remove alloc_nid_done/fail for performance
Date: Wed, 08 May 2013 09:56:11 +0900
Message-id: <1367974571-29255-2-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.1.3.566.gaa39828
In-reply-to: <1367974571-29255-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1367974571-29255-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsVy+t8zY923izoDDVrWGltc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlXGk8yRrwXOvikdf
	V7M1MF6z6WLk5JAQMJH4ufIvG4QtJnHh3nogm4tDSGAZo8Sr75vYYYqOrd3HDJGYzigx5U8v
	I0hCSKCNSeLansIuRg4ONgFtic37DUDCIgLMEgumnmcEqWcWmMAo8X/RexaQhLCAq8SKtt3M
	IDaLgKrE36nP2EF6eQXcJea3OkLs0pVY/f852F5OAQ+JvkUTmCFWuUus//QY7AYJgd9sEgsW
	noGaIyDxbfIhFpA5EgKyEpsOMEPMkZQ4uOIGywRG4QWMDKsYRVMLkguKk9KLjPWKE3OLS/PS
	9ZLzczcxQgK2fwfj3QPWhxiTgcZNZJYSTc4HBnxeSbyhsZmRhamJqbGRuaUZacJK4rxqLdaB
	QgLpiSWp2ampBalF8UWlOanFhxiZODilGhi3uvMHPvPvvvloPUfbD4bJ/rPyT11aJ9q5/vWu
	J+dmXDfL6ZzgJO/EYHTbbbuW4upyvgcuD4USbHp+WKr9yS/84VV3/KKQ0sWVT/tTHN5/eSNQ
	cpF/X8ZN++wtKwtKH56alLLj5IOq+2aBqaWPVXp3VcR8uFl845v7Ug9j2xOxJnePaGxNX2Sp
	xFKckWioxVxUnAgA/kqU5W4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsVy+t9jQd23izoDDS5u1rO4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON45
	3tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2ibkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3f
	kCC4HiMDNJCwjjHjSOdJ1oLnXhWPvq5ma2C8ZtPFyMkhIWAicWztPmYIW0ziwr31bF2MXBxC
	AtMZJab86WUESQgJtDFJXNtT2MXIwcEmoC2xeb8BSFhEgFliwdTzjCD1zAITGCX+L3rPApIQ
	FnCVWNG2G2woi4CqxN+pz9hBenkF3CXmtzpC7NKVWP3/OTuIzSngIdG3aAIzxCp3ifWfHjNP
	YORdwMiwilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4Hp5J72Bc1WBxiFGAg1GJh9eCuzNQ
	iDWxrLgy9xCjBAezkghvWQFQiDclsbIqtSg/vqg0J7X4EGMy0FETmaVEk/OBsZpXEm9obGJm
	ZGlkZmFkYm5OmrCSOO/BVutAIYH0xJLU7NTUgtQimC1MHJxSDYzGq8RMOy13HZ4hN23X8SNp
	d/Svu9Xv2cs+U+4u68GCzHNtO1boFWx/X3jmhqE/2/c49q3xB7TaJQ/L8ujwfD18akuQ8TJF
	Q1EX79TNjQLLbB1fvdGM51VIDrqleMxMIdhnhfHhxKtX1D//DPtzfVbRiW65hytypb5+aPeZ
	yuO6p0m032TjvU1KLMUZiYZazEXFiQCIskmCywIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This mechanism revealed two issues: bug and performance.

Now, iput() doesn't guarantee that the inode is freed completely due to the
linked f2fs_drop_inode().
So, in the case of failure on f2fs_new_inode(), we should not add the free nid
again to the list even though iput() is called before then.

Second thing is for performance.
When allocating a free nid, we scan to find a new NID_NEW candidate, and after
allocation, we need to scan again to remove the free nid.

So, this patch resolves the issues by removing this mechanism.
Just do this with a simple basic list control.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/f2fs.h  |  2 --
 fs/f2fs/namei.c | 15 ------------
 fs/f2fs/node.c  | 76 +++++++++++++--------------------------------------------
 fs/f2fs/node.h  |  6 -----
 fs/f2fs/xattr.c |  2 --
 5 files changed, 17 insertions(+), 84 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 20aab02..2fe2567 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -956,8 +956,6 @@ struct page *get_node_page_ra(struct page *, int);
 void sync_inode_page(struct dnode_of_data *);
 int sync_node_pages(struct f2fs_sb_info *, nid_t, struct writeback_control *);
 bool alloc_nid(struct f2fs_sb_info *, nid_t *);
-void alloc_nid_done(struct f2fs_sb_info *, nid_t);
-void alloc_nid_failed(struct f2fs_sb_info *, nid_t);
 void recover_node_page(struct f2fs_sb_info *, struct page *,
 		struct f2fs_summary *, struct node_info *, block_t);
 int recover_inode_page(struct f2fs_sb_info *, struct page *);
diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 4aa26e5..077ead1 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -26,7 +26,6 @@ static struct inode *f2fs_new_inode(struct inode *dir, umode_t mode)
 	struct f2fs_sb_info *sbi = F2FS_SB(sb);
 	nid_t ino;
 	struct inode *inode;
-	bool nid_free = false;
 	int err, ilock;
 
 	inode = new_inode(sb);
@@ -60,7 +59,6 @@ static struct inode *f2fs_new_inode(struct inode *dir, umode_t mode)
 	err = insert_inode_locked(inode);
 	if (err) {
 		err = -EINVAL;
-		nid_free = true;
 		goto out;
 	}
 	trace_f2fs_new_inode(inode, 0);
@@ -73,8 +71,6 @@ out:
 fail:
 	trace_f2fs_new_inode(inode, err);
 	iput(inode);
-	if (nid_free)
-		alloc_nid_failed(sbi, ino);
 	return ERR_PTR(err);
 }
 
@@ -146,8 +142,6 @@ static int f2fs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
 	if (err)
 		goto out;
 
-	alloc_nid_done(sbi, ino);
-
 	if (!sbi->por_doing)
 		d_instantiate(dentry, inode);
 	unlock_new_inode(inode);
@@ -156,7 +150,6 @@ out:
 	clear_nlink(inode);
 	unlock_new_inode(inode);
 	iput(inode);
-	alloc_nid_failed(sbi, ino);
 	return err;
 }
 
@@ -287,8 +280,6 @@ static int f2fs_symlink(struct inode *dir, struct dentry *dentry,
 		goto out;
 
 	err = page_symlink(inode, symname, symlen);
-	alloc_nid_done(sbi, inode->i_ino);
-
 	d_instantiate(dentry, inode);
 	unlock_new_inode(inode);
 	return err;
@@ -296,7 +287,6 @@ out:
 	clear_nlink(inode);
 	unlock_new_inode(inode);
 	iput(inode);
-	alloc_nid_failed(sbi, inode->i_ino);
 	return err;
 }
 
@@ -324,8 +314,6 @@ static int f2fs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 	if (err)
 		goto out_fail;
 
-	alloc_nid_done(sbi, inode->i_ino);
-
 	d_instantiate(dentry, inode);
 	unlock_new_inode(inode);
 
@@ -336,7 +324,6 @@ out_fail:
 	clear_nlink(inode);
 	unlock_new_inode(inode);
 	iput(inode);
-	alloc_nid_failed(sbi, inode->i_ino);
 	return err;
 }
 
@@ -375,7 +362,6 @@ static int f2fs_mknod(struct inode *dir, struct dentry *dentry,
 	if (err)
 		goto out;
 
-	alloc_nid_done(sbi, inode->i_ino);
 	d_instantiate(dentry, inode);
 	unlock_new_inode(inode);
 	return 0;
@@ -383,7 +369,6 @@ out:
 	clear_nlink(inode);
 	unlock_new_inode(inode);
 	iput(inode);
-	alloc_nid_failed(sbi, inode->i_ino);
 	return err;
 }
 
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 3df43b4..fa5e8dc 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -432,13 +432,11 @@ int get_dnode_of_data(struct dnode_of_data *dn, pgoff_t index, int mode)
 			dn->nid = nids[i];
 			npage[i] = new_node_page(dn, noffset[i]);
 			if (IS_ERR(npage[i])) {
-				alloc_nid_failed(sbi, nids[i]);
 				err = PTR_ERR(npage[i]);
 				goto release_pages;
 			}
 
 			set_nid(parent, offset[i - 1], nids[i], i == 1);
-			alloc_nid_done(sbi, nids[i]);
 			done = true;
 		} else if (mode == LOOKUP_NODE_RA && i == level && level > 1) {
 			npage[i] = get_node_page_ra(parent, offset[i - 1]);
@@ -1243,10 +1241,18 @@ static struct free_nid *__lookup_free_nid_list(nid_t n, struct list_head *head)
 	return NULL;
 }
 
-static void __del_from_free_nid_list(struct free_nid *i)
+/*
+ * should be covered by free_nid_list_lock
+ */
+static void __del_from_free_nid_list(struct f2fs_nm_info *nm_i,
+						struct free_nid *i)
 {
+	if (!i)
+		return;
+
 	list_del(&i->list);
 	kmem_cache_free(free_nid_slab, i);
+	nm_i->fcnt--;
 }
 
 static int add_free_nid(struct f2fs_nm_info *nm_i, nid_t nid, bool build)
@@ -1280,7 +1286,6 @@ retry:
 		goto retry;
 	}
 	i->nid = nid;
-	i->state = NID_NEW;
 
 	spin_lock(&nm_i->free_nid_list_lock);
 	if (__lookup_free_nid_list(nid, &nm_i->free_nid_list)) {
@@ -1299,10 +1304,7 @@ static void remove_free_nid(struct f2fs_nm_info *nm_i, nid_t nid)
 	struct free_nid *i;
 	spin_lock(&nm_i->free_nid_list_lock);
 	i = __lookup_free_nid_list(nid, &nm_i->free_nid_list);
-	if (i && i->state == NID_NEW) {
-		__del_from_free_nid_list(i);
-		nm_i->fcnt--;
-	}
+	__del_from_free_nid_list(nm_i, i);
 	spin_unlock(&nm_i->free_nid_list_lock);
 }
 
@@ -1382,8 +1384,6 @@ static void build_free_nids(struct f2fs_sb_info *sbi)
 bool alloc_nid(struct f2fs_sb_info *sbi, nid_t *nid)
 {
 	struct f2fs_nm_info *nm_i = NM_I(sbi);
-	struct free_nid *i = NULL;
-	struct list_head *this;
 retry:
 	if (sbi->total_valid_node_count + 1 >= nm_i->max_nid)
 		return false;
@@ -1392,17 +1392,13 @@ retry:
 
 	/* We should not use stale free nids created by build_free_nids */
 	if (nm_i->fcnt && !sbi->on_build_free_nids) {
-		BUG_ON(list_empty(&nm_i->free_nid_list));
-		list_for_each(this, &nm_i->free_nid_list) {
-			i = list_entry(this, struct free_nid, list);
-			if (i->state == NID_NEW)
-				break;
-		}
+		struct list_head *flist = &nm_i->free_nid_list;
+		struct free_nid *i;
 
-		BUG_ON(i->state != NID_NEW);
+		BUG_ON(list_empty(flist));
+		i = list_first_entry(flist, struct free_nid, list);
 		*nid = i->nid;
-		i->state = NID_ALLOC;
-		nm_i->fcnt--;
+		__del_from_free_nid_list(nm_i, i);
 		spin_unlock(&nm_i->free_nid_list_lock);
 		return true;
 	}
@@ -1417,41 +1413,6 @@ retry:
 	goto retry;
 }
 
-/*
- * alloc_nid() should be called prior to this function.
- */
-void alloc_nid_done(struct f2fs_sb_info *sbi, nid_t nid)
-{
-	struct f2fs_nm_info *nm_i = NM_I(sbi);
-	struct free_nid *i;
-
-	spin_lock(&nm_i->free_nid_list_lock);
-	i = __lookup_free_nid_list(nid, &nm_i->free_nid_list);
-	BUG_ON(!i || i->state != NID_ALLOC);
-	__del_from_free_nid_list(i);
-	spin_unlock(&nm_i->free_nid_list_lock);
-}
-
-/*
- * alloc_nid() should be called prior to this function.
- */
-void alloc_nid_failed(struct f2fs_sb_info *sbi, nid_t nid)
-{
-	struct f2fs_nm_info *nm_i = NM_I(sbi);
-	struct free_nid *i;
-
-	spin_lock(&nm_i->free_nid_list_lock);
-	i = __lookup_free_nid_list(nid, &nm_i->free_nid_list);
-	BUG_ON(!i || i->state != NID_ALLOC);
-	if (nm_i->fcnt > 2 * MAX_FREE_NIDS) {
-		__del_from_free_nid_list(i);
-	} else {
-		i->state = NID_NEW;
-		nm_i->fcnt++;
-	}
-	spin_unlock(&nm_i->free_nid_list_lock);
-}
-
 void recover_node_page(struct f2fs_sb_info *sbi, struct page *page,
 		struct f2fs_summary *sum, struct node_info *ni,
 		block_t new_blkaddr)
@@ -1747,11 +1708,8 @@ void destroy_node_manager(struct f2fs_sb_info *sbi)
 
 	/* destroy free nid list */
 	spin_lock(&nm_i->free_nid_list_lock);
-	list_for_each_entry_safe(i, next_i, &nm_i->free_nid_list, list) {
-		BUG_ON(i->state == NID_ALLOC);
-		__del_from_free_nid_list(i);
-		nm_i->fcnt--;
-	}
+	list_for_each_entry_safe(i, next_i, &nm_i->free_nid_list, list)
+		__del_from_free_nid_list(nm_i, i);
 	BUG_ON(nm_i->fcnt);
 	spin_unlock(&nm_i->free_nid_list_lock);
 
diff --git a/fs/f2fs/node.h b/fs/f2fs/node.h
index 0a2d72f..2f226a4 100644
--- a/fs/f2fs/node.h
+++ b/fs/f2fs/node.h
@@ -74,15 +74,9 @@ static inline void node_info_from_raw_nat(struct node_info *ni,
 /*
  * For free nid mangement
  */
-enum nid_state {
-	NID_NEW,	/* newly added to free nid list */
-	NID_ALLOC	/* it is allocated */
-};
-
 struct free_nid {
 	struct list_head list;	/* for free node id list */
 	nid_t nid;		/* node id */
-	int state;		/* in use or not: NID_NEW or NID_ALLOC */
 };
 
 static inline int next_free_nid(struct f2fs_sb_info *sbi, nid_t *nid)
diff --git a/fs/f2fs/xattr.c b/fs/f2fs/xattr.c
index 0b02dce..5675920 100644
--- a/fs/f2fs/xattr.c
+++ b/fs/f2fs/xattr.c
@@ -337,13 +337,11 @@ int f2fs_setxattr(struct inode *inode, int name_index, const char *name,
 
 		page = new_node_page(&dn, XATTR_NODE_OFFSET);
 		if (IS_ERR(page)) {
-			alloc_nid_failed(sbi, fi->i_xattr_nid);
 			fi->i_xattr_nid = 0;
 			error = PTR_ERR(page);
 			goto exit;
 		}
 
-		alloc_nid_done(sbi, fi->i_xattr_nid);
 		base_addr = page_address(page);
 		header = XATTR_HDR(base_addr);
 		header->h_magic = cpu_to_le32(F2FS_XATTR_MAGIC);
-- 
1.8.1.3.566.gaa39828

