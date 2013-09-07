Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751039Ab3IGHTl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 03:19:41 -0400
Received: from top.free-electrons.com ([176.31.233.9]:49771 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750920Ab3IGHTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 03:19:40 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: tony@atomide.com, linux@arm.linux.org.uk, khilman@deeprootsystems.com
Cc: linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] ARM: OMAP: remove deprecated IRQF_DISABLED
Date: Sat,  7 Sep 2013 09:19:25 +0200
Message-Id: <1378538365-7353-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the IRQF_DISABLED flag from OMAP code
It's a NOOP since 2.6.35, and will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 arch/arm/mach-omap1/fpga.c     | 3 +--
 arch/arm/mach-omap1/pm.c       | 1 -
 arch/arm/mach-omap1/time.c     | 2 +-
 arch/arm/mach-omap1/timer32k.c | 2 +-
 arch/arm/mach-omap2/timer.c    | 2 +-
 arch/arm/plat-omap/dma.c       | 1 -
 6 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-omap1/fpga.c b/arch/arm/mach-omap1/fpga.c
index 8bd71b2..3c0e422 100644
--- a/arch/arm/mach-omap1/fpga.c
+++ b/arch/arm/mach-omap1/fpga.c
@@ -135,8 +135,7 @@ static struct irq_chip omap_fpga_irq = {
  * mask_ack routine for all of the FPGA interrupts has been changed from
  * fpga_mask_ack_irq() to fpga_ack_irq() so that the specific FPGA interrupt
  * being serviced is left unmasked.  We can do this because the FPGA cascade
- * interrupt is installed with the IRQF_DISABLED flag, which leaves all
- * interrupts masked at the CPU while an FPGA interrupt handler executes.
+ * interrupt is run with all interrupts masked.
  *
  * Limited testing indicates that this workaround appears to be effective
  * for the smc9194 Ethernet driver used on the Innovator.  It should work
diff --git a/arch/arm/mach-omap1/pm.c b/arch/arm/mach-omap1/pm.c
index 358b82c..40a1ae3 100644
--- a/arch/arm/mach-omap1/pm.c
+++ b/arch/arm/mach-omap1/pm.c
@@ -628,7 +628,6 @@ static irqreturn_t omap_wakeup_interrupt(int irq, void *dev)
 
 static struct irqaction omap_wakeup_irq = {
 	.name		= "peripheral wakeup",
-	.flags		= IRQF_DISABLED,
 	.handler	= omap_wakeup_interrupt
 };
 
diff --git a/arch/arm/mach-omap1/time.c b/arch/arm/mach-omap1/time.c
index 80603d2..6b5f298 100644
--- a/arch/arm/mach-omap1/time.c
+++ b/arch/arm/mach-omap1/time.c
@@ -160,7 +160,7 @@ static irqreturn_t omap_mpu_timer1_interrupt(int irq, void *dev_id)
 
 static struct irqaction omap_mpu_timer1_irq = {
 	.name		= "mpu_timer1",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= omap_mpu_timer1_interrupt,
 };
 
diff --git a/arch/arm/mach-omap1/timer32k.c b/arch/arm/mach-omap1/timer32k.c
index 0b74246..107e7ab 100644
--- a/arch/arm/mach-omap1/timer32k.c
+++ b/arch/arm/mach-omap1/timer32k.c
@@ -156,7 +156,7 @@ static irqreturn_t omap_32k_timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction omap_32k_timer_irq = {
 	.name		= "32KHz timer",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= omap_32k_timer_interrupt,
 };
 
diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
index b37e1fc..6552cd9 100644
--- a/arch/arm/mach-omap2/timer.c
+++ b/arch/arm/mach-omap2/timer.c
@@ -78,7 +78,7 @@ static irqreturn_t omap2_gp_timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction omap2_gp_timer_irq = {
 	.name		= "gp_timer",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= omap2_gp_timer_interrupt,
 };
 
diff --git a/arch/arm/plat-omap/dma.c b/arch/arm/plat-omap/dma.c
index 4d463ca..848eab5 100644
--- a/arch/arm/plat-omap/dma.c
+++ b/arch/arm/plat-omap/dma.c
@@ -1965,7 +1965,6 @@ static irqreturn_t omap2_dma_irq_handler(int irq, void *dev_id)
 static struct irqaction omap24xx_dma_irq = {
 	.name = "DMA",
 	.handler = omap2_dma_irq_handler,
-	.flags = IRQF_DISABLED
 };
 
 #else
-- 
1.8.1.2

