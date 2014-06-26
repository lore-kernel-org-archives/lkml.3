Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582AbaFZHNr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 03:13:47 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:35131 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755482AbaFZHNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 03:13:45 -0400
From: Sricharan R <r.sricharan@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <tony@atomide.com>, <santosh.shilimkar@ti.com>, <nm@ti.com>,
        <rnayak@ti.com>, <linux@arm.linux.org.uk>, <r.sricharan@ti.com>,
        <tglx@linutronix.de>, <jason@lakedaemon.net>, <joe@perches.com>
Subject: [PATCH V4 07/16] irqchip: crossbar: Fix sparse and checkpatch warnings
Date: Thu, 26 Jun 2014 12:40:25 +0530
Message-ID: <1403766634-18543-8-git-send-email-r.sricharan@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403766634-18543-1-git-send-email-r.sricharan@ti.com>
References: <1403766634-18543-1-git-send-email-r.sricharan@ti.com>
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
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 drivers/irqchip/irq-crossbar.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/irqchip/irq-crossbar.c b/drivers/irqchip/irq-crossbar.c
index 88fbe0f..f7eda9f 100644
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

