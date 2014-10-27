Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751671AbaJ0P3h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 11:29:37 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:48572 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbaJ0P3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 11:29:33 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-91-544e64d99cd8
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
Subject: [PATCH 3/8] mfd: max77686/802: Remove support for board files
Date: Mon, 27 Oct 2014 16:03:41 +0100
Message-id: <1414422226-10948-4-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1414422226-10948-1-git-send-email-k.kozlowski@samsung.com>
References: <1414422226-10948-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsVy+t/xa7o3U/xCDO7NN7fYOGM9q8WkdQeY
	LKY+fMJmcf3Lc1aL+UfOsVoc/V1g8fqFoUXvgqtsFmeb3rBb3P96lNHi25UOJotNj6+xWlze
	NYfNYsb5fUwWty/zWqw9cpfd4nQ3q4OgR0tzD5vH3+fXWTz+rnrB7LFz1l12j02rOtk87lzb
	w+Yx72Sgx+Yl9R59W1YxenzeJBfAFcVlk5Kak1mWWqRvl8CVsf7PNPaC+zIVHZvOsDYwnhHv
	YuTkkBAwkTj6bAELhC0mceHeerYuRi4OIYGljBIX399jgnD6mCTaD75lAqliEzCW2Lx8CViV
	iEAns0TPwV5mEIdZYDWTxM8rp5hBqoQF3CRWrNkG1sEioCrx6vwjsB28Au4SqyduY4fYJydx
	8thkVhCbU8BD4vX9r2C9QkA1n99vZZzAyLuAkWEVo2hqaXJBcVJ6rpFecWJucWleul5yfu4m
	RkiQf93BuPSY1SFGAQ5GJR7eCcW+IUKsiWXFlbmHGCU4mJVEeE8F+IUI8aYkVlalFuXHF5Xm
	pBYfYmTi4JRqYBS0WOA4qf6mduI88e2fKxSC156J9Hm8YdqrsPMvfA4HbT7EG3a9Zrv8W0+Z
	7weO3hG/sX3ShyMLudqzo6e3T56Uqm3UlBPJJT/t9OJgiV/OL6+HBl+QMao5cKr3+KNN0YXX
	9cqvq6et1jj6ZJbmof2+V95k2faG/uFT0/kmeOqUhZhN26mbHIeUWIozEg21mIuKEwEUZDgd
	UAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver is used only on Exynos based boards with DTS support.
Convert the driver to DTS-only version. This simplifies a little the
code:
1. No dead (unused) entries in platform_data structure.
2. More code removed (from all three patches: 34 insertions(+), 107
   deletions).
3. Regulator driver does not depend on allocated memory
   from MFD driver.
4. It makes also easier extending the regulator driver

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/mfd/max77686.c               | 23 -----------------------
 include/linux/mfd/max77686-private.h |  1 -
 include/linux/mfd/max77686.h         | 22 ----------------------
 3 files changed, 46 deletions(-)

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
index 553f7d09258a..ea8501dfc865 100644
--- a/include/linux/mfd/max77686.h
+++ b/include/linux/mfd/max77686.h
@@ -136,26 +136,4 @@ struct max77686_opmode_data {
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

