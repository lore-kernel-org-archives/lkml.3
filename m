Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab3CXXlj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 19:41:39 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:49427 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754991Ab3CXXlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 19:41:09 -0400
X-AuditID: cbfee690-b7f656d0000007e3-ff-514f8f11f4c7
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 4/4] f2fs: fix to give correct parent inode number for roll
 forward
Date: Mon, 25 Mar 2013 08:40:14 +0900
Message-id: <1364168414-12815-4-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.1.3.566.gaa39828
In-reply-to: <1364168414-12815-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1364168414-12815-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJLMWRmVeSWpSXmKPExsVy+t8zQ13Bfv9Agy+9uhbXd/1lsri0yN1i
	z96TLBaXd81hc2Dx2L3gM5NH35ZVjB6fN8kFMEdx2aSk5mSWpRbp2yVwZdzqusZesFW74t2K
	c2wNjFuUuxg5OSQETCTOzH3HBGGLSVy4t54NxBYSWMYocXFaNkzNkc437F2MXEDx6YwSBz8e
	ZIVw2pgkLl5fBNTNwcEmoC2xeb8BSIOIALPEgqnnGUFqmAUmMEr8X/SepYuRnUNYIFTiKQ9I
	CYuAqsTnG1sZQWxeAXeJd4u+QN2gK7H6/3N2kImcAh4Sf784Q5zjLtF89inYRAmB32wSN9+0
	MkLMEZD4NvkQC0i9hICsxKYDzBBjJCUOrrjBMoFReAEjwypG0dSC5ILipPQiE73ixNzi0rx0
	veT83E2MkGCdsIPx3gHrQ4zJQOMmMkuJJucDgz2vJN7Q2MzIwtTE1NjI3NKMNGElcV71FutA
	IYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYwyCukHury/3Eu46LR3v8mutSGbCw5dPZN3Mi6a
	93VU4VKevA15t/i+fevdduhXUlfF19wDe5aqGixJeZKgeWPRtK0ztUK/1q5+2/Qj+8nHVeJf
	+v22Tte8FpK76sS6xXJnJFe7qnFvn+Pzu5BZ2Tnt3M0DdZELT8yYFxS12kv5vto8vvOyf1WO
	KLEUZyQaajEXFScCADiPZ0dsAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsVy+t9jQV3Bfv9Ag2efpC2u7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8y41XWNvWCrdsW7FefYGhi3KHcxcnJICJhIHOl8ww5hi0lcuLeerYuRi0NI
	YDqjxMGPB1khnDYmiYvXFzF1MXJwsAloS2zebwDSICLALLFg6nlGkBpmgQmMEv8XvWfpYmTn
	EBYIlXjKA1LCIqAq8fnGVkYQm1fAXeLdoi9MELt0JVb/f84OMpFTwEPi7xdnkLAQUEnz2aeM
	Exh5FzAyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQIjoZnUjsYVzZYHGIU4GBU4uEVqPEP
	FGJNLCuuzD3EKMHBrCTC+6YHKMSbklhZlVqUH19UmpNafIgxGeioicxSosn5wEjNK4k3NDYx
	M7I0MrMwMjE3J01YSZz3QKt1oJBAemJJanZqakFqEcwWJg5OqQbGdafDnPh9Zj9P3Bn5X1KX
	s5lv+swzaUuWnt0lNPUny57oKyeZdu6+9uHt+ysvWJ/7ROx9q5XF9H6W42q5vf0ttp/2tyyo
	zvA5431s66zEi83JNv4/3NyXXg+blW1Y9YfxqE9QeZiNXPzFtPir9zJi6t/yqyyR0tM58zH4
	YOHpkG/7tm2uWdVxSImlOCPRUIu5qDgRADSjr7LKAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we recover fsync'ed data after power-off-recovery, we should guarantee
that any parent inode number should be correct for each direct inode blocks.

So, let's make the following rules.

- The fsync should do checkpoint to all the inodes that were experienced hard
links.

