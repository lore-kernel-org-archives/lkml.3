Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab3JAOtn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 10:49:43 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:39205 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350Ab3JAOti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 10:49:38 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: [PATCH] xfs: Use kmem_free() instead of free()
Date: Tue,  1 Oct 2013 16:47:53 +0200
Message-Id: <1380638873-5181-1-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a build failure caused by calling the free() function which
does not exist in the Linux kernel.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 fs/xfs/xfs_log_recover.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 4324058..3979749 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1585,7 +1585,7 @@ xlog_recover_add_to_trans(
 		"bad number of regions (%d) in inode log format",
 				  in_f->ilf_size);
 			ASSERT(0);
-			free(ptr);
+			kmem_free(ptr);
 			return XFS_ERROR(EIO);
 		}
 
-- 
1.8.4

