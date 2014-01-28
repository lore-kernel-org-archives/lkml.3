Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285AbaA1MVu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 07:21:50 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:20320 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755199AbaA1MTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 07:19:10 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-ef-52e7a039d9da
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 08/18] mfd: max14577: Rename state container to maxim_core
Date: Tue, 28 Jan 2014 13:18:32 +0100
Message-id: <1390911522-28209-9-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1390911522-28209-1-git-send-email-k.kozlowski@samsung.com>
References: <1390911522-28209-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprALMWRmVeSWpSXmKPExsVy+t/xa7qWC54HGUx9Ym4x9eETNovrX56z
	Wrx+YWhxtukNu8X9r0cZLb5d6WCy2PT4GqvF5V1z2CzWHrnLbnG7cQWbxeluVgduj52z7rJ7
	bFrVyeZx59oeNo95JwM9Ni+p9+jbsorR4/MmuQD2KC6blNSczLLUIn27BK6M3ZtnsxQ8zan4
	OnMXSwNjd3QXIyeHhICJxKX+C8wQtpjEhXvr2boYuTiEBJYySuw/dgTK6WOSuH/5HBtIFZuA
	scTm5UvAEiICq5kk1iyYygKSYBboZZS4udsDxBYW8JLY/OwLWAOLgKrEuhtrwVbwCrhL7P/1
	BijOAbROQWLOJBuQMKeAh8Srq41MILYQUMmp4+9YJjDyLmBkWMUomlqaXFCclJ5rpFecmFtc
	mpeul5yfu4kREopfdzAuPWZ1iFGAg1GJh/dB97MgIdbEsuLK3EOMEhzMSiK8ibOfBwnxpiRW
	VqUW5ccXleakFh9iZOLglGpgjD80eUuz3Z6GdwedT+2+Vhnt+LE14knv+ZwzS3flHfu6f2nC
	hK8cj9OYuBmMCurbVn9SPPKMW9v8a/ULX5nPQsvEf3r59Vv/W7sn0GV33bpFYrn7b3RPz752
	Ii+6Oz/bt8k4aJn5jqffTbRkHqncX3f/jve7myfL1qqYdiw42PtdW2LRXG5FaSWW4oxEQy3m
	ouJEAActGosjAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch continues the preparation for adding support for max77836
device to existing max14577 driver.

The patch renames the struct "max14577" state container to "maxim_core".
This is only a rename-like patch, new code is not added.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/extcon/extcon-max14577.c     |   22 +++++------
 drivers/mfd/max14577.c               |   68 +++++++++++++++++-----------------
 drivers/power/max14577_charger.c     |   16 ++++----
 drivers/regulator/max14577.c         |    6 +--
 include/linux/mfd/max14577-private.h |    5 ++-
 5 files changed, 60 insertions(+), 57 deletions(-)

