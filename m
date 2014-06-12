Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933671AbaFLL4f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 07:56:35 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:32784 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933586AbaFLL41 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 07:56:27 -0400
From: Sricharan R <r.sricharan@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <tony@atomide.com>, <santosh.shilimkar@ti.com>, <nm@ti.com>,
        <rnayak@ti.com>, <linux@arm.linux.org.uk>, <r.sricharan@ti.com>,
        <tglx@linutronix.de>, <jason@lakedaemon.net>
Subject: [PATCH V2 07/19] irqchip: crossbar: fix sparse warnings
Date: Thu, 12 Jun 2014 17:23:15 +0530
Message-ID: <1402574007-13987-8-git-send-email-r.sricharan@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1402574007-13987-1-git-send-email-r.sricharan@ti.com>
References: <1402574007-13987-1-git-send-email-r.sricharan@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nishanth Menon <nm@ti.com>

There is absolutely no need for crossbar driver to expose functions and
variables into global namespace. So make them all static

Fixes sparse warnings:
drivers/irqchip/irq-crossbar.c:129:29: warning: symbol 'routable_irq_domain_ops' was not declared. Should it be static?
drivers/irqchip/irq-crossbar.c:252:5: warning: symbol 'dra_irqs_unused' was not declared. Should it be static?
drivers/irqchip/irq-crossbar.c:253:22: warning: symbol 'cb_dra_data' was not declared. Should it be static?
drivers/irqchip/irq-crossbar.c:261:12: warning: symbol 'irqcrossbar_init' was not declared. Should it be static?

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 drivers/irqchip/irq-crossbar.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/irqchip/irq-crossbar.c b/drivers/irqchip/irq-crossbar.c
index c5415ae..5da9d36 100644
--- a/drivers/irqchip/irq-crossbar.c
+++ b/drivers/irqchip/irq-crossbar.c
@@ -16,6 +16,7 @@
 #include <linux/of_device.h>
 #include <linux/slab.h>
 #include <linux/irqchip/arm-gic.h>
+#include <linux/irqchip/irq-crossbar.h>
 
 #define IRQ_FREE	-1
 #define IRQ_RESERVED	-2
@@ -126,7 +127,7 @@ found:
 	return 0;
 }
 
-const struct irq_domain_ops routable_irq_domain_ops = {
+static const struct irq_domain_ops routable_irq_domain_ops = {
 	.map = crossbar_domain_map,
 	.unmap = crossbar_domain_unmap,
 	.xlate = crossbar_domain_xlate
@@ -249,8 +250,8 @@ err1:
 }
 
 /* irq number 10 cannot be used because of hw bug */
-int dra_irqs_unused[] = { 10 };
-struct crossbar_data cb_dra_data = { dra_irqs_unused,
+static int dra_irqs_unused[] = { 10 };
+static struct crossbar_data cb_dra_data = { dra_irqs_unused,
 				     ARRAY_SIZE(dra_irqs_unused), 0 };
 
 static const struct of_device_id crossbar_match[] __initconst = {
-- 
1.7.9.5

