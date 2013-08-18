Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811Ab3HRFTq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 01:19:46 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:63221 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773Ab3HRFTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 01:19:45 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Sekhar Nori <nsekhar@ti.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Kevin Hilman <khilman@linaro.org>,
        Philip Avinash <avinashphilip@ti.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v3 1/7] gpio: davinci: coding style correction
Date: Sun, 18 Aug 2013 10:48:57 +0530
Message-Id: <1376803143-13738-2-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1376803143-13738-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1376803143-13738-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philip Avinash <avinashphilip@ti.com>

Make some minor coding style fixes. Use proper multi-line
commenting style, arrange include files alphabetically and
use a macro for register offset.

Signed-off-by: Philip Avinash <avinashphilip@ti.com>
[nsekhar@ti.com: dropped changes which were considered
churn - line break fixes and variable name changes]
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sekhar Nori <nsekhar@ti.com>
Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/gpio/gpio-davinci.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/gpio/gpio-davinci.c b/drivers/gpio/gpio-davinci.c
index 17df6db..af7ea0b 100644
--- a/drivers/gpio/gpio-davinci.c
+++ b/drivers/gpio/gpio-davinci.c
@@ -9,12 +9,11 @@
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
  */
-#include <linux/gpio.h>
-#include <linux/errno.h>
-#include <linux/kernel.h>
 #include <linux/clk.h>
-#include <linux/err.h>
+#include <linux/errno.h>
+#include <linux/gpio.h>
 #include <linux/io.h>
+#include <linux/kernel.h>
 
 #include <asm/mach/irq.h>
 
@@ -31,6 +30,8 @@ struct davinci_gpio_regs {
 	u32	intstat;
 };
 
+#define BINTEN	0x8 /* GPIO Interrupt Per-Bank Enable Register */
+
 #define chip2controller(chip)	\
 	container_of(chip, struct davinci_gpio_controller, chip)
 
@@ -304,7 +305,8 @@ static int gpio_to_irq_unbanked(struct gpio_chip *chip, unsigned offset)
 {
 	struct davinci_soc_info *soc_info = &davinci_soc_info;
 
-	/* NOTE:  we assume for now that only irqs in the first gpio_chip
+	/*
+	 * NOTE:  we assume for now that only irqs in the first gpio_chip
 	 * can provide direct-mapped IRQs to AINTC (up to 32 GPIOs).
 	 */
 	if (offset < soc_info->gpio_unbanked)
@@ -368,7 +370,8 @@ static int __init davinci_gpio_irq_setup(void)
 	}
 	clk_prepare_enable(clk);
 
-	/* Arrange gpio_to_irq() support, handling either direct IRQs or
+	/*
+	 * Arrange gpio_to_irq() support, handling either direct IRQs or
 	 * banked IRQs.  Having GPIOs in the first GPIO bank use direct
 	 * IRQs, while the others use banked IRQs, would need some setup
 	 * tweaks to recognize hardware which can do that.
@@ -450,10 +453,11 @@ static int __init davinci_gpio_irq_setup(void)
 	}
 
 done:
-	/* BINTEN -- per-bank interrupt enable. genirq would also let these
+	/*
+	 * BINTEN -- per-bank interrupt enable. genirq would also let these
 	 * bits be set/cleared dynamically.
 	 */
-	__raw_writel(binten, gpio_base + 0x08);
+	__raw_writel(binten, gpio_base + BINTEN);
 
 	printk(KERN_INFO "DaVinci: %d gpio irqs\n", irq - gpio_to_irq(0));
 
-- 
1.7.9.5

