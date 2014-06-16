Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbaFPL0U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 07:26:20 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:41710 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995AbaFPL0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 07:26:16 -0400
From: Sricharan R <r.sricharan@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <tony@atomide.com>, <santosh.shilimkar@ti.com>, <nm@ti.com>,
        <rnayak@ti.com>, <linux@arm.linux.org.uk>, <r.sricharan@ti.com>,
        <tglx@linutronix.de>, <jason@lakedaemon.net>, <joe@perches.com>
Subject: [PATCH V3 07/16] irqchip: crossbar: fix sparse and checkpatch warnings
Date: Mon, 16 Jun 2014 16:53:07 +0530
Message-ID: <1402917796-31574-8-git-send-email-r.sricharan@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1402917796-31574-1-git-send-email-r.sricharan@ti.com>
References: <1402917796-31574-1-git-send-email-r.sricharan@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nishanth Menon <nm@ti.com>

There is absolutely no need for crossbar driver to expose functions and
variables into global namespace. So make them all static

Also fix a couple of checkpatch warnings.

Fixes sparse warnings:
drivers/irqchip/irq-crossbar.c:129:29: warning: symbol 'routable_irq_domain_ops' was not declared. Should it be static?
drivers/irqchip/irq-crossbar.c:261:12: warning: symbol 'irqcrossbar_init' was not declared. Should it be static?

Checkpatch warnings:
WARNING: Prefer kcalloc over kzalloc with multiply
+	cb->irq_map = kzalloc(max * sizeof(int), GFP_KERNEL);

WARNING: Prefer kcalloc over kzalloc with multiply
+	cb->register_offsets = kzalloc(max * sizeof(int), GFP_KERNEL);

Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sricharan R <r.sricharan@ti.com>
---
[V3] Added checkpatch fixes as well to this.

 drivers/irqchip/irq-crossbar.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/irqchip/irq-crossbar.c b/drivers/irqchip/irq-crossbar.c
index 42ea49d..2d7fbdb 100644
--- a/drivers/irqchip/irq-crossbar.c
+++ b/drivers/irqchip/irq-crossbar.c
@@ -15,6 +15,7 @@
 #include <linux/of_irq.h>
 #include <linux/slab.h>
 #include <linux/irqchip/arm-gic.h>
+#include <linux/irqchip/irq-crossbar.h>
 
 #define IRQ_FREE	-1
 #define IRQ_RESERVED	-2
@@ -118,7 +119,7 @@ found:
 	return 0;
 }
 
-const struct irq_domain_ops routable_irq_domain_ops = {
+static const struct irq_domain_ops routable_irq_domain_ops = {
 	.map = crossbar_domain_map,
 	.unmap = crossbar_domain_unmap,
 	.xlate = crossbar_domain_xlate
@@ -139,7 +140,7 @@ static int __init crossbar_of_init(struct device_node *node)
 		goto err1;
 
 	of_property_read_u32(node, "ti,max-irqs", &max);
-	cb->irq_map = kzalloc(max * sizeof(int), GFP_KERNEL);
+	cb->irq_map = kcalloc(max, sizeof(int), GFP_KERNEL);
 	if (!cb->irq_map)
 		goto err2;
 
@@ -184,7 +185,7 @@ static int __init crossbar_of_init(struct device_node *node)
 	}
 
 
-	cb->register_offsets = kzalloc(max * sizeof(int), GFP_KERNEL);
+	cb->register_offsets = kcalloc(max, sizeof(int), GFP_KERNEL);
 	if (!cb->register_offsets)
 		goto err3;
 
-- 
1.7.9.5

