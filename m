Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807Ab3BDL6k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 06:58:40 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:39933 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755709Ab3BDL6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:58:16 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 73/73] ARM: ux500: Pass regulator platform data using the new format
Date: Mon,  4 Feb 2013 11:54:28 +0000
Message-Id: <1359978868-28736-74-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
References: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
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

