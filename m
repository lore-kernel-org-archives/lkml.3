Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019Ab3COEsE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 00:48:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34768 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860Ab3COEsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 00:48:00 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: plagnioj@jcrosoft.com, linus.walleij@linaro.org, sachin.kamat@linaro.org
Subject: [PATCH 2/2] pinctrl: at91: Fix checkpatch errors
Date: Fri, 15 Mar 2013 10:07:03 +0530
Message-Id: <1363322223-19850-2-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1363322223-19850-1-git-send-email-sachin.kamat@linaro.org>
References: <1363322223-19850-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the following types of checkpatch errors:
ERROR: "foo * bar" should be "foo *bar"
ERROR: "foo* bar" should be "foo *bar"
ERROR: space required before the open parenthesis '('
ERROR: "(foo*)" should be "(foo *)"
ERROR: space required after that ',' (ctx:WxV)
ERROR: "(foo*const*)" should be "(foo *const*)"
ERROR: space required before that '*' (ctx:VxB)

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/pinctrl/pinctrl-at91.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
index 353c7bf..03d8bed 100644
--- a/drivers/pinctrl/pinctrl-at91.c
+++ b/drivers/pinctrl/pinctrl-at91.c
@@ -303,7 +303,7 @@ static const struct pinctrl_ops at91_pctrl_ops = {
 	.dt_free_map		= at91_dt_free_map,
 };
 
-static void __iomem * pin_to_controller(struct at91_pinctrl *info,
+static void __iomem *pin_to_controller(struct at91_pinctrl *info,
 				 unsigned int bank)
 {
 	return gpio_chips[bank]->regbase;
@@ -501,7 +501,7 @@ static void at91_pin_dbg(const struct device *dev, const struct at91_pmx_pin *pi
 	}
 }
 
-static int pin_check_config(struct at91_pinctrl *info, const char* name,
+static int pin_check_config(struct at91_pinctrl *info, const char *name,
 			    int index, const struct at91_pmx_pin *pin)
 {
 	int mux;
@@ -579,7 +579,7 @@ static int at91_pmx_enable(struct pinctrl_dev *pctldev, unsigned selector,
 		pio = pin_to_controller(info, pin->bank);
 		mask = pin_to_mask(pin->pin);
 		at91_mux_disable_interrupt(pio, mask);
-		switch(pin->mux) {
+		switch (pin->mux) {
 		case AT91_MUX_GPIO:
 			at91_mux_gpio_enable(pio, mask, 1);
 			break;
@@ -944,7 +944,7 @@ static int at91_pinctrl_probe_dt(struct platform_device *pdev,
 		return -ENODEV;
 
 	info->dev = &pdev->dev;
-	info->ops = (struct at91_pinctrl_mux_ops*)
+	info->ops = (struct at91_pinctrl_mux_ops *)
 		of_match_device(at91_pinctrl_of_match, &pdev->dev)->data;
 	at91_pinctrl_child_count(info, np);
 
@@ -1002,7 +1002,7 @@ static int at91_pinctrl_probe(struct platform_device *pdev)
 {
 	struct at91_pinctrl *info;
 	struct pinctrl_pin_desc *pdesc;
-	int ret, i, j ,k;
+	int ret, i, j, k;
 
 	info = devm_kzalloc(&pdev->dev, sizeof(*info), GFP_KERNEL);
 	if (!info)
@@ -1509,7 +1509,7 @@ static int at91_gpio_probe(struct platform_device *pdev)
 		goto err;
 	}
 
-	at91_chip->ops = (struct at91_pinctrl_mux_ops*)
+	at91_chip->ops = (struct at91_pinctrl_mux_ops *)
 		of_match_device(at91_gpio_of_match, &pdev->dev)->data;
 	at91_chip->pioc_virq = irq;
 	at91_chip->pioc_idx = alias_idx;
@@ -1546,7 +1546,8 @@ static int at91_gpio_probe(struct platform_device *pdev)
 			chip->ngpio = ngpio;
 	}
 
-	names = devm_kzalloc(&pdev->dev, sizeof(char*) * chip->ngpio, GFP_KERNEL);
+	names = devm_kzalloc(&pdev->dev, sizeof(char *) * chip->ngpio,
+			     GFP_KERNEL);
 
 	if (!names) {
 		ret = -ENOMEM;
@@ -1556,7 +1557,7 @@ static int at91_gpio_probe(struct platform_device *pdev)
 	for (i = 0; i < chip->ngpio; i++)
 		names[i] = kasprintf(GFP_KERNEL, "pio%c%d", alias_idx + 'A', i);
 
-	chip->names = (const char*const*)names;
+	chip->names = (const char *const *)names;
 
 	range = &at91_chip->range;
 	range->name = chip->label;
-- 
1.7.4.1

