Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482AbaDNJRl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 05:17:41 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:54678 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbaDNJRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 05:17:38 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-b2-534ba7ae2536
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v5 2/9] mfd: max14577: Add muic prefix to regmap config
Date: Mon, 14 Apr 2014 11:17:13 +0200
Message-id: <1397467040-30502-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-reply-to: <1397467040-30502-1-git-send-email-k.kozlowski@samsung.com>
References: <1397467040-30502-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplluLIzCtJLcpLzFFi42I5/e/4Fd11y72DDaa06FpsnLGe1WLqwyds
	Fte/PGe1eP3C0OJs0xt2i/tfjzJafLvSwWRxedccNou1R+6yW9xuXMFmcbqb1YHbY+esu+we
	m1Z1snncubaHzWPeyUCPvi2rGD0+b5ILYIvisklJzcksSy3St0vgytj8ooG5YKJQxfWDN1gb
	GOfydzFyckgImEh8+tvKCGGLSVy4t56ti5GLQ0hgKaPE3zWLWCCcPiaJziNnWECq2ASMJTYv
	XwJWJSLQzCTR0neWEcRhFjjKKDG99y0TSJWwgLvE/nX/mUFsFgFViZuffgLFOTh4geLPTjlD
	rFOQWPZlLVgJp4CHxK3uY2C2EFDJi0+32Scw8i5gZFjFKJpamlxQnJSea6RXnJhbXJqXrpec
	n7uJERKEX3cwLj1mdYhRgINRiYe3Y453sBBrYllxZe4hRgkOZiUR3m0ZXsFCvCmJlVWpRfnx
	RaU5qcWHGJk4OKUaGNOu3to1w97cR+ms9IxGz4bNM16lzbwV/0T1RGfCma5FZmE3n3avkNsu
	6T5J/tWSKefCEz0sd0karTH8uezxeS2Z43zKz1eUrpgR53rgbvav/Ci50xr7by+d9umJxhPp
	Qx1Tbv0OOykj/fHlt5WXt6ak87v8mvxJpy21Rdv09fPVidcKmiqYg5qUWIozEg21mIuKEwED
	RTBkIAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add muic prefix to regmap config to differentiate between another regmap
config for MAX77836 PMIC node. Additionally remove unused
symbols: MAX14577_REG_INVALID and max14577_irq_source.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/mfd/max14577.c               | 9 +++++----
 include/linux/mfd/max14577-private.h | 4 +---
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/mfd/max14577.c b/drivers/mfd/max14577.c
index 5f13cefe8def..d180fae8e317 100644
--- a/drivers/mfd/max14577.c
+++ b/drivers/mfd/max14577.c
@@ -37,7 +37,7 @@ static struct mfd_cell max14577_devs[] = {
 	{ .name = "max14577-charger", },
 };
 
-static bool max14577_volatile_reg(struct device *dev, unsigned int reg)
+static bool max14577_muic_volatile_reg(struct device *dev, unsigned int reg)
 {
 	switch (reg) {
 	case MAX14577_REG_INT1 ... MAX14577_REG_STATUS3:
@@ -48,10 +48,10 @@ static bool max14577_volatile_reg(struct device *dev, unsigned int reg)
 	return false;
 }
 
-static const struct regmap_config max14577_regmap_config = {
+static const struct regmap_config max14577_muic_regmap_config = {
 	.reg_bits	= 8,
 	.val_bits	= 8,
-	.volatile_reg	= max14577_volatile_reg,
+	.volatile_reg	= max14577_muic_volatile_reg,
 	.max_register	= MAX14577_REG_END,
 };
 
@@ -113,7 +113,8 @@ static int max14577_i2c_probe(struct i2c_client *i2c,
 	max14577->i2c = i2c;
 	max14577->irq = i2c->irq;
 
-	max14577->regmap = devm_regmap_init_i2c(i2c, &max14577_regmap_config);
+	max14577->regmap = devm_regmap_init_i2c(i2c,
+			&max14577_muic_regmap_config);
 	if (IS_ERR(max14577->regmap)) {
 		ret = PTR_ERR(max14577->regmap);
 		dev_err(max14577->dev, "Failed to allocate register map: %d\n",
diff --git a/include/linux/mfd/max14577-private.h b/include/linux/mfd/max14577-private.h
index c9b332fb0d5d..97b78d94f92f 100644
--- a/include/linux/mfd/max14577-private.h
+++ b/include/linux/mfd/max14577-private.h
@@ -22,9 +22,7 @@
 #include <linux/i2c.h>
 #include <linux/regmap.h>
 
-#define MAX14577_REG_INVALID		(0xff)
-
-/* Slave addr = 0x4A: Interrupt */
+/* Slave addr = 0x4A: MUIC and Charger */
 enum max14577_reg {
 	MAX14577_REG_DEVICEID		= 0x00,
 	MAX14577_REG_INT1		= 0x01,
-- 
1.8.3.2

