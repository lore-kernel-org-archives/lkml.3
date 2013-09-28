Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289Ab3I1Xgk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 19:36:40 -0400
Received: from mail-qe0-f46.google.com ([209.85.128.46]:50037 "EHLO
	mail-qe0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174Ab3I1Xgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 19:36:37 -0400
From: "Geyslan G. Bem" <geyslan@gmail.com>
To: ericvh@gmail.com, rminnich@sandia.gov, lucho@ionkov.net
Cc: v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        "Geyslan G. Bem" <geyslan@gmail.com>
Subject: [PATCH] 9p: remove unused 'p9_fid' struct pointer
Date: Sat, 28 Sep 2013 20:32:13 -0300
Message-Id: <1380411144-9236-1-git-send-email-geyslan@gmail.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the useless '*fid' variable.

Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
---
 fs/9p/cache.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/9p/cache.c b/fs/9p/cache.c
index a9ea73d..50f9d9c 100644
--- a/fs/9p/cache.c
+++ b/fs/9p/cache.c
@@ -239,13 +239,12 @@ void v9fs_cache_inode_flush_cookie(struct inode *inode)
 void v9fs_cache_inode_set_cookie(struct inode *inode, struct file *filp)
 {
 	struct v9fs_inode *v9inode = V9FS_I(inode);
-	struct p9_fid *fid;
 
 	if (!v9inode->fscache)
 		return;
 
 	spin_lock(&v9inode->fscache_lock);
-	fid = filp->private_data;
+
 	if ((filp->f_flags & O_ACCMODE) != O_RDONLY)
 		v9fs_cache_inode_flush_cookie(inode);
 	else
-- 
1.8.4

