Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954Ab3EFSGh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 14:06:37 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:28863
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754278Ab3EFSGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 14:06:35 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 9
X-BigFish: VS9(z329eqzzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bh8275dhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
From: Fabio Estevam <fabio.estevam@freescale.com>
To: <shawn.guo@linaro.org>
CC: <kernel@pengutronix.de>, <festevam@gmail.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 06/13] pwm: pwm-mxs: Let device core handle pinctrl
Date: Mon, 6 May 2013 15:05:54 -0300
Message-ID: <1367863561-11534-6-git-send-email-fabio.estevam@freescale.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1367863561-11534-1-git-send-email-fabio.estevam@freescale.com>
References: <1367863561-11534-1-git-send-email-fabio.estevam@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit ab78029 (drivers/pinctrl: grab default handles from device core),
we can rely on device core for handling pinctrl.

So remove devm_pinctrl_get_select_default() from the driver. 

Cc: Thierry Reding <thierry.reding@avionic-design.de>
Cc: <linux-kernel@vger.kernel.org>
Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/pwm/pwm-mxs.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/pwm/pwm-mxs.c b/drivers/pwm/pwm-mxs.c
index a53d309..7dd6544 100644
--- a/drivers/pwm/pwm-mxs.c
+++ b/drivers/pwm/pwm-mxs.c
@@ -16,7 +16,6 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
-#include <linux/pinctrl/consumer.h>
 #include <linux/platform_device.h>
 #include <linux/pwm.h>
 #include <linux/slab.h>
@@ -131,7 +130,6 @@ static int mxs_pwm_probe(struct platform_device *pdev)
 	struct device_node *np = pdev->dev.of_node;
 	struct mxs_pwm_chip *mxs;
 	struct resource *res;
-	struct pinctrl *pinctrl;
 	int ret;
 
 	mxs = devm_kzalloc(&pdev->dev, sizeof(*mxs), GFP_KERNEL);
@@ -143,10 +141,6 @@ static int mxs_pwm_probe(struct platform_device *pdev)
 	if (IS_ERR(mxs->base))
 		return PTR_ERR(mxs->base);
 
-	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
-	if (IS_ERR(pinctrl))
-		return PTR_ERR(pinctrl);
-
 	mxs->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(mxs->clk))
 		return PTR_ERR(mxs->clk);
-- 
1.7.9.5


