Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661AbaLCL3p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:29:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54626 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653AbaLCL1t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:49 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Fabian Frederick <fabf@skynet.be>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 100/101] fs/jfs/jfs_inode.c: atomically set inode->i_flags
Date: Wed,  3 Dec 2014 12:27:02 +0100
Message-Id: <7e3bea443c47e2f499d7547dbabafbaacfa2f8e6.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 24e4a0f3de21ad715c9235367e241554c64b9adb upstream.

According to commit 5f16f3225b0624

ext4: atomically set inode->i_flags in ext4_set_inode_flags()

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/jfs/jfs_inode.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/jfs/jfs_inode.c b/fs/jfs/jfs_inode.c
index 7f464c513ba0..6b0f816201a2 100644
--- a/fs/jfs/jfs_inode.c
+++ b/fs/jfs/jfs_inode.c
@@ -29,20 +29,20 @@
 void jfs_set_inode_flags(struct inode *inode)
 {
 	unsigned int flags = JFS_IP(inode)->mode2;
-
-	inode->i_flags &= ~(S_IMMUTABLE | S_APPEND |
-		S_NOATIME | S_DIRSYNC | S_SYNC);
+	unsigned int new_fl = 0;
 
 	if (flags & JFS_IMMUTABLE_FL)
-		inode->i_flags |= S_IMMUTABLE;
+		new_fl |= S_IMMUTABLE;
 	if (flags & JFS_APPEND_FL)
-		inode->i_flags |= S_APPEND;
+		new_fl |= S_APPEND;
 	if (flags & JFS_NOATIME_FL)
-		inode->i_flags |= S_NOATIME;
+		new_fl |= S_NOATIME;
 	if (flags & JFS_DIRSYNC_FL)
-		inode->i_flags |= S_DIRSYNC;
+		new_fl |= S_DIRSYNC;
 	if (flags & JFS_SYNC_FL)
-		inode->i_flags |= S_SYNC;
+		new_fl |= S_SYNC;
+	inode_set_flags(inode, new_fl, S_IMMUTABLE | S_APPEND | S_NOATIME |
+			S_DIRSYNC | S_SYNC);
 }
 
 void jfs_get_inode_flags(struct jfs_inode_info *jfs_ip)
-- 
2.1.3

