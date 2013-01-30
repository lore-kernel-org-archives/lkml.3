Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873Ab3A3Tkg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 14:40:36 -0500
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:48747 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756792Ab3A3Tkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 14:40:31 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3/4] pinctrl/abx500: beautify the ABX500 pin control driver
Date: Wed, 30 Jan 2013 20:40:15 +0100
Message-ID: <1359574815-15695-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lee Jones <lee.jones@linaro.org>

This patch provides some superficial changes to the driver to
aid with readability and maintainability. We're mostly fixing
things like white-space errors, spreading out code which as
been clumped together impeding readability and comment layout,
such as using the new "/**" comment start for function headers
etc. No code semantics were harmed in the making of this patch.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinctrl-abx500.c | 94 +++++++++++++++++++++++++---------------
 1 file changed, 59 insertions(+), 35 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-abx500.c b/drivers/pinctrl/pinctrl-abx500.c
index 305a9cb..426b47c 100644
--- a/drivers/pinctrl/pinctrl-abx500.c
+++ b/drivers/pinctrl/pinctrl-abx500.c
@@ -127,7 +127,7 @@ static inline struct abx500_pinctrl *to_abx500_pinctrl(struct gpio_chip *chip)
 }
 
 static int abx500_gpio_get_bit(struct gpio_chip *chip, u8 reg,
-					unsigned offset, bool *bit)
+			       unsigned offset, bool *bit)
 {
 	struct abx500_pinctrl *pct = to_abx500_pinctrl(chip);
 	u8 pos = offset % 8;
@@ -149,7 +149,7 @@ static int abx500_gpio_get_bit(struct gpio_chip *chip, u8 reg,
 }
 
 static int abx500_gpio_set_bits(struct gpio_chip *chip, u8 reg,
-					unsigned offset, int val)
+				unsigned offset, int val)
 {
 	struct abx500_pinctrl *pct = to_abx500_pinctrl(chip);
 	u8 pos = offset % 8;
@@ -160,12 +160,14 @@ static int abx500_gpio_set_bits(struct gpio_chip *chip, u8 reg,
 				AB8500_MISC, reg, BIT(pos), val << pos);
 	if (ret < 0)
 		dev_err(pct->dev, "%s write failed\n", __func__);
+
 	return ret;
 }
+
 /**
  * abx500_gpio_get() - Get the particular GPIO value
- * @chip: Gpio device
- * @offset: GPIO number to read
+ * @chip:	Gpio device
+ * @offset:	GPIO number to read
  */
 static int abx500_gpio_get(struct gpio_chip *chip, unsigned offset)
 {
@@ -179,6 +181,7 @@ static int abx500_gpio_get(struct gpio_chip *chip, unsigned offset)
 		dev_err(pct->dev, "%s failed\n", __func__);
 		return ret;
 	}
+
 	return bit;
 }
 
