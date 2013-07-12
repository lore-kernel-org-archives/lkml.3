Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932978Ab3GLLcc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 07:32:32 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:52662 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932834Ab3GLLcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 07:32:08 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] MFD: twl6040: Cosmetic, parameter alignment change
Date: Fri, 12 Jul 2013 13:32:03 +0200
Message-ID: <1373628724-11397-2-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1373628724-11397-1-git-send-email-peter.ujfalusi@ti.com>
References: <1373628724-11397-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To comply with coding style.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/mfd/twl6040.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/mfd/twl6040.c b/drivers/mfd/twl6040.c
index a4034ed..3bd110e 100644
--- a/drivers/mfd/twl6040.c
+++ b/drivers/mfd/twl6040.c
@@ -549,7 +549,7 @@ static int twl6040_probe(struct i2c_client *client,
 	twl6040->supplies[0].supply = "vio";
 	twl6040->supplies[1].supply = "v2v1";
 	ret = devm_regulator_bulk_get(&client->dev, TWL6040_NUM_SUPPLIES,
-				 twl6040->supplies);
+				      twl6040->supplies);
 	if (ret != 0) {
 		dev_err(&client->dev, "Failed to get supplies: %d\n", ret);
 		goto regulator_get_err;
@@ -578,33 +578,32 @@ static int twl6040_probe(struct i2c_client *client,
 
 	if (gpio_is_valid(twl6040->audpwron)) {
 		ret = devm_gpio_request_one(&client->dev, twl6040->audpwron,
-					GPIOF_OUT_INIT_LOW, "audpwron");
+					    GPIOF_OUT_INIT_LOW, "audpwron");
 		if (ret)
 			goto gpio_err;
 	}
 
-	ret = regmap_add_irq_chip(twl6040->regmap, twl6040->irq,
-			IRQF_ONESHOT, 0, &twl6040_irq_chip,
-			&twl6040->irq_data);
+	ret = regmap_add_irq_chip(twl6040->regmap, twl6040->irq, IRQF_ONESHOT,
+				  0, &twl6040_irq_chip,&twl6040->irq_data);
 	if (ret < 0)
 		goto gpio_err;
 
 	twl6040->irq_ready = regmap_irq_get_virq(twl6040->irq_data,
-					       TWL6040_IRQ_READY);
+						 TWL6040_IRQ_READY);
 	twl6040->irq_th = regmap_irq_get_virq(twl6040->irq_data,
-					       TWL6040_IRQ_TH);
+					      TWL6040_IRQ_TH);
 
 	ret = devm_request_threaded_irq(twl6040->dev, twl6040->irq_ready, NULL,
-				   twl6040_readyint_handler, IRQF_ONESHOT,
-				   "twl6040_irq_ready", twl6040);
+					twl6040_readyint_handler, IRQF_ONESHOT,
+					"twl6040_irq_ready", twl6040);
 	if (ret) {
 		dev_err(twl6040->dev, "READY IRQ request failed: %d\n", ret);
 		goto readyirq_err;
 	}
 
 	ret = devm_request_threaded_irq(twl6040->dev, twl6040->irq_th, NULL,
-				   twl6040_thint_handler, IRQF_ONESHOT,
-				   "twl6040_irq_th", twl6040);
+					twl6040_thint_handler, IRQF_ONESHOT,
+					"twl6040_irq_th", twl6040);
 	if (ret) {
 		dev_err(twl6040->dev, "Thermal IRQ request failed: %d\n", ret);
 		goto thirq_err;
-- 
1.8.2.1

