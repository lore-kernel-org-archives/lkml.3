Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901AbaL1OVy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 09:21:54 -0500
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:59121 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751824AbaL1OVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 09:21:52 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnUNAGQRoFRXQ78c/2dsb2JhbABcgwaBKrQeBgEBAQEBBQF3lzaBCxcBAQEBAX2EOi8jgRo3iDABtT+PIoYDiXQdhBMFjXSJFIlnh2kigUUBgik9MYJDAQEB
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 1/1 linux-next] fs/affs/file.c: replace if/BUG by BUG_ON
Date: Sun, 28 Dec 2014 15:21:46 +0100
Message-Id: <1419776506-31594-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/affs/file.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/affs/file.c b/fs/affs/file.c
index 8faa659..e1b51e5 100644
--- a/fs/affs/file.c
+++ b/fs/affs/file.c
@@ -180,8 +180,7 @@ affs_get_extblock_slow(struct inode *inode, u32 ext)
 		ext_key = be32_to_cpu(AFFS_TAIL(sb, bh)->extension);
 		if (ext < AFFS_I(inode)->i_extcnt)
 			goto read_ext;
-		if (ext > AFFS_I(inode)->i_extcnt)
-			BUG();
+		BUG_ON(ext > AFFS_I(inode)->i_extcnt);
 		bh = affs_alloc_extblock(inode, bh, ext);
 		if (IS_ERR(bh))
 			return bh;
@@ -198,8 +197,7 @@ affs_get_extblock_slow(struct inode *inode, u32 ext)
 		struct buffer_head *prev_bh;
 
 		/* allocate a new extended block */
-		if (ext > AFFS_I(inode)->i_extcnt)
-			BUG();
+		BUG_ON(ext > AFFS_I(inode)->i_extcnt);
 
 		/* get previous extended block */
 		prev_bh = affs_get_extblock(inode, ext - 1);
-- 
2.1.0

