Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518AbbAZPKN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 10:10:13 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:9851 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752838AbbAZPKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 10:10:02 -0500
Message-Id: <20150126150959.341644194@goodmis.org>
User-Agent: quilt/0.61-1
Date: Mon, 26 Jan 2015 10:09:17 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH 04/16 v3] fold debugfs_link() into caller
References: <20150126150913.653681560@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0004-fold-debugfs_link-into-caller.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/debugfs/inode.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 18564b08884c..c69e00d69ff1 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -103,14 +103,6 @@ static int debugfs_mkdir(struct dentry *dentry, umode_t mode)
 	return res;
 }
 
-static int debugfs_link(struct dentry *dentry, umode_t mode,
-			void *data)
-{
-	struct inode *dir = dentry->d_parent->d_inode;
-	mode = (mode & S_IALLUGO) | S_IFLNK;
-	return debugfs_mknod(dir, dentry, mode, 0, data, NULL);
-}
-
 static int debugfs_create(struct dentry *dentry, umode_t mode,
 			  void *data, const struct file_operations *fops)
 {
@@ -466,7 +458,8 @@ struct dentry *debugfs_create_symlink(const char *name, struct dentry *parent,
 		return NULL;
 	}
 
-	error = debugfs_link(dentry, S_IFLNK | S_IRWXUGO, link);
+	error = debugfs_mknod(dentry->d_parent->d_inode, dentry,
+			      S_IFLNK | S_IRWXUGO, 0, link, NULL);
 	if (error)
 		kfree(link);
 
-- 
2.1.4


