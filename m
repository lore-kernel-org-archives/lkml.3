Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028Ab3LMO2O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 09:28:14 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:60525 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753003Ab3LMO2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 09:28:11 -0500
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH 1/5] xfs: factor prid related codes into xfs_get_initial_prid()
Date: Fri, 13 Dec 2013 22:27:49 +0800
Message-Id: <1386944873-16796-2-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1386944873-16796-1-git-send-email-zwu.kernel@gmail.com>
References: <1386944873-16796-1-git-send-email-zwu.kernel@gmail.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121314-5806-0000-0000-000023AA5223
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

It will be reused by the O_TMPFILE creation function.

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/xfs/xfs_inode.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 001aa89..e8b9a68 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1139,6 +1139,14 @@ xfs_bumplink(
 	return 0;
 }
 
+static inline prid_t xfs_get_initial_prid(struct xfs_inode *dp)
+{
+	if (dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
+		return xfs_get_projid(dp);
+	else
+		return XFS_PROJID_DEFAULT;
+}
+
 int
 xfs_create(
 	xfs_inode_t		*dp,
@@ -1169,10 +1177,7 @@ xfs_create(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
 
-	if (dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
-		prid = xfs_get_projid(dp);
-	else
-		prid = XFS_PROJID_DEFAULT;
+	prid = xfs_get_initial_prid(dp);
 
 	/*
 	 * Make sure that we have allocated dquot(s) on disk.
-- 
1.7.6.5

