Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932337AbaGDJzx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 05:55:53 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:38026 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbaGDJzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 05:55:49 -0400
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
Subject: [PATCH v6 06/23] mfd: max77686: Make error checking consistent
Date: Fri,  4 Jul 2014 11:55:05 +0200
Message-Id: <1404467722-26687-7-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1404467722-26687-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1404467722-26687-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Error checking across the driver is mostly consistent besides
a few exceptions, so change these exceptions for consistency.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 drivers/mfd/max77686.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/max77686.c b/drivers/mfd/max77686.c
index ada4976..87fe52e 100644
--- a/drivers/mfd/max77686.c
+++ b/drivers/mfd/max77686.c
@@ -134,7 +134,7 @@ static int max77686_i2c_probe(struct i2c_client *i2c,
 
 	max77686 = devm_kzalloc(&i2c->dev,
 				sizeof(struct max77686_dev), GFP_KERNEL);
-	if (max77686 == NULL)
+	if (!max77686)
 		return -ENOMEM;
 
 	i2c_set_clientdata(i2c, max77686);
@@ -153,8 +153,8 @@ static int max77686_i2c_probe(struct i2c_client *i2c,
 		return ret;
 	}
 
-	if (regmap_read(max77686->regmap,
-			 MAX77686_REG_DEVICE_ID, &data) < 0) {
+	ret = regmap_read(max77686->regmap, MAX77686_REG_DEVICE_ID, &data);
+	if (ret < 0) {
 		dev_err(max77686->dev,
 			"device not found on this channel (this is not an error)\n");
 		return -ENODEV;
@@ -180,7 +180,7 @@ static int max77686_i2c_probe(struct i2c_client *i2c,
 				  IRQF_TRIGGER_FALLING | IRQF_ONESHOT |
 				  IRQF_SHARED, 0, &max77686_irq_chip,
 				  &max77686->irq_data);
-	if (ret != 0) {
+	if (ret) {
 		dev_err(&i2c->dev, "failed to add PMIC irq chip: %d\n", ret);
 		goto err_unregister_i2c;
 	}
@@ -188,7 +188,7 @@ static int max77686_i2c_probe(struct i2c_client *i2c,
 				  IRQF_TRIGGER_FALLING | IRQF_ONESHOT |
 				  IRQF_SHARED, 0, &max77686_rtc_irq_chip,
 				  &max77686->rtc_irq_data);
-	if (ret != 0) {
+	if (ret) {
 		dev_err(&i2c->dev, "failed to add RTC irq chip: %d\n", ret);
 		goto err_del_irqc;
 	}
-- 
2.0.0.rc2

