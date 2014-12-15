Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939AbaLOH2I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 02:28:08 -0500
Received: from mail.kernel.org ([198.145.19.201]:34498 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893AbaLOH1t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 02:27:49 -0500
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 7/7] f2fs: use missing the use of f2fs_kunmap_page
Date: Sun, 14 Dec 2014 23:27:38 -0800
Message-Id: <1418628458-82740-7-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1418628458-82740-1-git-send-email-jaegeuk@kernel.org>
References: <1418628458-82740-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch calls f2fs_kunmap_page which I missed before.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/dir.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index b1a7d57..b74097a 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -286,8 +286,7 @@ void f2fs_set_link(struct inode *dir, struct f2fs_dir_entry *de,
 	f2fs_wait_on_page_writeback(page, type);
 	de->ino = cpu_to_le32(inode->i_ino);
 	set_de_type(de, inode);
-	if (!f2fs_has_inline_dentry(dir))
-		kunmap(page);
+	f2fs_dentry_kunmap(dir, page);
 	set_page_dirty(page);
 	dir->i_mtime = dir->i_ctime = CURRENT_TIME;
 	mark_inode_dirty(dir);
-- 
2.1.1

