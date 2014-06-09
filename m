Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942AbaFISFM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 14:05:12 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:36037 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520AbaFISFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 14:05:09 -0400
From: Florian Fainelli <f.fainelli@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, jason@lakedaemon.net,
        tglx@linutronix.de, Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH] irqchip: brcmstb-l2: Level-2 interrupts are edge sensitive
Date: Mon,  9 Jun 2014 11:05:02 -0700
Message-Id: <1402337102-19428-1-git-send-email-f.fainelli@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver was configuring the interrupt handler for the Level-2
interrupts to be "level" triggered while they are in fact "edge"
triggered. Fix this by using the correct handler.

Reported-by: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/irqchip/irq-brcmstb-l2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-brcmstb-l2.c b/drivers/irqchip/irq-brcmstb-l2.c
index 8ee2a36d5840..c15c840987d2 100644
--- a/drivers/irqchip/irq-brcmstb-l2.c
+++ b/drivers/irqchip/irq-brcmstb-l2.c
@@ -150,7 +150,7 @@ int __init brcmstb_l2_intc_of_init(struct device_node *np,
 
 	/* Allocate a single Generic IRQ chip for this node */
 	ret = irq_alloc_domain_generic_chips(data->domain, 32, 1,
-				np->full_name, handle_level_irq, clr, 0, 0);
+				np->full_name, handle_edge_irq, clr, 0, 0);
 	if (ret) {
 		pr_err("failed to allocate generic irq chip\n");
 		goto out_free_domain;
-- 
1.9.1

