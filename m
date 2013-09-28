Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab3I1Xic (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 19:38:32 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:47285 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755421Ab3I1Xgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 19:36:53 -0400
From: "Geyslan G. Bem" <geyslan@gmail.com>
To: ericvh@gmail.com, rminnich@sandia.gov, lucho@ionkov.net
Cc: v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        "Geyslan G. Bem" <geyslan@gmail.com>
Subject: [PATCH] 9p: remove never used return variable
Date: Sat, 28 Sep 2013 20:32:18 -0300
Message-Id: <1380411144-9236-6-git-send-email-geyslan@gmail.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1380411144-9236-1-git-send-email-geyslan@gmail.com>
References: <1380411144-9236-1-git-send-email-geyslan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the useless 'err' variable, since the return is treated
farther down without the use of it.

Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
---
 fs/9p/vfs_inode_dotl.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index a7c4814..a892c2f 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -477,13 +477,11 @@ static int
 v9fs_vfs_getattr_dotl(struct vfsmount *mnt, struct dentry *dentry,
 		 struct kstat *stat)
 {
-	int err;
 	struct v9fs_session_info *v9ses;
 	struct p9_fid *fid;
 	struct p9_stat_dotl *st;
 
 	p9_debug(P9_DEBUG_VFS, "dentry: %p\n", dentry);
-	err = -EPERM;
 	v9ses = v9fs_dentry2v9ses(dentry);
 	if (v9ses->cache == CACHE_LOOSE || v9ses->cache == CACHE_FSCACHE) {
 		generic_fillattr(dentry->d_inode, stat);
-- 
1.8.4

