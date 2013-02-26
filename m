Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758884Ab3BZLx2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 06:53:28 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:36994 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757864Ab3BZLxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 06:53:23 -0500
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: kuninori.morimoto.gx@renesas.com, linux-sh@vger.kernel.org,
        benh@kernel.crashing.org, grant.likely@secretlab.ca,
        horms@verge.net.au, Magnus Damm <magnus.damm@gmail.com>,
        tglx@linutronix.de
Date: Tue, 26 Feb 2013 20:59:04 +0900
Message-Id: <20130226115904.5630.11666.sendpatchset@w520>
In-Reply-To: <20130226115834.5630.45471.sendpatchset@w520>
References: <20130226115834.5630.45471.sendpatchset@w520>
Subject: [PATCH 03/05] irqchip: intc-irqpin: Add force comments
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Add comments to describe the special case for
"force" versions of enable and disable functions.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 Thanks to Thomas Gleixner for this suggestion.

 drivers/irqchip/irq-renesas-intc-irqpin.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- 0006/drivers/irqchip/irq-renesas-intc-irqpin.c
+++ work/drivers/irqchip/irq-renesas-intc-irqpin.c	2013-02-26 19:36:33.000000000 +0900
@@ -199,6 +199,11 @@ static void intc_irqpin_irq_enable_force
 	int irq = p->irq[irqd_to_hwirq(d)].requested_irq;
 
 	intc_irqpin_irq_enable(d);
+
+	/* enable interrupt through parent interrupt controller,
+	 * assumes non-shared interrupt with 1:1 mapping
+	 * needed for busted IRQs on some SoCs like sh73a0
+	 */
 	irq_get_chip(irq)->irq_unmask(irq_get_irq_data(irq));
 }
 
@@ -207,6 +212,10 @@ static void intc_irqpin_irq_disable_forc
 	struct intc_irqpin_priv *p = irq_data_get_irq_chip_data(d);
 	int irq = p->irq[irqd_to_hwirq(d)].requested_irq;
 
+	/* disable interrupt through parent interrupt controller,
+	 * assumes non-shared interrupt with 1:1 mapping
+	 * needed for busted IRQs on some SoCs like sh73a0
+	 */
 	irq_get_chip(irq)->irq_mask(irq_get_irq_data(irq));
 	intc_irqpin_irq_disable(d);
 }
