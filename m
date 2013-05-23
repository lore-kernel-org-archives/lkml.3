Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759516Ab3EWPZc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 11:25:32 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:44249 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759496Ab3EWPZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 11:25:31 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, sameo@linux.intel.com
Cc: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 01/16] mfd: tps65912: Convert to managed resources for allocating memory
Date: Thu, 23 May 2013 16:25:02 +0100
Message-Id: <1369322717-30429-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Saves on code and simplifies the driver, as these resources are now
tracked and freed automatically when the driver is realised.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/tps65912-core.c |    2 --
 drivers/mfd/tps65912-i2c.c  |    3 ++-
 drivers/mfd/tps65912-spi.c  |    3 ++-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/tps65912-core.c b/drivers/mfd/tps65912-core.c
index f91037a..7035743 100644
--- a/drivers/mfd/tps65912-core.c
+++ b/drivers/mfd/tps65912-core.c
@@ -161,7 +161,6 @@ int tps65912_device_init(struct tps65912 *tps65912)
 
 err:
 	mfd_remove_devices(tps65912->dev);
-	kfree(tps65912);
 	return ret;
 }
 
@@ -169,7 +168,6 @@ void tps65912_device_exit(struct tps65912 *tps65912)
 {
 	mfd_remove_devices(tps65912->dev);
 	tps65912_irq_exit(tps65912);
-	kfree(tps65912);
 }
 
 MODULE_AUTHOR("Margarita Olaya	<magi@slimlogic.co.uk>");
diff --git a/drivers/mfd/tps65912-i2c.c b/drivers/mfd/tps65912-i2c.c
index c041f2c..6a6343e 100644
--- a/drivers/mfd/tps65912-i2c.c
+++ b/drivers/mfd/tps65912-i2c.c
@@ -77,7 +77,8 @@ static int tps65912_i2c_probe(struct i2c_client *i2c,
 {
 	struct tps65912 *tps65912;
 
-	tps65912 = kzalloc(sizeof(struct tps65912), GFP_KERNEL);
+	tps65912 = devm_kzalloc(&i2c->dev,
+				sizeof(struct tps65912), GFP_KERNEL);
 	if (tps65912 == NULL)
 		return -ENOMEM;
 
diff --git a/drivers/mfd/tps65912-spi.c b/drivers/mfd/tps65912-spi.c
index b45f460..69a5178 100644
--- a/drivers/mfd/tps65912-spi.c
+++ b/drivers/mfd/tps65912-spi.c
@@ -85,7 +85,8 @@ static int tps65912_spi_probe(struct spi_device *spi)
 {
 	struct tps65912 *tps65912;
 
-	tps65912 = kzalloc(sizeof(struct tps65912), GFP_KERNEL);
+	tps65912 = devm_kzalloc(&spi->dev,
+				sizeof(struct tps65912), GFP_KERNEL);
 	if (tps65912 == NULL)
 		return -ENOMEM;
 
-- 
1.7.10.4

