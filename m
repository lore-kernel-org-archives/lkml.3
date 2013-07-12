Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932920Ab3GLLar (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 07:30:47 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:52595 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932757Ab3GLLaq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 07:30:46 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
CC: <linux-gpio@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] GPIO: gpio-twl6040: Remove support for legacy (pdata) mode
Date: Fri, 12 Jul 2013 13:30:43 +0200
Message-ID: <1373628643-11360-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.2.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TWL6040 is used only with OMAP4/5 SoCs and they can only boot in in DT mode.
The support for pdata/legacy boot can be removed.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/gpio/gpio-twl6040.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/gpio/gpio-twl6040.c b/drivers/gpio/gpio-twl6040.c
index 0be82c6..d420d30 100644
--- a/drivers/gpio/gpio-twl6040.c
+++ b/drivers/gpio/gpio-twl6040.c
@@ -84,15 +84,11 @@ static struct gpio_chip twl6040gpo_chip = {
 
 static int gpo_twl6040_probe(struct platform_device *pdev)
 {
-	struct twl6040_gpo_data *pdata = pdev->dev.platform_data;
 	struct device *twl6040_core_dev = pdev->dev.parent;
 	struct twl6040 *twl6040 = dev_get_drvdata(twl6040_core_dev);
 	int ret;
 
-	if (pdata)
-		twl6040gpo_chip.base = pdata->gpio_base;
-	else
-		twl6040gpo_chip.base = -1;
+	twl6040gpo_chip.base = -1;
 
 	if (twl6040_get_revid(twl6040) < TWL6041_REV_ES2_0)
 		twl6040gpo_chip.ngpio = 3; /* twl6040 have 3 GPO */
-- 
1.8.2.1

