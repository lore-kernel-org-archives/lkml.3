Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890AbbAHM5t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 07:57:49 -0500
Received: from www.osadl.org ([62.245.132.105]:39728 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932257AbbAHM5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 07:57:48 -0500
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org,
        Nicholas Mc Guire <der.herr@hofr.at>
Subject: [PATCH] xfs: fix implicit bool to int conversion
Date: Thu,  8 Jan 2015 13:49:51 +0100
Message-Id: <1420721391-22717-1-git-send-email-der.herr@hofr.at>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

try_wait_for_completion returns bool so the wrapper function
xfs_dqflock_nowait should probably also return bool and not int. 

Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---

patch was only compile tested x86_64_defconfig + CONFIG_XFS_FS=m
CONFIG_XFS_QUOTA=y

patch is against linux-next 3.19.0-rc3 -next-20150107

 fs/xfs/xfs_dquot.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index c24c67e..2f536f3 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -86,7 +86,7 @@ static inline void xfs_dqflock(xfs_dquot_t *dqp)
 	wait_for_completion(&dqp->q_flush);
 }
 
-static inline int xfs_dqflock_nowait(xfs_dquot_t *dqp)
+static inline bool xfs_dqflock_nowait(xfs_dquot_t *dqp)
 {
 	return try_wait_for_completion(&dqp->q_flush);
 }
-- 
1.7.10.4

