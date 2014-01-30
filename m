Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751201AbaA3HcI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 02:32:08 -0500
Received: from mail-ae1-f3.auone-net.jp ([106.187.231.3]:45246 "EHLO
	dmta01.auone-net.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751058AbaA3HcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 02:32:05 -0500
Date: Thu, 30 Jan 2014 16:32:02 +0900
From: Kusanagi Kouichi <slash@ac.auone-net.jp>
To: linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs: Return EXDEV for cross file system snapshot
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Message-Id: <52e9fff3000260ca00006df700005bb6e0000bb51ac1@amlmta038.auone-net.jp>
X-MXM-DELIVERY-TYPE: 3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EXDEV seems an appropriate error if an operation fails bacause it
crosses file system boundaries.

Signed-off-by: Kusanagi Kouichi <slash@ac.auone-net.jp>
---
 fs/btrfs/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 34772cb..0176045 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1573,7 +1573,7 @@ static noinline int btrfs_ioctl_snap_create_transid(struct file *file,
 		if (src_inode->i_sb != file_inode(file)->i_sb) {
 			btrfs_info(BTRFS_I(src_inode)->root->fs_info,
 				   "Snapshot src from another FS");
-			ret = -EINVAL;
+			ret = -EXDEV;
 		} else if (!inode_owner_or_capable(src_inode)) {
 			/*
 			 * Subvolume creation is not restricted, but snapshots
-- 
1.9.rc1

