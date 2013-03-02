Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790Ab3CBDlQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 22:41:16 -0500
Received: from mail-da0-f44.google.com ([209.85.210.44]:45419 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441Ab3CBDlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 22:41:12 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH 3/5] f2fs: move f2fs_balance_fs to correct place in unlink
Date: Sat,  2 Mar 2013 12:41:03 +0900
Message-Id: <1362195663-20751-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Actual dirty of pages will occur in f2fs_delete_entry so move the
f2fs_balance_fs just before deletion.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/f2fs/namei.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 1a49b88..eaa86f5 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -223,8 +223,6 @@ static int f2fs_unlink(struct inode *dir, struct dentry *dentry)
 	struct page *page;
 	int err = -ENOENT;
 
-	f2fs_balance_fs(sbi);
-
 	de = f2fs_find_entry(dir, &dentry->d_name, &page);
 	if (!de)
 		goto fail;
@@ -236,6 +234,8 @@ static int f2fs_unlink(struct inode *dir, struct dentry *dentry)
 		goto fail;
 	}
 
+	f2fs_balance_fs(sbi);
+
 	f2fs_delete_entry(de, page, inode);
 
 	/* In order to evict this inode,  we set it dirty */
-- 
1.7.9.5

