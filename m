Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702AbaBGKKO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 05:10:14 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:35992 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbaBGKFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 05:05:14 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-c5-52f4afd7d77d
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Anton Vorontsov <anton@enomsg.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH v2 04/15] mfd: max14577: Add "muic" suffix to regmap and
 irq_chip
Date: Fri, 07 Feb 2014 11:04:36 +0100
Message-id: <1391767487-10017-5-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1391767487-10017-1-git-send-email-k.kozlowski@samsung.com>
References: <1391767487-10017-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOLMWRmVeSWpSXmKPExsVy+t/xq7rX138JMvi0QNXi4FZNi40z1rNa
	TH34hM3i+pfnrBaTnrxntpi4cjKzxesXhhZnm96wW9z/epTRYtPja6wWl3fNYbNYe+Quu8Xt
	xhVsFqe7WR34PCb0f2L02DnrLrvH5hVaHptWdbJ53Lm2h81j3slAj81L6j36tqxi9Pi8SS6A
	M4rLJiU1J7MstUjfLoEr4/CVfqaCFZ4VU9+dZW1gfG3bxcjJISFgIvH06n52CFtM4sK99Wxd
	jFwcQgJLGSW2TF/GApIQEuhjkph0yQrEZhMwlti8fAlYkYhAC5PE+/X7GUEcZoFjTBIb75xi
	A6kSFgiWaOq5xARiswioSizvPw+2glfAXWLTjgmsXYwcQOsUJOZMsgEJcwp4SGx5cI4VYpm7
	xK9lPewTGHkXMDKsYhRNLU0uKE5KzzXSK07MLS7NS9dLzs/dxAgJ3K87GJceszrEKMDBqMTD
	q7jic5AQa2JZcWXuIUYJDmYlEV6NtV+ChHhTEiurUovy44tKc1KLDzEycXBKNTAeK3i+ZvHC
	Rq5tgRkst/l0Jqw2PbG0NIm/q8eoSGvu532zm9V5pLxW/M34137m6edq9WkfIq986GyL+Hjj
	pZvrs2NqnKHzprx9H2GzZLVO1kq503wlvsdbPkxIW35GOn/51tLqfNnC9a95Dk6LO62wlem9
	Ju+dyyGzCjxPnDywb78Vi8ixsgO8SizFGYmGWsxFxYkAUmrBCDoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch continues the preparation for adding support for max77836
device to existing max14577 driver.

Add "muic" suffix to regmap and irq_data fields in maxim_core state
container to prepare for max77836 support.
This is only a rename-like patch, new code is not added.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Anton Vorontsov <anton@enomsg.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Acked-by: Lee Jones <lee.jones@linaro.org>
Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
Tested-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/extcon/extcon-max14577.c     |   17 +++++++++--------
 drivers/mfd/max14577.c               |   22 +++++++++++-----------
 drivers/power/max14577_charger.c     |    8 ++++----
 drivers/regulator/max14577.c         |    2 +-
 include/linux/mfd/max14577-private.h |    4 ++--
 5 files changed, 27 insertions(+), 26 deletions(-)

