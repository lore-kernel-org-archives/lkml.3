Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119Ab3L3QJi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 11:09:38 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:62245 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756058Ab3L3QJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 11:09:36 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: olof@lixom.net, khilman@linaro.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 02/17] ARM: ixp4xx: Remove deprecated IRQF_DISABLED flag
Date: Mon, 30 Dec 2013 17:09:16 +0100
Message-Id: <1388419771-30075-2-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1388419771-30075-1-git-send-email-daniel.lezcano@linaro.org>
References: <1388419771-30075-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This flag is a NOOP and scheduled to be removed

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 arch/arm/mach-ixp4xx/common.c        |    2 +-
 arch/arm/mach-ixp4xx/dsmg600-setup.c |    3 +--
 arch/arm/mach-ixp4xx/fsg-setup.c     |    6 ++----
 arch/arm/mach-ixp4xx/nas100d-setup.c |    3 +--
 arch/arm/mach-ixp4xx/nslu2-setup.c   |    6 ++----
 5 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/arch/arm/mach-ixp4xx/common.c b/arch/arm/mach-ixp4xx/common.c
index bc9d8ec..0bf5258 100644
--- a/arch/arm/mach-ixp4xx/common.c
+++ b/arch/arm/mach-ixp4xx/common.c
@@ -312,7 +312,7 @@ static irqreturn_t ixp4xx_timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction ixp4xx_timer_irq = {
 	.name		= "timer1",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= ixp4xx_timer_interrupt,
 	.dev_id		= &clockevent_ixp4xx,
 };
diff --git a/arch/arm/mach-ixp4xx/dsmg600-setup.c b/arch/arm/mach-ixp4xx/dsmg600-setup.c
index 736dc69..43ee06d 100644
--- a/arch/arm/mach-ixp4xx/dsmg600-setup.c
+++ b/arch/arm/mach-ixp4xx/dsmg600-setup.c
@@ -233,8 +233,7 @@ static int __init dsmg600_gpio_init(void)
 
 	gpio_request(DSMG600_RB_GPIO, "reset button");
 	if (request_irq(gpio_to_irq(DSMG600_RB_GPIO), &dsmg600_reset_handler,
-		IRQF_DISABLED | IRQF_TRIGGER_LOW,
-		"DSM-G600 reset button", NULL) < 0) {
+		IRQF_TRIGGER_LOW, "DSM-G600 reset button", NULL) < 0) {
 
 		printk(KERN_DEBUG "Reset Button IRQ %d not available\n",
 			gpio_to_irq(DSMG600_RB_GPIO));
diff --git a/arch/arm/mach-ixp4xx/fsg-setup.c b/arch/arm/mach-ixp4xx/fsg-setup.c
index 429966b7..5c4b0c4 100644
--- a/arch/arm/mach-ixp4xx/fsg-setup.c
+++ b/arch/arm/mach-ixp4xx/fsg-setup.c
@@ -208,16 +208,14 @@ static void __init fsg_init(void)
 	platform_add_devices(fsg_devices, ARRAY_SIZE(fsg_devices));
 
 	if (request_irq(gpio_to_irq(FSG_RB_GPIO), &fsg_reset_handler,
-			IRQF_DISABLED | IRQF_TRIGGER_LOW,
-			"FSG reset button", NULL) < 0) {
+			IRQF_TRIGGER_LOW, "FSG reset button", NULL) < 0) {
 
 		printk(KERN_DEBUG "Reset Button IRQ %d not available\n",
 			gpio_to_irq(FSG_RB_GPIO));
 	}
 
 	if (request_irq(gpio_to_irq(FSG_SB_GPIO), &fsg_power_handler,
-			IRQF_DISABLED | IRQF_TRIGGER_LOW,
-			"FSG power button", NULL) < 0) {
+			IRQF_TRIGGER_LOW, "FSG power button", NULL) < 0) {
 
 		printk(KERN_DEBUG "Power Button IRQ %d not available\n",
 			gpio_to_irq(FSG_SB_GPIO));
diff --git a/arch/arm/mach-ixp4xx/nas100d-setup.c b/arch/arm/mach-ixp4xx/nas100d-setup.c
index 507cb52..4e0f762 100644
--- a/arch/arm/mach-ixp4xx/nas100d-setup.c
+++ b/arch/arm/mach-ixp4xx/nas100d-setup.c
@@ -295,8 +295,7 @@ static void __init nas100d_init(void)
 	pm_power_off = nas100d_power_off;
 
 	if (request_irq(gpio_to_irq(NAS100D_RB_GPIO), &nas100d_reset_handler,
-		IRQF_DISABLED | IRQF_TRIGGER_LOW,
-		"NAS100D reset button", NULL) < 0) {
+		IRQF_TRIGGER_LOW, "NAS100D reset button", NULL) < 0) {
 
 		printk(KERN_DEBUG "Reset Button IRQ %d not available\n",
 			gpio_to_irq(NAS100D_RB_GPIO));
diff --git a/arch/arm/mach-ixp4xx/nslu2-setup.c b/arch/arm/mach-ixp4xx/nslu2-setup.c
index ba5f1cd..88c025f 100644
--- a/arch/arm/mach-ixp4xx/nslu2-setup.c
+++ b/arch/arm/mach-ixp4xx/nslu2-setup.c
@@ -265,16 +265,14 @@ static void __init nslu2_init(void)
 	pm_power_off = nslu2_power_off;
 
 	if (request_irq(gpio_to_irq(NSLU2_RB_GPIO), &nslu2_reset_handler,
-		IRQF_DISABLED | IRQF_TRIGGER_LOW,
-		"NSLU2 reset button", NULL) < 0) {
+		IRQF_TRIGGER_LOW, "NSLU2 reset button", NULL) < 0) {
 
 		printk(KERN_DEBUG "Reset Button IRQ %d not available\n",
 			gpio_to_irq(NSLU2_RB_GPIO));
 	}
 
 	if (request_irq(gpio_to_irq(NSLU2_PB_GPIO), &nslu2_power_handler,
-		IRQF_DISABLED | IRQF_TRIGGER_HIGH,
-		"NSLU2 power button", NULL) < 0) {
+		IRQF_TRIGGER_HIGH, "NSLU2 power button", NULL) < 0) {
 
 		printk(KERN_DEBUG "Power Button IRQ %d not available\n",
 			gpio_to_irq(NSLU2_PB_GPIO));
-- 
1.7.9.5

