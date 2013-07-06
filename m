Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480Ab3GFGDl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 02:03:41 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:53735 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836Ab3GFGDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 02:03:40 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: kernel@pengutronix.de, linux@arm.linux.org.uk
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] ARM: imx: remove IRQF_DISABLED
Date: Sat,  6 Jul 2013 08:03:17 +0200
Message-Id: <1373090597-20571-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This flag is a NOOP since 2.6.35 and can be removed.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 arch/arm/mach-imx/Kconfig             | 2 +-
 arch/arm/mach-imx/epit.c              | 2 +-
 arch/arm/mach-imx/mach-armadillo5x0.c | 3 +--
 arch/arm/mach-imx/mach-mx31_3ds.c     | 2 +-
 arch/arm/mach-imx/mach-pcm037.c       | 3 +--
 arch/arm/mach-imx/mx31lilly-db.c      | 3 +--
 arch/arm/mach-imx/time.c              | 2 +-
 7 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
index 60661a4..05920fe 100644
--- a/arch/arm/mach-imx/Kconfig
+++ b/arch/arm/mach-imx/Kconfig
@@ -22,7 +22,7 @@ config MXC_IRQ_PRIOR
 	help
 	  Select this if you want to use prioritized IRQ handling.
 	  This feature prevents higher priority ISR to be interrupted
-	  by lower priority IRQ even IRQF_DISABLED flag is not set.
+	  by lower priority IRQ.
 	  This may be useful in embedded applications, where are strong
 	  requirements for timing.
 	  Say N here, unless you have a specialized requirement.
diff --git a/arch/arm/mach-imx/epit.c b/arch/arm/mach-imx/epit.c
index e02de18..074b1a8 100644
--- a/arch/arm/mach-imx/epit.c
+++ b/arch/arm/mach-imx/epit.c
@@ -171,7 +171,7 @@ static irqreturn_t epit_timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction epit_timer_irq = {
 	.name		= "i.MX EPIT Timer Tick",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= epit_timer_interrupt,
 };
 
diff --git a/arch/arm/mach-imx/mach-armadillo5x0.c b/arch/arm/mach-imx/mach-armadillo5x0.c
index 368a6e3..58b864a 100644
--- a/arch/arm/mach-imx/mach-armadillo5x0.c
+++ b/arch/arm/mach-imx/mach-armadillo5x0.c
@@ -404,8 +404,7 @@ static int armadillo5x0_sdhc1_init(struct device *dev,
 
 	/* When supported the trigger type have to be BOTH */
 	ret = request_irq(gpio_to_irq(IOMUX_TO_GPIO(MX31_PIN_ATA_DMACK)),
-			  detect_irq,
-			  IRQF_DISABLED | IRQF_TRIGGER_FALLING,
+			  detect_irq, IRQF_TRIGGER_FALLING,
 			  "sdhc-detect", data);
 
 	if (ret)
diff --git a/arch/arm/mach-imx/mach-mx31_3ds.c b/arch/arm/mach-imx/mach-mx31_3ds.c
index 1ed9161..50044a2 100644
--- a/arch/arm/mach-imx/mach-mx31_3ds.c
+++ b/arch/arm/mach-imx/mach-mx31_3ds.c
@@ -311,7 +311,7 @@ static int mx31_3ds_sdhc1_init(struct device *dev,
 	}
 
 	ret = request_irq(gpio_to_irq(IOMUX_TO_GPIO(MX31_PIN_GPIO3_1)),
-			  detect_irq, IRQF_DISABLED |
+			  detect_irq,
 			  IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
 			  "sdhc1-detect", data);
 	if (ret) {
diff --git a/arch/arm/mach-imx/mach-pcm037.c b/arch/arm/mach-imx/mach-pcm037.c
index bc0261e..45303bd6 100644
--- a/arch/arm/mach-imx/mach-pcm037.c
+++ b/arch/arm/mach-imx/mach-pcm037.c
@@ -371,8 +371,7 @@ static int pcm970_sdhc1_init(struct device *dev, irq_handler_t detect_irq,
 #endif
 
 	ret = request_irq(gpio_to_irq(IOMUX_TO_GPIO(MX31_PIN_SCK6)), detect_irq,
-			IRQF_DISABLED | IRQF_TRIGGER_FALLING,
-				"sdhc-detect", data);
+			IRQF_TRIGGER_FALLING, "sdhc-detect", data);
 	if (ret)
 		goto err_gpio_free_2;
 
diff --git a/arch/arm/mach-imx/mx31lilly-db.c b/arch/arm/mach-imx/mx31lilly-db.c
index d4361b8..649fe49 100644
--- a/arch/arm/mach-imx/mx31lilly-db.c
+++ b/arch/arm/mach-imx/mx31lilly-db.c
@@ -130,8 +130,7 @@ static int mxc_mmc1_init(struct device *dev,
 	gpio_direction_input(gpio_wp);
 
 	ret = request_irq(gpio_to_irq(IOMUX_TO_GPIO(MX31_PIN_GPIO1_1)),
-			  detect_irq,
-			  IRQF_DISABLED | IRQF_TRIGGER_FALLING,
+			  detect_irq, IRQF_TRIGGER_FALLING,
 			  "MMC detect", data);
 	if (ret)
 		goto exit_free_wp;
diff --git a/arch/arm/mach-imx/time.c b/arch/arm/mach-imx/time.c
index fea9131..a1cd831 100644
--- a/arch/arm/mach-imx/time.c
+++ b/arch/arm/mach-imx/time.c
@@ -250,7 +250,7 @@ static irqreturn_t mxc_timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction mxc_timer_irq = {
 	.name		= "i.MX Timer Tick",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= mxc_timer_interrupt,
 };
 
-- 
1.8.1.2