- So, the only normal files can be recovered by roll-forward.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/f2fs.h  |  2 +-
 fs/f2fs/file.c  | 22 ++--------------------
 fs/f2fs/namei.c | 14 ++++++++++----
 fs/f2fs/node.h  | 15 +++++++++++++++
 4 files changed, 28 insertions(+), 25 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 380e2b3..77e2eb0 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -148,6 +148,7 @@ struct extent_info {
  * i_advise uses FADVISE_XXX_BIT. We can add additional hints later.
  */
 #define FADVISE_COLD_BIT	0x01
+#define FADVISE_CP_BIT		0x02
 
 struct f2fs_inode_info {
 	struct inode vfs_inode;		/* serve a vfs inode */
@@ -825,7 +826,6 @@ static inline int f2fs_clear_bit(unsigned int nr, char *addr)
 /* used for f2fs_inode_info->flags */
 enum {
 	FI_NEW_INODE,		/* indicate newly allocated inode */
-	FI_NEED_CP,		/* need to do checkpoint during fsync */
 	FI_INC_LINK,		/* need to increment i_nlink */
 	FI_ACL_MODE,		/* indicate acl mode */
 	FI_NO_ALLOC,		/* should not allocate any blocks */
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index d65fcad..e031f57 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -103,23 +103,6 @@ static const struct vm_operations_struct f2fs_file_vm_ops = {
 	.remap_pages	= generic_file_remap_pages,
 };
 
-static int need_to_sync_dir(struct f2fs_sb_info *sbi, struct inode *inode)
-{
-	struct dentry *dentry;
-	nid_t pino;
-
-	inode = igrab(inode);
-	dentry = d_find_any_alias(inode);
-	if (!dentry) {
-		iput(inode);
-		return 0;
-	}
-	pino = dentry->d_parent->d_inode->i_ino;
-	dput(dentry);
-	iput(inode);
-	return !is_checkpointed_node(sbi, pino);
-}
-
 int f2fs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 {
 	struct inode *inode = file->f_mapping->host;
@@ -149,17 +132,16 @@ int f2fs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 
 	if (!S_ISREG(inode->i_mode) || inode->i_nlink != 1)
 		need_cp = true;
-	else if (is_inode_flag_set(F2FS_I(inode), FI_NEED_CP))
+	else if (is_cp_file(inode))
 		need_cp = true;
 	else if (!space_for_roll_forward(sbi))
 		need_cp = true;
-	else if (need_to_sync_dir(sbi, inode))
+	else if (!is_checkpointed_node(sbi, F2FS_I(inode)->i_pino))
 		need_cp = true;
 
 	if (need_cp) {
 		/* all the dirty node pages should be flushed for POR */
 		ret = f2fs_sync_fs(inode->i_sb, 1);
-		clear_inode_flag(F2FS_I(inode), FI_NEED_CP);
 	} else {
 		/* if there is no written node page, write its inode page */
 		while (!sync_node_pages(sbi, inode->i_ino, &wbc)) {
diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index d4a171b..7c6e219 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -15,6 +15,7 @@
 #include <linux/ctype.h>
 
 #include "f2fs.h"
+#include "node.h"
 #include "xattr.h"
 #include "acl.h"
 
@@ -99,7 +100,7 @@ static int is_multimedia_file(const unsigned char *s, const char *sub)
 /*
  * Set multimedia files as cold files for hot/cold data separation
  */
-static inline void set_cold_file(struct f2fs_sb_info *sbi, struct inode *inode,
+static inline void set_cold_files(struct f2fs_sb_info *sbi, struct inode *inode,
 		const unsigned char *name)
 {
 	int i;
@@ -108,7 +109,7 @@ static inline void set_cold_file(struct f2fs_sb_info *sbi, struct inode *inode,
 	int count = le32_to_cpu(sbi->raw_super->extension_count);
 	for (i = 0; i < count; i++) {
 		if (!is_multimedia_file(name, extlist[i])) {
-			F2FS_I(inode)->i_advise |= FADVISE_COLD_BIT;
+			set_cold_file(inode);
 			break;
 		}
 	}
@@ -130,7 +131,7 @@ static int f2fs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
 		return PTR_ERR(inode);
 
 	if (!test_opt(sbi, DISABLE_EXT_IDENTIFY))
-		set_cold_file(sbi, inode, dentry->d_name.name);
+		set_cold_files(sbi, inode, dentry->d_name.name);
 
 	inode->i_op = &f2fs_file_inode_operations;
 	inode->i_fop = &f2fs_file_operations;
@@ -173,6 +174,12 @@ static int f2fs_link(struct dentry *old_dentry, struct inode *dir,
 	if (err)
 		goto out;
 
+	/*
+	 * This file should be checkpointed during fsync.
+	 * We lost i_pino from now on.
+	 */
+	set_cp_file(inode);
+
 	d_instantiate(dentry, inode);
 	return 0;
 out:
@@ -425,7 +432,6 @@ static int f2fs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	}
 
 	old_inode->i_ctime = CURRENT_TIME;
-	set_inode_flag(F2FS_I(old_inode), FI_NEED_CP);
 	mark_inode_dirty(old_inode);
 
 	f2fs_delete_entry(old_entry, old_page, NULL);
diff --git a/fs/f2fs/node.h b/fs/f2fs/node.h
index afdb130..d009cdf 100644
--- a/fs/f2fs/node.h
+++ b/fs/f2fs/node.h
@@ -277,6 +277,21 @@ static inline int is_cold_file(struct inode *inode)
 	return F2FS_I(inode)->i_advise & FADVISE_COLD_BIT;
 }
 
+static inline void set_cold_file(struct inode *inode)
+{
+	F2FS_I(inode)->i_advise |= FADVISE_COLD_BIT;
+}
+
+static inline int is_cp_file(struct inode *inode)
+{
+	return F2FS_I(inode)->i_advise & FADVISE_CP_BIT;
+}
+
+static inline void set_cp_file(struct inode *inode)
+{
+	F2FS_I(inode)->i_advise |= FADVISE_CP_BIT;
+}
+
 static inline int is_cold_data(struct page *page)
 {
 	return PageChecked(page);
-- 
1.8.1.3.566.gaa39828

