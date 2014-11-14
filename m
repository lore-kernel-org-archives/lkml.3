Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934768AbaKNA7k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 19:59:40 -0500
Received: from mail.kernel.org ([198.145.19.201]:42342 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933409AbaKNA7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 19:59:39 -0500
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 1/3] f2fs: reduce the number of inline_data inode before clearing it
Date: Thu, 13 Nov 2014 16:59:32 -0800
Message-Id: <1415926774-49230-1-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The # of inline_data inode is decreased only when it has inline_data.
After clearing the flag, we can't decreased the number.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/inline.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index 8b66109..2310670 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -116,8 +116,8 @@ no_update:
 	/* clear inline data and flag after data writeback */
 	truncate_inline_data(dn->inode_page, 0);
 clear_out:
-	f2fs_clear_inline_inode(dn->inode);
 	stat_dec_inline_inode(dn->inode);
+	f2fs_clear_inline_inode(dn->inode);
 	sync_inode_page(dn);
 	f2fs_put_dnode(dn);
 	return 0;
-- 
2.1.1

