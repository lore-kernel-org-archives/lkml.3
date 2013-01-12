Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667Ab3ALFlp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 00:41:45 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:42268 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab3ALFlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 00:41:42 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH 2/4] f2fs: avoid redundant time update for parent directory in f2fs_delete_entry
Date: Sat, 12 Jan 2013 14:41:33 +0900
Message-Id: <1357969293-9327-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

In call to f2fs_delete_entry, 'dir' time modification code is put
at two places.
So, remove the redundant code for timing update.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/f2fs/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index 951ed52..989980e 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -503,7 +503,7 @@ void f2fs_delete_entry(struct f2fs_dir_entry *dentry, struct page *page,
 	}
 
 	if (inode) {
-		inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME;
+		inode->i_ctime = CURRENT_TIME;
 		drop_nlink(inode);
 		if (S_ISDIR(inode->i_mode)) {
 			drop_nlink(inode);
-- 
1.7.9.5

