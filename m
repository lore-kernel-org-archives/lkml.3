Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751021Ab3JNF06 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 01:26:58 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:57222 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722Ab3JNF05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 01:26:57 -0400
From: Manish Badarkhe <badarkhe.manish@gmail.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: badarkhe.manish@gmail.com, anton@enomsg.org, dwmw2@infradead.org
Subject: [PATCH] max17042_battery: use SIMPLE_DEV_PM_OPS
Date: Mon, 14 Oct 2013 10:56:51 +0530
Message-Id: <1381728411-21935-1-git-send-email-badarkhe.manish@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the SIMPLE_DEV_PM_OPS macro to declare the driver's
pm_ops.

Signed-off-by: Manish Badarkhe <badarkhe.manish@gmail.com>
---
:100644 100644 d664ef5... bd72b0f... M	drivers/power/max17042_battery.c
 drivers/power/max17042_battery.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/power/max17042_battery.c b/drivers/power/max17042_battery.c
index d664ef5..bd72b0f 100644
--- a/drivers/power/max17042_battery.c
+++ b/drivers/power/max17042_battery.c
@@ -786,7 +786,7 @@ static int max17042_remove(struct i2c_client *client)
 	return 0;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int max17042_suspend(struct device *dev)
 {
 	struct max17042_chip *chip = dev_get_drvdata(dev);
@@ -816,17 +816,11 @@ static int max17042_resume(struct device *dev)
 
 	return 0;
 }
-
-static const struct dev_pm_ops max17042_pm_ops = {
-	.suspend	= max17042_suspend,
-	.resume		= max17042_resume,
-};
-
-#define MAX17042_PM_OPS (&max17042_pm_ops)
-#else
-#define MAX17042_PM_OPS NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(max17042_pm_ops, max17042_suspend,
+			max17042_resume);
+
 #ifdef CONFIG_OF
 static const struct of_device_id max17042_dt_match[] = {
 	{ .compatible = "maxim,max17042" },
@@ -849,7 +843,7 @@ static struct i2c_driver max17042_i2c_driver = {
 	.driver	= {
 		.name	= "max17042",
 		.of_match_table = of_match_ptr(max17042_dt_match),
-		.pm	= MAX17042_PM_OPS,
+		.pm	= &max17042_pm_ops,
 	},
 	.probe		= max17042_probe,
 	.remove		= max17042_remove,
-- 
1.7.10.4

