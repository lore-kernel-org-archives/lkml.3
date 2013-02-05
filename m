Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879Ab3BETup (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 14:50:45 -0500
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:45620 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756729Ab3BETt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 14:49:27 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Lee Jones <lee.jones@linaro.org>, <arm@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 11/14] ARM: ux500: remove irq_base property from platform_data
Date: Tue, 5 Feb 2013 20:48:32 +0100
Message-ID: <1360093715-6348-12-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1360093715-6348-1-git-send-email-linus.walleij@stericsson.com>
References: <1360093715-6348-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lee Jones <lee.jones@linaro.org>

AB8500 GPIO no longer handles its GPIO IRQs. Instead, the AB8500
core driver has taken back the responsibility. Prior to this
happening, the AB8500 GPIO driver provided a set of virtual IRQs
which were used as a pass-through. These virtual IRQs had a base
of MOP500_AB8500_VIR_GPIO_IRQ_BASE, which was passed though pdata.
We don't need to do this anymore, so we're pulling out the
property from the structure.

Cc: arm@kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
Requesting an ACK from the ARM SoC maintainers on this patch.
---
 arch/arm/mach-ux500/board-mop500.c     | 1 -
 include/linux/mfd/abx500/ab8500-gpio.h | 1 -
 2 files changed, 2 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index b6f14ee..b8781ca 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -92,7 +92,6 @@ static struct platform_device snowball_gpio_en_3v3_regulator_dev = {
 
 static struct abx500_gpio_platform_data ab8500_gpio_pdata = {
 	.gpio_base		= MOP500_AB8500_PIN_GPIO(1),
-	.irq_base		= MOP500_AB8500_VIR_GPIO_IRQ_BASE,
 };
 
 /* ab8500-codec */
diff --git a/include/linux/mfd/abx500/ab8500-gpio.h b/include/linux/mfd/abx500/ab8500-gpio.h
index e8c8281..172b2f2 100644
--- a/include/linux/mfd/abx500/ab8500-gpio.h
+++ b/include/linux/mfd/abx500/ab8500-gpio.h
@@ -16,7 +16,6 @@
 
 struct abx500_gpio_platform_data {
 	int gpio_base;
-	u32 irq_base;
 };
 
 enum abx500_gpio_pull_updown {
-- 
1.7.11.3

