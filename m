Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab3JVHif (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 03:38:35 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:45378 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413Ab3JVHid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 03:38:33 -0400
From: Denis Efremov <yefremov.denis@gmail.com>
To: Ben Myers <bpm@sgi.com>
Cc: Denis Efremov <yefremov.denis@gmail.com>, Alex Elder <elder@kernel.org>,
        xfs@oss.sgi.com, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: [PATCH] xfs:xfs_dir2_node.c: pointer use before check for null
Date: Tue, 22 Oct 2013 11:36:15 +0400
Message-Id: <1382427375-8863-1-git-send-email-yefremov.denis@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reorder of assert and args pointer dereference.

Found by Linux Driver Verification project (linuxtesting.org) -
PVS-Studio analyzer.

Signed-off-by: Denis Efremov <yefremov.denis@gmail.com>
---
 fs/xfs/xfs_dir2_node.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_dir2_node.c b/fs/xfs/xfs_dir2_node.c
index 4c3dba7..0ba7382 100644
--- a/fs/xfs/xfs_dir2_node.c
+++ b/fs/xfs/xfs_dir2_node.c
@@ -1365,8 +1365,8 @@ xfs_dir2_leafn_split(
 	 * Allocate space for a new leaf node.
 	 */
 	args = state->args;
-	mp = args->dp->i_mount;
 	ASSERT(args != NULL);
+	mp = args->dp->i_mount;
 	ASSERT(oldblk->magic == XFS_DIR2_LEAFN_MAGIC);
 	error = xfs_da_grow_inode(args, &blkno);
 	if (error) {
-- 
1.8.3.1

