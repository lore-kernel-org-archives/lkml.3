Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846Ab3JGWXO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 18:23:14 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:34914 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab3JGWXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 18:23:13 -0400
From: "Geyslan G. Bem" <geyslan@gmail.com>
To: ericvh@gmail.com, rminnich@sandia.gov, lucho@ionkov.net,
        v9fs-developer@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, kernel-br@googlegroups.com,
        "Geyslan G. Bem" <geyslan@gmail.com>
Subject: [PATCH] 9p: unsigned/signed wrap in p9/unix modes.
Date: Mon,  7 Oct 2013 19:19:00 -0300
Message-Id: <1381184340-11190-1-git-send-email-geyslan@gmail.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes the sign type to unsigned, avoiding the possibility of
wrap when ORing the p9 or unix bit modes.

Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
---
 fs/9p/vfs_inode.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index b352457..574095e 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -63,7 +63,7 @@ static const struct inode_operations v9fs_symlink_inode_operations;
 
 static u32 unixmode2p9mode(struct v9fs_session_info *v9ses, umode_t mode)
 {
-	int res;
+	u32 res;
 	res = mode & 0777;
 	if (S_ISDIR(mode))
 		res |= P9_DMDIR;
@@ -125,7 +125,7 @@ static int p9mode2perm(struct v9fs_session_info *v9ses,
 static umode_t p9mode2unixmode(struct v9fs_session_info *v9ses,
 			       struct p9_wstat *stat, dev_t *rdev)
 {
-	int res;
+	umode_t res;
 	u32 mode = stat->mode;
 
 	*rdev = 0;
@@ -144,7 +144,7 @@ static umode_t p9mode2unixmode(struct v9fs_session_info *v9ses,
 	else if ((mode & P9_DMDEVICE) && (v9fs_proto_dotu(v9ses))
 		 && (v9ses->nodev == 0)) {
 		char type = 0, ext[32];
-		int major = -1, minor = -1;
+		u32 major = 0, minor = 0;
 
 		strlcpy(ext, stat->extension, sizeof(ext));
 		sscanf(ext, "%c %u %u", &type, &major, &minor);
-- 
1.8.4

