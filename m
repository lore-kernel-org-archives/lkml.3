Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098Ab3KHPFl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 10:05:41 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:41411 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757293Ab3KHPFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 10:05:39 -0500
X-AuditID: cbfec7f5-b7fe66d00000432e-5f-527cfdc16825
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 1/2] mfd: sec: reorder params in API for regmap consistency
Date: Fri, 08 Nov 2013 16:05:17 +0100
Message-id: <1383923118-26921-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDJMWRmVeSWpSXmKPExsVy+t/xq7oH/9YEGUx8rWAx9eETNovrX56z
	Wrx+YWhxtukNu8X9r0cZLb5d6WCy2PT4GqvF5V1z2CxmnN/HZHG7cQWbxeluVouLK74wOfB4
	7Jx1l91j06pONo871/awecw7GeixeUm9R9+WVYwenzfJBbBHcdmkpOZklqUW6dslcGXsnXGe
	saBfq2Lr/ZcsDYzblboYOTkkBEwk1l/4xgRhi0lcuLeerYuRi0NIYCmjxNmPv5ggnD4miav7
	jjKDVLEJGEtsXr4ErEpE4AuTRMef72AJZoE4idMvloPZwgLeEqe3LQOzWQRUJR62/mLsYuTg
	4BVwl9h9QgnElBBQkJgzyWYCI/cCRoZVjKKppckFxUnpuUZ6xYm5xaV56XrJ+bmbGCEh9nUH
	49JjVocYBTgYlXh4T1yqDhJiTSwrrsw9xCjBwawkwlv+sCZIiDclsbIqtSg/vqg0J7X4ECMT
	B6dUA6PtSTPT+ZvZTOV+3Q5iNix4kXnU8lYZ9zf5owtmXtsR4XeF66I+Z0utzbPEoGVLw0VC
	vvRdq3si1lp0NOyf6ITdNv+qf0eWzq1g5V7uc67RZP+NXV0G3rWV16s6vrwJ1Jn/6dgV28cF
	7I19cS5KPT9afd74Oa4S9fUtELe0eSK8/+Pnvj9ZJ5VYijMSDbWYi4oTASFEyUoPAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The last two parameters of certain register access functions were in
different order than regmap API. This was confusing and error-prone.

Reorder parameters for register access API to match regmap API:
 - sec_bulk_read() reorder count and buf,
 - sec_bulk_write() reorder count and buf,
 - sec_reg_update() reorder val and mask.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/mfd/sec-core.c           |    6 +++---
 drivers/regulator/s5m8767.c      |   26 +++++++++++++-------------
 include/linux/mfd/samsung/core.h |    6 +++---
 3 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
index f530e4b..039814e 100644
--- a/drivers/mfd/sec-core.c
+++ b/drivers/mfd/sec-core.c
@@ -84,7 +84,7 @@ int sec_reg_read(struct sec_pmic_dev *sec_pmic, u8 reg, void *dest)
 }
 EXPORT_SYMBOL_GPL(sec_reg_read);
 
-int sec_bulk_read(struct sec_pmic_dev *sec_pmic, u8 reg, int count, u8 *buf)
+int sec_bulk_read(struct sec_pmic_dev *sec_pmic, u8 reg, u8 *buf, int count)
 {
 	return regmap_bulk_read(sec_pmic->regmap, reg, buf, count);
 }
@@ -96,13 +96,13 @@ int sec_reg_write(struct sec_pmic_dev *sec_pmic, u8 reg, u8 value)
 }
 EXPORT_SYMBOL_GPL(sec_reg_write);
 
-int sec_bulk_write(struct sec_pmic_dev *sec_pmic, u8 reg, int count, u8 *buf)
+int sec_bulk_write(struct sec_pmic_dev *sec_pmic, u8 reg, u8 *buf, int count)
 {
 	return regmap_raw_write(sec_pmic->regmap, reg, buf, count);
 }
 EXPORT_SYMBOL_GPL(sec_bulk_write);
 
-int sec_reg_update(struct sec_pmic_dev *sec_pmic, u8 reg, u8 val, u8 mask)
+int sec_reg_update(struct sec_pmic_dev *sec_pmic, u8 reg, u8 mask, u8 val)
 {
 	return regmap_update_bits(sec_pmic->regmap, reg, mask, val);
 }
diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index c24448b..ac10db4 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -243,7 +243,7 @@ static int s5m8767_reg_enable(struct regulator_dev *rdev)
 	if (ret)
 		return ret;
 
