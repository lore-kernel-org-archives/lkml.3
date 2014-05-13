Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760710AbaEMNwz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 09:52:55 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:49910 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbaEMNwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 09:52:53 -0400
Date: Tue, 13 May 2014 15:52:43 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH] bad_inode: add ->rename2()
Message-ID: <20140513135243.GA17233@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

so we return -EIO instead of -EINVAL.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/bad_inode.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/bad_inode.c
+++ b/fs/bad_inode.c
@@ -224,6 +224,13 @@ static int bad_inode_rename (struct inod
 	return -EIO;
 }
 
+static int bad_inode_rename2(struct inode *old_dir, struct dentry *old_dentry,
+			     struct inode *new_dir, struct dentry *new_dentry,
+			     unsigned int flags)
+{
+	return -EIO;
+}
+
 static int bad_inode_readlink(struct dentry *dentry, char __user *buffer,
 		int buflen)
 {
@@ -280,6 +287,7 @@ static const struct inode_operations bad
 	.rmdir		= bad_inode_rmdir,
 	.mknod		= bad_inode_mknod,
 	.rename		= bad_inode_rename,
+	.rename2	= bad_inode_rename2,
 	.readlink	= bad_inode_readlink,
 	/* follow_link must be no-op, otherwise unmounting this inode
 	   won't work */
