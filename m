Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252AbaJBSxT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 14:53:19 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:64388 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbaJBSwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 14:52:24 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: [PATCH v2 3/5] pinctrl: samsung: Constify samsung_pin_bank_type struct
Date: Thu,  2 Oct 2014 20:52:09 +0200
Message-Id: <1412275931-10807-4-git-send-email-tomasz.figa@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1412275931-10807-1-git-send-email-tomasz.figa@gmail.com>
References: <1412275931-10807-1-git-send-email-tomasz.figa@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This structure is not intended to be modified at runtime and functions
as constant data shared between multiple pin banks. This patch makes all
instances of it constant across the driver.

Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 drivers/pinctrl/samsung/pinctrl-exynos.c  |  6 +++---
 drivers/pinctrl/samsung/pinctrl-s3c24xx.c |  6 +++---
 drivers/pinctrl/samsung/pinctrl-s3c64xx.c | 14 +++++++-------
 drivers/pinctrl/samsung/pinctrl-samsung.c | 20 +++++++++-----------
 drivers/pinctrl/samsung/pinctrl-samsung.h |  2 +-
 5 files changed, 23 insertions(+), 25 deletions(-)

diff --git a/drivers/pinctrl/samsung/pinctrl-exynos.c b/drivers/pinctrl/samsung/pinctrl-exynos.c
index 67658d6d4b4e..0f46391df3ea 100644
--- a/drivers/pinctrl/samsung/pinctrl-exynos.c
+++ b/drivers/pinctrl/samsung/pinctrl-exynos.c
@@ -46,12 +46,12 @@ static inline struct exynos_irq_chip *to_exynos_irq_chip(struct irq_chip *chip)
 	return container_of(chip, struct exynos_irq_chip, chip);
 }
 
