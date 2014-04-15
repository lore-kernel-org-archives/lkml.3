Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241AbaDOK7N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 06:59:13 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:55973 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbaDOK7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 06:59:09 -0400
X-AuditID: cbfee68f-b7f156d00000276c-79-534d10fa2dd8
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 1/3] f2fs: remove costly dirty_dir_inode operations
Date: Tue, 15 Apr 2014 19:57:01 +0900
Message-id: <1397559423-27411-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t8zQ91fAr7BBq2rTSyu7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgytj78gNLwVOtiq7v
	f9kaGDcpdzFyckgImEi8fN7FAmGLSVy4t56ti5GLQ0hgGaPEoQ0HWLsYOcCKZj4WhIhPZ5Q4
	v7mbCcLpZJKYfuo1I0gRm4C2xOb9BiCDRASYJRZMPc8IUsMsMIFR4v+i92AbhAWcJd4/7GYE
	sVkEVCW+t0wHi/MKuEv8av4BdYW2xLbnE8GaJQQes0ncOPsIqkFA4tvkQywQF8lKbDrADFEv
	KXFwxQ2WCYyCCxgZVjGKphYkFxQnpRcZ6xUn5haX5qXrJefnbmKEhGD/Dsa7B6wPMSYDjZvI
	LCWanA8M4bySeENjMyMLUxNTYyNzSzPShJXEee8/TAoSEkhPLEnNTk0tSC2KLyrNSS0+xMjE
	wSnVwFjuqaM/w/TPP/1bX6KPT5lzsWPpxzvBO8QP1P6UXSTVllCTMSd5XwPDupt/VnZ47Lqy
	ykeXceKNYpGgELGrvD4xXrP33ZcVT9It/Fs+j8F78zelJcYp7H6fFcJXrHE22Z6sc7H9wyJb
	l9ZrIi82RuhYffSMWfcvULxN7vGGUCGe1J27Wdgnv1BiKc5INNRiLipOBADxtqVjVwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t9jQd1fAr7BBjN26ltc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5ix9+UHloKnWhVd3/+yNTBuUu5i5OCQEDCRmPlYsIuRE8gUk7hwbz1bFyMX
	h5DAdEaJ85u7mSCcTiaJ6adeM4I0sAloS2zebwDSICLALLFg6nlGkBpmgQmMEv8XvWcBSQgL
	OEu8f9jNCGKzCKhKfG+ZDhbnFXCX+NX8gwVim7bEtucTGScwci9gZFjFKJpakFxQnJSea6RX
	nJhbXJqXrpecn7uJERzgz6R3MK5qsDjEKMDBqMTDO+Gdd7AQa2JZcWXuIUYJDmYlEd6P3L7B
	QrwpiZVVqUX58UWlOanFhxiTgbZPZJYSTc4HRl9eSbyhsYmZkaWRmYWRibk5acJK4rwHW60D
	hQTSE0tSs1NTC1KLYLYwcXBKNTCaaadtOTZd+Y1VfFUCc4OOurLLvJsz1y0xi4jkzc/zufhL
	VPFJCv/fg2t2PFx95Ov6XdoqF941372dv/PTq6/rL/oJBDSWGnxyV5aombu+frXLvaRd63/e
	nLF057nl/NcvsbrtlLV4E8Ov5nJ6vQw7j3+V5neNZ7zP+b2TdeaXJ1dJbzn0d+17JZbijERD
	Leai4kQA0M8HxrQCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes list opeations in handling dirty dir inodes.
Previously, F2FS traverses whole the list of dirty dir inodes to check whether
there is an existing inode or not, resulting in heavy CPU overheads.

So this patch removes such the traverse operations by adding FI_DIRTY_DIR to
indicate the inode lies on the list or not.
Through this simple flag, we can remove redundant operations gracefully.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/checkpoint.c | 52 +++++++++++++---------------------------------------
 fs/f2fs/f2fs.h       |  3 ++-
 fs/f2fs/recovery.c   | 18 ++++++++++--------
 3 files changed, 25 insertions(+), 48 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 890e23d..5133aec 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -555,14 +555,13 @@ fail_no_cp:
 static int __add_dirty_inode(struct inode *inode, struct dir_inode_entry *new)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
-	struct list_head *head = &sbi->dir_inode_list;
-	struct dir_inode_entry *entry;
 
-	list_for_each_entry(entry, head, list)
-		if (unlikely(entry->inode == inode))
-			return -EEXIST;
+	if (is_inode_flag_set(F2FS_I(inode), FI_DIRTY_DIR))
+		return -EEXIST;
 
-	list_add_tail(&new->list, head);
+	set_inode_flag(F2FS_I(inode), FI_DIRTY_DIR);
+	F2FS_I(inode)->dirty_dir = new;
+	list_add_tail(&new->list, &sbi->dir_inode_list);
 	stat_inc_dirty_dir(sbi);
 	return 0;
 }
@@ -611,31 +610,26 @@ void add_dirty_dir_inode(struct inode *inode)
 void remove_dirty_dir_inode(struct inode *inode)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
