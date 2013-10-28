Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523Ab3J1FIL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 01:08:11 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:61442 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab3J1FIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 01:08:09 -0400
X-AuditID: cbfee68f-b7f836d000001b39-22-526df138e2cc
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 1/2] f2fs: clean up acl flow for better readability
Date: Mon, 28 Oct 2013 14:07:25 +0900
Message-id: <1382936846-4860-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsVy+t8zI12Lj7lBBhue81lc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlXF7532mgm3CFc+2
	rGNpYHzG38XIySEhYCKxoLmXDcIWk7hwbz2QzcUhJLCMUeLks8VsMEXvVhxkhkhMZ5ToW/uZ
	BcJpZpJY1H6asYuRg4NNQFti834DkAYRAWaJBVPPM4LUMAtMYJT4v+g9C0hCWMBZ4uPOa0wg
	NouAqsSs97cYQWxeATeJ4zc3sUNs05bY9nwiWLOEwGM2iYP/jjJCNAhIfJt8iAVkmYSArMSm
	A8wQ9ZISB1fcYJnAKLiAkWEVo2hqQXJBcVJ6kbFecWJucWleul5yfu4mRkgQ9u9gvHvA+hBj
	MtC4icxSosn5wCDOK4k3NDYzsjA1MTU2Mrc0I01YSZz3/sOkICGB9MSS1OzU1ILUovii0pzU
	4kOMTBycUg2M1ayrvkw77vWSU/7h3Q4Fh8iiOTx7YnUnP0+yMGk2PRqkaquwLuyZ/rvrr4Ly
	n0k/ZLqhnPfc7dXd9e5e2hpdsd++73jeHxzPPivg+qqL/CKT1grPcpAtXHg198XJNK5rBpFF
	Pmv2ff7sYrO7ovO3NNffJRVs++YL3dPzfX7hruBJ1uqby/lElFiKMxINtZiLihMB8YkqflgC	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsVy+t9jQV2Lj7lBBu0N3BbXd/1lsri0yN1i
	z96TLBaXd81hc2Dx2L3gM5NH35ZVjB6fN8kFMEc1MNpkpCampBYppOYl56dk5qXbKnkHxzvH
	m5oZGOoaWlqYKynkJeam2iq5+AToumXmAG1TUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesb
	EgTXY2SABhLWMWbc3nmfqWCbcMWzLetYGhif8XcxcnJICJhIvFtxkBnCFpO4cG89WxcjF4eQ
	wHRGib61n1kgnGYmiUXtpxm7GDk42AS0JTbvNwBpEBFgllgw9TwjSA2zwARGif+L3rOAJIQF
	nCU+7rzGBGKzCKhKzHp/ixHE5hVwkzh+cxM7xDZtiW3PJzJOYORewMiwilE0tSC5oDgpPddI
	rzgxt7g0L10vOT93EyM4xJ9J72Bc1WBxiFGAg1GJh3fD2twgIdbEsuLK3EOMEhzMSiK8fbeA
	QrwpiZVVqUX58UWlOanFhxiTgbZPZJYSTc4Hxl9eSbyhsYmZkaWRmYWRibk5acJK4rwHW60D
	hQTSE0tSs1NTC1KLYLYwcXBKNTDWijVdubZ87nO7FXJnU6q2vuhSZa3cx8i1Q/zNrpI9F8IF
	J146LxdbO8nNxtw34F5QTGB1os/vN60/+besf7Thb/q3Ww4l693Ph4X+a18UG8iwvjzgzqK5
	bhb7hEybMnNkuR9nzcn9Ondb67afBz5u9be/8v8ww/JNlgHqHkzKq56xevReEfNQYinOSDTU
	Yi4qTgQAfAx4+7UCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleans up a couple of acl codes.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/acl.c | 25 +++++++++++++------------
 fs/f2fs/acl.h |  6 +++---
 2 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/fs/f2fs/acl.c b/fs/f2fs/acl.c
index b7826ec..f1a6975 100644
--- a/fs/f2fs/acl.c
+++ b/fs/f2fs/acl.c
@@ -262,8 +262,8 @@ static int f2fs_set_acl(struct inode *inode, int type, struct posix_acl *acl)
 
 int f2fs_init_acl(struct inode *inode, struct inode *dir)
 {
-	struct posix_acl *acl = NULL;
 	struct f2fs_sb_info *sbi = F2FS_SB(dir->i_sb);
+	struct posix_acl *acl = NULL;
 	int error = 0;
 
 	if (!S_ISLNK(inode->i_mode)) {
@@ -276,19 +276,19 @@ int f2fs_init_acl(struct inode *inode, struct inode *dir)
 			inode->i_mode &= ~current_umask();
 	}
 
-	if (test_opt(sbi, POSIX_ACL) && acl) {
+	if (!test_opt(sbi, POSIX_ACL) || !acl)
+		goto cleanup;
 
-		if (S_ISDIR(inode->i_mode)) {
-			error = f2fs_set_acl(inode, ACL_TYPE_DEFAULT, acl);
-			if (error)
-				goto cleanup;
-		}
-		error = posix_acl_create(&acl, GFP_KERNEL, &inode->i_mode);
-		if (error < 0)
-			return error;
-		if (error > 0)
-			error = f2fs_set_acl(inode, ACL_TYPE_ACCESS, acl);
+	if (S_ISDIR(inode->i_mode)) {
+		error = f2fs_set_acl(inode, ACL_TYPE_DEFAULT, acl);
+		if (error)
+			goto cleanup;
 	}
+	error = posix_acl_create(&acl, GFP_KERNEL, &inode->i_mode);
+	if (error < 0)
+		return error;
+	if (error > 0)
+		error = f2fs_set_acl(inode, ACL_TYPE_ACCESS, acl);
 cleanup:
 	posix_acl_release(acl);
 	return error;
@@ -313,6 +313,7 @@ int f2fs_acl_chmod(struct inode *inode)
 	error = posix_acl_chmod(&acl, GFP_KERNEL, mode);
 	if (error)
 		return error;
+
 	error = f2fs_set_acl(inode, ACL_TYPE_ACCESS, acl);
 	posix_acl_release(acl);
 	return error;
diff --git a/fs/f2fs/acl.h b/fs/f2fs/acl.h
index 80f4306..3839048 100644
--- a/fs/f2fs/acl.h
+++ b/fs/f2fs/acl.h
@@ -36,9 +36,9 @@ struct f2fs_acl_header {
 
 #ifdef CONFIG_F2FS_FS_POSIX_ACL
 
-extern struct posix_acl *f2fs_get_acl(struct inode *inode, int type);
-extern int f2fs_acl_chmod(struct inode *inode);
-extern int f2fs_init_acl(struct inode *inode, struct inode *dir);
+extern struct posix_acl *f2fs_get_acl(struct inode *, int);
+extern int f2fs_acl_chmod(struct inode *);
+extern int f2fs_init_acl(struct inode *, struct inode *);
 #else
 #define f2fs_check_acl	NULL
 #define f2fs_get_acl	NULL
-- 
1.8.4.474.g128a96c

