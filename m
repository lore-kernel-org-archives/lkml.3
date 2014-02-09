Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbaBINQY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 08:16:24 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:37653 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbaBINQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 08:16:22 -0500
Date: Sun, 9 Feb 2014 18:46:18 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        ocfs2-devel@oss.oracle.com, josh@joshtriplett.org
Subject: [PATCH 15/21] fs: Mark function as static in ocfs2/xattr.c
Message-ID: <4c4a91b6cb44627906572e2beae874160a470362.1391949868.git.rashika.kheria@gmail.com>
References: <b572932c3e016c55e596686283036316a1aacd2f.1391949868.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b572932c3e016c55e596686283036316a1aacd2f.1391949868.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark functions as static in ocfs2/xattr.c because it is not used outside
this file.

This eliminates the following warning in ocfs2/xattr.c:
fs/ocfs2/xattr.c:7256:5: warning: no previous prototype for ‘ocfs2_initxattrs’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 fs/ocfs2/xattr.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 185fa3b7..7041df5 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -7256,8 +7256,8 @@ static int ocfs2_xattr_security_set(struct dentry *dentry, const char *name,
 			       name, value, size, flags);
 }
 
-int ocfs2_initxattrs(struct inode *inode, const struct xattr *xattr_array,
-		     void *fs_info)
+static int ocfs2_initxattrs(struct inode *inode, const struct xattr *xattr_array,
+			    void *fs_info)
 {
 	const struct xattr *xattr;
 	int err = 0;
-- 
1.7.9.5

