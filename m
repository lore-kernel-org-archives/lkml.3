Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab3ITUNi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:13:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41544 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702Ab3ITUNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:13:33 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Anand Avati <avati@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 61/93] fuse: invalidate inode attributes on xattr modification
Date: Fri, 20 Sep 2013 13:08:56 -0700
Message-Id: <1379707768-1804-62-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379707768-1804-1-git-send-email-kamal@canonical.com>
References: <1379707768-1804-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anand Avati <avati@redhat.com>

commit d331a415aef98717393dda0be69b7947da08eba3 upstream.

Calls like setxattr and removexattr result in updation of ctime.
Therefore invalidate inode attributes to force a refresh.

Signed-off-by: Anand Avati <avati@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/fuse/dir.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 315e1f8..54a24fc 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1548,6 +1548,8 @@ static int fuse_setxattr(struct dentry *entry, const char *name,
 		fc->no_setxattr = 1;
 		err = -EOPNOTSUPP;
 	}
+	if (!err)
+		fuse_invalidate_attr(inode);
 	return err;
 }
 
@@ -1677,6 +1679,8 @@ static int fuse_removexattr(struct dentry *entry, const char *name)
 		fc->no_removexattr = 1;
 		err = -EOPNOTSUPP;
 	}
+	if (!err)
+		fuse_invalidate_attr(inode);
 	return err;
 }
 
-- 
1.8.1.2

