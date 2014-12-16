Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750996AbaLPKMX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 05:12:23 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:38573 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbaLPKMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 05:12:21 -0500
From: Bob Liu <bob.liu@oracle.com>
To: xen-devel@lists.xen.org
Cc: konrad.wilk@oracle.com, linux-kernel@vger.kernel.org,
        david.vrabel@citrix.com, Bob Liu <bob.liu@oracle.com>
Subject: [PATCH] xen/blkfront: increase the default value of xen_blkif_max_segments
Date: Tue, 16 Dec 2014 18:11:36 +0800
Message-Id: <1418724696-23922-1-git-send-email-bob.liu@oracle.com>
X-Mailer: git-send-email 1.7.10.4
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The default maximum value of segments in indirect requests was 32, IO
operations with bigger block size(>32*4k) would be split and performance start
to drop.

Nowadays backend device usually support 512k max_sectors_kb on desktop, and
may larger on server machines with high-end storage system.
The default size 128k was not very appropriate, this patch increases the default
maximum value to 128(128*4k=512k).

Signed-off-by: Bob Liu <bob.liu@oracle.com>
---
 drivers/block/xen-blkfront.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 2236c6f..1bf2429 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -94,9 +94,9 @@ static const struct block_device_operations xlvbd_block_fops;
  * by the backend driver.
  */
 
-static unsigned int xen_blkif_max_segments = 32;
+static unsigned int xen_blkif_max_segments = 128;
 module_param_named(max, xen_blkif_max_segments, int, S_IRUGO);
-MODULE_PARM_DESC(max, "Maximum amount of segments in indirect requests (default is 32)");
+MODULE_PARM_DESC(max, "Maximum amount of segments in indirect requests (default is 128)");
 
 #define BLK_RING_SIZE __CONST_RING_SIZE(blkif, PAGE_SIZE)
 
-- 
1.7.10.4

