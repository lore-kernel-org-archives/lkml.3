Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158AbaFGQpD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 12:45:03 -0400
Received: from mail.kernel.org ([198.145.19.201]:59908 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128AbaFGQpA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 12:45:00 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 2/3] f2fs: recover fallocated space
Date: Sun,  8 Jun 2014 01:44:31 +0900
Message-Id: <1402159472-61137-2-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 1.8.5.2 (Apple Git-48)
In-Reply-To: <1402159472-61137-1-git-send-email-jaegeuk@kernel.org>
References: <1402159472-61137-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a fallocated file is fsynced, we should recover the i_size after sudden
power cut.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/file.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index d97e5c4..78110da 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -682,6 +682,7 @@ static int expand_inode_data(struct inode *inode, loff_t offset,
 		i_size_read(inode) < new_size) {
 		i_size_write(inode, new_size);
 		mark_inode_dirty(inode);
+		f2fs_write_inode(inode, NULL);
 	}
 
 	return ret;
-- 
1.8.5.2 (Apple Git-48)

