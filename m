Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390Ab3L0EC3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 23:02:29 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:62327 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210Ab3L0EBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 23:01:47 -0500
X-AuditID: cbfee691-b7efc6d0000039d3-96-52bcfb9ea542
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 6/6] f2fs: add inline_data recovery routine
Date: Fri, 27 Dec 2013 13:00:20 +0900
Message-id: <1388116820-15038-6-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
In-reply-to: <1388116820-15038-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1388116820-15038-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsVy+t8zY915v/cEGUw8KWFxfddfJotLi9wt
	9uw9yWJxedccNgcWj90LPjN59G1ZxejxeZNcAHMUl01Kak5mWWqRvl0CV8bMS0IFe7Urps2a
	ydbA2KPcxcjJISFgIvHg6AUWCFtM4sK99WxdjFwcQgLLGCUO7tvDBlO088sLVojEdEaJ3u1r
	2UESQgLNTBJtM3m7GDk42AS0JTbvNwAJiwgwSyyYep4RpJ5ZYAKjxP9F78E2CAtYS3Rv/s8M
	YrMIqErM/buUEcTmFXCXWH7rIDPEMm2Jbc8ngsU5BTwk2n/eh9rlLvF1/UEmkKESAr/ZJFaf
	m8gCMUhA4tvkQywgR0gIyEpsOgA1R1Li4IobLBMYhRcwMqxiFE0tSC4oTkovMtUrTswtLs1L
	10vOz93ECAnYiTsY7x+wPsSYDDRuIrOUaHI+MODzSuINjc2MLExNTI2NzC3NSBNWEudNf5QU
	JCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoFx94W7i2M2Xwp6EiAit6WqYc9/8x/pHLGtHySN
	br96tePItXkM9c17lXsLjCs6mdxeuoWsyl77bfveHHGtFTd+XrO5y33v1JrLc0X2WSn8bAi8
	1e2jvWRBSsW9KVLuG719FWMeFb3W+TbB+GWl5HyBOHvGHd+7Z6xoYGe4dVxsl88r7yiLnJtK
	SizFGYmGWsxFxYkAMEUz/24CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsVy+t9jQd15v/cEGUzdJWJxfddfJotLi9wt
	9uw9yWJxedccNgcWj90LPjN59G1ZxejxeZNcAHNUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxz
	vKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtA2JYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+
	IUFwPUYGaCBhHWPGzEtCBXu1K6bNmsnWwNij3MXIySEhYCKx88sLVghbTOLCvfVsXYxcHEIC
	0xklerevZQdJCAk0M0m0zeTtYuTgYBPQlti83wAkLCLALLFg6nlGkHpmgQmMEv8XvWcBSQgL
	WEt0b/7PDGKzCKhKzP27lBHE5hVwl1h+6yAzxDJtiW3PJ4LFOQU8JNp/3ofa5S7xdf1BpgmM
	vAsYGVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBMfDM+kdjKsaLA4xCnAwKvHwOmzYEyTE
	mlhWXJl7iFGCg1lJhPfzFaAQb0piZVVqUX58UWlOavEhxmSgqyYyS4km5wNjNa8k3tDYxMzI
	0sjMwsjE3Jw0YSVx3oOt1oFCAumJJanZqakFqUUwW5g4OKUaGIV+7Ctvd9p4ZZXk49YPur/9
	E20EPon13txn7D15gfrLbSWzBL5+Vvc2e6js3ysfXXq4yWLWIfZ/jDWVqxbkHLh9a/r1uf4q
	F1/FHp0qIhYUynZiOcONZzVmAnMPSYavXfzh3ivxSWXX/0XxsXgHM2rujK2IqbKdxJvW2Gk5
	b9d9rt0Mgt+aHiqxFGckGmoxFxUnAgD0FP8+ywIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a inline_data recovery routine with the following policy.

[prev.] [next] of inline_data flag
   o       o  -> recover inline_data
   o       x  -> remove inline_data, and then recover data blocks
   x       o  -> remove inline_data, and then recover inline_data
   x       x  -> recover data blocks

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/f2fs.h          |  2 ++
 fs/f2fs/file.c          |  2 +-
 fs/f2fs/inline.c        | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/f2fs/recovery.c      |  8 ++++++--
 include/linux/f2fs_fs.h |  3 +--
 5 files changed, 58 insertions(+), 5 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index ef4073f..6991a28 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1010,6 +1010,7 @@ static inline int f2fs_readonly(struct super_block *sb)
  */
 int f2fs_sync_file(struct file *, loff_t, loff_t, int);
 void truncate_data_blocks(struct dnode_of_data *);
+int truncate_blocks(struct inode *, u64);
 void f2fs_truncate(struct inode *);
 int f2fs_getattr(struct vfsmount *, struct dentry *, struct kstat *);
 int f2fs_setattr(struct dentry *, struct iattr *);
@@ -1318,4 +1319,5 @@ bool f2fs_may_inline(struct inode *);
 int f2fs_read_inline_data(struct inode *, struct page *);
 int f2fs_convert_inline_data(struct inode *, pgoff_t);
 int f2fs_write_inline_data(struct inode *, struct page *, unsigned int);
