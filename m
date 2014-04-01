Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367AbaDAQ3Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:29:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44605 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946AbaDAQPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:15:38 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Al Viro <viro@zeniv.linux.org.uk>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 65/86] ocfs2 syncs the wrong range...
Date: Tue,  1 Apr 2014 09:08:18 -0700
Message-Id: <1396368519-12728-66-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396368519-12728-1-git-send-email-kamal@canonical.com>
References: <1396368519-12728-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.21 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 1b56e98990bcdbb20b9fab163654b9315bf158e8 upstream.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/ocfs2/file.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 37d313e..ff759ce 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2375,8 +2375,8 @@ out_dio:
 
 	if (((file->f_flags & O_DSYNC) && !direct_io) || IS_SYNC(inode) ||
 	    ((file->f_flags & O_DIRECT) && !direct_io)) {
-		ret = filemap_fdatawrite_range(file->f_mapping, pos,
-					       pos + count - 1);
+		ret = filemap_fdatawrite_range(file->f_mapping, *ppos,
+					       *ppos + count - 1);
 		if (ret < 0)
 			written = ret;
 
@@ -2389,8 +2389,8 @@ out_dio:
 		}
 
 		if (!ret)
-			ret = filemap_fdatawait_range(file->f_mapping, pos,
-						      pos + count - 1);
+			ret = filemap_fdatawait_range(file->f_mapping, *ppos,
+						      *ppos + count - 1);
 	}
 
 	/*
-- 
1.8.3.2

