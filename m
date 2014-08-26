Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934701AbaHZKFG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 06:05:06 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:21162 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934684AbaHZKFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 06:05:01 -0400
From: Marc Zyngier <marc.zyngier@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux@openrisc.net
Cc: linux@arm.linux.org.uk, shawn.guo@freescale.com, kernel@pengutronix.de,
        tony@atomide.com, catalin.marinas@arm.com, will.deacon@arm.com,
        jonas@southpole.se, tglx@linutronix.de, jason@lakedaemon.net,
        shc_work@mail.ru, baohua@kernel.org, maxime.ripard@free-electrons.com,
        marc.zyngier@arm.com, khilman@linaro.org, sboyd@codeaurora.org,
        lorenzo.pieralisi@arm.com, larry.bassel@linaro.org,
        mark.rutland@arm.com, sudeep.holla@arm.com,
        stefan.kristiansson@saunalahti.fi, vkale@apm.com,
        schwidefsky@de.ibm.com
Subject: [PATCH v2 21/26] irqchip: or1k-pic: convert to handle_domain_irq
Date: Tue, 26 Aug 2014 11:03:36 +0100
Message-Id: <1409047421-27649-22-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1409047421-27649-1-git-send-email-marc.zyngier@arm.com>
References: <1409047421-27649-1-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new handle_domain_irq method to handle interrupts.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-or1k-pic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-or1k-pic.c b/drivers/irqchip/irq-or1k-pic.c
index 17ff033..e93d079 100644
--- a/drivers/irqchip/irq-or1k-pic.c
+++ b/drivers/irqchip/irq-or1k-pic.c
@@ -113,7 +113,7 @@ static inline int pic_get_irq(int first)
 	else
 		hwirq = hwirq + first - 1;
 
-	return irq_find_mapping(root_domain, hwirq);
+	return hwirq;
 }
 
 static void or1k_pic_handle_irq(struct pt_regs *regs)
@@ -121,7 +121,7 @@ static void or1k_pic_handle_irq(struct pt_regs *regs)
 	int irq = -1;
 
 	while ((irq = pic_get_irq(irq + 1)) != NO_IRQ)
-		handle_IRQ(irq, regs);
+		handle_domain_irq(root_domain, irq, regs);
 }
 
 static int or1k_map(struct irq_domain *d, unsigned int irq, irq_hw_number_t hw)
-- 
2.0.4

