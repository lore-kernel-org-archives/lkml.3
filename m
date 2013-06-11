Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab3FKLlv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 07:41:51 -0400
Received: from www.linutronix.de ([62.245.132.108]:33634 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755489Ab3FKLls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 07:41:48 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
Cc: =?UTF-8?q?Beno=C3=AEt=20Cousson?= <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jonathan Cameron <jic23@cam.ac.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 17/22] mfd & iio/ti_am335x_adc: rename device from tiadc to TI-am335x-adc
Date: Tue, 11 Jun 2013 13:31:03 +0200
Message-Id: <1370950268-7224-18-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370950268-7224-1-git-send-email-bigeasy@linutronix.de>
References: <1370950268-7224-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TI-adc reads a little better compared to tiadc. And if we add am335x to
it then we have the same naming scheme as the tsc side.

Acked-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/iio/adc/ti_am335x_adc.c |    3 +--
 drivers/mfd/ti_am335x_tscadc.c  |    2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
index 9939810..4bec91e 100644
--- a/drivers/iio/adc/ti_am335x_adc.c
+++ b/drivers/iio/adc/ti_am335x_adc.c
@@ -292,7 +292,7 @@ MODULE_DEVICE_TABLE(of, ti_adc_dt_ids);
 
 static struct platform_driver tiadc_driver = {
 	.driver = {
-		.name   = "tiadc",
+		.name   = "TI-am335x-adc",
 		.owner	= THIS_MODULE,
 		.pm	= TIADC_PM_OPS,
 		.of_match_table = of_match_ptr(ti_adc_dt_ids),
@@ -300,7 +300,6 @@ static struct platform_driver tiadc_driver = {
 	.probe	= tiadc_probe,
 	.remove	= tiadc_remove,
 };
-
 module_platform_driver(tiadc_driver);
 
 MODULE_DESCRIPTION("TI ADC controller driver");
diff --git a/drivers/mfd/ti_am335x_tscadc.c b/drivers/mfd/ti_am335x_tscadc.c
index bf33134..d3f48d2 100644
--- a/drivers/mfd/ti_am335x_tscadc.c
+++ b/drivers/mfd/ti_am335x_tscadc.c
@@ -204,7 +204,7 @@ static	int ti_tscadc_probe(struct platform_device *pdev)
 	if (adc_channels > 0) {
 		tscadc->adc_cell = tscadc->used_cells;
 		cell = &tscadc->cells[tscadc->used_cells++];
-		cell->name = "tiadc";
+		cell->name = "TI-am335x-adc";
 		cell->of_compatible = "ti,am3359-adc";
 		cell->platform_data = &tscadc;
 		cell->pdata_size = sizeof(tscadc);
-- 
1.7.10.4

