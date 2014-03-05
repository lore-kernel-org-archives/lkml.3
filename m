Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758838AbaCEPNj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 10:13:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41010 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757152AbaCEOZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:25:54 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andrew Lunn <andrew@lunn.ch>, Jason Cooper <jason@lakedaemon.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 064/131] irqchip: orion: Fix getting generic chip pointer.
Date: Wed,  5 Mar 2014 14:23:08 +0000
Message-Id: <1394029455-23128-65-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Lunn <andrew@lunn.ch>

commit d86e9af6336c0ad586a5dbd70064253d40bbb5ff upstream.

Enabling SPARSE_IRQ shows up a bug in the irq-orion bridge interrupt
handler. The bridge interrupt is implemented using a single generic
chip. Thus the parameter passed to irq_get_domain_generic_chip()
should always be zero.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Acked-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Fixes: 9dbd90f17e4f ("irqchip: Add support for Marvell Orion SoCs")
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/irqchip/irq-orion.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-orion.c b/drivers/irqchip/irq-orion.c
index 0dfdc5c..8e41be6 100644
--- a/drivers/irqchip/irq-orion.c
+++ b/drivers/irqchip/irq-orion.c
@@ -111,7 +111,8 @@ IRQCHIP_DECLARE(orion_intc, "marvell,orion-intc", orion_irq_init);
 static void orion_bridge_irq_handler(unsigned int irq, struct irq_desc *desc)
 {
 	struct irq_domain *d = irq_get_handler_data(irq);
-	struct irq_chip_generic *gc = irq_get_domain_generic_chip(d, irq);
+
+	struct irq_chip_generic *gc = irq_get_domain_generic_chip(d, 0);
 	u32 stat = readl_relaxed(gc->reg_base + ORION_BRIDGE_IRQ_CAUSE) &
 		   gc->mask_cache;
 
-- 
1.9.0