diff --git a/drivers/extcon/extcon-max14577.c b/drivers/extcon/extcon-max14577.c
index 2879cc5844dc..fd48b4909470 100644
--- a/drivers/extcon/extcon-max14577.c
+++ b/drivers/extcon/extcon-max14577.c
@@ -176,7 +176,7 @@ static int max14577_muic_set_debounce_time(struct max14577_muic_info *info,
 	case ADC_DEBOUNCE_TIME_10MS:
 	case ADC_DEBOUNCE_TIME_25MS:
 	case ADC_DEBOUNCE_TIME_38_62MS:
-		ret = max14577_update_reg(info->maxim_core->regmap,
+		ret = max14577_update_reg(info->maxim_core->regmap_muic,
 				MAXIM_MUIC_REG_CONTROL3,
 				MAXIM_CONTROL3_ADCDBSET_MASK,
 				time << MAXIM_CONTROL3_ADCDBSET_SHIFT);
@@ -210,7 +210,7 @@ static int max14577_muic_set_path(struct max14577_muic_info *info,
 	u8 ctrl1, ctrl2 = 0;
 
 	/* Set open state to path before changing hw path */
-	ret = max14577_update_reg(info->maxim_core->regmap,
+	ret = max14577_update_reg(info->maxim_core->regmap_muic,
 			MAXIM_MUIC_REG_CONTROL1,
 			MAXIM_CONTROL1_CLEAR_IDBEN_MICEN_MASK,
 			MAXIM_CONTROL1_SW_OPEN);
@@ -224,7 +224,7 @@ static int max14577_muic_set_path(struct max14577_muic_info *info,
 	else
 		ctrl1 = MAXIM_CONTROL1_SW_OPEN;
 
-	ret = max14577_update_reg(info->maxim_core->regmap,
+	ret = max14577_update_reg(info->maxim_core->regmap_muic,
 				MAXIM_MUIC_REG_CONTROL1,
 				MAXIM_CONTROL1_CLEAR_IDBEN_MICEN_MASK, ctrl1);
 	if (ret < 0) {
@@ -237,7 +237,7 @@ static int max14577_muic_set_path(struct max14577_muic_info *info,
 	else
 		ctrl2 |= MAXIM_CONTROL2_LOWPWR_MASK;	/* LowPwr=1, CPEn=0 */
 
-	ret = max14577_update_reg(info->maxim_core->regmap,
+	ret = max14577_update_reg(info->maxim_core->regmap_muic,
 			MAXIM_MUIC_REG_CONTROL2,
 			MAXIM_CONTROL2_LOWPWR_MASK | MAXIM_CONTROL2_CPEN_MASK,
 			ctrl2);
@@ -505,7 +505,7 @@ static void max14577_muic_irq_work(struct work_struct *work)
 
 	mutex_lock(&info->mutex);
 
-	ret = max14577_bulk_read(info->maxim_core->regmap,
+	ret = max14577_bulk_read(info->maxim_core->regmap_muic,
 			MAXIM_MUIC_REG_STATUS1, info->status, 2);
 	if (ret) {
 		dev_err(info->dev, "failed to read MUIC register\n");
@@ -581,7 +581,7 @@ static int max14577_muic_detect_accessory(struct max14577_muic_info *info)
 	mutex_lock(&info->mutex);
 
 	/* Read STATUSx register to detect accessory */
-	ret = max14577_bulk_read(info->maxim_core->regmap,
+	ret = max14577_bulk_read(info->maxim_core->regmap_muic,
 			MAXIM_MUIC_REG_STATUS1, info->status, 2);
 	if (ret) {
 		dev_err(info->dev, "failed to read MUIC register\n");
@@ -651,7 +651,8 @@ static int max14577_muic_probe(struct platform_device *pdev)
 		struct max14577_muic_irq *muic_irq = &muic_irqs[i];
 		unsigned int virq = 0;
 
-		virq = regmap_irq_get_virq(maxim_core->irq_data, muic_irq->irq);
+		virq = regmap_irq_get_virq(maxim_core->irq_data_muic,
+				muic_irq->irq);
 		if (!virq)
 			return -EINVAL;
 		muic_irq->virq = virq;
@@ -693,7 +694,7 @@ static int max14577_muic_probe(struct platform_device *pdev)
 	max14577_muic_set_path(info, info->path_uart, true);
 
 	/* Check revision number of MUIC device*/
-	ret = max14577_read_reg(info->maxim_core->regmap,
+	ret = max14577_read_reg(info->maxim_core->regmap_muic,
 			MAXIM_MUIC_REG_DEVICEID, &id);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to read revision number\n");
diff --git a/drivers/mfd/max14577.c b/drivers/mfd/max14577.c
index 4567728f3fd4..449e025bd80d 100644
--- a/drivers/mfd/max14577.c
+++ b/drivers/mfd/max14577.c
@@ -112,17 +112,17 @@ static int max14577_i2c_probe(struct i2c_client *i2c,
 	maxim_core->i2c = i2c;
 	maxim_core->irq = i2c->irq;
 
-	maxim_core->regmap = devm_regmap_init_i2c(i2c,
-		&max14577_muic_regmap_config);
-	if (IS_ERR(maxim_core->regmap)) {
-		ret = PTR_ERR(maxim_core->regmap);
+	maxim_core->regmap_muic = devm_regmap_init_i2c(i2c,
+			&max14577_muic_regmap_config);
+	if (IS_ERR(maxim_core->regmap_muic)) {
+		ret = PTR_ERR(maxim_core->regmap_muic);
 		dev_err(maxim_core->dev, "Failed to allocate register map: %d\n",
 				ret);
 		return ret;
 	}
 
-	ret = max14577_read_reg(maxim_core->regmap, MAXIM_MUIC_REG_DEVICEID,
-			&reg_data);
+	ret = max14577_read_reg(maxim_core->regmap_muic,
+			MAXIM_MUIC_REG_DEVICEID, &reg_data);
 	if (ret) {
 		dev_err(maxim_core->dev, "Device not found on this channel: %d\n",
 				ret);
@@ -135,10 +135,10 @@ static int max14577_i2c_probe(struct i2c_client *i2c,
 	dev_info(maxim_core->dev, "Device ID: 0x%x, vendor: 0x%x\n",
 			maxim_core->device_id, maxim_core->vendor_id);
 
-	ret = regmap_add_irq_chip(maxim_core->regmap, maxim_core->irq,
+	ret = regmap_add_irq_chip(maxim_core->regmap_muic, maxim_core->irq,
 				  IRQF_TRIGGER_FALLING | IRQF_ONESHOT, 0,
 				  &max14577_irq_chip,
-				  &maxim_core->irq_data);
+				  &maxim_core->irq_data_muic);
 	if (ret != 0) {
 		dev_err(&i2c->dev, "Failed to request IRQ %d: %d\n",
 				maxim_core->irq, ret);
@@ -147,7 +147,7 @@ static int max14577_i2c_probe(struct i2c_client *i2c,
 
 	ret = mfd_add_devices(maxim_core->dev, -1, max14577_devs,
 			ARRAY_SIZE(max14577_devs), NULL, 0,
-			regmap_irq_get_domain(maxim_core->irq_data));
+			regmap_irq_get_domain(maxim_core->irq_data_muic));
 	if (ret < 0)
 		goto err_mfd;
 
@@ -156,7 +156,7 @@ static int max14577_i2c_probe(struct i2c_client *i2c,
 	return 0;
 
 err_mfd:
-	regmap_del_irq_chip(maxim_core->irq, maxim_core->irq_data);
+	regmap_del_irq_chip(maxim_core->irq, maxim_core->irq_data_muic);
 
 	return ret;
 }
@@ -166,7 +166,7 @@ static int max14577_i2c_remove(struct i2c_client *i2c)
 	struct maxim_core *maxim_core = i2c_get_clientdata(i2c);
 
 	mfd_remove_devices(maxim_core->dev);
-	regmap_del_irq_chip(maxim_core->irq, maxim_core->irq_data);
+	regmap_del_irq_chip(maxim_core->irq, maxim_core->irq_data_muic);
 
 	return 0;
 }
diff --git a/drivers/power/max14577_charger.c b/drivers/power/max14577_charger.c
index 335c42a13136..58cddc3b15d6 100644
--- a/drivers/power/max14577_charger.c
+++ b/drivers/power/max14577_charger.c
@@ -31,7 +31,7 @@ struct max14577_charger {
 
 static int max14577_get_charger_state(struct max14577_charger *chg)
 {
-	struct regmap *rmap = chg->maxim_core->regmap;
+	struct regmap *rmap = chg->maxim_core->regmap_muic;
 	int state = POWER_SUPPLY_STATUS_DISCHARGING;
 	u8 reg_data;
 
@@ -87,7 +87,7 @@ static int max14577_get_charge_type(struct max14577_charger *chg)
 
 static int max14577_get_online(struct max14577_charger *chg)
 {
-	struct regmap *rmap = chg->maxim_core->regmap;
+	struct regmap *rmap = chg->maxim_core->regmap_muic;
 	u8 reg_data;
 
 	max14577_read_reg(rmap, MAXIM_MUIC_REG_STATUS2, &reg_data);
@@ -116,7 +116,7 @@ static int max14577_get_online(struct max14577_charger *chg)
  */
 static int max14577_get_battery_health(struct max14577_charger *chg)
 {
-	struct regmap *rmap = chg->maxim_core->regmap;
+	struct regmap *rmap = chg->maxim_core->regmap_muic;
 	int state = POWER_SUPPLY_HEALTH_GOOD;
 	u8 reg_data;
 
@@ -156,7 +156,7 @@ static int max14577_get_present(struct max14577_charger *chg)
  */
 static void max14577_charger_reg_init(struct max14577_charger *chg)
 {
-	struct regmap *rmap = chg->maxim_core->regmap;
+	struct regmap *rmap = chg->maxim_core->regmap_muic;
 	u8 reg_data;
 
 	/*
diff --git a/drivers/regulator/max14577.c b/drivers/regulator/max14577.c
index 3d75ca7aa87e..d7e8fa630d63 100644
--- a/drivers/regulator/max14577.c
+++ b/drivers/regulator/max14577.c
@@ -207,7 +207,7 @@ static int max14577_regulator_probe(struct platform_device *pdev)
 		return ret;
 
 	config.dev = &pdev->dev;
-	config.regmap = maxim_core->regmap;
+	config.regmap = maxim_core->regmap_muic;
 
 	for (i = 0; i < ARRAY_SIZE(supported_regulators); i++) {
 		struct regulator_dev *regulator;
diff --git a/include/linux/mfd/max14577-private.h b/include/linux/mfd/max14577-private.h
index a0a24556741d..d69c56f02eac 100644
--- a/include/linux/mfd/max14577-private.h
+++ b/include/linux/mfd/max14577-private.h
@@ -251,9 +251,9 @@ struct maxim_core {
 	struct device *dev;
 	struct i2c_client *i2c; /* Slave addr = 0x4A */
 
-	struct regmap *regmap;
+	struct regmap *regmap_muic;
 
-	struct regmap_irq_chip_data *irq_data;
+	struct regmap_irq_chip_data *irq_data_muic;
 	int irq;
 
 	/* Device ID */
-- 
1.7.9.5

