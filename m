Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab3I1XhF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 19:37:05 -0400
Received: from mail-qe0-f44.google.com ([209.85.128.44]:63434 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755399Ab3I1Xg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 19:36:59 -0400
From: "Geyslan G. Bem" <geyslan@gmail.com>
To: ericvh@gmail.com, rminnich@sandia.gov, lucho@ionkov.net
Cc: v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        "Geyslan G. Bem" <geyslan@gmail.com>
Subject: [PATCH] 9p: proper use of the 'name' variable
Date: Sat, 28 Sep 2013 20:32:20 -0300
Message-Id: <1380411144-9236-8-git-send-email-geyslan@gmail.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1380411144-9236-1-git-send-email-geyslan@gmail.com>
References: <1380411144-9236-1-git-send-email-geyslan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'name' variable was assigned but never used. Hence puts its
assignment to the top and makes proper use of its value.

Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
---
 fs/9p/vfs_inode_dotl.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index 6803758..86b6944 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -772,8 +772,10 @@ v9fs_vfs_link_dotl(struct dentry *old_dentry, struct inode *dir,
 	struct p9_fid *dfid, *oldfid;
 	struct v9fs_session_info *v9ses;
 
+	name = (char *) dentry->d_name.name;
+
 	p9_debug(P9_DEBUG_VFS, "dir ino: %lu, old_name: %s, new_name: %s\n",
-		 dir->i_ino, old_dentry->d_name.name, dentry->d_name.name);
+		 dir->i_ino, old_dentry->d_name.name, name);
 
 	v9ses = v9fs_inode2v9ses(dir);
 	dir_dentry = dentry->d_parent;
@@ -785,9 +787,7 @@ v9fs_vfs_link_dotl(struct dentry *old_dentry, struct inode *dir,
 	if (IS_ERR(oldfid))
 		return PTR_ERR(oldfid);
 
-	name = (char *) dentry->d_name.name;
-
-	err = p9_client_link(dfid, oldfid, (char *)dentry->d_name.name);
+	err = p9_client_link(dfid, oldfid, name);
 
 	if (err < 0) {
 		p9_debug(P9_DEBUG_VFS, "p9_client_link failed %d\n", err);
-- 
1.8.4

