Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758877Ab3FCPou (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 11:44:50 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:36056 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756694Ab3FCPor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 11:44:47 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Jerome Marchand <jmarchan@redhat.com>
Cc: Yijing Wang <wangyijing@huawei.com>, Jiang Liu <jiang.liu@huawei.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v1 1/8] zram: simplify and optimize zram_to_dev()
Date: Mon,  3 Jun 2013 23:42:13 +0800
Message-Id: <1370274140-26420-2-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370274140-26420-1-git-send-email-jiang.liu@huawei.com>
References: <1370274140-26420-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 drivers/staging/zram/zram_sysfs.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/zram/zram_sysfs.c b/drivers/staging/zram/zram_sysfs.c
index e6a929d..8cb7822 100644
--- a/drivers/staging/zram/zram_sysfs.c
+++ b/drivers/staging/zram/zram_sysfs.c
@@ -30,18 +30,9 @@ static u64 zram_stat64_read(struct zram *zram, u64 *v)
 	return val;
 }
 
-static struct zram *dev_to_zram(struct device *dev)
+static inline struct zram *dev_to_zram(struct device *dev)
 {
-	int i;
-	struct zram *zram = NULL;
-
-	for (i = 0; i < zram_get_num_devices(); i++) {
-		zram = &zram_devices[i];
-		if (disk_to_dev(zram->disk) == dev)
-			break;
-	}
-
-	return zram;
+	return (struct zram *)dev_to_disk(dev)->private_data;
 }
 
 static ssize_t disksize_show(struct device *dev,
-- 
1.8.1.2

