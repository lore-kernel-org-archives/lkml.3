Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916Ab3FKLoj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 07:44:39 -0400
Received: from www.linutronix.de ([62.245.132.108]:33579 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755340Ab3FKLlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 07:41:18 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
Cc: =?UTF-8?q?Beno=C3=AEt=20Cousson?= <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jonathan Cameron <jic23@cam.ac.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 16/22] mfd & input/ti_am335x_tsc: rename device from tsc to TI-am335x-tsc
Date: Tue, 11 Jun 2013 13:31:02 +0200
Message-Id: <1370950268-7224-17-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370950268-7224-1-git-send-email-bigeasy@linutronix.de>
References: <1370950268-7224-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tsc is a very generic name. This patch adds a TI and HW prefix to it
less generic.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/input/touchscreen/ti_am335x_tsc.c |    2 +-
 drivers/mfd/ti_am335x_tscadc.c            |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/touchscreen/ti_am335x_tsc.c b/drivers/input/touchscreen/ti_am335x_tsc.c
index 66c5a26..d6643cb 100644
--- a/drivers/input/touchscreen/ti_am335x_tsc.c
+++ b/drivers/input/touchscreen/ti_am335x_tsc.c
@@ -491,7 +491,7 @@ static struct platform_driver ti_tsc_driver = {
 	.probe	= titsc_probe,
 	.remove	= titsc_remove,
 	.driver	= {
-		.name   = "tsc",
+		.name   = "TI-am335x-tsc",
 		.owner	= THIS_MODULE,
 		.pm	= TITSC_PM_OPS,
 		.of_match_table = of_match_ptr(ti_tsc_dt_ids),
diff --git a/drivers/mfd/ti_am335x_tscadc.c b/drivers/mfd/ti_am335x_tscadc.c
index 74e4694..bf33134 100644
--- a/drivers/mfd/ti_am335x_tscadc.c
+++ b/drivers/mfd/ti_am335x_tscadc.c
@@ -194,7 +194,7 @@ static	int ti_tscadc_probe(struct platform_device *pdev)
 	if (tsc_wires > 0) {
 		tscadc->tsc_cell = tscadc->used_cells;
 		cell = &tscadc->cells[tscadc->used_cells++];
-		cell->name = "tsc";
+		cell->name = "TI-am335x-tsc";
 		cell->of_compatible = "ti,am3359-tsc";
 		cell->platform_data = &tscadc;
 		cell->pdata_size = sizeof(tscadc);
-- 
1.7.10.4

