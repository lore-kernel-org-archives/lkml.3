Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058Ab3JUS6i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 14:58:38 -0400
Received: from mail-ye0-f170.google.com ([209.85.213.170]:46971 "EHLO
	mail-ye0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab3JUS6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 14:58:37 -0400
From: "Geyslan G. Bem" <geyslan@gmail.com>
To: kernel-br@googlegroups.com
Cc: "Geyslan G. Bem" <geyslan@gmail.com>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Ron Minnich <rminnich@sandia.gov>, Latchesar Ionkov <lucho@ionkov.net>,
        v9fs-developer@lists.sourceforge.net (open list:9P FILE SYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] 9p: remove useless 'name' variable and assignment
Date: Mon, 21 Oct 2013 15:53:45 -0300
Message-Id: <1382381625-16974-1-git-send-email-geyslan@gmail.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no use of 'name' pointer. Get rid of its useless assignment.

Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
---
 fs/9p/vfs_inode_dotl.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index a7c4814..2cd9042 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -772,7 +772,6 @@ v9fs_vfs_link_dotl(struct dentry *old_dentry, struct inode *dir,
 		struct dentry *dentry)
 {
 	int err;
-	char *name;
 	struct dentry *dir_dentry;
 	struct p9_fid *dfid, *oldfid;
 	struct v9fs_session_info *v9ses;
@@ -790,8 +789,6 @@ v9fs_vfs_link_dotl(struct dentry *old_dentry, struct inode *dir,
 	if (IS_ERR(oldfid))
 		return PTR_ERR(oldfid);
 
-	name = (char *) dentry->d_name.name;
-
 	err = p9_client_link(dfid, oldfid, (char *)dentry->d_name.name);
 
 	if (err < 0) {
-- 
1.8.4

