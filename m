Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063AbaKZCIR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 21:08:17 -0500
Received: from mail.kernel.org ([198.145.19.201]:47514 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796AbaKZCIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 21:08:15 -0500
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH] f2fs: fix to recover converted inline_data
Date: Tue, 25 Nov 2014 18:08:11 -0800
Message-Id: <1416967691-47240-1-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If an inode has converted inline_data which was written to the disk, we should
set its inode flag for further fsync so that this inline_data can be recovered
from sudden power off.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/inline.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index e27f290..f2d3c58 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -122,6 +122,9 @@ no_update:
 	if (dirty)
 		inode_dec_dirty_pages(dn->inode);
 
+	/* this converted inline_data should be recovered. */
+	set_inode_flag(F2FS_I(dn->inode), FI_APPEND_WRITE);
+
 	/* clear inline data and flag after data writeback */
 	truncate_inline_data(dn->inode_page, 0);
 clear_out:
-- 
2.1.1

