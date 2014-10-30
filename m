Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759661AbaJ3LY1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 07:24:27 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:42895 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759232AbaJ3LV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 07:21:27 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-44-54521f34fb4b
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v3 08/14] mfd: max77686/802: Remove support for board files
Date: Thu, 30 Oct 2014 12:20:47 +0100
Message-id: <1414668053-31370-9-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1414668053-31370-1-git-send-email-k.kozlowski@samsung.com>
References: <1414668053-31370-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFLMWRmVeSWpSXmKPExsVy+t/xq7om8kEhBtNbJCw2zljPajFp3QEm
	i6kPn7BZXP/ynNVi/pFzrBZHfxdYvH5haNG74CqbxdmmN+wW978eZbT4dqWDyWLT42usFpd3
	zWGzmHF+H5PF7cu8FmuP3GW3ON3N6iDo0dLcw+bx9/l1Fo+/q14we+ycdZfdY9OqTjaPO9f2
	sHnMOxnosXlJvUffllWMHp83yQVwRXHZpKTmZJalFunbJXBlTFjxjKlghXLF9MWdbA2Mv2S6
	GDk4JARMJNYtzupi5AQyxSQu3FvP1sXIxSEksJRR4vPueSwQTh+TxLcDn9hBqtgEjCU2L18C
	ViUi0Mks0XOwlxnEYRZYzSTx88opZpCxwgLeEjPX1oE0sAioShy8dZgRxOYVcJeY2PyNEWKd
	nMTJY5NZQWxOAQ+JNR/bWUFahYBq7n3TnsDIu4CRYRWjaGppckFxUnquoV5xYm5xaV66XnJ+
	7iZGSHh/2cG4+JjVIUYBDkYlHl6HjQEhQqyJZcWVuYcYJTiYlUR4V4sFhQjxpiRWVqUW5ccX
	leakFh9iZOLglGpgVJf4yWOUbdZ275qG8f0pn+sTl61QbLi7Ocl46+5Xr6z4ZK3bg3bPufXD
	LK7cva/9dFBZ/8QFV/W2zckxnj5193rG7fHtnZo1d6O2JsVq7A67e+Tjh4K5wTP0zWTPTfOY
	rZCqKbT7plJ/+BaXO4w/k1k2Z3feVCrpLTg7//pxR2NRf2ZN/d4oJZbijERDLeai4kQAfpA2
	gk0CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver is used only on Exynos based boards with DTS support.
Convert the driver to DTS-only version. This simplifies a little the
code:
1. No dead (unused) entries in platform_data structure.
2. More code removed.
3. Regulator driver does not depend on allocated memory
   from MFD driver.
4. It makes also easier extending the regulator driver.

Add to the max77686 MFD driver dependency on CONFIG_OF because without
DTS the regulator drivers won't bind.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Reviewed-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 drivers/mfd/Kconfig                  |  1 +
 drivers/mfd/max77686.c               | 23 -----------------------
 include/linux/mfd/max77686-private.h |  1 -
 include/linux/mfd/max77686.h         | 28 ----------------------------
 4 files changed, 1 insertion(+), 52 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index cbdb10918af1..fd9d19ccf8c0 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -401,6 +401,7 @@ config MFD_MAX14577
 config MFD_MAX77686
 	bool "Maxim Semiconductor MAX77686/802 PMIC Support"
 	depends on I2C=y
+	depends on OF
 	select MFD_CORE
 	select REGMAP_I2C
 	select REGMAP_IRQ
diff --git a/drivers/mfd/max77686.c b/drivers/mfd/max77686.c
index 9e1046bdef90..418b08b6c066 100644
--- a/drivers/mfd/max77686.c
+++ b/drivers/mfd/max77686.c
@@ -211,24 +211,10 @@ static const struct of_device_id max77686_pmic_dt_match[] = {
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
@@ -239,14 +225,6 @@ static int max77686_i2c_probe(struct i2c_client *i2c,
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
@@ -265,7 +243,6 @@ static int max77686_i2c_probe(struct i2c_client *i2c,
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

