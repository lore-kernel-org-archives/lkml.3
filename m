Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517AbaDALRz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:17:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42507 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbaDALRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:17:52 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 085/144] ocfs2 syncs the wrong range...
Date: Tue,  1 Apr 2014 12:14:49 +0100
Message-Id: <1396350948-29910-86-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 1b56e98990bcdbb20b9fab163654b9315bf158e8 upstream.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ocfs2/file.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 3261d71..fb4b887 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2374,8 +2374,8 @@ out_dio:
 
 	if (((file->f_flags & O_DSYNC) && !direct_io) || IS_SYNC(inode) ||
 	    ((file->f_flags & O_DIRECT) && !direct_io)) {
-		ret = filemap_fdatawrite_range(file->f_mapping, pos,
-					       pos + count - 1);
+		ret = filemap_fdatawrite_range(file->f_mapping, *ppos,
+					       *ppos + count - 1);
 		if (ret < 0)
 			written = ret;
 
@@ -2388,8 +2388,8 @@ out_dio:
 		}
 
 		if (!ret)
-			ret = filemap_fdatawait_range(file->f_mapping, pos,
-						      pos + count - 1);
+			ret = filemap_fdatawait_range(file->f_mapping, *ppos,
+						      *ppos + count - 1);
 	}
 
 	/*
-- 
1.9.1

