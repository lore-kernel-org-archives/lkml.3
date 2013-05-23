Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759914Ab3EWP3b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 11:29:31 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:41956 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759559Ab3EWPZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 11:25:42 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, sameo@linux.intel.com
Cc: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 05/16] mfd: ab8500-gpadc: Convert to managed resources for allocating memory
Date: Thu, 23 May 2013 16:25:06 +0100
Message-Id: <1369322717-30429-5-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1369322717-30429-1-git-send-email-lee.jones@linaro.org>
References: <1369322717-30429-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/ab8500-gpadc.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/mfd/ab8500-gpadc.c b/drivers/mfd/ab8500-gpadc.c
index 13f7866..f1d4565 100644
--- a/drivers/mfd/ab8500-gpadc.c
+++ b/drivers/mfd/ab8500-gpadc.c
@@ -925,7 +925,7 @@ static int ab8500_gpadc_probe(struct platform_device *pdev)
 	int ret = 0;
 	struct ab8500_gpadc *gpadc;
 
-	gpadc = kzalloc(sizeof(struct ab8500_gpadc), GFP_KERNEL);
+	gpadc = devm_kzalloc(&pdev->dev, sizeof(struct ab8500_gpadc), GFP_KERNEL);
 	if (!gpadc) {
 		dev_err(&pdev->dev, "Error: No memory\n");
 		return -ENOMEM;
@@ -1005,8 +1005,6 @@ fail_irq:
 	free_irq(gpadc->irq_sw, gpadc);
 	free_irq(gpadc->irq_hw, gpadc);
 fail:
-	kfree(gpadc);
-	gpadc = NULL;
 	return ret;
 }
 
@@ -1031,8 +1029,6 @@ static int ab8500_gpadc_remove(struct platform_device *pdev)
 
 	pm_runtime_put_noidle(gpadc->dev);
 
-	kfree(gpadc);
-	gpadc = NULL;
 	return 0;
 }
 
-- 
1.7.10.4

