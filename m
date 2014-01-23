Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636AbaAWWiR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 17:38:17 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:59655 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbaAWWiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 17:38:15 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] irqchip: orion: clear bridge cause register on init
Date: Thu, 23 Jan 2014 23:38:04 +0100
Message-Id: <1390516686-2224-2-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1390516686-2224-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1390516686-2224-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is good practice to mask and clear pending irqs on init. We already
mask all irqs, so also clear the bridge irq cause register.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/irqchip/irq-orion.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-orion.c b/drivers/irqchip/irq-orion.c
index e51d40031884..4137c3d15284 100644
--- a/drivers/irqchip/irq-orion.c
+++ b/drivers/irqchip/irq-orion.c
@@ -180,8 +180,9 @@ static int __init orion_bridge_irq_init(struct device_node *np,
 	gc->chip_types[0].chip.irq_mask = irq_gc_mask_clr_bit;
 	gc->chip_types[0].chip.irq_unmask = irq_gc_mask_set_bit;
 
-	/* mask all interrupts */
+	/* mask and clear all interrupts */
 	writel(0, gc->reg_base + ORION_BRIDGE_IRQ_MASK);
+	writel(0, gc->reg_base + ORION_BRIDGE_IRQ_CAUSE);
 
 	irq_set_handler_data(irq, domain);
 	irq_set_chained_handler(irq, orion_bridge_irq_handler);
-- 
1.8.5.2

