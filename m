Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817AbaDAJQx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 05:16:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58742 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789AbaDAJQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 05:16:50 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 26/29] GFS2: inline function gfs2_set_mode
Date: Tue,  1 Apr 2014 10:15:38 +0100
Message-Id: <1396343741-1524-27-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1396343741-1524-1-git-send-email-swhiteho@redhat.com>
References: <1396343741-1524-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

Here is a revised patch based on Steve's feedback:

This patch eliminates function gfs2_set_mode which was only called in
one place, and always returned 0.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/acl.c b/fs/gfs2/acl.c
index 394dc55..3088e2a 100644
--- a/fs/gfs2/acl.c
+++ b/fs/gfs2/acl.c
@@ -64,18 +64,6 @@ struct posix_acl *gfs2_get_acl(struct inode *inode, int type)
 	return acl;
 }
 
-static int gfs2_set_mode(struct inode *inode, umode_t mode)
-{
-	int error = 0;
-
-	if (mode != inode->i_mode) {
-		inode->i_mode = mode;
-		mark_inode_dirty(inode);
-	}
-
-	return error;
-}
-
 int gfs2_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 {
 	int error;
@@ -98,9 +86,10 @@ int gfs2_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 		if (error == 0)
 			acl = NULL;
 
-		error = gfs2_set_mode(inode, mode);
-		if (error)
-			return error;
+		if (mode != inode->i_mode) {
+			inode->i_mode = mode;
+			mark_inode_dirty(inode);
+		}
 	}
 
 	if (acl) {
-- 
1.8.3.1

