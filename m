Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914AbaDAJSW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 05:18:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30623 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751771AbaDAJQt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 05:16:49 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 25/29] GFS2: Remove extraneous function gfs2_security_init
Date: Tue,  1 Apr 2014 10:15:37 +0100
Message-Id: <1396343741-1524-26-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1396343741-1524-1-git-send-email-swhiteho@redhat.com>
References: <1396343741-1524-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch eliminates function gfs2_security_init in favor of just
calling security_inode_init_security directly.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index b52ebf8..69ed57a 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -571,13 +571,6 @@ static int gfs2_initxattrs(struct inode *inode, const struct xattr *xattr_array,
 	return err;
 }
 
-static int gfs2_security_init(struct gfs2_inode *dip, struct gfs2_inode *ip,
-			      const struct qstr *qstr)
-{
-	return security_inode_init_security(&ip->i_inode, &dip->i_inode, qstr,
-					    &gfs2_initxattrs, NULL);
-}
-
 /**
  * gfs2_create_inode - Create a new inode
  * @dir: The parent directory
@@ -758,7 +751,8 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 	if (error)
 		goto fail_gunlock3;
 
-	error = gfs2_security_init(dip, ip, name);
+	error = security_inode_init_security(&ip->i_inode, &dip->i_inode, name,
+					     &gfs2_initxattrs, NULL);
 	if (error)
 		goto fail_gunlock3;
 
-- 
1.8.3.1

