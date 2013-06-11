Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab3FKG44 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 02:56:56 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:30231 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907Ab3FKG4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 02:56:54 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-b0-51b6ca36eafc
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH] f2fs: avoid freqeunt write_inode calls
Date: Tue, 11 Jun 2013 15:55:34 +0900
Message-id: <1370933734-343-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.1.3.566.gaa39828
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t8zI12zU9sCDQ4uYrO4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK+N/5y7Ggu9iFSva
	zzI3MD4T6mLk5JAQMJE4+/0nG4QtJnHh3nogm4tDSGAZo8Sp9m4mmKKTRxcyQyQWMUp0zD4J
	1iEk0MYk8f6PYxcjBwebgLbE5v0GIGERAWaJBVPPM4LUMwtMYJT4v+g9C0hCWMBcYtLyP8wg
	NouAqsT1hivsIDavgKvEw23nWSCW6Uqs/v+cHaRZQuAxm8Sxu/tYIBoEJL5NPsQCskxCQFZi
	0wFmiHpJiYMrbrBMYBRcwMiwilE0tSC5oDgpvchQrzgxt7g0L10vOT93EyMkBHt3MN4+YH2I
	MRlo3ERmKdHkfGAI55XEGxqbGVmYmpgaG5lbmpEmrCTOq9ZiHSgkkJ5YkpqdmlqQWhRfVJqT
	WnyIkYmDU6qB8YLIXs6kc+HXvu5c9/PJG0nOIh4j3XLNd0vNJSZOdb3GrqbPp35/I7PbdPa8
	20wmFq1JyWc2Va5a9HJas8mlg996O0+e0z2QdFyJTWzdIZGlTXVH+rz9S1Qnsn33/MFhdEJJ
	vfagjcPayWyO4vfWpZokPjvdUrF9I5+acZyY0PL4/Q8uPdY7qcRSnJFoqMVcVJwIAEdqy/tX	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t9jAV2zU9sCDc5MYrS4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON45
	3tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2ibkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3f
	kCC4HiMDNJCwjjHjf+cuxoLvYhUr2s8yNzA+E+pi5OSQEDCROHl0ITOELSZx4d56ti5GLg4h
	gUWMEh2zT7KBJIQE2pgk3v9x7GLk4GAT0JbYvN8AJCwiwCyxYOp5RpB6ZoEJjBL/F71nAUkI
	C5hLTFr+B2woi4CqxPWGK+wgNq+Aq8TDbedZIJbpSqz+/5x9AiP3AkaGVYyiqQXJBcVJ6bmG
	esWJucWleel6yfm5mxjBAf5MagfjygaLQ4wCHIxKPLwJjNsChVgTy4orcw8xSnAwK4nwmm4H
	CvGmJFZWpRblxxeV5qQWH2JMBto+kVlKNDkfGH15JfGGxiZmRpZGZhZGJubmpAkrifMeaLUO
	FBJITyxJzU5NLUgtgtnCxMEp1cDoV+myf8oeHf8lm2Wr1hin3OZa1tiet7ZJY4/jp3enpmhr
	Zm2obexh9uvZ+fXjhC4OpedqP1cumdUcePIgR43pvp85y9gmbpHes+jBPNuWnDS+vb8vqb1l
	c+q1yHl7kGMf/9IAZmGhq7/1eqRdTnS43UjgfS7fvmP6/f380udb0jPmMWtuu5ypxFKckWio
	xVxUnAgAi4TE1bQCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If update_inode is called, we don't need to do write_inode.
So, let's use a *dirty* flag for each inode.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/f2fs.h  |  1 +
 fs/f2fs/file.c  |  1 +
 fs/f2fs/inode.c |  4 ++++
 fs/f2fs/super.c | 12 ++++++++++++
 4 files changed, 18 insertions(+)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 27edf59..a05aa65 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -856,6 +856,7 @@ static inline int f2fs_clear_bit(unsigned int nr, char *addr)
 /* used for f2fs_inode_info->flags */
 enum {
 	FI_NEW_INODE,		/* indicate newly allocated inode */
+	FI_DIRTY_INODE,		/* indicate inode is dirty or not */
 	FI_INC_LINK,		/* need to increment i_nlink */
 	FI_ACL_MODE,		/* indicate acl mode */
 	FI_NO_ALLOC,		/* should not allocate any blocks */
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 2f649b8..fda226f 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -147,6 +147,7 @@ int f2fs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	} else {
 		/* if there is no written node page, write its inode page */
 		while (!sync_node_pages(sbi, inode->i_ino, &wbc)) {
+			mark_inode_dirty_sync(inode);
 			ret = f2fs_write_inode(inode, NULL);
 			if (ret)
 				goto out;
diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index b44a4c1..2b2d45d1 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -192,6 +192,7 @@ void update_inode(struct inode *inode, struct page *node_page)
 
 	set_cold_node(inode, node_page);
 	set_page_dirty(node_page);
+	clear_inode_flag(F2FS_I(inode), FI_DIRTY_INODE);
 }
 
 int update_inode_page(struct inode *inode)
@@ -217,6 +218,9 @@ int f2fs_write_inode(struct inode *inode, struct writeback_control *wbc)
 			inode->i_ino == F2FS_META_INO(sbi))
 		return 0;
 
+	if (!is_inode_flag_set(F2FS_I(inode), FI_DIRTY_INODE))
+		return 0;
+
 	if (wbc)
 		f2fs_balance_fs(sbi);
 
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 4fdcdff..49ce011 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -112,6 +112,17 @@ static int f2fs_drop_inode(struct inode *inode)
 	return generic_drop_inode(inode);
 }
 
+/*
+ * f2fs_dirty_inode() is called from __mark_inode_dirty()
+ *
+ * We should call set_dirty_inode to write the dirty inode through write_inode.
+ */
+void f2fs_dirty_inode(struct inode *inode, int flags)
+{
+	set_inode_flag(F2FS_I(inode), FI_DIRTY_INODE);
+	return;
+}
+
 static void f2fs_i_callback(struct rcu_head *head)
 {
 	struct inode *inode = container_of(head, struct inode, i_rcu);
@@ -249,6 +260,7 @@ static struct super_operations f2fs_sops = {
 	.drop_inode	= f2fs_drop_inode,
 	.destroy_inode	= f2fs_destroy_inode,
 	.write_inode	= f2fs_write_inode,
+	.dirty_inode	= f2fs_dirty_inode,
 	.show_options	= f2fs_show_options,
 	.evict_inode	= f2fs_evict_inode,
 	.put_super	= f2fs_put_super,
-- 
1.8.1.3.566.gaa39828

