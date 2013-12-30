Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191Ab3L3UDh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 15:03:37 -0500
Received: from mail-gg0-f177.google.com ([209.85.161.177]:34980 "EHLO
	mail-gg0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932104Ab3L3UDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 15:03:36 -0500
From: Fabio Estevam <festevam@gmail.com>
To: broonie@kernel.org
Cc: linux-kernel@vger.kernel.org, Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] regulator: wm831x-dcdc: Remove unneeded 'err' label
Date: Mon, 30 Dec 2013 18:03:24 -0200
Message-Id: <1388433804-30541-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

There is no need to jump to the 'err' label.

Returnn the error directly instead.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/regulator/wm831x-dcdc.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/regulator/wm831x-dcdc.c b/drivers/regulator/wm831x-dcdc.c
index 6823e6f..04cf9c1 100644
--- a/drivers/regulator/wm831x-dcdc.c
+++ b/drivers/regulator/wm831x-dcdc.c
@@ -762,8 +762,7 @@ static int wm831x_boostp_probe(struct platform_device *pdev)
 	res = platform_get_resource(pdev, IORESOURCE_REG, 0);
 	if (res == NULL) {
 		dev_err(&pdev->dev, "No REG resource\n");
-		ret = -EINVAL;
-		goto err;
+		return -EINVAL;
 	}
 	dcdc->base = res->start;
 
@@ -788,7 +787,7 @@ static int wm831x_boostp_probe(struct platform_device *pdev)
 		ret = PTR_ERR(dcdc->regulator);
 		dev_err(wm831x->dev, "Failed to register DCDC%d: %d\n",
 			id + 1, ret);
-		goto err;
+		return ret;
 	}
 
 	irq = wm831x_irq(wm831x, platform_get_irq_byname(pdev, "UV"));
@@ -799,15 +798,12 @@ static int wm831x_boostp_probe(struct platform_device *pdev)
 	if (ret != 0) {
 		dev_err(&pdev->dev, "Failed to request UV IRQ %d: %d\n",
 			irq, ret);
-		goto err;
+		return ret;
 	}
 
 	platform_set_drvdata(pdev, dcdc);
 
 	return 0;
-
-err:
-	return ret;
 }
 
 static struct platform_driver wm831x_boostp_driver = {
-- 
1.8.1.2

