Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab3J0Dgr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 23:36:47 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:45003 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605Ab3J0Dgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 23:36:46 -0400
From: Cong Ding <dinggnu@gmail.com>
To: Eric Van Hensbergen <ericvh@gmail.com>, Ron Minnich <rminnich@sandia.gov>,
        Latchesar Ionkov <lucho@ionkov.net>,
        v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: Cong Ding <dinggnu@gmail.com>
Subject: [PATCH] fs/9p: fix flags in the format of printf
Date: Sat, 26 Oct 2013 20:36:23 -0700
Message-Id: <1382844984-7550-1-git-send-email-dinggnu@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To print "int" value, we should use %d rather than %u.

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 fs/9p/vfs_inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index af7d531..dcc099a 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -147,7 +147,7 @@ static umode_t p9mode2unixmode(struct v9fs_session_info *v9ses,
 		int major = -1, minor = -1;
 
 		strlcpy(ext, stat->extension, sizeof(ext));
-		sscanf(ext, "%c %u %u", &type, &major, &minor);
+		sscanf(ext, "%c %d %d", &type, &major, &minor);
 		switch (type) {
 		case 'c':
 			res |= S_IFCHR;
-- 
1.7.9.5

