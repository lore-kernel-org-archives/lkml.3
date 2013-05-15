Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289Ab3EOJUH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 05:20:07 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:52373 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab3EOJUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 05:20:05 -0400
From: Leon Romanovsky <leon@leon.nu>
To: sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, Leon Romanovsky <leon@leon.nu>
Subject: [PATCH] drivers: mfd: tps65912: Convert to use devm_kzalloc
Date: Wed, 15 May 2013 12:19:46 +0300
Message-Id: <1368609586-20905-1-git-send-email-leon@leon.nu>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to call kfree while using devm_kzalloc,
remove it from *_device_init function.

Signed-off-by: Leon Romanovsky <leon@leon.nu>
---
 drivers/mfd/tps65912-core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/tps65912-core.c b/drivers/mfd/tps65912-core.c
index aeb8e40..f25e552 100644
--- a/drivers/mfd/tps65912-core.c
+++ b/drivers/mfd/tps65912-core.c
@@ -127,7 +127,8 @@ int tps65912_device_init(struct tps65912 *tps65912)
 	struct tps65912_platform_data *init_data;
 	int ret, dcdc_avs, value;
 
-	init_data = kzalloc(sizeof(struct tps65912_platform_data), GFP_KERNEL);
+	init_data = devm_kzalloc(&tps65912->dev,
+			sizeof(struct tps65912_platform_data), GFP_KERNEL);
 	if (init_data == NULL)
 		return -ENOMEM;
 
@@ -156,11 +157,9 @@ int tps65912_device_init(struct tps65912 *tps65912)
 	if (ret < 0)
 		goto err;
 
-	kfree(init_data);
 	return ret;
 
 err:
-	kfree(init_data);
 	mfd_remove_devices(tps65912->dev);
 	kfree(tps65912);
 	return ret;
-- 
1.8.1.5

