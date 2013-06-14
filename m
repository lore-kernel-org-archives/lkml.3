Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962Ab3FNJfb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 05:35:31 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:42539 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818Ab3FNJfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 05:35:30 -0400
From: Philip Avinash <avinashphilip@ti.com>
To: <nsekhar@ti.com>, <khilman@deeprootsystems.com>, <linux@arm.linux.org.uk>,
        <grant.likely@secretlab.ca>, <linus.walleij@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>, <avinashphilip@ti.com>
Subject: [PATCH v2 1/7] gpio: davinci: coding style correction
Date: Fri, 14 Jun 2013 15:05:26 +0530
Message-ID: <1371202532-14628-2-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1371202532-14628-1-git-send-email-avinashphilip@ti.com>
References: <1371202532-14628-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make some minor coding style fixes. Use proper multi-line
commenting style, arrange include files alphabetically use
macros for bit definitions.

Signed-off-by: Philip Avinash <avinashphilip@ti.com>
Signed-off-by: Sekhar Nori <nsekhar@ti.com>
---
Changes since v1:
	- Remove variable name replacement
	- Add line break after BINTEN macro definition

 drivers/gpio/gpio-davinci.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/gpio/gpio-davinci.c b/drivers/gpio/gpio-davinci.c
index 17df6db..e8d189c 100644
--- a/drivers/gpio/gpio-davinci.c
+++ b/drivers/gpio/gpio-davinci.c
@@ -9,12 +9,12 @@
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
  */
-#include <linux/gpio.h>
-#include <linux/errno.h>
-#include <linux/kernel.h>
+
 #include <linux/clk.h>
-#include <linux/err.h>
+#include <linux/errno.h>
+#include <linux/gpio.h>
 #include <linux/io.h>
+#include <linux/kernel.h>
 
 #include <asm/mach/irq.h>
 
@@ -31,6 +31,8 @@ struct davinci_gpio_regs {
 	u32	intstat;
 };
 
+#define BINTEN	0x8 /* GPIO Interrupt Per-Bank Enable Register */
+
 #define chip2controller(chip)	\
 	container_of(chip, struct davinci_gpio_controller, chip)
 
@@ -304,7 +306,8 @@ static int gpio_to_irq_unbanked(struct gpio_chip *chip, unsigned offset)
 {
 	struct davinci_soc_info *soc_info = &davinci_soc_info;
 
-	/* NOTE:  we assume for now that only irqs in the first gpio_chip
+	/*
+	 * NOTE:  we assume for now that only irqs in the first gpio_chip
 	 * can provide direct-mapped IRQs to AINTC (up to 32 GPIOs).
 	 */
 	if (offset < soc_info->gpio_unbanked)
@@ -368,7 +371,8 @@ static int __init davinci_gpio_irq_setup(void)
 	}
 	clk_prepare_enable(clk);
 
-	/* Arrange gpio_to_irq() support, handling either direct IRQs or
+	/*
+	 * Arrange gpio_to_irq() support, handling either direct IRQs or
 	 * banked IRQs.  Having GPIOs in the first GPIO bank use direct
 	 * IRQs, while the others use banked IRQs, would need some setup
 	 * tweaks to recognize hardware which can do that.
@@ -450,10 +454,11 @@ static int __init davinci_gpio_irq_setup(void)
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

