Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030291Ab3FTOG7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 10:06:59 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:58823 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965594Ab3FTOG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 10:06:57 -0400
From: <patrice.chotard.st@gmail.com>
To: <linux-kernel@vger.kernel.org>, Linus Walleij <linus.walleij@linaro.org>
Cc: Olivier Clergeaud <olivier.clergeaud@st.com>,
        Lee Jones <lee.jones@linaro.org>,
        Fabio Baltieri <fabio.baltieri@linaro.org>,
        Patrice Chotard <patrice.chotard@st.com>
Subject: [PATCH v2 1/4] pinctrl: abx500: suppress hardcoded value
Date: Thu, 20 Jun 2013 16:05:42 +0200
Message-Id: <1371737145-27662-2-git-send-email-patrice.chotard.st@gmail.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1371737145-27662-1-git-send-email-patrice.chotard.st@gmail.com>
References: <1371737145-27662-1-git-send-email-patrice.chotard.st@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrice Chotard <patrice.chotard@st.com>

Replace hardcoded value by corresponding #define's.

Signed-off-by: Patrice Chotard <patrice.chotard@st.com>
---
 drivers/pinctrl/pinctrl-abx500.c       |   18 ++++++++++++++----
 include/linux/mfd/abx500/ab8500-gpio.h |    5 +++++
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-abx500.c b/drivers/pinctrl/pinctrl-abx500.c
index caa7ab6..d1d42e7 100644
--- a/drivers/pinctrl/pinctrl-abx500.c
+++ b/drivers/pinctrl/pinctrl-abx500.c
@@ -264,12 +264,18 @@ static int abx500_gpio_direction_output(struct gpio_chip *chip,
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
 
@@ -290,7 +296,10 @@ static int abx500_gpio_direction_output(struct gpio_chip *chip,
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
@@ -1018,7 +1027,8 @@ static int abx500_pin_config_set(struct pinctrl_dev *pctldev,
 		else
 			/* Chip only supports pull down */
 			ret = abx500_gpio_set_bits(chip, AB8500_GPIO_PUD1_REG,
-				offset, argument ? 0 : 1);
+				offset,
+				argument ? ABX500_GPIO_PULL_DOWN : ABX500_GPIO_PULL_NONE);
 		break;
 
 	case PIN_CONFIG_BIAS_PULL_UP:
diff --git a/include/linux/mfd/abx500/ab8500-gpio.h b/include/linux/mfd/abx500/ab8500-gpio.h
index 172b2f2..dafeca4 100644
--- a/include/linux/mfd/abx500/ab8500-gpio.h
+++ b/include/linux/mfd/abx500/ab8500-gpio.h
@@ -30,4 +30,9 @@ enum abx500_gpio_vinsel {
 	ABX500_GPIO_VINSEL_VDD_BIF = 0x2,
 };
 
+enum abx500_gpio_direction {
+	ABX500_GPIO_INPUT = 0x0,
+	ABX500_GPIO_OUTPUT = 0x1,
+};
+
 #endif /* _AB8500_GPIO_H */
-- 
1.7.10

