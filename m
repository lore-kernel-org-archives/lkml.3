Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150Ab3KHPFy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 10:05:54 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:41437 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932106Ab3KHPFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 10:05:51 -0500
X-AuditID: cbfec7f5-b7fe66d00000432e-9b-527cfdce46e5
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
Subject: [PATCH 2/2] mfd: max77693: reorder params in API for regmap consistency
Date: Fri, 08 Nov 2013 16:05:18 +0100
Message-id: <1383923118-26921-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1383923118-26921-1-git-send-email-k.kozlowski@samsung.com>
References: <1383923118-26921-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKLMWRmVeSWpSXmKPExsVy+t/xq7rn/tYEGVxolreY+vAJm8X1L89Z
	LV6/MLQ42/SG3eL+16OMFt+udDBZbHp8jdXi8q45bBYzzu9jsrjduILN4nQ3q8XFFV+YHHg8
	ds66y+6xaVUnm8eda3vYPOadDPTYvKTeo2/LKkaPz5vkAtijuGxSUnMyy1KL9O0SuDK+PtvE
	XPBQp6Lx9S72BsZ5ql2MnBwSAiYSz5p/M0LYYhIX7q1n62Lk4hASWMoo8WjHbmYIp49J4vK7
	P0wgVWwCxhKbly8BqxIR+MIk0fHnOzNIglkgTuL0i+VgtrBAgMSxxZvBbBYBVYkHe6eygNi8
	Au4Slz/0AQ3iAFqnIDFnkg1ImFPAQ2Lm1nlg5UJAJX//tLFOYORdwMiwilE0tTS5oDgpPddI
	rzgxt7g0L10vOT93EyMkKL/uYFx6zOoQowAHoxIP74lL1UFCrIllxZW5hxglOJiVRHjLH9YE
	CfGmJFZWpRblxxeV5qQWH2Jk4uCUamDc/W3ClRXJt/9qzW6Y/KNARGefyQnG/R5TpDZ2rTtv
	uMX+eFPjwXRG3XOCgRzn28yE/nKETSwMenA+j9VqxZQXYc6nog4sKso6/KuSI+NJzZYZtntc
	ZF/+WKGTPtshz+2d8PE3mVFTZ6la/Z1q+fr/5i2nRAMjmI6sOXHGRXuOu6lapc1WY658JZbi
	jERDLeai4kQAxwr29igCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The last two parameters of certain register access functions were in
different order than regmap API. This was confusing and error-prone.

Reorder parameters for register access API to match regmap API:
 - max77693_bulk_read() reorder count and buf,
 - max77693_bulk_write() reorder count and buf,
 - max77693_update_reg() reorder val and mask.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/extcon/extcon-max77693.c     |   14 +++++++-------
 drivers/mfd/max77693-irq.c           |    2 +-
 drivers/mfd/max77693.c               |    6 +++---
 include/linux/mfd/max77693-private.h |   10 +++++-----
 4 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
