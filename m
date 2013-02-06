Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757488Ab3BFKzs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 05:55:48 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:54777 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757455Ab3BFKz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 05:55:26 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, linus.walleij@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 49/49] ARM: ux500: Pass regulator platform data using the new format
Date: Wed,  6 Feb 2013 10:54:11 +0000
Message-Id: <1360148051-7560-50-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
References: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Regulator platform data is now passed though a single structure
as opposed to the old way where four separate struct elements
were required. This patch makes use of the new format.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500.c |    5 +----
 include/linux/mfd/abx500/ab8500.h  |   11 ++---------
 2 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index d453522..b47192d 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -217,10 +217,7 @@ static struct platform_device snowball_sbnet_dev = {
 
 static struct ab8500_platform_data ab8500_platdata = {
 	.irq_base	= MOP500_AB8500_IRQ_BASE,
-	.regulator_reg_init = ab8500_regulator_reg_init,
-	.num_regulator_reg_init	= ARRAY_SIZE(ab8500_regulator_reg_init),
-	.regulator	= ab8500_regulators,
-	.num_regulator	= ARRAY_SIZE(ab8500_regulators),
+	.regulator	= &ab8500_regulator_plat_data,
 	.gpio		= &ab8500_gpio_pdata,
 	.codec		= &ab8500_codec_pdata,
 };
diff --git a/include/linux/mfd/abx500/ab8500.h b/include/linux/mfd/abx500/ab8500.h
index 1cb5698..c7e33c8 100644
--- a/include/linux/mfd/abx500/ab8500.h
+++ b/include/linux/mfd/abx500/ab8500.h
@@ -266,8 +266,7 @@ struct ab8500 {
 	const int *irq_reg_offset;
 };
 
-struct regulator_reg_init;
-struct regulator_init_data;
+struct ab8500_regulator_platform_data;
 struct ab8500_gpio_platform_data;
 struct ab8500_codec_platform_data;
 
@@ -275,18 +274,12 @@ struct ab8500_codec_platform_data;
  * struct ab8500_platform_data - AB8500 platform data
  * @irq_base: start of AB8500 IRQs, AB8500_NR_IRQS will be used
  * @init: board-specific initialization after detection of ab8500
- * @num_regulator_reg_init: number of regulator init registers
- * @regulator_reg_init: regulator init registers
- * @num_regulator: number of regulators
  * @regulator: machine-specific constraints for regulators
  */
 struct ab8500_platform_data {
 	int irq_base;
 	void (*init) (struct ab8500 *);
-	int num_regulator_reg_init;
-	struct ab8500_regulator_reg_init *regulator_reg_init;
-	int num_regulator;
-	struct regulator_init_data *regulator;
+	struct ab8500_regulator_platform_data *regulator;
 	struct ab8500_gpio_platform_data *gpio;
 	struct ab8500_codec_platform_data *codec;
 };
-- 
1.7.9.5

