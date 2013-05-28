Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758457Ab3E1BVH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 21:21:07 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:63331 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754803Ab3E1BVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 21:21:03 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-ef-51a4067c2a5c
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 2/3] f2fs: fix dentry recovery routine
Date: Tue, 28 May 2013 10:19:44 +0900
Message-id: <1369703985-26284-2-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.1.3.566.gaa39828
In-reply-to: <1369703985-26284-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1369703985-26284-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJLMWRmVeSWpSXmKPExsVy+t8zfd0atiWBBpNms1pc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlXFs1SuWgg38FUse
	7WRpYNzM08XIwSEhYCLxcEFhFyMnkCkmceHeerYuRi4OIYFljBJbFz1mgqn59T4ZIj6dUeLq
	0VusEE4bk8SnCTeYQYrYBLQlNu83ABkkIsAssWDqeUaQGmaBCYwS/xe9ZwFJCAuYSWy/+x2s
	nkVAVeL28hqQMK+Au8SuDwdYII7QlVj9/zk7SAmngIfEgRZZkLAQUMm3G0/B1koIfGeTuLph
	CVg9i4CAxLfJh1gg7pSV2HSAGWKMpMTBFTdYJjAKL2BkWMUomlqQXFCclF5kolecmFtcmpeu
	l5yfu4kREqwTdjDeO2B9iDEZaNxEZinR5HxgsOeVxBsamxlZmJqYGhuZW5qRJqwkzqveYh0o
	JJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgZFvcYzYu33yczt9nBYteHNPx9fj+tP6+efj3qXw
	H+XfErfVa/bK6r+f/y1iC76ybVnE74i/m1bs8V2Tt5bj0/9NF1+2rtCKk1ySsCQ2uE5lY/1b
	+ZRIxxitxj01er3/z+/4cuS92oUXsn1Pa7g+/5Hy+fVXaXYK54cP9/gmrTfsnFWc5JEvEOSo
	xFKckWioxVxUnAgARenvv2wCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsVy+t9jQd0atiWBBi+eMFpc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5hxbNUrloIN/BVLHu1kaWDczNPFyMEhIWAi8et9chcjJ5ApJnHh3nq2LkYu
	DiGB6YwSV4/eYoVw2pgkPk24wQzSwCagLbF5vwFIg4gAs8SCqecZQWqYBSYwSvxf9J4FJCEs
	YCax/e53sHoWAVWJ28trQMK8Au4Suz4cYIFYpiux+v9zdpASTgEPiQMtsiBhIaCSbzeesk5g
	5F3AyLCKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzganknvYFzVYHGIUYCDUYmHd0L24kAh
	1sSy4srcQ4wSHMxKIrzbVwCFeFMSK6tSi/Lji0pzUosPMSYD3TSRWUo0OR8YqXkl8YbGJmZG
	lkZmFkYm5uakCSuJ8x5stQ4UEkhPLEnNTk0tSC2C2cLEwSnVwLgsTEItPTlhtahaquq+07+f
	X/r/duX2mOypMmqdWc6aP+MO6Ag1V31s6ZtfVlrCLZSvHbJMWvGMR6zdPNtc989TWt+IzKze
	nXE3d61XuQ7DwlDTZSuzHsWcqfxasSNX6dMGV57NGd8LYiKUy6xKGQ+7MF3Ns+z91y3EeubL
	jfypFzceZ+rWVWIpzkg01GIuKk4EAPKw3w3KAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The error scenario is:
1. create /a
(1.a link /a /b)
2. sync
3. unlinke /a
4. create /a
5. fsync /a
6. Sudden power-off

When the f2fs recovers the fsynced dentry, /a, we discover an exsiting dentry at
f2fs_find_entry() in recover_dentry().

In such the case, we should unlink the existing dentry and its inode
and then recover newly created dentry.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/recovery.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index 0dd2ce1..85f5e54 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -44,9 +44,10 @@ static int recover_dentry(struct page *ipage, struct inode *inode)
 	struct f2fs_node *raw_node = (struct f2fs_node *)kaddr;
 	struct f2fs_inode *raw_inode = &(raw_node->i);
 	nid_t pino = le32_to_cpu(raw_inode->i_pino);
+	struct f2fs_dir_entry *de;
 	struct qstr name;
 	struct page *page;
-	struct inode *dir;
+	struct inode *dir, *einode;
 	int err = 0;
 
 	dir = check_dirty_dir_inode(F2FS_SB(inode->i_sb), pino);
@@ -61,13 +62,21 @@ static int recover_dentry(struct page *ipage, struct inode *inode)
 
 	name.len = le32_to_cpu(raw_inode->i_namelen);
 	name.name = raw_inode->i_name;
-
-	if (f2fs_find_entry(dir, &name, &page)) {
-		kunmap(page);
-		f2fs_put_page(page, 0);
-	} else {
-		err = __f2fs_add_link(dir, &name, inode);
+retry:
+	de = f2fs_find_entry(dir, &name, &page);
+	if (de) {
+		einode = f2fs_iget(inode->i_sb, le32_to_cpu(de->ino));
+		if (IS_ERR(einode)) {
+			WARN_ON(1);
+			if (PTR_ERR(einode) == -ENOENT)
+				err = -EEXIST;
+			goto out;
+		}
+		f2fs_delete_entry(de, page, einode);
+		iput(einode);
+		goto retry;
 	}
+	err = __f2fs_add_link(dir, &name, inode);
 out:
 	f2fs_msg(inode->i_sb, KERN_NOTICE, "recover_inode and its dentry: "
 			"ino = %x, name = %s, dir = %lx, err = %d",
-- 
1.8.1.3.566.gaa39828

