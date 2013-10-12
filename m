Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560Ab3JLDRu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 23:17:50 -0400
Received: from top.free-electrons.com ([176.31.233.9]:53832 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752395Ab3JLDRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 23:17:49 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: kaloz@openwrt.org, khc@pm.waw.pl, linux@arm.linux.org.uk
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] ARM: IXP4xx: remove deprecated IRQF_DISABLED
Date: Sat, 12 Oct 2013 05:17:44 +0200
Message-Id: <1381547864-4970-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 arch/arm/mach-ixp4xx/common.c        | 2 +-
 arch/arm/mach-ixp4xx/dsmg600-setup.c | 3 +--
 arch/arm/mach-ixp4xx/fsg-setup.c     | 6 ++----
 arch/arm/mach-ixp4xx/nas100d-setup.c | 3 +--
 arch/arm/mach-ixp4xx/nslu2-setup.c   | 6 ++----
 5 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/arch/arm/mach-ixp4xx/common.c b/arch/arm/mach-ixp4xx/common.c
index 5327dec..a2b21f6 100644
--- a/arch/arm/mach-ixp4xx/common.c
+++ b/arch/arm/mach-ixp4xx/common.c
@@ -285,7 +285,7 @@ static irqreturn_t ixp4xx_timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction ixp4xx_timer_irq = {
 	.name		= "timer1",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= ixp4xx_timer_interrupt,
 	.dev_id		= &clockevent_ixp4xx,
 };
diff --git a/arch/arm/mach-ixp4xx/dsmg600-setup.c b/arch/arm/mach-ixp4xx/dsmg600-setup.c
index 63de1b3..053a564 100644
--- a/arch/arm/mach-ixp4xx/dsmg600-setup.c
+++ b/arch/arm/mach-ixp4xx/dsmg600-setup.c
@@ -253,8 +253,7 @@ static void __init dsmg600_init(void)
 	pm_power_off = dsmg600_power_off;
 
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
index ed667ce..008d792 100644
--- a/arch/arm/mach-ixp4xx/nas100d-setup.c
+++ b/arch/arm/mach-ixp4xx/nas100d-setup.c
@@ -271,8 +271,7 @@ static void __init nas100d_init(void)
 	pm_power_off = nas100d_power_off;
 
 	if (request_irq(gpio_to_irq(NAS100D_RB_GPIO), &nas100d_reset_handler,
-		IRQF_DISABLED | IRQF_TRIGGER_LOW,
-		"NAS100D reset button", NULL) < 0) {
+		IRQF_TRIGGER_LOW, "NAS100D reset button", NULL) < 0) {
 
 		printk(KERN_DEBUG "Reset Button IRQ %d not available\n",
 			gpio_to_irq(NAS100D_RB_GPIO));
diff --git a/arch/arm/mach-ixp4xx/nslu2-setup.c b/arch/arm/mach-ixp4xx/nslu2-setup.c
index 7e55236..01a85e4 100644
--- a/arch/arm/mach-ixp4xx/nslu2-setup.c
+++ b/arch/arm/mach-ixp4xx/nslu2-setup.c
@@ -258,16 +258,14 @@ static void __init nslu2_init(void)
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
1.8.1.2

