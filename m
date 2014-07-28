Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998AbaG1VYQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 17:24:16 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55575 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752293AbaG1VRp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 17:17:45 -0400
From: Felipe Balbi <balbi@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        <bcousson@baylibre.com>, <linux@arm.linux.org.uk>,
        <khilman@deeprootsystems.com>, <tglx@linutronix.de>,
        <jason@lakedaemon.net>, <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 32/35] irq: intc: minor improvement to omap_irq_pending()
Date: Mon, 28 Jul 2014 16:16:20 -0500
Message-ID: <1406582183-696-33-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 2.0.1.563.g66f467c
In-Reply-To: <1406582183-696-1-git-send-email-balbi@ti.com>
References: <1406582183-696-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We already hold the number of Pending registers
in omap_nr_pending. Let's use that instead.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/irqchip/irq-omap-intc.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/irqchip/irq-omap-intc.c b/drivers/irqchip/irq-omap-intc.c
index 30f5fa0..c9ba502 100644
--- a/drivers/irqchip/irq-omap-intc.c
+++ b/drivers/irqchip/irq-omap-intc.c
@@ -175,11 +175,10 @@ static void __init omap_irq_soft_reset(void)
 
 int omap_irq_pending(void)
 {
-	int irq;
+	int i;
 
-	for (irq = 0; irq < omap_nr_irqs; irq += 32)
-		if (intc_readl(INTC_PENDING_IRQ0 +
-					((irq >> 5) << 5)))
+	for (i = 0; i < omap_nr_pending; i++)
+		if (intc_readl(INTC_PENDING_IRQ0 + (0x20 * i)))
 			return 1;
 	return 0;
 }
-- 
2.0.1.563.g66f467c

