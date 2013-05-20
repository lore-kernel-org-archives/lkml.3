Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126Ab3ETN4K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 09:56:10 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:12327 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932087Ab3ETN4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 09:56:04 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 9
X-BigFish: VS9(z329eqzzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
From: Fabio Estevam <fabio.estevam@freescale.com>
To: <gregkh@linuxfoundation.org>
CC: <kernel@pengutronix.de>, <shawn.guo@linaro.org>,
        <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH 3/3] imx-drm: parallel-display: Let device core handle pinctrl
Date: Mon, 20 May 2013 10:55:51 -0300
Message-ID: <1369058151-24986-3-git-send-email-fabio.estevam@freescale.com>
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
 drivers/staging/imx-drm/parallel-display.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/staging/imx-drm/parallel-display.c b/drivers/staging/imx-drm/parallel-display.c
index e7fba62..f324ed3 100644
--- a/drivers/staging/imx-drm/parallel-display.c
+++ b/drivers/staging/imx-drm/parallel-display.c
@@ -23,7 +23,6 @@
 #include <drm/drm_fb_helper.h>
 #include <drm/drm_crtc_helper.h>
 #include <linux/videodev2.h>
-#include <linux/pinctrl/consumer.h>
 
 #include "imx-drm.h"
 
@@ -206,20 +205,11 @@ static int imx_pd_probe(struct platform_device *pdev)
 	struct imx_parallel_display *imxpd;
 	int ret;
 	const char *fmt;
-	struct pinctrl *pinctrl;
 
 	imxpd = devm_kzalloc(&pdev->dev, sizeof(*imxpd), GFP_KERNEL);
 	if (!imxpd)
 		return -ENOMEM;
 
-	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
-	if (IS_ERR(pinctrl)) {
-		ret = PTR_ERR(pinctrl);
-		dev_warn(&pdev->dev, "pinctrl_get_select_default failed with %d",
-				ret);
-		return ret;
-	}
-
 	edidp = of_get_property(np, "edid", &imxpd->edid_len);
 	if (edidp)
 		imxpd->edid = kmemdup(edidp, imxpd->edid_len, GFP_KERNEL);
-- 
1.8.1.2


