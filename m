Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751803AbaDNHj2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 03:39:28 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:59901 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750807AbaDNHjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 03:39:04 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlcGADSPS1NXQ6NG/2dsb2JhbABagwbEK4EfF3SCUxMcIxiBAiQTiAAByxiOboQ/AQOYYAGKZIdfgzM7
Date: Mon, 14 Apr 2014 09:39:01 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Dave <shaggy@kernel.org>, Tytso <tytso@mit.edu>
Subject: [PATCH V2] fs/jfs/jfs_inode.c: atomically set inode->i_flags
Message-Id: <20140414093901.ea2d873d712ca4c8155d7827@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to commit 5f16f3225b0624

ext4: atomically set inode->i_flags in ext4_set_inode_flags()

Inspired-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Dave Kleikamp <shaggy@kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/jfs/jfs_inode.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/jfs/jfs_inode.c b/fs/jfs/jfs_inode.c
index 7f464c5..6b0f816 100644
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
1.8.3.2
