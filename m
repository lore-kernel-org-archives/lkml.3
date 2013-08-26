Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761Ab3HZLRR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 07:17:17 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:64107 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab3HZLQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 07:16:53 -0400
X-AuditID: cbfee68e-b7f756d000004512-6a-521b392082a4
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 4/5] f2fs: add the truncate_xattr_node function
Date: Mon, 26 Aug 2013 20:16:40 +0900
Message-id: <1377515801-15243-4-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.3.1.437.g0dbd812
In-reply-to: <1377515801-15243-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1377515801-15243-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsVy+t8zY10FS+kggxMn1Cyu7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgyvgx4Qh7wTLhioPH
	jzE1MD7i72Lk5JAQMJFYtfgrM4QtJnHh3nq2LkYuDiGBZYwSkxbsYIQp6ujvYYFITGeUuH70
	LTOE08YkseH8KSCHg4NNQFti834DkAYRAWaJBVPPM4LUMAtMYJT4v+g9C0hCWMBe4sKqSUwg
	NouAqsTtpkesIDavgLvEm03foM7QlVh04iBYnFPAQ6Lj1Q12EFsIqObi3MtgV0gIfGeTePXh
	GBvEIAGJb5MPsYAcISEgK7HpANQcSYmDK26wTGAUXsDIsIpRNLUguaA4Kb3ISK84Mbe4NC9d
	Lzk/dxMjJGj7djDePGB9iDEZaNxEZinR5Hxg0OeVxBsamxlZmJqYGhuZW5qRJqwkzqvWYh0o
	JJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgbHyt72AoPFG7lDeMxUf/jAUVt4U1Ki9etTCY8Es
	iZDK/2u5ry38c3pnVoeP2pIJE/9sWy9zVIPn1EyOm5KR24939Mfx5EREpKW05PQFGJ9/3FSV
	Zfra3qlpYpUhe+3ftdPUikSEbkuuy3NwK35ztWEfx6P0NQ/8dtwwfPiQR1Xhtd2FrNhtBUos
	xRmJhlrMRcWJANkpmOhwAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsVy+t9jQV0FS+kgg0/vlCyu7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8z4MeEIe8Ey4YqDx48xNTA+4u9i5OSQEDCR6OjvYYGwxSQu3FvP1sXIxSEk
	MJ1R4vrRt8wQThuTxIbzp4AcDg42AW2JzfsNQBpEBJglFkw9zwhSwywwgVHi/6L3YJOEBewl
	LqyaxARiswioStxuesQKYvMKuEu82fSNGWKbrsSiEwfB4pwCHhIdr26wg9hCQDUX515mmcDI
	u4CRYRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcEw8k97BuKrB4hCjAAejEg9vAJt0kBBr
	YllxZe4hRgkOZiURXnNRoBBvSmJlVWpRfnxRaU5q8SHGZKCrJjJLiSbnA+M1ryTe0NjEzMjS
	yMzCyMTcnDRhJXHeg63WgUIC6YklqdmpqQWpRTBbmDg4pRoYo17dPccrUtsw5aPbqt75e3vz
	uKLv2bJY8p+YWyL2cs8T9SNbeU/PPn7j5etJhczSXJkhqxXYtO/zSvxsuL9U8b6laJXZWu3n
	MVMj/mvUvDtRtkzC5M45712MYj7KX5vuJPzjCVzR7cUsLvL6fJO9/iyftKsK0xav3fjgybJH
	W21uHZHSV2HLUWIpzkg01GIuKk4EAGYgxm7NAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The truncate_xattr_node function will be used by inline xattr.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/f2fs.h |  1 +
 fs/f2fs/node.c | 39 ++++++++++++++++++++++++++++-----------
 2 files changed, 29 insertions(+), 11 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 0343759..0fe9302 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1016,6 +1016,7 @@ int is_checkpointed_node(struct f2fs_sb_info *, nid_t);
 void get_node_info(struct f2fs_sb_info *, nid_t, struct node_info *);
 int get_dnode_of_data(struct dnode_of_data *, pgoff_t, int);
 int truncate_inode_blocks(struct inode *, pgoff_t);
+int truncate_xattr_node(struct inode *, struct page *);
 int remove_inode_page(struct inode *);
 struct page *new_inode_page(struct inode *, const struct qstr *);
 struct page *new_node_page(struct dnode_of_data *, unsigned int, struct page *);
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index f0e733b..2a464a7 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -772,6 +772,29 @@ fail:
 	return err > 0 ? 0 : err;
 }
 
+int truncate_xattr_node(struct inode *inode, struct page *page)
+{
+	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
+	nid_t nid = F2FS_I(inode)->i_xattr_nid;
+	struct dnode_of_data dn;
+	struct page *npage;
+
+	if (!nid)
+		return 0;
+
+	npage = get_node_page(sbi, nid);
+	if (IS_ERR(npage))
+		return PTR_ERR(npage);
+
+	F2FS_I(inode)->i_xattr_nid = 0;
+	set_new_dnode(&dn, inode, page, npage, nid);
+
+	if (page)
+		dn.inode_page_locked = 1;
+	truncate_node(&dn);
+	return 0;
+}
+
 /*
  * Caller should grab and release a mutex by calling mutex_lock_op() and
  * mutex_unlock_op().
@@ -782,22 +805,16 @@ int remove_inode_page(struct inode *inode)
 	struct page *page;
 	nid_t ino = inode->i_ino;
 	struct dnode_of_data dn;
+	int err;
 
 	page = get_node_page(sbi, ino);
 	if (IS_ERR(page))
 		return PTR_ERR(page);
 
-	if (F2FS_I(inode)->i_xattr_nid) {
-		nid_t nid = F2FS_I(inode)->i_xattr_nid;
-		struct page *npage = get_node_page(sbi, nid);
-
-		if (IS_ERR(npage))
-			return PTR_ERR(npage);
-
-		F2FS_I(inode)->i_xattr_nid = 0;
-		set_new_dnode(&dn, inode, page, npage, nid);
-		dn.inode_page_locked = 1;
-		truncate_node(&dn);
+	err = truncate_xattr_node(inode, page);
+	if (err) {
+		f2fs_put_page(page, 1);
+		return err;
 	}
 
 	/* 0 is possible, after f2fs_new_inode() is failed */
-- 
1.8.3.1.437.g0dbd812

