Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639Ab3GVBWH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 21:22:07 -0400
Received: from mail-yh0-f53.google.com ([209.85.213.53]:52984 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021Ab3GVBWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 21:22:02 -0400
From: Fabio Estevam <festevam@gmail.com>
To: linus.walleij@linaro.org
Cc: shawn.guo@linaro.org, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] pinctrl: pinctrl-imx: Remove unneeded check for platform_get_resource()
Date: Sun, 21 Jul 2013 22:16:21 -0300
Message-Id: <1374455781-17905-1-git-send-email-festevam@gmail.com>
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
 drivers/pinctrl/pinctrl-imx.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-imx.c b/drivers/pinctrl/pinctrl-imx.c
index 57a4eb0..dea739a 100644
--- a/drivers/pinctrl/pinctrl-imx.c
+++ b/drivers/pinctrl/pinctrl-imx.c
@@ -580,9 +580,6 @@ int imx_pinctrl_probe(struct platform_device *pdev,
 		return -ENOMEM;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENOENT;
-
 	ipctl->base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(ipctl->base))
 		return PTR_ERR(ipctl->base);
-- 
1.8.1.2

