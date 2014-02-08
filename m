Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751786AbaBHQYv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 11:24:51 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:39201 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbaBHQYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 11:24:50 -0500
Date: Sat, 8 Feb 2014 21:54:44 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, josh@joshtriplett.org
Subject: [PATCH 1/2] block: Mark function as static in blk-lib.c
Message-ID: <7dce86ade62eada14e58bb334bb9b7bd87627b68.1391876538.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark function as static in blk-lib.c because it is not used outside this
file.

This eliminates the following warning in blk-lib.c:
block/blk-lib.c:221:5: warning: no previous prototype for ‘__blkdev_issue_zeroout’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---
 block/blk-lib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 2da76c9..332e7a9 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -218,7 +218,7 @@ EXPORT_SYMBOL(blkdev_issue_write_same);
  *  Generate and issue number of bios with zerofiled pages.
  */
 
-int __blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
+static int __blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 			sector_t nr_sects, gfp_t gfp_mask)
 {
 	int ret;
-- 
1.7.9.5

