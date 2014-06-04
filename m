Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbaFDPCL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 11:02:11 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:33122 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbaFDPCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 11:02:08 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org
Subject: [PATCH v2] irqchip: nvic: Use the generic noop function
Date: Wed,  4 Jun 2014 16:01:52 +0100
Message-Id: <1401894112-13386-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1401885425-12378-1-git-send-email-daniel.thompson@linaro.org>
References: <1401885425-12378-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the generic function saves looking up this custom one in a source
navigator.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Cooper <jason@lakedaemon.net>
---
 drivers/irqchip/irq-nvic.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/irqchip/irq-nvic.c b/drivers/irqchip/irq-nvic.c
index 70bdf6e..4ff0805 100644
--- a/drivers/irqchip/irq-nvic.c
+++ b/drivers/irqchip/irq-nvic.c
@@ -49,14 +49,6 @@ nvic_handle_irq(irq_hw_number_t hwirq, struct pt_regs *regs)
 	handle_IRQ(irq, regs);
 }
 
-static void nvic_eoi(struct irq_data *d)
-{
-	/*
-	 * This is a no-op as end of interrupt is signaled by the exception
-	 * return sequence.
-	 */
-}
-
 static int __init nvic_of_init(struct device_node *node,
 			       struct device_node *parent)
 {
@@ -102,7 +94,10 @@ static int __init nvic_of_init(struct device_node *node,
 		gc->chip_types[0].regs.disable = NVIC_ICER;
 		gc->chip_types[0].chip.irq_mask = irq_gc_mask_disable_reg;
 		gc->chip_types[0].chip.irq_unmask = irq_gc_unmask_enable_reg;
-		gc->chip_types[0].chip.irq_eoi = nvic_eoi;
+		/* This is a no-op as end of interrupt is signaled by the
+		 * exception return sequence.
+		 */
+		gc->chip_types[0].chip.irq_eoi = irq_gc_noop;
 
 		/* disable interrupts */
 		writel_relaxed(~0, gc->reg_base + NVIC_ICER);
-- 
1.9.0

