Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905Ab3FDQId (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 12:08:33 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:63764 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755425Ab3FDQIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 12:08:32 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Jerome Marchand <jmarchan@redhat.com>
Cc: Yijing Wang <wangyijing@huawei.com>, Jiang Liu <jiang.liu@huawei.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 01/10] zram: kill unused zram_get_num_devices()
Date: Wed,  5 Jun 2013 00:05:59 +0800
Message-Id: <1370361968-8764-1-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now there's no caller of zram_get_num_devices(), so kill it.
And change zram_devices to static because it's only used in zram_drv.c.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 drivers/staging/zram/zram_drv.c | 7 +------
 drivers/staging/zram/zram_drv.h | 2 --
 2 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index e34e3fe..0a07de4 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -37,7 +37,7 @@
 
 /* Globals */
 static int zram_major;
-struct zram *zram_devices;
+static struct zram *zram_devices;
 
 /* Module params (documentation at end) */
 static unsigned int num_devices = 1;
@@ -669,11 +669,6 @@ static void destroy_device(struct zram *zram)
 		blk_cleanup_queue(zram->queue);
 }
 
-unsigned int zram_get_num_devices(void)
-{
-	return num_devices;
-}
-
 static int __init zram_init(void)
 {
 	int ret, dev_id;
diff --git a/drivers/staging/zram/zram_drv.h b/drivers/staging/zram/zram_drv.h
index 2d1a3f1..a18b66d 100644
--- a/drivers/staging/zram/zram_drv.h
+++ b/drivers/staging/zram/zram_drv.h
@@ -109,8 +109,6 @@ struct zram {
 	struct zram_stats stats;
 };
 
-extern struct zram *zram_devices;
-unsigned int zram_get_num_devices(void);
 #ifdef CONFIG_SYSFS
 extern struct attribute_group zram_disk_attr_group;
 #endif
-- 
1.8.1.2

