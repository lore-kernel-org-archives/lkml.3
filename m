Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002AbaAPNQd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 08:16:33 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:47399 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963AbaAPNQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 08:16:29 -0500
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>, Jerome Marchand <jmarchan@redhat.com>,
        Nitin Gupta <ngupta@vflare.org>, linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCHv3 8/8] zram: move zram size warning to documentation
Date: Thu, 16 Jan 2014 16:12:16 +0300
Message-Id: <1389877936-15543-9-git-send-email-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 1.8.5.3.493.gb139ac2
In-Reply-To: <1389877936-15543-1-git-send-email-sergey.senozhatsky@gmail.com>
References: <1389877936-15543-1-git-send-email-sergey.senozhatsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move zram warning about disksize and size of memory correlation
to zram documentation.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---
 Documentation/blockdev/zram.txt |  5 +++++
 drivers/block/zram/zram_drv.c   | 15 ---------------
 2 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/Documentation/blockdev/zram.txt b/Documentation/blockdev/zram.txt
index 2eccddf..393541be 100644
--- a/Documentation/blockdev/zram.txt
+++ b/Documentation/blockdev/zram.txt
@@ -33,6 +33,11 @@ Following shows a typical sequence of steps for using zram.
             echo 512M > /sys/block/zram0/disksize
             echo 1G > /sys/block/zram0/disksize
 
+Note:
+There is little point creating a zram of greater than twice the size of memory
+since we expect a 2:1 compression ratio. Note that zram uses about 0.1% of the
+size of the disk when not in use so a huge zram is wasteful.
+
 3) Activate:
 	mkswap /dev/zram0
 	swapon /dev/zram0
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 9d67fbf..5ec61be 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -535,23 +535,8 @@ static void zram_reset_device(struct zram *zram, bool reset_capacity)
 
 static void zram_init_device(struct zram *zram, struct zram_meta *meta)
 {
-	if (zram->disksize > 2 * (totalram_pages << PAGE_SHIFT)) {
-		pr_info(
-		"There is little point creating a zram of greater than "
-		"twice the size of memory since we expect a 2:1 compression "
-		"ratio. Note that zram uses about 0.1%% of the size of "
-		"the disk when not in use so a huge zram is "
-		"wasteful.\n"
-		"\tMemory Size: %lu kB\n"
-		"\tSize you selected: %llu kB\n"
-		"Continuing anyway ...\n",
-		(totalram_pages << PAGE_SHIFT) >> 10, zram->disksize >> 10
-		);
-	}
-
 	/* zram devices sort of resembles non-rotational disks */
 	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, zram->disk->queue);
-
 	zram->meta = meta;
 	pr_debug("Initialization done!\n");
 }
-- 
1.8.5.3.493.gb139ac2

