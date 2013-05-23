Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758932Ab3EWN6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 09:58:20 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:38180 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758632Ab3EWN6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 09:58:16 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH 2/4] f2fs: remove unneeded initializations in f2fs_parent_dir
Date: Thu, 23 May 2013 22:58:07 +0900
Message-Id: <1369317488-14346-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

There is no need to initialize few pointers in f2fs_parent_dir
as the values are not checked and instead directly initialized
values are used.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/f2fs/dir.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index fc1dacf..b278bfb 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -215,9 +215,9 @@ struct f2fs_dir_entry *f2fs_find_entry(struct inode *dir,
 
 struct f2fs_dir_entry *f2fs_parent_dir(struct inode *dir, struct page **p)
 {
-	struct page *page = NULL;
-	struct f2fs_dir_entry *de = NULL;
-	struct f2fs_dentry_block *dentry_blk = NULL;
+	struct page *page;
+	struct f2fs_dir_entry *de;
+	struct f2fs_dentry_block *dentry_blk;
 
 	page = get_lock_data_page(dir, 0);
 	if (IS_ERR(page))
-- 
1.7.9.5

