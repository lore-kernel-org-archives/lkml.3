Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758956Ab3FCPqU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 11:46:20 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:33328 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758903Ab3FCPo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 11:44:59 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Jerome Marchand <jmarchan@redhat.com>
Cc: Yijing Wang <wangyijing@huawei.com>, Jiang Liu <jiang.liu@huawei.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v1 4/8] zram: destroy all devices on error recovery path in zram_init()
Date: Mon,  3 Jun 2013 23:42:16 +0800
Message-Id: <1370274140-26420-5-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370274140-26420-1-git-send-email-jiang.liu@huawei.com>
References: <1370274140-26420-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On error recovery path of zram_init(), it leaks the zram device object
causing the failure.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 drivers/staging/zram/zram_drv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 0738f6c..3d90344 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -712,8 +712,8 @@ static int __init zram_init(void)
 	return 0;
 
 free_devices:
-	while (dev_id)
-		destroy_device(&zram_devices[--dev_id]);
+	while (dev_id >= 0)
+		destroy_device(&zram_devices[dev_id--]);
 	kfree(zram_devices);
 unregister:
 	unregister_blkdev(zram_major, "zram");
-- 
1.8.1.2

