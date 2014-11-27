Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbaK0LVS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 06:21:18 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:44171 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277AbaK0LVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 06:21:13 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-1d-54770927063a
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene@kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v4 1/7] mfd: max77686/802: Remove support for board files
Date: Thu, 27 Nov 2014 12:20:47 +0100
Message-id: <1417087253-12306-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1417087253-12306-1-git-send-email-k.kozlowski@samsung.com>
References: <1417087253-12306-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprILMWRmVeSWpSXmKPExsVy+t/xK7rqnOUhBtN+sFlsnLGe1WLqwyds
	FvOPnGO1eP3C0KL/8Wtmi7NNb9gt7n89ymjx7UoHk8Wmx9dYLS7vmsNmMeP8PiaLtUfusjvw
	eOycdZfdY9OqTjaPO9f2sHlsXlLv0bdlFaPH501yAWxRXDYpqTmZZalF+nYJXBkXtj1jLbip
	WnF5rXsDY7t8FyMnh4SAicTLR63MELaYxIV769m6GLk4hASWMkrcOrCKEcLpY5L4tecsI0gV
	m4CxxOblS9hAbBGBFYwSx28ogtjMAuuZJB5scwKxhQU8JRrn94JNZRFQlZi37TRYL6+Au8Tb
	DXtZIbbJSZw8NhnM5hTwkNh76zYLiC0EVLPn1R2WCYy8CxgZVjGKppYmFxQnpeca6RUn5haX
	5qXrJefnbmKEBOPXHYxLj1kdYhTgYFTi4WW4VRYixJpYVlyZe4hRgoNZSYSXi7E8RIg3JbGy
	KrUoP76oNCe1+BAjEwenVAPj1LlxgqnJhi8+yxvv1upKYtzVxrv4Tcwi0WuP7gi9f3LhN9eG
	96Glx9dHHmq5py4lfufP6n92kzPzpqWnTn4qtnJq+LqUWt4NLAI5wQuOpsy1VUpdsmrCKoFL
	9tnnbxRWRv262snG/lD+XJpD4zUFyylH8zU4jKyD1VYo/58jGSo4Wf7Pqc3qSizFGYmGWsxF
	xYkAeCWtYyQCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver is used only on Exynos based boards with DTS support.
After removal of board file support from max77686 and max77802 regulator
drivers, the MFD driver can be converted to DTS-only version. This
simplifies a little the code:
1. No dead (unused) entries in platform_data structure.
2. More code removed.
3. Regulator driver does not depend on allocated memory
   from MFD driver.
4. It makes also easier extending the regulator driver.

Add to the max77686 MFD driver dependency on CONFIG_OF because without
DTS the regulator drivers (max77686 and max77802) won't bind.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Reviewed-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Acked-by: Lee Jones <lee.jones@linaro.org>
Acked-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Tested-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 drivers/mfd/Kconfig                  |  1 +
 drivers/mfd/max77686.c               | 23 -----------------------
 include/linux/mfd/max77686-private.h |  1 -
 include/linux/mfd/max77686.h         | 28 ----------------------------
 4 files changed, 1 insertion(+), 52 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 72d38081f779..2bb0789a828b 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -412,6 +412,7 @@ config MFD_MAX14577
 config MFD_MAX77686
 	bool "Maxim Semiconductor MAX77686/802 PMIC Support"
 	depends on I2C=y
+	depends on OF
 	select MFD_CORE
 	select REGMAP_I2C
 	select REGMAP_IRQ
diff --git a/drivers/mfd/max77686.c b/drivers/mfd/max77686.c
index 929795eae9fc..3da237afacde 100644
--- a/drivers/mfd/max77686.c
+++ b/drivers/mfd/max77686.c
@@ -205,24 +205,10 @@ static const struct of_device_id max77686_pmic_dt_match[] = {
 	{ },
 };
 
