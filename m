Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358Ab3JYLzi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 07:55:38 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:55256 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab3JYLzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 07:55:36 -0400
From: Denis Efremov <yefremov.denis@gmail.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Denis Efremov <yefremov.denis@gmail.com>, Ben Myers <bpm@sgi.com>,
        Alex Elder <elder@kernel.org>, xfs@oss.sgi.com,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH v2] xfs:xfs_dir2_node.c: pointer use before check for null
Date: Fri, 25 Oct 2013 15:53:25 +0400
Message-Id: <1382702005-32245-1-git-send-email-yefremov.denis@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20131022203322.GA2797@dastard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ASSERT on args takes place after args dereference.
This assertion is redundant since we are going to panic anyway.

Found by Linux Driver Verification project (linuxtesting.org) -
PVS-Studio analyzer.

Signed-off-by: Denis Efremov <yefremov.denis@gmail.com>
---
 fs/xfs/xfs_dir2_node.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_dir2_node.c b/fs/xfs/xfs_dir2_node.c
index 4c3dba7..dc814df 100644
--- a/fs/xfs/xfs_dir2_node.c
+++ b/fs/xfs/xfs_dir2_node.c
@@ -1366,7 +1366,6 @@ xfs_dir2_leafn_split(
 	 */
 	args = state->args;
 	mp = args->dp->i_mount;
-	ASSERT(args != NULL);
 	ASSERT(oldblk->magic == XFS_DIR2_LEAFN_MAGIC);
 	error = xfs_da_grow_inode(args, &blkno);
 	if (error) {
-- 
1.8.3.1

