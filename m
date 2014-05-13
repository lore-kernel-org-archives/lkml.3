Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827AbaEMAav (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 20:30:51 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:47388 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663AbaEMAaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 20:30:18 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Rob Herring <robh@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6/7] irqchip: mxs: fix function type for IRQCHIP_OF_DECLARE
Date: Mon, 12 May 2014 19:29:52 -0500
Message-Id: <1399940993-1773-7-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399940993-1773-1-git-send-email-robherring2@gmail.com>
References: <1399940993-1773-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <robh@kernel.org>

Adding function type checking to IRQCHIP_OF_DECLARE found a type mismatch
with icoll_of_init. The function should return an error code or 0 on
success.

Signed-off-by: Rob Herring <robh@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/irqchip/irq-mxs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-mxs.c b/drivers/irqchip/irq-mxs.c
index 63b3d4e..4044ff2 100644
--- a/drivers/irqchip/irq-mxs.c
+++ b/drivers/irqchip/irq-mxs.c
@@ -96,7 +96,7 @@ static struct irq_domain_ops icoll_irq_domain_ops = {
 	.xlate = irq_domain_xlate_onecell,
 };
 
-static void __init icoll_of_init(struct device_node *np,
+static int __init icoll_of_init(struct device_node *np,
 			  struct device_node *interrupt_parent)
 {
 	icoll_base = of_iomap(np, 0);
@@ -110,6 +110,6 @@ static void __init icoll_of_init(struct device_node *np,
 
 	icoll_domain = irq_domain_add_linear(np, ICOLL_NUM_IRQS,
 					     &icoll_irq_domain_ops, NULL);
-	WARN_ON(!icoll_domain);
+	return icoll_domain ? 0 : -ENODEV;
 }
 IRQCHIP_DECLARE(mxs, "fsl,icoll", icoll_of_init);
-- 
1.9.1

