Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750941Ab3LIFAw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 00:00:52 -0500
Received: from top.free-electrons.com ([176.31.233.9]:60989 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750724Ab3LIFAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 00:00:50 -0500
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: linux@arm.linux.org.uk, gerg@uclinux.org, linus.walleij@linaro.org
Cc: arnd@arndb.de, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH][RESEND] ARM: misc: remove deprecated IRQF_DISABLED
Date: Mon,  9 Dec 2013 06:00:30 +0100
Message-Id: <1386565230-19228-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381550411-5824-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1381550411-5824-1-git-send-email-michael.opdenacker@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the use of the IRQF_DISABLED flag
from miscellaneous code in mach-xxx and plat-xxx

This flag is a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 arch/arm/mach-ebsa110/core.c             | 2 +-
 arch/arm/mach-integrator/integrator_ap.c | 2 +-
 arch/arm/mach-ks8695/time.c              | 2 +-
 arch/arm/mach-netx/time.c                | 2 +-
 arch/arm/mach-rpc/dma.c                  | 2 +-
 arch/arm/mach-rpc/time.c                 | 1 -
 arch/arm/mach-sa1100/time.c              | 2 +-
 arch/arm/mach-u300/timer.c               | 2 +-
 arch/arm/plat-iop/time.c                 | 2 +-
 arch/arm/plat-pxa/dma.c                  | 2 +-
 10 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/arm/mach-ebsa110/core.c b/arch/arm/mach-ebsa110/core.c
index 68ac934d4565..8254e716b095 100644
--- a/arch/arm/mach-ebsa110/core.c
+++ b/arch/arm/mach-ebsa110/core.c
@@ -206,7 +206,7 @@ ebsa110_timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction ebsa110_timer_irq = {
 	.name		= "EBSA110 Timer Tick",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= ebsa110_timer_interrupt,
 };
 
diff --git a/arch/arm/mach-integrator/integrator_ap.c b/arch/arm/mach-integrator/integrator_ap.c
index d50dc2dbfd89..699abfdbc673 100644
--- a/arch/arm/mach-integrator/integrator_ap.c
+++ b/arch/arm/mach-integrator/integrator_ap.c
@@ -368,7 +368,7 @@ static struct clock_event_device integrator_clockevent = {
 
 static struct irqaction integrator_timer_irq = {
 	.name		= "timer",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= integrator_timer_interrupt,
 	.dev_id		= &integrator_clockevent,
 };
diff --git a/arch/arm/mach-ks8695/time.c b/arch/arm/mach-ks8695/time.c
index 426c97662f5b..a197874bf382 100644
--- a/arch/arm/mach-ks8695/time.c
+++ b/arch/arm/mach-ks8695/time.c
@@ -122,7 +122,7 @@ static irqreturn_t ks8695_timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction ks8695_timer_irq = {
 	.name		= "ks8695_tick",
-	.flags		= IRQF_DISABLED | IRQF_TIMER,
+	.flags		= IRQF_TIMER,
 	.handler	= ks8695_timer_interrupt,
 };
 
diff --git a/arch/arm/mach-netx/time.c b/arch/arm/mach-netx/time.c
index 6df42e643031..3177c7a40930 100644
--- a/arch/arm/mach-netx/time.c
+++ b/arch/arm/mach-netx/time.c
@@ -99,7 +99,7 @@ netx_timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction netx_timer_irq = {
 	.name		= "NetX Timer Tick",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= netx_timer_interrupt,
 };
 
diff --git a/arch/arm/mach-rpc/dma.c b/arch/arm/mach-rpc/dma.c
index 85883b2e0e49..6d3517dc4772 100644
--- a/arch/arm/mach-rpc/dma.c
+++ b/arch/arm/mach-rpc/dma.c
@@ -141,7 +141,7 @@ static int iomd_request_dma(unsigned int chan, dma_t *dma)
 	struct iomd_dma *idma = container_of(dma, struct iomd_dma, dma);
 
 	return request_irq(idma->irq, iomd_dma_handle,
-			   IRQF_DISABLED, idma->dma.device_id, idma);
+			   0, idma->dma.device_id, idma);
 }
 
 static void iomd_free_dma(unsigned int chan, dma_t *dma)
diff --git a/arch/arm/mach-rpc/time.c b/arch/arm/mach-rpc/time.c
index 9a6def14df01..9a5158861ca9 100644
--- a/arch/arm/mach-rpc/time.c
+++ b/arch/arm/mach-rpc/time.c
@@ -75,7 +75,6 @@ ioc_timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction ioc_timer_irq = {
 	.name		= "timer",
-	.flags		= IRQF_DISABLED,
 	.handler	= ioc_timer_interrupt
 };
 
diff --git a/arch/arm/mach-sa1100/time.c b/arch/arm/mach-sa1100/time.c
index 713c86cd3d64..a98fded8c432 100644
--- a/arch/arm/mach-sa1100/time.c
+++ b/arch/arm/mach-sa1100/time.c
@@ -112,7 +112,7 @@ static struct clock_event_device ckevt_sa1100_osmr0 = {
 
 static struct irqaction sa1100_timer_irq = {
 	.name		= "ost0",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= sa1100_ost0_interrupt,
 	.dev_id		= &ckevt_sa1100_osmr0,
 };
diff --git a/arch/arm/mach-u300/timer.c b/arch/arm/mach-u300/timer.c
index 9a5f9fb352ce..f4669c4225c3 100644
--- a/arch/arm/mach-u300/timer.c
+++ b/arch/arm/mach-u300/timer.c
@@ -329,7 +329,7 @@ static irqreturn_t u300_timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction u300_timer_irq = {
 	.name		= "U300 Timer Tick",
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_TIMER | IRQF_IRQPOLL,
 	.handler	= u300_timer_interrupt,
 };
 
diff --git a/arch/arm/plat-iop/time.c b/arch/arm/plat-iop/time.c
index 29606bd75f3f..71626e323c78 100644
--- a/arch/arm/plat-iop/time.c
+++ b/arch/arm/plat-iop/time.c
@@ -127,7 +127,7 @@ iop_timer_interrupt(int irq, void *dev_id)
 static struct irqaction iop_timer_irq = {
 	.name		= "IOP Timer Tick",
 	.handler	= iop_timer_interrupt,
-	.flags		= IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL,
+	.flags		= IRQF_TIMER | IRQF_IRQPOLL,
 	.dev_id		= &iop_clockevent,
 };
 
diff --git a/arch/arm/plat-pxa/dma.c b/arch/arm/plat-pxa/dma.c
index 79ef102e3b2b..054fc5a1a11c 100644
--- a/arch/arm/plat-pxa/dma.c
+++ b/arch/arm/plat-pxa/dma.c
@@ -377,7 +377,7 @@ int __init pxa_init_dma(int irq, int num_ch)
 		spin_lock_init(&dma_channels[i].lock);
 	}
 
-	ret = request_irq(irq, dma_irq_handler, IRQF_DISABLED, "DMA", NULL);
+	ret = request_irq(irq, dma_irq_handler, 0, "DMA", NULL);
 	if (ret) {
 		printk (KERN_CRIT "Wow!  Can't register IRQ for DMA\n");
 		kfree(dma_channels);
-- 
1.8.3.2

