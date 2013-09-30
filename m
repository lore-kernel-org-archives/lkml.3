Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740Ab3I3KNU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:13:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43719 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755701Ab3I3KNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:13:12 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Anand Avati <avati@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 076/104] fuse: invalidate inode attributes on xattr modification
Date: Mon, 30 Sep 2013 11:10:53 +0100
Message-Id: <1380535881-9239-77-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anand Avati <avati@redhat.com>

commit d331a415aef98717393dda0be69b7947da08eba3 upstream.

Calls like setxattr and removexattr result in updation of ctime.
Therefore invalidate inode attributes to force a refresh.

Signed-off-by: Anand Avati <avati@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/fuse/dir.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index f6e4bc8..b60cc5f 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1511,6 +1511,8 @@ static int fuse_setxattr(struct dentry *entry, const char *name,
 		fc->no_setxattr = 1;
 		err = -EOPNOTSUPP;
 	}
+	if (!err)
+		fuse_invalidate_attr(inode);
 	return err;
 }
 
@@ -1640,6 +1642,8 @@ static int fuse_removexattr(struct dentry *entry, const char *name)
 		fc->no_removexattr = 1;
 		err = -EOPNOTSUPP;
 	}
+	if (!err)
+		fuse_invalidate_attr(inode);
 	return err;
 }
 
-- 
1.8.3.2

