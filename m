Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744AbaLVWRg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 17:17:36 -0500
Received: from sauhun.de ([89.238.76.85]:53780 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754781AbaLVWRe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 17:17:34 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: linux-gpio@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        Nicolas Pitre <nico@fluxnic.net>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>, linux-mmc@vger.kernel.org
Subject: [PATCH 2/3] mmc: host: don't use devm_pinctrl_get_select_default() in probe
Date: Mon, 22 Dec 2014 23:16:54 +0100
Message-Id: <1419286616-9893-2-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419286616-9893-1-git-send-email-wsa@the-dreams.de>
References: <1419286616-9893-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit ab78029ecc34 (drivers/pinctrl: grab default handles from device
core), we can rely on device core for setting the default pins.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/mmc/host/mvsdio.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/mmc/host/mvsdio.c b/drivers/mmc/host/mvsdio.c
index 4f8618f4522d..a2cb92851f1f 100644
--- a/drivers/mmc/host/mvsdio.c
+++ b/drivers/mmc/host/mvsdio.c
@@ -25,7 +25,6 @@
 #include <linux/of_irq.h>
 #include <linux/mmc/host.h>
 #include <linux/mmc/slot-gpio.h>
-#include <linux/pinctrl/consumer.h>
 
 #include <asm/sizes.h>
 #include <asm/unaligned.h>
@@ -704,7 +703,6 @@ static int mvsd_probe(struct platform_device *pdev)
 	const struct mbus_dram_target_info *dram;
 	struct resource *r;
 	int ret, irq;
-	struct pinctrl *pinctrl;
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	irq = platform_get_irq(pdev, 0);
@@ -721,10 +719,6 @@ static int mvsd_probe(struct platform_device *pdev)
 	host->mmc = mmc;
 	host->dev = &pdev->dev;
 
-	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
-	if (IS_ERR(pinctrl))
-		dev_warn(&pdev->dev, "no pins associated\n");
-
 	/*
 	 * Some non-DT platforms do not pass a clock, and the clock
 	 * frequency is passed through platform_data. On DT platforms,
-- 
2.1.3

