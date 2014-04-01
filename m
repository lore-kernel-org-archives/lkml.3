Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929AbaDAJSu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 05:18:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45664 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705AbaDAJQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 05:16:48 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 24/29] GFS2: Increase the max number of ACLs
Date: Tue,  1 Apr 2014 10:15:36 +0100
Message-Id: <1396343741-1524-25-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1396343741-1524-1-git-send-email-swhiteho@redhat.com>
References: <1396343741-1524-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch increases the maximum number of ACLs from 25 to 300 for
a 4K block size. The value is adjusted accordingly if the block size
is smaller. Note that this is an arbitrary limit with a performance
tradeoff, and that the physical limit is slightly over 500.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/acl.c b/fs/gfs2/acl.c
index 9c59ebe..394dc55 100644
--- a/fs/gfs2/acl.c
+++ b/fs/gfs2/acl.c
@@ -85,7 +85,7 @@ int gfs2_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 
 	BUG_ON(name == NULL);
 
-	if (acl->a_count > GFS2_ACL_MAX_ENTRIES)
+	if (acl->a_count > GFS2_ACL_MAX_ENTRIES(GFS2_SB(inode)))
 		return -E2BIG;
 
 	if (type == ACL_TYPE_ACCESS) {
diff --git a/fs/gfs2/acl.h b/fs/gfs2/acl.h
index 301260c..2d65ec4 100644
--- a/fs/gfs2/acl.h
+++ b/fs/gfs2/acl.h
@@ -14,7 +14,7 @@
 
 #define GFS2_POSIX_ACL_ACCESS		"posix_acl_access"
 #define GFS2_POSIX_ACL_DEFAULT		"posix_acl_default"
-#define GFS2_ACL_MAX_ENTRIES		25
+#define GFS2_ACL_MAX_ENTRIES(sdp) ((300 << (sdp)->sd_sb.sb_bsize_shift) >> 12)
 
 extern struct posix_acl *gfs2_get_acl(struct inode *inode, int type);
 extern int gfs2_set_acl(struct inode *inode, struct posix_acl *acl, int type);
-- 
1.8.3.1

