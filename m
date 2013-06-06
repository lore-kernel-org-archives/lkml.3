Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481Ab3FFQL0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 12:11:26 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:43858 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344Ab3FFQLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 12:11:23 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Jerome Marchand <jmarchan@redhat.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 08/10] zram: kill unused zram_get_num_devices()
Date: Fri,  7 Jun 2013 00:07:29 +0800
Message-Id: <1370534851-26056-9-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370534851-26056-1-git-send-email-jiang.liu@huawei.com>
References: <1370534851-26056-1-git-send-email-jiang.liu@huawei.com>
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
index 9289217..5e6545a 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -37,7 +37,7 @@
 
 /* Globals */
 static int zram_major;
-struct zram *zram_devices;
+static struct zram *zram_devices;
 
 /* Module params (documentation at end) */
 static unsigned int num_devices = 1;
@@ -679,11 +679,6 @@ static void destroy_device(struct zram *zram)
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
index d542eee..b3a315d 100644
--- a/drivers/staging/zram/zram_drv.h
+++ b/drivers/staging/zram/zram_drv.h
@@ -110,8 +110,6 @@ struct zram {
 	struct zram_stats stats;
 };
 
-extern struct zram *zram_devices;
-unsigned int zram_get_num_devices(void);
 #ifdef CONFIG_SYSFS
 extern struct attribute_group zram_disk_attr_group;
 #endif
-- 
1.8.1.2

