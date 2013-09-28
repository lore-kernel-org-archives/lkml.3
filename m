Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab3I1Xi4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 19:38:56 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:56937 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755361Ab3I1Xgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 19:36:47 -0400
From: "Geyslan G. Bem" <geyslan@gmail.com>
To: ericvh@gmail.com, rminnich@sandia.gov, lucho@ionkov.net
Cc: v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        "Geyslan G. Bem" <geyslan@gmail.com>
Subject: [PATCH] 9p: remove unused 'super_block' struct pointer
Date: Sat, 28 Sep 2013 20:32:16 -0300
Message-Id: <1380411144-9236-4-git-send-email-geyslan@gmail.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1380411144-9236-1-git-send-email-geyslan@gmail.com>
References: <1380411144-9236-1-git-send-email-geyslan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the useless '*sb' variable.

Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
---
 fs/9p/vfs_inode.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 7566477..b352457 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -783,7 +783,6 @@ struct dentry *v9fs_vfs_lookup(struct inode *dir, struct dentry *dentry,
 				      unsigned int flags)
 {
 	struct dentry *res;
-	struct super_block *sb;
 	struct v9fs_session_info *v9ses;
 	struct p9_fid *dfid, *fid;
 	struct inode *inode;
@@ -795,7 +794,6 @@ struct dentry *v9fs_vfs_lookup(struct inode *dir, struct dentry *dentry,
 	if (dentry->d_name.len > NAME_MAX)
 		return ERR_PTR(-ENAMETOOLONG);
 
-	sb = dir->i_sb;
 	v9ses = v9fs_inode2v9ses(dir);
 	/* We can walk d_parent because we hold the dir->i_mutex */
 	dfid = v9fs_fid_lookup(dentry->d_parent);
-- 
1.8.4

