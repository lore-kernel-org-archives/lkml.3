Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812Ab3GJP7P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 11:59:15 -0400
Received: from sauhun.de ([89.238.76.85]:44299 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754735Ab3GJP6x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 11:58:53 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Tony Lindgren <tony@atomide.com>,
        linux-omap@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: [PATCH 02/12] drivers/i2c/busses: don't use devm_pinctrl_get_select_default() in probe
Date: Wed, 10 Jul 2013 16:57:37 +0100
Message-Id: <1373471889-18107-2-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1373471889-18107-1-git-send-email-wsa@the-dreams.de>
References: <1373471889-18107-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit ab78029 (drivers/pinctrl: grab default handles from device core),
we can rely on device core for setting the default pins. Compile tested only.

Acked-by: Linus Walleij <linus.walleij@linaro.org> (personally at LCE13)
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/i2c/busses/i2c-omap.c |   13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index 142b694d..d09512e 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -43,7 +43,6 @@
 #include <linux/slab.h>
 #include <linux/i2c-omap.h>
 #include <linux/pm_runtime.h>
-#include <linux/pinctrl/consumer.h>
 
 /* I2C controller revisions */
 #define OMAP_I2C_OMAP1_REV_2		0x20
@@ -216,8 +215,6 @@ struct omap_i2c_dev {
 	u16			syscstate;
 	u16			westate;
 	u16			errata;
-
-	struct pinctrl		*pins;
 };
 
 static const u8 reg_map_ip_v1[] = {
@@ -1120,16 +1117,6 @@ omap_i2c_probe(struct platform_device *pdev)
 		dev->set_mpu_wkup_lat = pdata->set_mpu_wkup_lat;
 	}
 
-	dev->pins = devm_pinctrl_get_select_default(&pdev->dev);
-	if (IS_ERR(dev->pins)) {
-		if (PTR_ERR(dev->pins) == -EPROBE_DEFER)
-			return -EPROBE_DEFER;
-
-		dev_warn(&pdev->dev, "did not get pins for i2c error: %li\n",
-			 PTR_ERR(dev->pins));
-		dev->pins = NULL;
-	}
-
 	dev->dev = &pdev->dev;
 	dev->irq = irq;
 
-- 
1.7.10.4

