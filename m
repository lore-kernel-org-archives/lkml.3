Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933466AbaFLL4E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 07:56:04 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58189 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755873AbaFLLzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 07:55:55 -0400
From: Sricharan R <r.sricharan@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <tony@atomide.com>, <santosh.shilimkar@ti.com>, <nm@ti.com>,
        <rnayak@ti.com>, <linux@arm.linux.org.uk>, <r.sricharan@ti.com>,
        <tglx@linutronix.de>, <jason@lakedaemon.net>
Subject: [PATCH V2 01/19] irqchip: crossbar: dont use '0' to mark reserved interrupts
Date: Thu, 12 Jun 2014 17:23:09 +0530
Message-ID: <1402574007-13987-2-git-send-email-r.sricharan@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1402574007-13987-1-git-send-email-r.sricharan@ti.com>
References: <1402574007-13987-1-git-send-email-r.sricharan@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nishanth Menon <nm@ti.com>

Today '0' is actually reserved, but may not be the same in the future.

So, use a flag to mark the GIC interrupts that are reserved.

Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sricharan R <r.sricharan@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 drivers/irqchip/irq-crossbar.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-crossbar.c b/drivers/irqchip/irq-crossbar.c
index 3d15d16..20105bc 100644
--- a/drivers/irqchip/irq-crossbar.c
+++ b/drivers/irqchip/irq-crossbar.c
@@ -17,6 +17,7 @@
 #include <linux/irqchip/arm-gic.h>
 
 #define IRQ_FREE	-1
+#define IRQ_RESERVED	-2
 #define GIC_IRQ_START	32
 
 /*
@@ -139,7 +140,7 @@ static int __init crossbar_of_init(struct device_node *node)
 				pr_err("Invalid reserved entry\n");
 				goto err3;
 			}
-			cb->irq_map[entry] = 0;
+			cb->irq_map[entry] = IRQ_RESERVED;
 		}
 	}
 
@@ -170,7 +171,7 @@ static int __init crossbar_of_init(struct device_node *node)
 	 * reserved irqs. so find and store the offsets once.
 	 */
 	for (i = 0; i < max; i++) {
-		if (!cb->irq_map[i])
+		if (cb->irq_map[i] == IRQ_RESERVED)
 			continue;
 
 		cb->register_offsets[i] = reserved;
-- 
1.7.9.5

