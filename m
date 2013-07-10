Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab3GJL46 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 07:56:58 -0400
Received: from mga03.intel.com ([143.182.124.21]:64337 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754492Ab3GJLzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 07:55:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1035,1363158000"; 
   d="scan'208";a="266364933"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 4/5] pinctrl-baytrail: introduce to_byt_gpio() macro
Date: Wed, 10 Jul 2013 14:55:39 +0300
Message-Id: <1373457340-16666-5-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1373457340-16666-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1373457340-16666-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The introduced macro helps to convert struct gpio_chip to struct byt_gpio.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/pinctrl/pinctrl-baytrail.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-baytrail.c b/drivers/pinctrl/pinctrl-baytrail.c
index 14a143c..14e1e22 100644
--- a/drivers/pinctrl/pinctrl-baytrail.c
+++ b/drivers/pinctrl/pinctrl-baytrail.c
@@ -130,10 +130,12 @@ struct byt_gpio {
 	struct pinctrl_gpio_range	*range;
 };
 
+#define to_byt_gpio(c)	container_of(c, struct byt_gpio, chip)
+
 static void __iomem *byt_gpio_reg(struct gpio_chip *chip, unsigned offset,
 				 int reg)
 {
-	struct byt_gpio *vg = container_of(chip, struct byt_gpio, chip);
+	struct byt_gpio *vg = to_byt_gpio(chip);
 	u32 reg_offset;
 
 	if (reg == BYT_INT_STAT_REG)
@@ -146,7 +148,7 @@ static void __iomem *byt_gpio_reg(struct gpio_chip *chip, unsigned offset,
 
 static int byt_gpio_request(struct gpio_chip *chip, unsigned offset)
 {
-	struct byt_gpio *vg = container_of(chip, struct byt_gpio, chip);
+	struct byt_gpio *vg = to_byt_gpio(chip);
 
 	pm_runtime_get(&vg->pdev->dev);
 
@@ -155,7 +157,7 @@ static int byt_gpio_request(struct gpio_chip *chip, unsigned offset)
 
 static void byt_gpio_free(struct gpio_chip *chip, unsigned offset)
 {
-	struct byt_gpio *vg = container_of(chip, struct byt_gpio, chip);
+	struct byt_gpio *vg = to_byt_gpio(chip);
 	void __iomem *reg = byt_gpio_reg(&vg->chip, offset, BYT_CONF0_REG);
 	u32 value;
 
@@ -216,7 +218,7 @@ static int byt_gpio_get(struct gpio_chip *chip, unsigned offset)
 
 static void byt_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
 {
-	struct byt_gpio *vg = container_of(chip, struct byt_gpio, chip);
+	struct byt_gpio *vg = to_byt_gpio(chip);
 	void __iomem *reg = byt_gpio_reg(chip, offset, BYT_VAL_REG);
 	unsigned long flags;
 	u32 old_val;
@@ -235,7 +237,7 @@ static void byt_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
 
 static int byt_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
 {
-	struct byt_gpio *vg = container_of(chip, struct byt_gpio, chip);
+	struct byt_gpio *vg = to_byt_gpio(chip);
 	void __iomem *reg = byt_gpio_reg(chip, offset, BYT_VAL_REG);
 	unsigned long flags;
 	u32 value;
@@ -254,7 +256,7 @@ static int byt_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
 static int byt_gpio_direction_output(struct gpio_chip *chip,
 				     unsigned gpio, int value)
 {
-	struct byt_gpio *vg = container_of(chip, struct byt_gpio, chip);
+	struct byt_gpio *vg = to_byt_gpio(chip);
 	void __iomem *reg = byt_gpio_reg(chip, gpio, BYT_VAL_REG);
 	unsigned long flags;
 	u32 reg_val;
@@ -272,7 +274,7 @@ static int byt_gpio_direction_output(struct gpio_chip *chip,
 
 static void byt_gpio_dbg_show(struct seq_file *s, struct gpio_chip *chip)
 {
-	struct byt_gpio *vg = container_of(chip, struct byt_gpio, chip);
+	struct byt_gpio *vg = to_byt_gpio(chip);
 	int i;
 	unsigned long flags;
 	u32 conf0, val, offs;
@@ -301,7 +303,7 @@ static void byt_gpio_dbg_show(struct seq_file *s, struct gpio_chip *chip)
 
 static int byt_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
 {
-	struct byt_gpio *vg = container_of(chip, struct byt_gpio, chip);
+	struct byt_gpio *vg = to_byt_gpio(chip);
 	return irq_create_mapping(vg->domain, offset);
 }
 
-- 
1.8.3.2

