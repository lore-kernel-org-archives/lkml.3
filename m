Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318AbaAWWiV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 17:38:21 -0500
Received: from mail-ee0-f44.google.com ([74.125.83.44]:35348 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360AbaAWWiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 17:38:16 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] irqchip: orion: use handle_edge_irq on bridge irqs
Date: Thu, 23 Jan 2014 23:38:05 +0100
Message-Id: <1390516686-2224-3-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1390516686-2224-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1390516686-2224-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bridge irqs are edge-triggered, i.e. they get asserted on low-to-high
transitions and not on the level of the downstream interrupt line.
This replaces handle_level_irq by the more appropriate handle_edge_irq.

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
 drivers/irqchip/irq-orion.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-orion.c b/drivers/irqchip/irq-orion.c
index 4137c3d15284..1f636f719065 100644
--- a/drivers/irqchip/irq-orion.c
+++ b/drivers/irqchip/irq-orion.c
@@ -143,7 +143,7 @@ static int __init orion_bridge_irq_init(struct device_node *np,
 	}
 
 	ret = irq_alloc_domain_generic_chips(domain, nrirqs, 1, np->name,
-			     handle_level_irq, clr, 0, IRQ_GC_INIT_MASK_CACHE);
+			     handle_edge_irq, clr, 0, IRQ_GC_INIT_MASK_CACHE);
 	if (ret) {
 		pr_err("%s: unable to alloc irq domain gc\n", np->name);
 		return ret;
-- 
1.8.5.2

