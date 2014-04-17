Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162AbaDQP5j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 11:57:39 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:29643 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752479AbaDQP5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 11:57:08 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao0UAJ/4T1Nbsma4/2dsb2JhbABZgwarGJlWAgKBJBd0glMTHCMYahgkE4doAxUBxCINhwKMSYIZhD8BA5cAgW0BimqCE4VQgzM7
Date: Thu, 17 Apr 2014 17:54:59 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>, tytso <tytso@mit.edu>
Subject: [PATCH 1/1] fs/ubifs/ioctl.c: atomically set inode->i_flags
Message-Id: <20140417175459.6cbd49e16ce30724b7638607@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to commit 5f16f3225b0624

ext4: atomically set inode->i_flags in ext4_set_inode_flags()

Inspired-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ubifs/ioctl.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/ubifs/ioctl.c b/fs/ubifs/ioctl.c
index 648b143..26f416e 100644
--- a/fs/ubifs/ioctl.c
+++ b/fs/ubifs/ioctl.c
@@ -37,16 +37,18 @@
 void ubifs_set_inode_flags(struct inode *inode)
 {
 	unsigned int flags = ubifs_inode(inode)->flags;
+	unsigned int new_fl = 0;
 
-	inode->i_flags &= ~(S_SYNC | S_APPEND | S_IMMUTABLE | S_DIRSYNC);
 	if (flags & UBIFS_SYNC_FL)
-		inode->i_flags |= S_SYNC;
+		new_fl |= S_SYNC;
 	if (flags & UBIFS_APPEND_FL)
-		inode->i_flags |= S_APPEND;
+		new_fl |= S_APPEND;
 	if (flags & UBIFS_IMMUTABLE_FL)
-		inode->i_flags |= S_IMMUTABLE;
+		new_fl |= S_IMMUTABLE;
 	if (flags & UBIFS_DIRSYNC_FL)
-		inode->i_flags |= S_DIRSYNC;
+		new_fl |= S_DIRSYNC;
+	inode_set_flags(inode, new_fl, S_SYNC | S_APPEND | S_IMMUTABLE |
+			S_DIRSYNC);
 }
 
 /*
-- 
1.8.4.5

