Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588Ab3AXKUV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 05:20:21 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:33365 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396Ab3AXKUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 05:20:10 -0500
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: w.sang@pengutronix.de, kgene.kim@samsung.com, patches@linaro.org
Subject: [PATCH V3 1/4] i2c: s3c2410: Remove unnecessary label err_noclk
Date: Thu, 24 Jan 2013 15:41:06 +0530
Message-Id: <1359022269-12593-2-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1359022269-12593-1-git-send-email-tushar.behera@linaro.org>
References: <1359022269-12593-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

err_noclk label redirects to a simple return statement. Move the
return statement to the caller location and remove the label.

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
Changes since V2:
  * Rebased to v3.8-rc4.

 drivers/i2c/busses/i2c-s3c2410.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
index a290d08..b7ca1f4 100644
--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -1000,8 +1000,8 @@ static int s3c24xx_i2c_probe(struct platform_device *pdev)
 
 	i2c->pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
 	if (!i2c->pdata) {
-		ret = -ENOMEM;
-		goto err_noclk;
+		dev_err(&pdev->dev, "no memory for platform data\n");
+		return -ENOMEM;
 	}
 
 	i2c->quirks = s3c24xx_get_device_quirks(pdev);
@@ -1025,8 +1025,7 @@ static int s3c24xx_i2c_probe(struct platform_device *pdev)
 	i2c->clk = clk_get(&pdev->dev, "i2c");
 	if (IS_ERR(i2c->clk)) {
 		dev_err(&pdev->dev, "cannot get clock\n");
-		ret = -ENOENT;
-		goto err_noclk;
+		return -ENOENT;
 	}
 
 	dev_dbg(&pdev->dev, "clock source %p\n", i2c->clk);
@@ -1133,8 +1132,6 @@ static int s3c24xx_i2c_probe(struct platform_device *pdev)
  err_clk:
 	clk_disable_unprepare(i2c->clk);
 	clk_put(i2c->clk);
-
- err_noclk:
 	return ret;
 }
 
-- 
1.7.4.1