-	return sec_reg_update(s5m8767->iodev, reg, enable_ctrl, mask);
+	return sec_reg_update(s5m8767->iodev, reg, mask, enable_ctrl);
 }
 
 static int s5m8767_reg_disable(struct regulator_dev *rdev)
@@ -256,7 +256,7 @@ static int s5m8767_reg_disable(struct regulator_dev *rdev)
 	if (ret)
 		return ret;
 
-	return sec_reg_update(s5m8767->iodev, reg, ~mask, mask);
+	return sec_reg_update(s5m8767->iodev, reg, mask, ~mask);
 }
 
 static int s5m8767_get_vsel_reg(int reg_id, struct s5m8767_info *s5m8767)
@@ -820,14 +820,14 @@ static int s5m8767_pmic_probe(struct platform_device *pdev)
 	if (pdata->buck2_gpiodvs || pdata->buck3_gpiodvs ||
 	   pdata->buck4_gpiodvs) {
 		sec_reg_update(s5m8767->iodev, S5M8767_REG_BUCK2CTRL,
-				(pdata->buck2_gpiodvs) ? (1 << 1) : (0 << 1),
-				1 << 1);
+				1 << 1,
+				(pdata->buck2_gpiodvs) ? (1 << 1) : (0 << 1));
 		sec_reg_update(s5m8767->iodev, S5M8767_REG_BUCK3CTRL,
-				(pdata->buck3_gpiodvs) ? (1 << 1) : (0 << 1),
-				1 << 1);
+				1 << 1,
+				(pdata->buck3_gpiodvs) ? (1 << 1) : (0 << 1));
 		sec_reg_update(s5m8767->iodev, S5M8767_REG_BUCK4CTRL,
-				(pdata->buck4_gpiodvs) ? (1 << 1) : (0 << 1),
-				1 << 1);
+				1 << 1,
+				(pdata->buck4_gpiodvs) ? (1 << 1) : (0 << 1));
 	}
 
 	/* Initialize GPIO DVS registers */
@@ -862,19 +862,19 @@ static int s5m8767_pmic_probe(struct platform_device *pdev)
 		switch (s5m8767->ramp_delay) {
 		case 5:
 			sec_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP,
-					0x40, 0xf0);
+					0xf0, 0x40);
 			break;
 		case 10:
 			sec_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP,
-					0x90, 0xf0);
+					0xf0, 0x90);
 			break;
 		case 25:
 			sec_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP,
-					0xd0, 0xf0);
+					0xf0, 0xd0);
 			break;
 		case 50:
 			sec_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP,
-					0xe0, 0xf0);
+					0xf0, 0xe0);
 			break;
 		case 100:
 			sec_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP,
@@ -882,7 +882,7 @@ static int s5m8767_pmic_probe(struct platform_device *pdev)
 			break;
 		default:
 			sec_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP,
-					0x90, 0xf0);
+					0xf0, 0x90);
 		}
 	}
 
diff --git a/include/linux/mfd/samsung/core.h b/include/linux/mfd/samsung/core.h
index 378ae8a..b04509e 100644
--- a/include/linux/mfd/samsung/core.h
+++ b/include/linux/mfd/samsung/core.h
@@ -58,10 +58,10 @@ void sec_irq_exit(struct sec_pmic_dev *sec_pmic);
 int sec_irq_resume(struct sec_pmic_dev *sec_pmic);
 
 extern int sec_reg_read(struct sec_pmic_dev *sec_pmic, u8 reg, void *dest);
-extern int sec_bulk_read(struct sec_pmic_dev *sec_pmic, u8 reg, int count, u8 *buf);
+extern int sec_bulk_read(struct sec_pmic_dev *sec_pmic, u8 reg, u8 *buf, int count);
 extern int sec_reg_write(struct sec_pmic_dev *sec_pmic, u8 reg, u8 value);
-extern int sec_bulk_write(struct sec_pmic_dev *sec_pmic, u8 reg, int count, u8 *buf);
-extern int sec_reg_update(struct sec_pmic_dev *sec_pmic, u8 reg, u8 val, u8 mask);
+extern int sec_bulk_write(struct sec_pmic_dev *sec_pmic, u8 reg, u8 *buf, int count);
+extern int sec_reg_update(struct sec_pmic_dev *sec_pmic, u8 reg, u8 mask, u8 val);
 
 struct sec_platform_data {
 	struct sec_regulator_data	*regulators;
-- 
1.7.9.5

