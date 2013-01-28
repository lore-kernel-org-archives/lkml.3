Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757016Ab3A1OQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 09:16:17 -0500
Received: from mail-da0-f49.google.com ([209.85.210.49]:61033 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756298Ab3A1OQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 09:16:15 -0500
Message-ID: <1359382563.6625.1.camel@phoenix>
Subject: [PATCH 1/2] regulator: gpio-regulator: Use of_gpio_count()
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Heiko Stuebner <heiko@sntech.de>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Mon, 28 Jan 2013 22:16:03 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/gpio-regulator.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/regulator/gpio-regulator.c b/drivers/regulator/gpio-regulator.c
index bae681c..d819ba7 100644
--- a/drivers/regulator/gpio-regulator.c
+++ b/drivers/regulator/gpio-regulator.c
@@ -163,10 +163,7 @@ of_get_gpio_regulator_config(struct device *dev, struct device_node *np)
 	config->enable_gpio = of_get_named_gpio(np, "enable-gpio", 0);
 
 	/* Fetch GPIOs. */
-	for (i = 0; ; i++)
-		if (of_get_named_gpio(np, "gpios", i) < 0)
-			break;
-	config->nr_gpios = i;
+	config->nr_gpios = of_gpio_count(np);
 
 	config->gpios = devm_kzalloc(dev,
 				sizeof(struct gpio) * config->nr_gpios,
-- 
1.7.9.5