index da268fb..602d948 100644
--- a/drivers/extcon/extcon-max77693.c
+++ b/drivers/extcon/extcon-max77693.c
@@ -257,8 +257,8 @@ static int max77693_muic_set_debounce_time(struct max77693_muic_info *info,
 	case ADC_DEBOUNCE_TIME_38_62MS:
 		ret = max77693_update_reg(info->max77693->regmap_muic,
 					  MAX77693_MUIC_REG_CTRL3,
-					  time << CONTROL3_ADCDBSET_SHIFT,
-					  CONTROL3_ADCDBSET_MASK);
+					  CONTROL3_ADCDBSET_MASK,
+					  time << CONTROL3_ADCDBSET_SHIFT);
 		if (ret) {
 			dev_err(info->dev, "failed to set ADC debounce time\n");
 			return ret;
@@ -294,7 +294,7 @@ static int max77693_muic_set_path(struct max77693_muic_info *info,
 		ctrl1 = CONTROL1_SW_OPEN;
 
 	ret = max77693_update_reg(info->max77693->regmap_muic,
-			MAX77693_MUIC_REG_CTRL1, ctrl1, COMP_SW_MASK);
+			MAX77693_MUIC_REG_CTRL1, COMP_SW_MASK, ctrl1);
 	if (ret < 0) {
 		dev_err(info->dev, "failed to update MUIC register\n");
 		return ret;
@@ -306,8 +306,8 @@ static int max77693_muic_set_path(struct max77693_muic_info *info,
 		ctrl2 |= CONTROL2_LOWPWR_MASK;	/* LowPwr=1, CPEn=0 */
 
 	ret = max77693_update_reg(info->max77693->regmap_muic,
-			MAX77693_MUIC_REG_CTRL2, ctrl2,
-			CONTROL2_LOWPWR_MASK | CONTROL2_CPEN_MASK);
+			MAX77693_MUIC_REG_CTRL2,
+			CONTROL2_LOWPWR_MASK | CONTROL2_CPEN_MASK, ctrl2);
 	if (ret < 0) {
 		dev_err(info->dev, "failed to update MUIC register\n");
 		return ret;
@@ -970,7 +970,7 @@ static void max77693_muic_irq_work(struct work_struct *work)
 			irq_type = muic_irqs[i].irq;
 
 	ret = max77693_bulk_read(info->max77693->regmap_muic,
-			MAX77693_MUIC_REG_STATUS1, 2, info->status);
+			MAX77693_MUIC_REG_STATUS1, info->status, 2);
 	if (ret) {
 		dev_err(info->dev, "failed to read MUIC register\n");
 		mutex_unlock(&info->mutex);
@@ -1043,7 +1043,7 @@ static int max77693_muic_detect_accessory(struct max77693_muic_info *info)
 
 	/* Read STATUSx register to detect accessory */
 	ret = max77693_bulk_read(info->max77693->regmap_muic,
-			MAX77693_MUIC_REG_STATUS1, 2, info->status);
+			MAX77693_MUIC_REG_STATUS1, info->status, 2);
 	if (ret) {
 		dev_err(info->dev, "failed to read MUIC register\n");
 		mutex_unlock(&info->mutex);
diff --git a/drivers/mfd/max77693-irq.c b/drivers/mfd/max77693-irq.c
index 1029d01..8718927 100644
--- a/drivers/mfd/max77693-irq.c
+++ b/drivers/mfd/max77693-irq.c
@@ -207,7 +207,7 @@ static irqreturn_t max77693_irq_thread(int irq, void *data)
 	if (irq_src & MAX77693_IRQSRC_MUIC)
 		/* MUIC INT1 ~ INT3 */
 		max77693_bulk_read(max77693->regmap_muic, MAX77693_MUIC_REG_INT1,
-			MAX77693_NUM_IRQ_MUIC_REGS, &irq_reg[MUIC_INT1]);
+			&irq_reg[MUIC_INT1], MAX77693_NUM_IRQ_MUIC_REGS);
 
 	/* Apply masking */
 	for (i = 0; i < MAX77693_IRQ_GROUP_NR; i++) {
diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
index c04723e..54f1a7f 100644
--- a/drivers/mfd/max77693.c
+++ b/drivers/mfd/max77693.c
@@ -60,7 +60,7 @@ int max77693_read_reg(struct regmap *map, u8 reg, u8 *dest)
 }
 EXPORT_SYMBOL_GPL(max77693_read_reg);
 
-int max77693_bulk_read(struct regmap *map, u8 reg, int count, u8 *buf)
+int max77693_bulk_read(struct regmap *map, u8 reg, u8 *buf, int count)
 {
 	int ret;
 
@@ -80,7 +80,7 @@ int max77693_write_reg(struct regmap *map, u8 reg, u8 value)
 }
 EXPORT_SYMBOL_GPL(max77693_write_reg);
 
-int max77693_bulk_write(struct regmap *map, u8 reg, int count, u8 *buf)
+int max77693_bulk_write(struct regmap *map, u8 reg, u8 *buf, int count)
 {
 	int ret;
 
@@ -90,7 +90,7 @@ int max77693_bulk_write(struct regmap *map, u8 reg, int count, u8 *buf)
 }
 EXPORT_SYMBOL_GPL(max77693_bulk_write);
 
-int max77693_update_reg(struct regmap *map, u8 reg, u8 val, u8 mask)
+int max77693_update_reg(struct regmap *map, u8 reg, u8 mask, u8 val)
 {
 	int ret;
 
diff --git a/include/linux/mfd/max77693-private.h b/include/linux/mfd/max77693-private.h
index 244fb0d..40fd954 100644
--- a/include/linux/mfd/max77693-private.h
+++ b/include/linux/mfd/max77693-private.h
@@ -334,12 +334,12 @@ enum max77693_types {
 };
 
 extern int max77693_read_reg(struct regmap *map, u8 reg, u8 *dest);
-extern int max77693_bulk_read(struct regmap *map, u8 reg, int count,
-				u8 *buf);
+extern int max77693_bulk_read(struct regmap *map, u8 reg, u8 *buf,
+				int count);
 extern int max77693_write_reg(struct regmap *map, u8 reg, u8 value);
-extern int max77693_bulk_write(struct regmap *map, u8 reg, int count,
-				u8 *buf);
-extern int max77693_update_reg(struct regmap *map, u8 reg, u8 val, u8 mask);
+extern int max77693_bulk_write(struct regmap *map, u8 reg, u8 *buf,
+				int count);
+extern int max77693_update_reg(struct regmap *map, u8 reg, u8 mask, u8 val);
 
 extern int max77693_irq_init(struct max77693_dev *max77686);
 extern void max77693_irq_exit(struct max77693_dev *max77686);
-- 
1.7.9.5