diff --git a/drivers/extcon/extcon-max14577.c b/drivers/extcon/extcon-max14577.c
index 6f7145a929cf..2879cc5844dc 100644
--- a/drivers/extcon/extcon-max14577.c
+++ b/drivers/extcon/extcon-max14577.c
@@ -41,7 +41,7 @@ enum max14577_muic_status {
 
 struct max14577_muic_info {
 	struct device *dev;
-	struct max14577 *max14577;
+	struct maxim_core *maxim_core;
 	struct extcon_dev *edev;
 	int prev_cable_type;
 	int prev_chg_type;
@@ -176,7 +176,7 @@ static int max14577_muic_set_debounce_time(struct max14577_muic_info *info,
 	case ADC_DEBOUNCE_TIME_10MS:
 	case ADC_DEBOUNCE_TIME_25MS:
 	case ADC_DEBOUNCE_TIME_38_62MS:
-		ret = max14577_update_reg(info->max14577->regmap,
+		ret = max14577_update_reg(info->maxim_core->regmap,
 				MAXIM_MUIC_REG_CONTROL3,
 				MAXIM_CONTROL3_ADCDBSET_MASK,
 				time << MAXIM_CONTROL3_ADCDBSET_SHIFT);
@@ -210,7 +210,7 @@ static int max14577_muic_set_path(struct max14577_muic_info *info,
 	u8 ctrl1, ctrl2 = 0;
 
 	/* Set open state to path before changing hw path */
-	ret = max14577_update_reg(info->max14577->regmap,
+	ret = max14577_update_reg(info->maxim_core->regmap,
 			MAXIM_MUIC_REG_CONTROL1,
 			MAXIM_CONTROL1_CLEAR_IDBEN_MICEN_MASK,
 			MAXIM_CONTROL1_SW_OPEN);
@@ -224,7 +224,7 @@ static int max14577_muic_set_path(struct max14577_muic_info *info,
 	else
 		ctrl1 = MAXIM_CONTROL1_SW_OPEN;
 
-	ret = max14577_update_reg(info->max14577->regmap,
+	ret = max14577_update_reg(info->maxim_core->regmap,
 				MAXIM_MUIC_REG_CONTROL1,
 				MAXIM_CONTROL1_CLEAR_IDBEN_MICEN_MASK, ctrl1);
 	if (ret < 0) {
@@ -237,7 +237,7 @@ static int max14577_muic_set_path(struct max14577_muic_info *info,
 	else
 		ctrl2 |= MAXIM_CONTROL2_LOWPWR_MASK;	/* LowPwr=1, CPEn=0 */
 
-	ret = max14577_update_reg(info->max14577->regmap,
+	ret = max14577_update_reg(info->maxim_core->regmap,
 			MAXIM_MUIC_REG_CONTROL2,
 			MAXIM_CONTROL2_LOWPWR_MASK | MAXIM_CONTROL2_CPEN_MASK,
 			ctrl2);
@@ -505,7 +505,7 @@ static void max14577_muic_irq_work(struct work_struct *work)
 
 	mutex_lock(&info->mutex);
 
-	ret = max14577_bulk_read(info->max14577->regmap,
+	ret = max14577_bulk_read(info->maxim_core->regmap,
 			MAXIM_MUIC_REG_STATUS1, info->status, 2);
 	if (ret) {
 		dev_err(info->dev, "failed to read MUIC register\n");
@@ -581,7 +581,7 @@ static int max14577_muic_detect_accessory(struct max14577_muic_info *info)
 	mutex_lock(&info->mutex);
 
 	/* Read STATUSx register to detect accessory */
-	ret = max14577_bulk_read(info->max14577->regmap,
+	ret = max14577_bulk_read(info->maxim_core->regmap,
 			MAXIM_MUIC_REG_STATUS1, info->status, 2);
 	if (ret) {
 		dev_err(info->dev, "failed to read MUIC register\n");
@@ -626,7 +626,7 @@ static void max14577_muic_detect_cable_wq(struct work_struct *work)
 
 static int max14577_muic_probe(struct platform_device *pdev)
 {
-	struct max14577 *max14577 = dev_get_drvdata(pdev->dev.parent);
+	struct maxim_core *maxim_core = dev_get_drvdata(pdev->dev.parent);
 	struct max14577_muic_info *info;
 	int delay_jiffies;
 	int ret;
@@ -639,7 +639,7 @@ static int max14577_muic_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 	info->dev = &pdev->dev;
-	info->max14577 = max14577;
+	info->maxim_core = maxim_core;
 
 	platform_set_drvdata(pdev, info);
 	mutex_init(&info->mutex);
@@ -651,7 +651,7 @@ static int max14577_muic_probe(struct platform_device *pdev)
 		struct max14577_muic_irq *muic_irq = &muic_irqs[i];
 		unsigned int virq = 0;
 
-		virq = regmap_irq_get_virq(max14577->irq_data, muic_irq->irq);
+		virq = regmap_irq_get_virq(maxim_core->irq_data, muic_irq->irq);
 		if (!virq)
 			return -EINVAL;
 		muic_irq->virq = virq;
@@ -693,7 +693,7 @@ static int max14577_muic_probe(struct platform_device *pdev)
 	max14577_muic_set_path(info, info->path_uart, true);
 
 	/* Check revision number of MUIC device*/
-	ret = max14577_read_reg(info->max14577->regmap,
+	ret = max14577_read_reg(info->maxim_core->regmap,
 			MAXIM_MUIC_REG_DEVICEID, &id);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to read revision number\n");
diff --git a/drivers/mfd/max14577.c b/drivers/mfd/max14577.c
index a054f6f6c16d..f160e582712d 100644
--- a/drivers/mfd/max14577.c
+++ b/drivers/mfd/max14577.c
@@ -85,7 +85,7 @@ static const struct regmap_irq_chip max14577_irq_chip = {
 static int max14577_i2c_probe(struct i2c_client *i2c,
 			      const struct i2c_device_id *id)
 {
-	struct max14577 *max14577;
+	struct maxim_core *maxim_core;
 	struct max14577_platform_data *pdata = dev_get_platdata(&i2c->dev);
 	struct device_node *np = i2c->dev.of_node;
 	u8 reg_data;
@@ -103,70 +103,70 @@ static int max14577_i2c_probe(struct i2c_client *i2c,
 		return -EINVAL;
 	}
 
-	max14577 = devm_kzalloc(&i2c->dev, sizeof(*max14577), GFP_KERNEL);
-	if (!max14577)
+	maxim_core = devm_kzalloc(&i2c->dev, sizeof(*maxim_core), GFP_KERNEL);
+	if (!maxim_core)
 		return -ENOMEM;
 
-	i2c_set_clientdata(i2c, max14577);
-	max14577->dev = &i2c->dev;
-	max14577->i2c = i2c;
-	max14577->irq = i2c->irq;
+	i2c_set_clientdata(i2c, maxim_core);
+	maxim_core->dev = &i2c->dev;
+	maxim_core->i2c = i2c;
+	maxim_core->irq = i2c->irq;
 
-	max14577->regmap = devm_regmap_init_i2c(i2c,
-			&max14577_muic_regmap_config);
-	if (IS_ERR(max14577->regmap)) {
-		ret = PTR_ERR(max14577->regmap);
-		dev_err(max14577->dev, "Failed to allocate register map: %d\n",
+	maxim_core->regmap = devm_regmap_init_i2c(i2c,
+		&max14577_muic_regmap_config);
+	if (IS_ERR(maxim_core->regmap)) {
+		ret = PTR_ERR(maxim_core->regmap);
+		dev_err(maxim_core->dev, "Failed to allocate register map: %d\n",
 				ret);
 		return ret;
 	}
 
-	ret = max14577_read_reg(max14577->regmap, MAXIM_MUIC_REG_DEVICEID,
+	ret = max14577_read_reg(maxim_core->regmap, MAXIM_MUIC_REG_DEVICEID,
 			&reg_data);
 	if (ret) {
-		dev_err(max14577->dev, "Device not found on this channel: %d\n",
+		dev_err(maxim_core->dev, "Device not found on this channel: %d\n",
 				ret);
 		return ret;
 	}
-	max14577->vendor_id = ((reg_data & MAXIM_DEVID_VENDORID_MASK) >>
+	maxim_core->vendor_id = ((reg_data & MAXIM_DEVID_VENDORID_MASK) >>
 				MAXIM_DEVID_VENDORID_SHIFT);
-	max14577->device_id = ((reg_data & MAXIM_DEVID_DEVICEID_MASK) >>
+	maxim_core->device_id = ((reg_data & MAXIM_DEVID_DEVICEID_MASK) >>
 				MAXIM_DEVID_DEVICEID_SHIFT);
-	dev_info(max14577->dev, "Device ID: 0x%x, vendor: 0x%x\n",
-			max14577->device_id, max14577->vendor_id);
+	dev_info(maxim_core->dev, "Device ID: 0x%x, vendor: 0x%x\n",
+			maxim_core->device_id, maxim_core->vendor_id);
 
-	ret = regmap_add_irq_chip(max14577->regmap, max14577->irq,
+	ret = regmap_add_irq_chip(maxim_core->regmap, maxim_core->irq,
 				  IRQF_TRIGGER_FALLING | IRQF_ONESHOT, 0,
 				  &max14577_irq_chip,
-				  &max14577->irq_data);
+				  &maxim_core->irq_data);
 	if (ret != 0) {
 		dev_err(&i2c->dev, "Failed to request IRQ %d: %d\n",
-				max14577->irq, ret);
+				maxim_core->irq, ret);
 		return ret;
 	}
 
-	ret = mfd_add_devices(max14577->dev, -1, max14577_devs,
+	ret = mfd_add_devices(maxim_core->dev, -1, max14577_devs,
 			ARRAY_SIZE(max14577_devs), NULL, 0,
-			regmap_irq_get_domain(max14577->irq_data));
+			regmap_irq_get_domain(maxim_core->irq_data));
 	if (ret < 0)
 		goto err_mfd;
 
-	device_init_wakeup(max14577->dev, 1);
+	device_init_wakeup(maxim_core->dev, 1);
 
 	return 0;
 
 err_mfd:
-	regmap_del_irq_chip(max14577->irq, max14577->irq_data);
+	regmap_del_irq_chip(maxim_core->irq, maxim_core->irq_data);
 
 	return ret;
 }
 
 static int max14577_i2c_remove(struct i2c_client *i2c)
 {
-	struct max14577 *max14577 = i2c_get_clientdata(i2c);
+	struct maxim_core *maxim_core = i2c_get_clientdata(i2c);
 
-	mfd_remove_devices(max14577->dev);
-	regmap_del_irq_chip(max14577->irq, max14577->irq_data);
+	mfd_remove_devices(maxim_core->dev);
+	regmap_del_irq_chip(maxim_core->irq, maxim_core->irq_data);
 
 	return 0;
 }
@@ -180,10 +180,10 @@ MODULE_DEVICE_TABLE(i2c, max14577_i2c_id);
 static int max14577_suspend(struct device *dev)
 {
 	struct i2c_client *i2c = container_of(dev, struct i2c_client, dev);
-	struct max14577 *max14577 = i2c_get_clientdata(i2c);
+	struct maxim_core *maxim_core = i2c_get_clientdata(i2c);
 
 	if (device_may_wakeup(dev)) {
-		enable_irq_wake(max14577->irq);
+		enable_irq_wake(maxim_core->irq);
 		/*
 		 * MUIC IRQ must be disabled during suspend if this is
 		 * a wake up source because it will be handled before
@@ -194,7 +194,7 @@ static int max14577_suspend(struct device *dev)
 		 * Interrupt handler tries to read registers but this read
 		 * will fail because I2C is still suspended.
 		 */
-		disable_irq(max14577->irq);
+		disable_irq(maxim_core->irq);
 	}
 
 	return 0;
@@ -203,11 +203,11 @@ static int max14577_suspend(struct device *dev)
 static int max14577_resume(struct device *dev)
 {
 	struct i2c_client *i2c = container_of(dev, struct i2c_client, dev);
-	struct max14577 *max14577 = i2c_get_clientdata(i2c);
+	struct maxim_core *maxim_core = i2c_get_clientdata(i2c);
 
 	if (device_may_wakeup(dev)) {
-		disable_irq_wake(max14577->irq);
-		enable_irq(max14577->irq);
+		disable_irq_wake(maxim_core->irq);
+		enable_irq(maxim_core->irq);
 	}
 
 	return 0;
diff --git a/drivers/power/max14577_charger.c b/drivers/power/max14577_charger.c
index 66a4e4edea42..335c42a13136 100644
--- a/drivers/power/max14577_charger.c
+++ b/drivers/power/max14577_charger.c
@@ -21,8 +21,8 @@
 #include <linux/mfd/max14577-private.h>
 
 struct max14577_charger {
-	struct device *dev;
-	struct max14577	*max14577;
+	struct device		*dev;
+	struct maxim_core	*maxim_core;
 	struct power_supply	charger;
 
 	unsigned int	charging_state;
@@ -31,7 +31,7 @@ struct max14577_charger {
 
 static int max14577_get_charger_state(struct max14577_charger *chg)
 {
-	struct regmap *rmap = chg->max14577->regmap;
+	struct regmap *rmap = chg->maxim_core->regmap;
 	int state = POWER_SUPPLY_STATUS_DISCHARGING;
 	u8 reg_data;
 
@@ -87,7 +87,7 @@ static int max14577_get_charge_type(struct max14577_charger *chg)
 
 static int max14577_get_online(struct max14577_charger *chg)
 {
-	struct regmap *rmap = chg->max14577->regmap;
+	struct regmap *rmap = chg->maxim_core->regmap;
 	u8 reg_data;
 
 	max14577_read_reg(rmap, MAXIM_MUIC_REG_STATUS2, &reg_data);
@@ -116,7 +116,7 @@ static int max14577_get_online(struct max14577_charger *chg)
  */
 static int max14577_get_battery_health(struct max14577_charger *chg)
 {
-	struct regmap *rmap = chg->max14577->regmap;
+	struct regmap *rmap = chg->maxim_core->regmap;
 	int state = POWER_SUPPLY_HEALTH_GOOD;
 	u8 reg_data;
 
@@ -156,7 +156,7 @@ static int max14577_get_present(struct max14577_charger *chg)
  */
 static void max14577_charger_reg_init(struct max14577_charger *chg)
 {
-	struct regmap *rmap = chg->max14577->regmap;
+	struct regmap *rmap = chg->maxim_core->regmap;
 	u8 reg_data;
 
 	/*
@@ -262,7 +262,7 @@ static int max14577_charger_get_property(struct power_supply *psy,
 static int max14577_charger_probe(struct platform_device *pdev)
 {
 	struct max14577_charger *chg;
-	struct max14577 *max14577 = dev_get_drvdata(pdev->dev.parent);
+	struct maxim_core *maxim_core = dev_get_drvdata(pdev->dev.parent);
 	int ret;
 
 	chg = devm_kzalloc(&pdev->dev, sizeof(*chg), GFP_KERNEL);
@@ -271,7 +271,7 @@ static int max14577_charger_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, chg);
 	chg->dev = &pdev->dev;
-	chg->max14577 = max14577;
+	chg->maxim_core = maxim_core;
 
 	max14577_charger_reg_init(chg);
 
diff --git a/drivers/regulator/max14577.c b/drivers/regulator/max14577.c
index e65d61bb200f..ead56ec819b5 100644
--- a/drivers/regulator/max14577.c
+++ b/drivers/regulator/max14577.c
@@ -196,8 +196,8 @@ static inline struct device_node *match_of_node(int index)
 
 static int max14577_regulator_probe(struct platform_device *pdev)
 {
-	struct max14577 *max14577 = dev_get_drvdata(pdev->dev.parent);
-	struct max14577_platform_data *pdata = dev_get_platdata(max14577->dev);
+	struct maxim_core *maxim_core = dev_get_drvdata(pdev->dev.parent);
+	struct max14577_platform_data *pdata = dev_get_platdata(maxim_core->dev);
 	int i, ret;
 	struct regulator_config config = {};
 
@@ -206,7 +206,7 @@ static int max14577_regulator_probe(struct platform_device *pdev)
 		return ret;
 
 	config.dev = &pdev->dev;
-	config.regmap = max14577->regmap;
+	config.regmap = maxim_core->regmap;
 
 	for (i = 0; i < ARRAY_SIZE(supported_regulators); i++) {
 		struct regulator_dev *regulator;
diff --git a/include/linux/mfd/max14577-private.h b/include/linux/mfd/max14577-private.h
index 9f5ce26cb54e..3fdc32b583be 100644
--- a/include/linux/mfd/max14577-private.h
+++ b/include/linux/mfd/max14577-private.h
@@ -247,7 +247,10 @@ enum maxim_irq {
 	MAXIM_IRQ_NUM,
 };
 
-struct max14577 {
+/*
+ * State container for max14577-like drivers.
+ */
+struct maxim_core {
 	struct device *dev;
 	struct i2c_client *i2c; /* Slave addr = 0x4A */
 
-- 
1.7.9.5