-static struct samsung_pin_bank_type bank_type_off = {
+static const struct samsung_pin_bank_type bank_type_off = {
 	.fld_width = { 4, 1, 2, 2, 2, 2, },
 	.reg_offset = { 0x00, 0x04, 0x08, 0x0c, 0x10, 0x14, },
 };
 
-static struct samsung_pin_bank_type bank_type_alive = {
+static const struct samsung_pin_bank_type bank_type_alive = {
 	.fld_width = { 4, 1, 2, 2, },
 	.reg_offset = { 0x00, 0x04, 0x08, 0x0c, },
 };
@@ -127,7 +127,7 @@ static int exynos_irq_set_type(struct irq_data *irqd, unsigned int type)
 	struct irq_chip *chip = irq_data_get_irq_chip(irqd);
 	struct exynos_irq_chip *our_chip = to_exynos_irq_chip(chip);
 	struct samsung_pin_bank *bank = irq_data_get_irq_chip_data(irqd);
-	struct samsung_pin_bank_type *bank_type = bank->type;
+	const struct samsung_pin_bank_type *bank_type = bank->type;
 	struct samsung_pinctrl_drv_data *d = bank->drvdata;
 	unsigned int pin = irqd->hwirq;
 	unsigned int shift = EXYNOS_EINT_CON_LEN * pin;
diff --git a/drivers/pinctrl/samsung/pinctrl-s3c24xx.c b/drivers/pinctrl/samsung/pinctrl-s3c24xx.c
index e38925906bd3..9db6cf5c8823 100644
--- a/drivers/pinctrl/samsung/pinctrl-s3c24xx.c
+++ b/drivers/pinctrl/samsung/pinctrl-s3c24xx.c
@@ -44,12 +44,12 @@
 #define EINT_EDGE_BOTH		6
 #define EINT_MASK		0xf
 
-static struct samsung_pin_bank_type bank_type_1bit = {
+static const struct samsung_pin_bank_type bank_type_1bit = {
 	.fld_width = { 1, 1, },
 	.reg_offset = { 0x00, 0x04, },
 };
 
-static struct samsung_pin_bank_type bank_type_2bit = {
+static const struct samsung_pin_bank_type bank_type_2bit = {
 	.fld_width = { 2, 1, 2, },
 	.reg_offset = { 0x00, 0x04, 0x08, },
 };
@@ -143,7 +143,7 @@ static void s3c24xx_eint_set_handler(unsigned int irq, unsigned int type)
 static void s3c24xx_eint_set_function(struct samsung_pinctrl_drv_data *d,
 					struct samsung_pin_bank *bank, int pin)
 {
-	struct samsung_pin_bank_type *bank_type = bank->type;
+	const struct samsung_pin_bank_type *bank_type = bank->type;
 	unsigned long flags;
 	void __iomem *reg;
 	u8 shift;
diff --git a/drivers/pinctrl/samsung/pinctrl-s3c64xx.c b/drivers/pinctrl/samsung/pinctrl-s3c64xx.c
index fcf8c36e727e..2a14db2826d8 100644
--- a/drivers/pinctrl/samsung/pinctrl-s3c64xx.c
+++ b/drivers/pinctrl/samsung/pinctrl-s3c64xx.c
@@ -68,32 +68,32 @@
 #define EINT_CON_MASK		0xF
 #define EINT_CON_LEN		4
 
-static struct samsung_pin_bank_type bank_type_4bit_off = {
+static const struct samsung_pin_bank_type bank_type_4bit_off = {
 	.fld_width = { 4, 1, 2, 0, 2, 2, },
 	.reg_offset = { 0x00, 0x04, 0x08, 0, 0x0c, 0x10, },
 };
 
-static struct samsung_pin_bank_type bank_type_4bit_alive = {
+static const struct samsung_pin_bank_type bank_type_4bit_alive = {
 	.fld_width = { 4, 1, 2, },
 	.reg_offset = { 0x00, 0x04, 0x08, },
 };
 
-static struct samsung_pin_bank_type bank_type_4bit2_off = {
+static const struct samsung_pin_bank_type bank_type_4bit2_off = {
 	.fld_width = { 4, 1, 2, 0, 2, 2, },
 	.reg_offset = { 0x00, 0x08, 0x0c, 0, 0x10, 0x14, },
 };
 
-static struct samsung_pin_bank_type bank_type_4bit2_alive = {
+static const struct samsung_pin_bank_type bank_type_4bit2_alive = {
 	.fld_width = { 4, 1, 2, },
 	.reg_offset = { 0x00, 0x08, 0x0c, },
 };
 
-static struct samsung_pin_bank_type bank_type_2bit_off = {
+static const struct samsung_pin_bank_type bank_type_2bit_off = {
 	.fld_width = { 2, 1, 2, 0, 2, 2, },
 	.reg_offset = { 0x00, 0x04, 0x08, 0, 0x0c, 0x10, },
 };
 
-static struct samsung_pin_bank_type bank_type_2bit_alive = {
+static const struct samsung_pin_bank_type bank_type_2bit_alive = {
 	.fld_width = { 2, 1, 2, },
 	.reg_offset = { 0x00, 0x04, 0x08, },
 };
@@ -272,7 +272,7 @@ static void s3c64xx_irq_set_handler(unsigned int irq, unsigned int type)
 static void s3c64xx_irq_set_function(struct samsung_pinctrl_drv_data *d,
 					struct samsung_pin_bank *bank, int pin)
 {
-	struct samsung_pin_bank_type *bank_type = bank->type;
+	const struct samsung_pin_bank_type *bank_type = bank->type;
 	unsigned long flags;
 	void __iomem *reg;
 	u8 shift;
diff --git a/drivers/pinctrl/samsung/pinctrl-samsung.c b/drivers/pinctrl/samsung/pinctrl-samsung.c
index 0504f0b75de8..b8edc901fe08 100644
--- a/drivers/pinctrl/samsung/pinctrl-samsung.c
+++ b/drivers/pinctrl/samsung/pinctrl-samsung.c
@@ -366,7 +366,7 @@ static void samsung_pinmux_setup(struct pinctrl_dev *pctldev, unsigned selector,
 					unsigned group, bool enable)
 {
 	struct samsung_pinctrl_drv_data *drvdata;
-	struct samsung_pin_bank_type *type;
+	const struct samsung_pin_bank_type *type;
 	struct samsung_pin_bank *bank;
 	void __iomem *reg;
 	u32 mask, shift, data, pin_offset;
@@ -422,7 +422,7 @@ static int samsung_pinconf_rw(struct pinctrl_dev *pctldev, unsigned int pin,
 				unsigned long *config, bool set)
 {
 	struct samsung_pinctrl_drv_data *drvdata;
-	struct samsung_pin_bank_type *type;
+	const struct samsung_pin_bank_type *type;
 	struct samsung_pin_bank *bank;
 	void __iomem *reg_base;
 	enum pincfg_type cfg_type = PINCFG_UNPACK_TYPE(*config);
@@ -528,7 +528,7 @@ static const struct pinconf_ops samsung_pinconf_ops = {
 static void samsung_gpio_set(struct gpio_chip *gc, unsigned offset, int value)
 {
 	struct samsung_pin_bank *bank = gc_to_pin_bank(gc);
-	struct samsung_pin_bank_type *type = bank->type;
+	const struct samsung_pin_bank_type *type = bank->type;
 	unsigned long flags;
 	void __iomem *reg;
 	u32 data;
@@ -552,7 +552,7 @@ static int samsung_gpio_get(struct gpio_chip *gc, unsigned offset)
 	void __iomem *reg;
 	u32 data;
 	struct samsung_pin_bank *bank = gc_to_pin_bank(gc);
-	struct samsung_pin_bank_type *type = bank->type;
+	const struct samsung_pin_bank_type *type = bank->type;
 
 	reg = bank->drvdata->virt_base + bank->pctl_offset;
 
@@ -569,7 +569,7 @@ static int samsung_gpio_get(struct gpio_chip *gc, unsigned offset)
 static int samsung_gpio_set_direction(struct gpio_chip *gc,
 					     unsigned offset, bool input)
 {
-	struct samsung_pin_bank_type *type;
+	const struct samsung_pin_bank_type *type;
 	struct samsung_pin_bank *bank;
 	struct samsung_pinctrl_drv_data *drvdata;
 	void __iomem *reg;
@@ -1096,9 +1096,8 @@ static void samsung_pinctrl_suspend_dev(
 	for (i = 0; i < ctrl->nr_banks; i++) {
 		struct samsung_pin_bank *bank = &ctrl->pin_banks[i];
 		void __iomem *reg = virt_base + bank->pctl_offset;
-
-		u8 *offs = bank->type->reg_offset;
-		u8 *widths = bank->type->fld_width;
+		const u8 *offs = bank->type->reg_offset;
+		const u8 *widths = bank->type->fld_width;
 		enum pincfg_type type;
 
 		/* Registers without a powerdown config aren't lost */
@@ -1147,9 +1146,8 @@ static void samsung_pinctrl_resume_dev(struct samsung_pinctrl_drv_data *drvdata)
 	for (i = 0; i < ctrl->nr_banks; i++) {
 		struct samsung_pin_bank *bank = &ctrl->pin_banks[i];
 		void __iomem *reg = virt_base + bank->pctl_offset;
-
-		u8 *offs = bank->type->reg_offset;
-		u8 *widths = bank->type->fld_width;
+		const u8 *offs = bank->type->reg_offset;
+		const u8 *widths = bank->type->fld_width;
 		enum pincfg_type type;
 
 		/* Registers without a powerdown config aren't lost */
diff --git a/drivers/pinctrl/samsung/pinctrl-samsung.h b/drivers/pinctrl/samsung/pinctrl-samsung.h
index f26595ee52d3..b4f7a8dd8dcb 100644
--- a/drivers/pinctrl/samsung/pinctrl-samsung.h
+++ b/drivers/pinctrl/samsung/pinctrl-samsung.h
@@ -130,7 +130,7 @@ struct samsung_pin_bank_type {
  * @pm_save: saved register values during suspend
  */
 struct samsung_pin_bank {
-	struct samsung_pin_bank_type *type;
+	const struct samsung_pin_bank_type *type;
 	u32		pctl_offset;
 	u32		pin_base;
 	u8		nr_pins;
-- 
2.1.1