+int recover_inline_data(struct inode *, struct page *);
 #endif
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 68dd7bf..c77ad4d 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -251,7 +251,7 @@ static void truncate_partial_data_page(struct inode *inode, u64 from)
 	f2fs_put_page(page, 1);
 }
 
-static int truncate_blocks(struct inode *inode, u64 from)
+int truncate_blocks(struct inode *inode, u64 from)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
 	unsigned int blocksize = inode->i_sb->s_blocksize;
diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index 048f601..0e940ce 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -174,3 +174,51 @@ int f2fs_write_inline_data(struct inode *inode,
 
 	return 0;
 }
+
+int recover_inline_data(struct inode *inode, struct page *npage)
+{
+	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
+	struct f2fs_inode *ri = NULL;
+	void *src_addr, *dst_addr;
+	struct page *ipage;
+
+	/*
+	 * The inline_data recovery policy is as follows.
+	 * [prev.] [next] of inline_data flag
+	 *    o       o  -> recover inline_data
+	 *    o       x  -> remove inline_data, and then recover data blocks
+	 *    x       o  -> remove inline_data, and then recover inline_data
+	 *    x       x  -> recover data blocks
+	 */
+	if (IS_INODE(npage))
+		ri = F2FS_INODE(npage);
+
+	if (f2fs_has_inline_data(inode) &&
+			ri && ri->i_inline & F2FS_INLINE_DATA) {
+process_inline:
+		ipage = get_node_page(sbi, inode->i_ino);
+		f2fs_bug_on(IS_ERR(ipage));
+
+		src_addr = inline_data_addr(npage);
+		dst_addr = inline_data_addr(ipage);
+		memcpy(dst_addr, src_addr, MAX_INLINE_DATA);
+		update_inode(inode, ipage);
+		f2fs_put_page(ipage, 1);
+		return -1;
+	}
+
+	if (f2fs_has_inline_data(inode)) {
+		ipage = get_node_page(sbi, inode->i_ino);
+		f2fs_bug_on(IS_ERR(ipage));
+		zero_user_segment(ipage, INLINE_DATA_OFFSET,
+				 INLINE_DATA_OFFSET + MAX_INLINE_DATA);
+		clear_inode_flag(F2FS_I(inode), FI_INLINE_DATA);
+		update_inode(inode, ipage);
+		f2fs_put_page(ipage, 1);
+	} else if (ri && ri->i_inline & F2FS_INLINE_DATA) {
+		truncate_blocks(inode, 0);
+		set_inode_flag(F2FS_I(inode), FI_INLINE_DATA);
+		goto process_inline;
+	}
+	return 0;
+}
diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index 96e690b6..655791e 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -298,6 +298,9 @@ static int do_recover_data(struct f2fs_sb_info *sbi, struct inode *inode,
 	struct node_info ni;
 	int err = 0, recovered = 0;
 
+	if (recover_inline_data(inode, page))
+		goto out;
+
 	start = start_bidx_of_node(ofs_of_node(page), fi);
 	if (IS_INODE(page))
 		end = start + ADDRS_PER_INODE(fi);
@@ -305,12 +308,13 @@ static int do_recover_data(struct f2fs_sb_info *sbi, struct inode *inode,
 		end = start + ADDRS_PER_BLOCK;
 
 	f2fs_lock_op(sbi);
+
 	set_new_dnode(&dn, inode, NULL, NULL, 0);
 
 	err = get_dnode_of_data(&dn, start, ALLOC_NODE);
 	if (err) {
 		f2fs_unlock_op(sbi);
-		return err;
+		goto out;
 	}
 
 	wait_on_page_writeback(dn.node_page);
@@ -361,7 +365,7 @@ static int do_recover_data(struct f2fs_sb_info *sbi, struct inode *inode,
 err:
 	f2fs_put_dnode(&dn);
 	f2fs_unlock_op(sbi);
-
+out:
 	f2fs_msg(sbi->sb, KERN_NOTICE, "recover_data: ino = %lx, "
 			"recovered_data = %d blocks, err = %d",
 			inode->i_ino, recovered, err);
diff --git a/include/linux/f2fs_fs.h b/include/linux/f2fs_fs.h
index aea5eed..da74d87 100644
--- a/include/linux/f2fs_fs.h
+++ b/include/linux/f2fs_fs.h
@@ -155,12 +155,11 @@ struct f2fs_extent {
 #define F2FS_INLINE_XATTR	0x01	/* file inline xattr flag */
 #define F2FS_INLINE_DATA	0x02	/* file inline data flag */
 
-
 #define MAX_INLINE_DATA		(sizeof(__le32) * (DEF_ADDRS_PER_INODE - \
 						F2FS_INLINE_XATTR_ADDRS - 1))
 
 #define INLINE_DATA_OFFSET	(PAGE_CACHE_SIZE - sizeof(struct node_footer) \
-				- sizeof(__le32)*(DEF_ADDRS_PER_INODE + 5 - 1))
+			- sizeof(__le32) * (DEF_ADDRS_PER_INODE + 5 - 1))
 
 struct f2fs_inode {
 	__le16 i_mode;			/* file mode */
-- 
1.8.4.474.g128a96c