@@ -193,7 +196,7 @@ static void abx500_gpio_set(struct gpio_chip *chip, unsigned offset, int val)
 }
 
 static int abx500_config_pull_updown(struct abx500_pinctrl *pct,
-				int offset, enum abx500_gpio_pull_updown val)
+				     int offset, enum abx500_gpio_pull_updown val)
 {
 	u8 pos;
 	int ret;
@@ -223,6 +226,7 @@ static int abx500_config_pull_updown(struct abx500_pinctrl *pct,
 out:
 	if (ret < 0)
 		dev_err(pct->dev, "%s failed (%d)\n", __func__, ret);
+
 	return ret;
 }
 
@@ -234,6 +238,7 @@ static int abx500_gpio_direction_output(struct gpio_chip *chip,
 	struct pullud *pullud = pct->soc->pullud;
 	unsigned gpio;
 	int ret;
+
 	/* set direction as output */
 	ret = abx500_gpio_set_bits(chip, AB8500_GPIO_DIR1_REG, offset, 1);
 	if (ret < 0)
@@ -253,6 +258,7 @@ static int abx500_gpio_direction_output(struct gpio_chip *chip,
 		if (ret < 0)
 			return ret;
 	}
+
 	/* set the output as 1 or 0 */
 	return abx500_gpio_set_bits(chip, AB8500_GPIO_OUT1_REG, offset, val);
 }
@@ -284,13 +290,14 @@ static int abx500_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
 }
 
 static int abx500_set_mode(struct pinctrl_dev *pctldev, struct gpio_chip *chip,
-		unsigned gpio, int alt_setting)
+			   unsigned gpio, int alt_setting)
 {
 	struct abx500_pinctrl *pct = pinctrl_dev_get_drvdata(pctldev);
 	struct alternate_functions af = pct->soc->alternate_functions[gpio];
 	int ret;
 	int val;
 	unsigned offset;
+
 	const char *modes[] = {
 		[ABX500_DEFAULT]	= "default",
 		[ABX500_ALT_A]		= "altA",
@@ -309,6 +316,7 @@ static int abx500_set_mode(struct pinctrl_dev *pctldev, struct gpio_chip *chip,
 
 	/* on ABx5xx, there is no GPIO0, so adjust the offset */
 	offset = gpio - 1;
+
 	switch (alt_setting) {
 	case ABX500_DEFAULT:
 		/*
@@ -324,6 +332,7 @@ static int abx500_set_mode(struct pinctrl_dev *pctldev, struct gpio_chip *chip,
 		ret = abx500_gpio_set_bits(chip, AB8500_GPIO_SEL1_REG,
 					   offset, val);
 		break;
+
 	case ABX500_ALT_A:
 		/*
 		 * for ABx5xx family, alt_a mode is always selected by
@@ -348,6 +357,7 @@ static int abx500_set_mode(struct pinctrl_dev *pctldev, struct gpio_chip *chip,
 			ret = abx500_gpio_set_bits(chip, AB8500_GPIO_SEL1_REG,
 					offset, 1);
 		break;
+
 	case ABX500_ALT_B:
 		ret = abx500_gpio_set_bits(chip, AB8500_GPIO_SEL1_REG,
 				offset, 0);
@@ -359,6 +369,7 @@ static int abx500_set_mode(struct pinctrl_dev *pctldev, struct gpio_chip *chip,
 					af.alt_bit2,
 					!!(af.altb_val && BIT(1)));
 		break;
+
 	case ABX500_ALT_C:
 		ret = abx500_gpio_set_bits(chip, AB8500_GPIO_SEL1_REG,
 				offset, 0);
@@ -370,13 +381,15 @@ static int abx500_set_mode(struct pinctrl_dev *pctldev, struct gpio_chip *chip,
 
 	default:
 		dev_dbg(pct->dev, "unknow alt_setting %d\n", alt_setting);
+
 		return -EINVAL;
 	}
+
 	return ret;
 }
 
 static u8 abx500_get_mode(struct pinctrl_dev *pctldev, struct gpio_chip *chip,
-		unsigned gpio)
+			  unsigned gpio)
 {
 	u8 mode;
 	bool bit_mode;
@@ -404,6 +417,7 @@ static u8 abx500_get_mode(struct pinctrl_dev *pctldev, struct gpio_chip *chip,
 			"alt_bitX value not in correct range (-1 to 7)\n");
 		return -EINVAL;
 	}
+
 	/* if alt_bit2 is used, alt_bit1 must be used too */
 	if ((af.alt_bit2 != UNUSED) && (af.alt_bit1 == UNUSED)) {
 		dev_err(pct->dev,
@@ -420,6 +434,7 @@ static u8 abx500_get_mode(struct pinctrl_dev *pctldev, struct gpio_chip *chip,
 	 */
 	if (mode)
 		return ABX500_DEFAULT;
+
 	/*
 	 * pin use the AlternatFunction register
 	 * read alt_bit1 value
@@ -448,8 +463,9 @@ static u8 abx500_get_mode(struct pinctrl_dev *pctldev, struct gpio_chip *chip,
 #include <linux/seq_file.h>
 
 static void abx500_gpio_dbg_show_one(struct seq_file *s,
-	struct pinctrl_dev *pctldev, struct gpio_chip *chip,
-	unsigned offset, unsigned gpio)
+				     struct pinctrl_dev *pctldev,
+				     struct gpio_chip *chip,
+				     unsigned offset, unsigned gpio)
 {
 	struct abx500_pinctrl *pct = to_abx500_pinctrl(chip);
 	const char *label = gpiochip_is_requested(chip, offset - 1);
@@ -457,6 +473,7 @@ static void abx500_gpio_dbg_show_one(struct seq_file *s,
 	int mode = -1;
 	bool is_out;
 	bool pull;
+
 	const char *modes[] = {
 		[ABX500_DEFAULT]	= "default",
 		[ABX500_ALT_A]		= "altA",
@@ -516,9 +533,9 @@ static void abx500_gpio_dbg_show(struct seq_file *s, struct gpio_chip *chip)
 
 #else
 static inline void abx500_gpio_dbg_show_one(struct seq_file *s,
-					 struct pinctrl_dev *pctldev,
-					 struct gpio_chip *chip,
-					 unsigned offset, unsigned gpio)
+					    struct pinctrl_dev *pctldev,
+					    struct gpio_chip *chip,
+					    unsigned offset, unsigned gpio)
 {
 }
 #define abx500_gpio_dbg_show	NULL
@@ -780,9 +797,9 @@ static const char *abx500_pmx_get_func_name(struct pinctrl_dev *pctldev,
 }
 
 static int abx500_pmx_get_func_groups(struct pinctrl_dev *pctldev,
-				   unsigned function,
-				   const char * const **groups,
-				   unsigned * const num_groups)
+				      unsigned function,
+				      const char * const **groups,
+				      unsigned * const num_groups)
 {
 	struct abx500_pinctrl *pct = pinctrl_dev_get_drvdata(pctldev);
 
@@ -830,7 +847,7 @@ static void abx500_disable_lazy_irq(struct gpio_chip *chip, unsigned gpio)
 }
 
 static int abx500_pmx_enable(struct pinctrl_dev *pctldev, unsigned function,
-			  unsigned group)
+			     unsigned group)
 {
 	struct abx500_pinctrl *pct = pinctrl_dev_get_drvdata(pctldev);
 	struct gpio_chip *chip = &pct->chip;
@@ -851,11 +868,12 @@ static int abx500_pmx_enable(struct pinctrl_dev *pctldev, unsigned function,
 		abx500_disable_lazy_irq(chip, g->pins[i]);
 		ret = abx500_set_mode(pctldev, chip, g->pins[i], g->altsetting);
 	}
+
 	return ret;
 }
 
 static void abx500_pmx_disable(struct pinctrl_dev *pctldev,
-			    unsigned function, unsigned group)
+			       unsigned function, unsigned group)
 {
 	struct abx500_pinctrl *pct = pinctrl_dev_get_drvdata(pctldev);
 	const struct abx500_pingroup *g;
@@ -869,8 +887,8 @@ static void abx500_pmx_disable(struct pinctrl_dev *pctldev,
 }
 
 int abx500_gpio_request_enable(struct pinctrl_dev *pctldev,
-			    struct pinctrl_gpio_range *range,
-			    unsigned offset)
+			       struct pinctrl_gpio_range *range,
+			       unsigned offset)
 {
 	struct abx500_pinctrl *pct = pinctrl_dev_get_drvdata(pctldev);
 	const struct abx500_pinrange *p;
@@ -908,8 +926,8 @@ int abx500_gpio_request_enable(struct pinctrl_dev *pctldev,
 }
 
 static void abx500_gpio_disable_free(struct pinctrl_dev *pctldev,
-			   struct pinctrl_gpio_range *range,
-			   unsigned offset)
+				     struct pinctrl_gpio_range *range,
+				     unsigned offset)
 {
 }
 
@@ -931,7 +949,7 @@ static int abx500_get_groups_cnt(struct pinctrl_dev *pctldev)
 }
 
 static const char *abx500_get_group_name(struct pinctrl_dev *pctldev,
-				       unsigned selector)
+					 unsigned selector)
 {
 	struct abx500_pinctrl *pct = pinctrl_dev_get_drvdata(pctldev);
 
@@ -939,19 +957,20 @@ static const char *abx500_get_group_name(struct pinctrl_dev *pctldev,
 }
 
 static int abx500_get_group_pins(struct pinctrl_dev *pctldev,
-		unsigned selector,
-		const unsigned **pins,
-		unsigned *num_pins)
+				 unsigned selector,
+				 const unsigned **pins,
+				 unsigned *num_pins)
 {
 	struct abx500_pinctrl *pct = pinctrl_dev_get_drvdata(pctldev);
 
 	*pins = pct->soc->groups[selector].pins;
 	*num_pins = pct->soc->groups[selector].npins;
+
 	return 0;
 }
 
 static void abx500_pin_dbg_show(struct pinctrl_dev *pctldev,
-		struct seq_file *s, unsigned offset)
+				struct seq_file *s, unsigned offset)
 {
 	struct abx500_pinctrl *pct = pinctrl_dev_get_drvdata(pctldev);
 	struct gpio_chip *chip = &pct->chip;
@@ -968,15 +987,15 @@ static struct pinctrl_ops abx500_pinctrl_ops = {
 };
 
 int abx500_pin_config_get(struct pinctrl_dev *pctldev,
-		       unsigned pin,
-		       unsigned long *config)
+			  unsigned pin,
+			  unsigned long *config)
 {
 	return -ENOSYS;
 }
 
 int abx500_pin_config_set(struct pinctrl_dev *pctldev,
-		       unsigned pin,
-		       unsigned long config)
+			  unsigned pin,
+			  unsigned long config)
 {
 	struct abx500_pinctrl *pct = pinctrl_dev_get_drvdata(pctldev);
 	struct pullud *pullud = pct->soc->pullud;
@@ -990,6 +1009,7 @@ int abx500_pin_config_set(struct pinctrl_dev *pctldev,
 		pin, config, (param == PIN_CONFIG_OUTPUT) ? "output " : "input",
 		(param == PIN_CONFIG_OUTPUT) ? (argument ? "high" : "low") :
 		(argument ? "pull up" : "pull down"));
+
 	/* on ABx500, there is no GPIO0, so adjust the offset */
 	offset = pin - 1;
 
@@ -1018,13 +1038,18 @@ int abx500_pin_config_set(struct pinctrl_dev *pctldev,
 			ret = abx500_gpio_set_bits(chip, AB8500_GPIO_PUD1_REG,
 				offset, argument ? 0 : 1);
 		break;
+
 	case PIN_CONFIG_OUTPUT:
 		ret = abx500_gpio_direction_output(chip, offset, argument);
+
 		break;
+
 	default:
 		dev_err(chip->dev, "illegal configuration requested\n");
+
 		return -EINVAL;
 	}
+
 	return ret;
 }
 
@@ -1090,7 +1115,7 @@ static int abx500_gpio_probe(struct platform_device *pdev)
 	int i;
 
 	pdata = abx500_pdata->gpio;
-	if (!pdata)	{
+	if (!pdata) {
 		dev_err(&pdev->dev, "gpio platform data missing\n");
 		return -ENODEV;
 	}
@@ -1150,8 +1175,7 @@ static int abx500_gpio_probe(struct platform_device *pdev)
 		goto out_free;
 	ret = gpiochip_add(&pct->chip);
 	if (ret) {
-		dev_err(&pdev->dev, "unable to add gpiochip: %d\n",
-				ret);
+		dev_err(&pdev->dev, "unable to add gpiochip: %d\n", ret);
 		goto out_rem_irq;
 	}
 	dev_info(&pdev->dev, "added gpiochip\n");
@@ -1193,9 +1217,9 @@ out_free:
 	return ret;
 }
 
-/*
+/**
  * abx500_gpio_remove() - remove Ab8500-gpio driver
- * @pdev :	Platform device registered
+ * @pdev:	Platform device registered
  */
 static int abx500_gpio_remove(struct platform_device *pdev)
 {
-- 
1.7.11.3