-	struct list_head *head;
 	struct dir_inode_entry *entry;
 
 	if (!S_ISDIR(inode->i_mode))
 		return;
 
 	spin_lock(&sbi->dir_inode_lock);
-	if (get_dirty_dents(inode)) {
+	if (get_dirty_dents(inode) ||
+			!is_inode_flag_set(F2FS_I(inode), FI_DIRTY_DIR)) {
 		spin_unlock(&sbi->dir_inode_lock);
 		return;
 	}
 
-	head = &sbi->dir_inode_list;
-	list_for_each_entry(entry, head, list) {
-		if (entry->inode == inode) {
-			list_del(&entry->list);
-			stat_dec_dirty_dir(sbi);
-			spin_unlock(&sbi->dir_inode_lock);
-			kmem_cache_free(inode_entry_slab, entry);
-			goto done;
-		}
-	}
+	entry = F2FS_I(inode)->dirty_dir;
+	list_del(&entry->list);
+	F2FS_I(inode)->dirty_dir = NULL;
+	clear_inode_flag(F2FS_I(inode), FI_DIRTY_DIR);
+	stat_dec_dirty_dir(sbi);
 	spin_unlock(&sbi->dir_inode_lock);
+	kmem_cache_free(inode_entry_slab, entry);
 
-done:
 	/* Only from the recovery routine */
 	if (is_inode_flag_set(F2FS_I(inode), FI_DELAY_IPUT)) {
 		clear_inode_flag(F2FS_I(inode), FI_DELAY_IPUT);
@@ -643,26 +637,6 @@ done:
 	}
 }
 
-struct inode *check_dirty_dir_inode(struct f2fs_sb_info *sbi, nid_t ino)
-{
-
-	struct list_head *head;
-	struct inode *inode = NULL;
-	struct dir_inode_entry *entry;
-
-	spin_lock(&sbi->dir_inode_lock);
-
-	head = &sbi->dir_inode_list;
-	list_for_each_entry(entry, head, list) {
-		if (entry->inode->i_ino == ino) {
-			inode = entry->inode;
-			break;
-		}
-	}
-	spin_unlock(&sbi->dir_inode_lock);
-	return inode;
-}
-
 void sync_dirty_dir_inodes(struct f2fs_sb_info *sbi)
 {
 	struct list_head *head;
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 2c5a5da..d3180f8 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -218,6 +218,7 @@ struct f2fs_inode_info {
 	nid_t i_xattr_nid;		/* node id that contains xattrs */
 	unsigned long long xattr_ver;	/* cp version of xattr modification */
 	struct extent_info ext;		/* in-memory extent cache entry */
+	struct dir_inode_entry *dirty_dir;	/* the pointer of dirty dir */
 };
 
 static inline void get_extent_info(struct extent_info *ext,
@@ -958,6 +959,7 @@ static inline int f2fs_clear_bit(unsigned int nr, char *addr)
 enum {
 	FI_NEW_INODE,		/* indicate newly allocated inode */
 	FI_DIRTY_INODE,		/* indicate inode is dirty or not */
+	FI_DIRTY_DIR,		/* indicate directory has dirty pages */
 	FI_INC_LINK,		/* need to increment i_nlink */
 	FI_ACL_MODE,		/* indicate acl mode */
 	FI_NO_ALLOC,		/* should not allocate any blocks */
@@ -1222,7 +1224,6 @@ int get_valid_checkpoint(struct f2fs_sb_info *);
 void set_dirty_dir_page(struct inode *, struct page *);
 void add_dirty_dir_inode(struct inode *);
 void remove_dirty_dir_inode(struct inode *);
-struct inode *check_dirty_dir_inode(struct f2fs_sb_info *, nid_t);
 void sync_dirty_dir_inodes(struct f2fs_sb_info *);
 void write_checkpoint(struct f2fs_sb_info *, bool);
 void init_orphan_info(struct f2fs_sb_info *);
diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index b1ae89f..9eb6487 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -46,15 +46,17 @@ static int recover_dentry(struct page *ipage, struct inode *inode)
 	struct inode *dir, *einode;
 	int err = 0;
 
-	dir = check_dirty_dir_inode(F2FS_SB(inode->i_sb), pino);
-	if (!dir) {
-		dir = f2fs_iget(inode->i_sb, pino);
-		if (IS_ERR(dir)) {
-			err = PTR_ERR(dir);
-			goto out;
-		}
-		set_inode_flag(F2FS_I(dir), FI_DELAY_IPUT);
+	dir = f2fs_iget(inode->i_sb, pino);
+	if (IS_ERR(dir)) {
+		err = PTR_ERR(dir);
+		goto out;
+	}
+
+	if (is_inode_flag_set(F2FS_I(dir), FI_DIRTY_DIR)) {
+		iput(dir);
+	} else {
 		add_dirty_dir_inode(dir);
+		set_inode_flag(F2FS_I(dir), FI_DELAY_IPUT);
 	}
 
 	name.len = le32_to_cpu(raw_inode->i_namelen);
-- 
1.8.4.474.g128a96c

