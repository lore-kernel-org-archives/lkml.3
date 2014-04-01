Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700AbaDAJQi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 05:16:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63694 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751546AbaDAJQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 05:16:30 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Jie Liu <jeff.liu@oracle.com>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 15/29] GFS2: return -E2BIG if hit the maximum limits of ACLs
Date: Tue,  1 Apr 2014 10:15:27 +0100
Message-Id: <1396343741-1524-16-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1396343741-1524-1-git-send-email-swhiteho@redhat.com>
References: <1396343741-1524-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jie Liu <jeff.liu@oracle.com>

Return -E2BIG rather than -EINVAL if hit the maximum size limits of
ACLs, as the former errno is consistent with VFS xattr syscalls.

This is pointed out by Dave Chinner in previous discussion thread:
http://www.spinics.net/lists/linux-fsdevel/msg71125.html

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/acl.c b/fs/gfs2/acl.c
index ba94566..9c59ebe 100644
--- a/fs/gfs2/acl.c
+++ b/fs/gfs2/acl.c
@@ -86,7 +86,7 @@ int gfs2_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 	BUG_ON(name == NULL);
 
 	if (acl->a_count > GFS2_ACL_MAX_ENTRIES)
-		return -EINVAL;
+		return -E2BIG;
 
 	if (type == ACL_TYPE_ACCESS) {
 		umode_t mode = inode->i_mode;
-- 
1.8.3.1

