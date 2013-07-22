Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332Ab3GVBTz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 21:19:55 -0400
Received: from mail-ye0-f180.google.com ([209.85.213.180]:33285 "EHLO
	mail-ye0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319Ab3GVBTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 21:19:53 -0400
From: Fabio Estevam <festevam@gmail.com>
To: gregkh@linuxfoundation.org
Cc: kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] imx-drm: imx-tve: Remove unneeded check for platform_get_resource()
Date: Sun, 21 Jul 2013 22:19:42 -0300
Message-Id: <1374455982-18055-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

As devm_ioremap_resource() is used on probe, there is no need to explicitly 
check the return value from platform_get_resource(), as this is something that
devm_ioremap_resource() takes care by itself.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/staging/imx-drm/imx-tve.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/staging/imx-drm/imx-tve.c b/drivers/staging/imx-drm/imx-tve.c
index a56797d..8232cea 100644
--- a/drivers/staging/imx-drm/imx-tve.c
+++ b/drivers/staging/imx-drm/imx-tve.c
@@ -623,11 +623,6 @@ static int imx_tve_probe(struct platform_device *pdev)
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "failed to get memory region\n");
-		return -ENOENT;
-	}
-
 	base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(base))
 		return PTR_ERR(base);
-- 
1.8.1.2

