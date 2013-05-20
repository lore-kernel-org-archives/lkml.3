Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585Ab3ETNR6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 09:17:58 -0400
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:28057
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752710Ab3ETNR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 09:17:57 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 9
X-BigFish: VS9(z329eqzzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
From: Fabio Estevam <fabio.estevam@freescale.com>
To: <gregkh@linuxfoundation.org>
CC: <zbr@ioremap.net>, <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] w1-gpio: Let device core handle pinctrl
Date: Mon, 20 May 2013 10:16:39 -0300
Message-ID: <1369055799-9428-1-git-send-email-fabio.estevam@freescale.com>
X-Mailer: git-send-email 1.8.1.2
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
 drivers/w1/masters/w1-gpio.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/w1/masters/w1-gpio.c b/drivers/w1/masters/w1-gpio.c
index 46d9701..f54ece2 100644
--- a/drivers/w1/masters/w1-gpio.c
+++ b/drivers/w1/masters/w1-gpio.c
@@ -16,7 +16,6 @@
 #include <linux/gpio.h>
 #include <linux/of_platform.h>
 #include <linux/of_gpio.h>
-#include <linux/pinctrl/consumer.h>
 #include <linux/err.h>
 #include <linux/of.h>
 
@@ -78,13 +77,8 @@ static int w1_gpio_probe(struct platform_device *pdev)
 {
 	struct w1_bus_master *master;
 	struct w1_gpio_platform_data *pdata;
-	struct pinctrl *pinctrl;
 	int err;
 
-	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
-	if (IS_ERR(pinctrl))
-		dev_warn(&pdev->dev, "unable to select pin group\n");
-
 	if (of_have_populated_dt()) {
 		err = w1_gpio_probe_dt(pdev);
 		if (err < 0) {
-- 
1.8.1.2


