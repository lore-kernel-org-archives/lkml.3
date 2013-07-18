Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757595Ab3GRJLo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 05:11:44 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:34862 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756100Ab3GRJLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 05:11:40 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-2d-51e7b14ba50d
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH] f2fs: update file name in the inode block during f2fs_rename
Date: Thu, 18 Jul 2013 18:11:23 +0900
Message-id: <1374138684-28520-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.3.1.437.g0dbd812
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t8zQ13vjc8DDV7sFLC4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK2PVxGnsBTcFK14u
	ucLewHiMr4uRk0NCwETi5NPLTBC2mMSFe+vZuhi5OIQEljFK7Ow/wARTtPT6SiaIxHRGiXuT
	pjFCOG1MEjvm3ALKcHCwCWhLbN5vANIgIsAssWDqebAaZoEJjBL/F71nAUkIC/hKbDs4mxXE
	ZhFQlXj35TSYzSvgLvF71UYWiG26EotOHGSFsO+zScy/aAJRLyDxbfIhFpBdEgKyEpsOMEOU
	SEocXHGDZQKj4AJGhlWMoqkFyQXFSelFhnrFibnFpXnpesn5uZsYISHYu4Px9gHrQ4zJQOMm
	MkuJJucDQzivJN7Q2MzIwtTE1NjI3NKMNGElcV61FutAIYH0xJLU7NTUgtSi+KLSnNTiQ4xM
	HJxSDYxTW2M5bj9VNV4UHeqowLyYJ8Aw+ZL9wq9iC8N2S93qaN5wh2myp2TOrVNs99QErx73
	38I6xzFFPrLTVWyFVvE7saeqvLdm74muF9e+ZLeWyYRv7t2FO5Y8nBXOWPUopfzfcdfzgsJK
	gpMkFYN8e6akm7/ivrRoQVnpszVvmDZH2ylZ8q5SCVBiKc5INNRiLipOBADMYgWEVwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsVy+t9jQV3vjc8DDU738Fhc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5ixauI09oKbghUvl1xhb2A8xtfFyMkhIWAisfT6SiYIW0ziwr31bF2MXBxC
	AtMZJe5NmsYI4bQxSeyYcwuoioODTUBbYvN+A5AGEQFmiQVTz4PVMAtMYJT4v+g9C0hCWMBX
	YtvB2awgNouAqsS7L6fBbF4Bd4nfqzayQGzTlVh04iDrBEbuBYwMqxhFUwuSC4qT0nON9IoT
	c4tL89L1kvNzNzGCQ/yZ9A7GVQ0WhxgFOBiVeHhv8DwPFGJNLCuuzD3EKMHBrCTCW24GFOJN
	SaysSi3Kjy8qzUktPsSYDLR9IrOUaHI+MP7ySuINjU3MjCyNzCyMTMzNSRNWEuc92GodKCSQ
	nliSmp2aWpBaBLOFiYNTqoGxdX5nfZzhqUNbeUwDSxQ+HZ32yjRPrjgnbHU839UlUY5e3hJF
	xba1bw0rVyd+i6+138/wpX75E5ss1c3nojwdlrbPnx2sJvlcjLe4ZurdnfargqQvCFl87dqs
	st1FePHC4DknCr2riy6Hzb5vbVW9e9/mXwerlG6Kb8pI3cp465zLlJLbpgxKLMUZiYZazEXF
	iQDlKnbZtQIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The error is reproducible by:

After this, when we retrieve the inode->i_name of test2 by dump.f2fs, we get
test1 instead of test2.
This is because f2fs didn't update the file name during the f2fs_rename.

So, this patch fixes that.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/dir.c   | 15 +++++++++++++++
 fs/f2fs/f2fs.h  |  1 +
 fs/f2fs/namei.c |  5 +++++
 3 files changed, 21 insertions(+)

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index 89ecb37..d1bb260 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -276,6 +276,21 @@ static void init_dent_inode(const struct qstr *name, struct page *ipage)
 	set_page_dirty(ipage);
 }
 
+int update_dent_inode(struct inode *inode, const struct qstr *name)
+{
+	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
+	struct page *page;
+
+	page = get_node_page(sbi, inode->i_ino);
+	if (IS_ERR(page))
+		return PTR_ERR(page);
+
+	init_dent_inode(name, page);
+	f2fs_put_page(page, 1);
+
+	return 0;
+}
+
 static int make_empty_dir(struct inode *inode,
 		struct inode *parent, struct page *page)
 {
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 2dfd584..a6858c7 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -953,6 +953,7 @@ struct f2fs_dir_entry *f2fs_parent_dir(struct inode *, struct page **);
 ino_t f2fs_inode_by_name(struct inode *, struct qstr *);
 void f2fs_set_link(struct inode *, struct f2fs_dir_entry *,
 				struct page *, struct inode *);
+int update_dent_inode(struct inode *, const struct qstr *);
 int __f2fs_add_link(struct inode *, const struct qstr *, struct inode *);
 void f2fs_delete_entry(struct f2fs_dir_entry *, struct page *, struct inode *);
 int f2fs_make_empty(struct inode *, struct inode *);
diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 64c0716..3297278 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -427,6 +427,11 @@ static int f2fs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		if (!new_entry)
 			goto out_dir;
 
+		if (update_dent_inode(old_inode, &new_dentry->d_name)) {
+			f2fs_put_page(new_page, 1);
+			goto out_dir;
+		}
+
 		f2fs_set_link(new_dir, new_entry, new_page, old_inode);
 
 		new_inode->i_ctime = CURRENT_TIME;
-- 
1.8.3.1.437.g0dbd812

