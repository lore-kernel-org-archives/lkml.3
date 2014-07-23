Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874AbaGWNQE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 09:16:04 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:56219 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754695AbaGWNP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 09:15:57 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-kernel@vger.kernel.org, hch@infradead.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Cc: Miklos Szeredi <mszeredi@suse.cz>
Subject: [PATCH 2/7] bad_inode: add ->rename2()
Date: Wed, 23 Jul 2014 15:15:31 +0200
Message-Id: <1406121336-1379-3-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1406121336-1379-1-git-send-email-miklos@szeredi.hu>
References: <1406121336-1379-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

so we return -EIO instead of -EINVAL.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/bad_inode.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/bad_inode.c b/fs/bad_inode.c
index 7c93953030fb..afd2b4408adf 100644
--- a/fs/bad_inode.c
+++ b/fs/bad_inode.c
@@ -218,8 +218,9 @@ static int bad_inode_mknod (struct inode *dir, struct dentry *dentry,
 	return -EIO;
 }
 
-static int bad_inode_rename (struct inode *old_dir, struct dentry *old_dentry,
-		struct inode *new_dir, struct dentry *new_dentry)
+static int bad_inode_rename2(struct inode *old_dir, struct dentry *old_dentry,
+			     struct inode *new_dir, struct dentry *new_dentry,
+			     unsigned int flags)
 {
 	return -EIO;
 }
@@ -279,7 +280,7 @@ static const struct inode_operations bad_inode_ops =
 	.mkdir		= bad_inode_mkdir,
 	.rmdir		= bad_inode_rmdir,
 	.mknod		= bad_inode_mknod,
-	.rename		= bad_inode_rename,
+	.rename2	= bad_inode_rename2,
 	.readlink	= bad_inode_readlink,
 	/* follow_link must be no-op, otherwise unmounting this inode
 	   won't work */
-- 
1.8.1.4

