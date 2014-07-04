Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964992AbaGDUZO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 16:25:14 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:38597 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755503AbaGDUZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 16:25:09 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Lee Jones <lee.jones@linaro.org>
Cc: Mark Brown <broonie@kernel.org>, Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        Tushar Behera <trblinux@gmail.com>, Andreas Farber <afaerber@suse.de>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v7 03/24] mfd: max77686: Don't define dummy function if OF isn't enabled
Date: Fri,  4 Jul 2014 22:24:06 +0200
Message-Id: <1404505467-26526-4-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1404505467-26526-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1404505467-26526-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the CONFIG_OF option was not enabled, a dummy function
max77686_i2c_parse_dt_pdata() was defined since this is called
unconditionally on probe(). Just always define the real function
and conditionally call it if CONFIG_OF is enabled instead.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 drivers/mfd/max77686.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/mfd/max77686.c b/drivers/mfd/max77686.c
index a38e9ee..d1f9d04 100644
--- a/drivers/mfd/max77686.c
+++ b/drivers/mfd/max77686.c
@@ -96,7 +96,6 @@ static const struct regmap_irq_chip max77686_rtc_irq_chip = {
 	.num_irqs		= ARRAY_SIZE(max77686_rtc_irqs),
 };
 
-#ifdef CONFIG_OF
 static const struct of_device_id max77686_pmic_dt_match[] = {
 	{.compatible = "maxim,max77686", .data = NULL},
 	{},
@@ -116,13 +115,6 @@ static struct max77686_platform_data *max77686_i2c_parse_dt_pdata(struct device
 	dev->platform_data = pd;
 	return pd;
 }
-#else
-static struct max77686_platform_data *max77686_i2c_parse_dt_pdata(struct device
-								  *dev)
-{
-	return 0;
-}
-#endif
 
 static int max77686_i2c_probe(struct i2c_client *i2c,
 			      const struct i2c_device_id *id)
@@ -132,7 +124,7 @@ static int max77686_i2c_probe(struct i2c_client *i2c,
 	unsigned int data;
 	int ret = 0;
 
-	if (i2c->dev.of_node)
+	if (IS_ENABLED(CONFIG_OF) && i2c->dev.of_node)
 		pdata = max77686_i2c_parse_dt_pdata(&i2c->dev);
 
 	if (!pdata) {
-- 
2.0.0.rc2

