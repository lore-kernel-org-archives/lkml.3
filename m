Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553AbaAZHP4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 02:15:56 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:50066 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbaAZHPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 02:15:54 -0500
From: Manish Badarkhe <badarkhe.manish@gmail.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dbaryshkov@gmail.com, dwmw2@infradead.org, badarkhe.manish@gmail.com
Subject: [PATCH] max8925_power: Use "IS_ENABLED(CONFIG_OF)" for DT code.
Date: Sun, 26 Jan 2014 12:45:40 +0530
Message-Id: <1390720540-13350-1-git-send-email-badarkhe.manish@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of "#if define CONFIG_OF" use "IS_ENABLED(CONFIG_OF)"
option for DT code to avoid if-deffery in code.

Signed-off-by: Manish Badarkhe <badarkhe.manish@gmail.com>
---
:100644 100644 b4513f2... d353fbc... M	drivers/power/max8925_power.c
 drivers/power/max8925_power.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/power/max8925_power.c b/drivers/power/max8925_power.c
index b4513f2..d353fbc 100644
--- a/drivers/power/max8925_power.c
+++ b/drivers/power/max8925_power.c
@@ -427,7 +427,6 @@ static int max8925_deinit_charger(struct max8925_power_info *info)
 	return 0;
 }
 
-#ifdef CONFIG_OF
 static struct max8925_power_pdata *
 max8925_power_dt_init(struct platform_device *pdev)
 {
@@ -468,13 +467,6 @@ max8925_power_dt_init(struct platform_device *pdev)
 
 	return pdata;
 }
-#else
-static struct max8925_power_pdata *
-max8925_power_dt_init(struct platform_device *pdev)
-{
-	return pdev->dev.platform_data;
-}
-#endif
 
 static int max8925_power_probe(struct platform_device *pdev)
 {
@@ -483,7 +475,11 @@ static int max8925_power_probe(struct platform_device *pdev)
 	struct max8925_power_info *info;
 	int ret;
 
-	pdata = max8925_power_dt_init(pdev);
+	if (IS_ENABLED(CONFIG_OF))
+		pdata = max8925_power_dt_init(pdev);
+	else
+		pdata = pdev->dev.platform_data;
+
 	if (!pdata) {
 		dev_err(&pdev->dev, "platform data isn't assigned to "
 			"power supply\n");
-- 
1.7.10.4

