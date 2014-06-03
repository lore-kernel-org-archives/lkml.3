Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878AbaFCLDn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:03:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1375 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753436AbaFCLC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:02:59 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Fabian Frederick <fabf@skynet.be>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 4/6] GFS2: fs/gfs2/bmap.c: kernel-doc warning fixes
Date: Tue,  3 Jun 2014 12:02:31 +0100
Message-Id: <1401793353-1469-5-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1401793353-1469-1-git-send-email-swhiteho@redhat.com>
References: <1401793353-1469-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>

Fix 2 typos and move one definition which was between function
comments and function definition (yet another kernel-doc warning)

Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index c62d4b9..e6ee5b6 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -707,7 +707,7 @@ int gfs2_extent_map(struct inode *inode, u64 lblock, int *new, u64 *dblock, unsi
  * @top: The first pointer in the buffer
  * @bottom: One more than the last pointer
  * @height: the height this buffer is at
- * @data: a pointer to a struct strip_mine
+ * @sm: a pointer to a struct strip_mine
  *
  * Returns: errno
  */
@@ -992,6 +992,8 @@ unlock:
 	return err;
 }
 
+#define GFS2_JTRUNC_REVOKES 8192
+
 /**
  * gfs2_journaled_truncate - Wrapper for truncate_pagecache for jdata files
  * @inode: The inode being truncated
@@ -1003,8 +1005,6 @@ unlock:
  * if the number of pages being truncated gets too large.
  */
 
-#define GFS2_JTRUNC_REVOKES 8192
-
 static int gfs2_journaled_truncate(struct inode *inode, u64 oldsize, u64 newsize)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(inode);
@@ -1348,7 +1348,7 @@ void gfs2_free_journal_extents(struct gfs2_jdesc *jd)
  * gfs2_add_jextent - Add or merge a new extent to extent cache
  * @jd: The journal descriptor
  * @lblock: The logical block at start of new extent
- * @pblock: The physical block at start of new extent
+ * @dblock: The physical block at start of new extent
  * @blocks: Size of extent in fs blocks
  *
  * Returns: 0 on success or -ENOMEM
-- 
1.8.3.1

