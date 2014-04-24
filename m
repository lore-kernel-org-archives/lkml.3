Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287AbaDXQZ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 12:25:58 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:47630 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753515AbaDXQZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 12:25:44 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlMWALw5WVNbsls8/2dsb2JhbABZgwaCXoEGqAqZagICgRsXdIJTExwjGIECJBOIRQHLZY5YhEABA45siggBim2HaYMzOw
Date: Thu, 24 Apr 2014 18:27:43 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/befs/linuxvfs.c: remove positive test on sector_t
Message-Id: <20140424182743.a7eee7499d25acf903a79758@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sector_t is unsigned.

Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/befs/linuxvfs.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
index d626756..6361871 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -133,14 +133,6 @@ befs_get_block(struct inode *inode, sector_t block,
 
 	befs_debug(sb, "---> befs_get_block() for inode %lu, block %ld",
 		   (unsigned long)inode->i_ino, (long)block);
-
-	if (block < 0) {
-		befs_error(sb, "befs_get_block() was asked for a block "
-			   "number less than zero: block %ld in inode %lu",
-			   (long)block, (unsigned long)inode->i_ino);
-		return -EIO;
-	}
-
 	if (create) {
 		befs_error(sb, "befs_get_block() was asked to write to "
 			   "block %ld in inode %lu", (long)block,
-- 
1.8.4.5

