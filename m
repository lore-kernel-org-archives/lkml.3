Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551Ab3FDQJI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 12:09:08 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:44981 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755792Ab3FDQJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 12:09:03 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Jerome Marchand <jmarchan@redhat.com>
Cc: Yijing Wang <wangyijing@huawei.com>, Jiang Liu <jiang.liu@huawei.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 09/10] zram: minor code cleanup
Date: Wed,  5 Jun 2013 00:06:07 +0800
Message-Id: <1370361968-8764-9-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370361968-8764-1-git-send-email-jiang.liu@huawei.com>
References: <1370361968-8764-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minor code cleanup for zram.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 drivers/staging/zram/zram_drv.c   | 11 ++++-------
 drivers/staging/zram/zram_sysfs.c |  3 +--
 2 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index a4595ca..088bd6a 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -481,13 +481,11 @@ static void __zram_reset_device(struct zram *zram)
 	/* Free all pages that are still in this zram device */
 	for (index = 0; index < zram->disksize >> PAGE_SHIFT; index++) {
 		unsigned long handle = meta->table[index].handle;
-		if (!handle)
-			continue;
-
-		zs_free(meta->mem_pool, handle);
+		if (handle)
+			zs_free(meta->mem_pool, handle);
 	}
 
-	zram_meta_free(zram->meta);
+	zram_meta_free(meta);
 	zram->meta = NULL;
 	/* Reset stats */
 	memset(&zram->stats, 0, sizeof(zram->stats));
@@ -686,8 +684,7 @@ static int __init zram_init(void)
 	int ret, dev_id;
 
 	if (num_devices > max_num_devices) {
-		pr_warn("Invalid value for num_devices: %u\n",
-				num_devices);
+		pr_warn("Invalid value for num_devices: %u\n", num_devices);
 		ret = -EINVAL;
 		goto out;
 	}
diff --git a/drivers/staging/zram/zram_sysfs.c b/drivers/staging/zram/zram_sysfs.c
index e239d94..2ae6b50 100644
--- a/drivers/staging/zram/zram_sysfs.c
+++ b/drivers/staging/zram/zram_sysfs.c
@@ -187,8 +187,7 @@ static ssize_t mem_used_total_show(struct device *dev,
 	return sprintf(buf, "%llu\n", val);
 }
 
-static DEVICE_ATTR(disksize, S_IRUGO | S_IWUSR,
-		disksize_show, disksize_store);
+static DEVICE_ATTR(disksize, S_IRUGO | S_IWUSR, disksize_show, disksize_store);
 static DEVICE_ATTR(initstate, S_IRUGO, initstate_show, NULL);
 static DEVICE_ATTR(reset, S_IWUSR, NULL, reset_store);
 static DEVICE_ATTR(num_reads, S_IRUGO, num_reads_show, NULL);
-- 
1.8.1.2

