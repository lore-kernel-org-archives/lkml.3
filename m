Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab3FKLbu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 07:31:50 -0400
Received: from www.linutronix.de ([62.245.132.108]:33446 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754836Ab3FKLbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 07:31:45 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
Cc: =?UTF-8?q?Beno=C3=AEt=20Cousson?= <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jonathan Cameron <jic23@cam.ac.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 07/22] input/ti_am33x_tsc: remove platform_data support
Date: Tue, 11 Jun 2013 13:30:53 +0200
Message-Id: <1370950268-7224-8-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370950268-7224-1-git-send-email-bigeasy@linutronix.de>
References: <1370950268-7224-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes access to platform data mfd_tscadc_board because the
platform is DT only.

Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/input/touchscreen/ti_am335x_tsc.c |   25 +------------------------
 1 file changed, 1 insertion(+), 24 deletions(-)

diff --git a/drivers/input/touchscreen/ti_am335x_tsc.c b/drivers/input/touchscreen/ti_am335x_tsc.c
index a44d2c4..66c5a26 100644
--- a/drivers/input/touchscreen/ti_am335x_tsc.c
+++ b/drivers/input/touchscreen/ti_am335x_tsc.c
@@ -24,7 +24,6 @@
 #include <linux/clk.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
-#include <linux/input/ti_am335x_tsc.h>
 #include <linux/delay.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
@@ -347,24 +346,6 @@ static int titsc_parse_dt(struct platform_device *pdev,
 			ts_dev->config_inp, ARRAY_SIZE(ts_dev->config_inp));
 }
 
-static int titsc_parse_pdata(struct ti_tscadc_dev *tscadc_dev,
-					struct titsc *ts_dev)
-{
-	struct mfd_tscadc_board	*pdata = tscadc_dev->dev->platform_data;
-
-	if (!pdata)
-		return -EINVAL;
-
-	ts_dev->wires = pdata->tsc_init->wires;
-	ts_dev->x_plate_resistance =
-		pdata->tsc_init->x_plate_resistance;
-	ts_dev->steps_to_configure =
-		pdata->tsc_init->steps_to_configure;
-	memcpy(ts_dev->config_inp, pdata->tsc_init->wire_config,
-		sizeof(pdata->tsc_init->wire_config));
-	return 0;
-}
-
 /*
  * The functions for inserting/removing driver as a module.
  */
@@ -390,11 +371,7 @@ static int titsc_probe(struct platform_device *pdev)
 	ts_dev->input = input_dev;
 	ts_dev->irq = tscadc_dev->irq;
 
-	if (tscadc_dev->dev->platform_data)
-		err = titsc_parse_pdata(tscadc_dev, ts_dev);
-	else
-		err = titsc_parse_dt(pdev, ts_dev);
-
+	err = titsc_parse_dt(pdev, ts_dev);
 	if (err) {
 		dev_err(&pdev->dev, "Could not find valid DT data.\n");
 		goto err_free_mem;
-- 
1.7.10.4

