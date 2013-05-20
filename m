Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074Ab3ETN4E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 09:56:04 -0400
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:9202 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756940Ab3ETN4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 09:56:00 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 9
X-BigFish: VS9(z329eqzzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
From: Fabio Estevam <fabio.estevam@freescale.com>
To: <gregkh@linuxfoundation.org>
CC: <kernel@pengutronix.de>, <shawn.guo@linaro.org>,
        <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH 2/3] imx-drm: imx-tve: Let device core handle pinctrl
Date: Mon, 20 May 2013 10:55:50 -0300
Message-ID: <1369058151-24986-2-git-send-email-fabio.estevam@freescale.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369058151-24986-1-git-send-email-fabio.estevam@freescale.com>
References: <1369058151-24986-1-git-send-email-fabio.estevam@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit ab78029 (drivers/pinctrl: grab default handles from device core)
we can rely on device core for handling pinctrl, so remove 
devm_pinctrl_get_select_default() from the driver.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/staging/imx-drm/imx-tve.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/staging/imx-drm/imx-tve.c b/drivers/staging/imx-drm/imx-tve.c
index ce65ad3..a56797d 100644
--- a/drivers/staging/imx-drm/imx-tve.c
+++ b/drivers/staging/imx-drm/imx-tve.c
@@ -22,7 +22,6 @@
 #include <linux/clk-provider.h>
 #include <linux/module.h>
 #include <linux/of_i2c.h>
-#include <linux/pinctrl/consumer.h>
 #include <linux/regmap.h>
 #include <linux/regulator/consumer.h>
 #include <linux/spinlock.h>
@@ -610,15 +609,6 @@ static int imx_tve_probe(struct platform_device *pdev)
 	}
 
 	if (tve->mode == TVE_MODE_VGA) {
-		struct pinctrl *pinctrl;
-
-		pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
-		if (IS_ERR(pinctrl)) {
-			ret = PTR_ERR(pinctrl);
-			dev_warn(&pdev->dev, "failed to setup pinctrl: %d", ret);
-			return ret;
-		}
-
 		ret = of_property_read_u32(np, "fsl,hsync-pin", &tve->hsync_pin);
 		if (ret < 0) {
 			dev_err(&pdev->dev, "failed to get vsync pin\n");
-- 
1.8.1.2


