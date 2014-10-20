Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbaJTFTP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 01:19:15 -0400
Received: from mail.kernel.org ([198.145.19.201]:59780 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752455AbaJTFSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 01:18:43 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 07/09] f2fs: fix to call f2fs_unlock_op
Date: Sun, 19 Oct 2014 22:18:30 -0700
Message-Id: <1413782312-11631-7-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413782312-11631-1-git-send-email-jaegeuk@kernel.org>
References: <1413782312-11631-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes to call f2fs_unlock_op, which was missing before.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/file.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 456df07..80d9a04 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -494,7 +494,7 @@ int truncate_blocks(struct inode *inode, u64 from, bool lock)
 	/* writepage can convert inline_data under get_donde_of_data */
 	if (f2fs_has_inline_data(inode)) {
 		f2fs_put_dnode(&dn);
-		goto done;
+		goto unlock_done;
 	}
 
 	count = ADDRS_PER_PAGE(dn.node_page, F2FS_I(inode));
@@ -510,6 +510,7 @@ int truncate_blocks(struct inode *inode, u64 from, bool lock)
 	f2fs_put_dnode(&dn);
 free_next:
 	err = truncate_inode_blocks(inode, free_from);
+unlock_done:
 	if (lock)
 		f2fs_unlock_op(sbi);
 done:
-- 
2.1.1

