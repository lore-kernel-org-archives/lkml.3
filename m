Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123Ab3FXMmY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 08:42:24 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:55893 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076Ab3FXMmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 08:42:19 -0400
From: <patrice.chotard.st@gmail.com>
To: <linux-kernel@vger.kernel.org>, Linus Walleij <linus.walleij@linaro.org>
Cc: Olivier Clergeaud <olivier.clergeaud@st.com>,
        Lee Jones <lee.jones@linaro.org>,
        Fabio Baltieri <fabio.baltieri@linaro.org>,
        Patrice Chotard <patrice.chotard@st.com>
Subject: [PATCH v3 1/4] pinctrl: abx500: suppress hardcoded value
Date: Mon, 24 Jun 2013 14:41:45 +0200
Message-Id: <1372077706-13008-1-git-send-email-patrice.chotard.st@gmail.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrice Chotard <patrice.chotard@st.com>

Replace hardcoded value by corresponding #define's.

Signed-off-by: Patrice Chotard <patrice.chotard@st.com>
---
 drivers/pinctrl/pinctrl-abx500.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-abx500.c b/drivers/pinctrl/pinctrl-abx500.c
index caa7ab6..7696bfd 100644
--- a/drivers/pinctrl/pinctrl-abx500.c
+++ b/drivers/pinctrl/pinctrl-abx500.c
@@ -96,6 +96,9 @@
 #define AB8540_GPIOX_VBAT_START	51
 #define AB8540_GPIOX_VBAT_END	54
 
+#define ABX500_GPIO_INPUT	0
+#define ABX500_GPIO_OUTPUT	1
+
 struct abx500_pinctrl {
 	struct device *dev;
 	struct pinctrl_dev *pctldev;
@@ -264,12 +267,18 @@ static int abx500_gpio_direction_output(struct gpio_chip *chip,
 	int ret;
 
 	/* set direction as output */
-	ret = abx500_gpio_set_bits(chip, AB8500_GPIO_DIR1_REG, offset, 1);
+	ret = abx500_gpio_set_bits(chip,
+				AB8500_GPIO_DIR1_REG,
+				offset,
+				ABX500_GPIO_OUTPUT);
 	if (ret < 0)
 		return ret;
 
 	/* disable pull down */
-	ret = abx500_gpio_set_bits(chip, AB8500_GPIO_PUD1_REG, offset, 1);
+	ret = abx500_gpio_set_bits(chip,
+				AB8500_GPIO_PUD1_REG,
+				offset,
+				ABX500_GPIO_PULL_NONE);
 	if (ret < 0)
 		return ret;
 
@@ -290,7 +299,10 @@ static int abx500_gpio_direction_output(struct gpio_chip *chip,
 static int abx500_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
 {
 	/* set the register as input */
-	return abx500_gpio_set_bits(chip, AB8500_GPIO_DIR1_REG, offset, 0);
+	return abx500_gpio_set_bits(chip,
+				AB8500_GPIO_DIR1_REG,
+				offset,
+				ABX500_GPIO_INPUT);
 }
 
 static int abx500_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
@@ -1018,7 +1030,8 @@ static int abx500_pin_config_set(struct pinctrl_dev *pctldev,
 		else
 			/* Chip only supports pull down */
 			ret = abx500_gpio_set_bits(chip, AB8500_GPIO_PUD1_REG,
-				offset, argument ? 0 : 1);
+				offset,
+				argument ? ABX500_GPIO_PULL_DOWN : ABX500_GPIO_PULL_NONE);
 		break;
 
 	case PIN_CONFIG_BIAS_PULL_UP:
-- 
1.7.10