-static struct max77686_platform_data *max77686_i2c_parse_dt_pdata(struct device
-								  *dev)
-{
-	struct max77686_platform_data *pd;
-
-	pd = devm_kzalloc(dev, sizeof(*pd), GFP_KERNEL);
-	if (!pd)
-		return NULL;
-
-	dev->platform_data = pd;
-	return pd;
-}
-
 static int max77686_i2c_probe(struct i2c_client *i2c,
 			      const struct i2c_device_id *id)
 {
 	struct max77686_dev *max77686 = NULL;
-	struct max77686_platform_data *pdata = dev_get_platdata(&i2c->dev);
 	const struct of_device_id *match;
 	unsigned int data;
 	int ret = 0;
@@ -233,14 +219,6 @@ static int max77686_i2c_probe(struct i2c_client *i2c,
 	const struct mfd_cell *cells;
 	int n_devs;
 
-	if (IS_ENABLED(CONFIG_OF) && i2c->dev.of_node && !pdata)
-		pdata = max77686_i2c_parse_dt_pdata(&i2c->dev);
-
-	if (!pdata) {
-		dev_err(&i2c->dev, "No platform data found.\n");
-		return -EINVAL;
-	}
-
 	max77686 = devm_kzalloc(&i2c->dev,
 				sizeof(struct max77686_dev), GFP_KERNEL);
 	if (!max77686)
@@ -259,7 +237,6 @@ static int max77686_i2c_probe(struct i2c_client *i2c,
 	max77686->dev = &i2c->dev;
 	max77686->i2c = i2c;
 
-	max77686->wakeup = pdata->wakeup;
 	max77686->irq = i2c->irq;
 
 	if (max77686->type == TYPE_MAX77686) {
diff --git a/include/linux/mfd/max77686-private.h b/include/linux/mfd/max77686-private.h
index 960b92ad450d..f5043490d67c 100644
--- a/include/linux/mfd/max77686-private.h
+++ b/include/linux/mfd/max77686-private.h
@@ -447,7 +447,6 @@ struct max77686_dev {
 	struct regmap_irq_chip_data *rtc_irq_data;
 
 	int irq;
-	bool wakeup;
 	struct mutex irqlock;
 	int irq_masks_cur[MAX77686_IRQ_GROUP_NR];
 	int irq_masks_cache[MAX77686_IRQ_GROUP_NR];
diff --git a/include/linux/mfd/max77686.h b/include/linux/mfd/max77686.h
index 553f7d09258a..bb995ab9a575 100644
--- a/include/linux/mfd/max77686.h
+++ b/include/linux/mfd/max77686.h
@@ -119,12 +119,6 @@ enum max77802_regulators {
 	MAX77802_REG_MAX,
 };
 
-struct max77686_regulator_data {
-	int id;
-	struct regulator_init_data *initdata;
-	struct device_node *of_node;
-};
-
 enum max77686_opmode {
 	MAX77686_OPMODE_NORMAL,
 	MAX77686_OPMODE_LP,
@@ -136,26 +130,4 @@ struct max77686_opmode_data {
 	int mode;
 };
 
-struct max77686_platform_data {
-	int ono;
-	int wakeup;
-
-	/* ---- PMIC ---- */
-	struct max77686_regulator_data *regulators;
-	int num_regulators;
-
-	struct max77686_opmode_data *opmode_data;
-
-	/*
-	 * GPIO-DVS feature is not enabled with the current version of
-	 * MAX77686 driver. Buck2/3/4_voltages[0] is used as the default
-	 * voltage at probe. DVS/SELB gpios are set as OUTPUT-LOW.
-	 */
-	int buck234_gpio_dvs[3]; /* GPIO of [0]DVS1, [1]DVS2, [2]DVS3 */
-	int buck234_gpio_selb[3]; /* [0]SELB2, [1]SELB3, [2]SELB4 */
-	unsigned int buck2_voltage[8]; /* buckx_voltage in uV */
-	unsigned int buck3_voltage[8];
-	unsigned int buck4_voltage[8];
-};
-
 #endif /* __LINUX_MFD_MAX77686_H */
-- 
1.9.1

