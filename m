Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934538AbaHZKEW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 06:04:22 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:20769 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934418AbaHZKES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 06:04:18 -0400
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
Subject: [PATCH v2 09/26] irqchip: mxs: convert to handle_domain_irq
Date: Tue, 26 Aug 2014 11:03:24 +0100
Message-Id: <1409047421-27649-10-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1409047421-27649-1-git-send-email-marc.zyngier@arm.com>
References: <1409047421-27649-1-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new handle_domain_irq method to handle interrupts.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-mxs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-mxs.c b/drivers/irqchip/irq-mxs.c
index 4044ff2..e4acf1e 100644
--- a/drivers/irqchip/irq-mxs.c
+++ b/drivers/irqchip/irq-mxs.c
@@ -78,8 +78,7 @@ asmlinkage void __exception_irq_entry icoll_handle_irq(struct pt_regs *regs)
 
 	irqnr = __raw_readl(icoll_base + HW_ICOLL_STAT_OFFSET);
 	__raw_writel(irqnr, icoll_base + HW_ICOLL_VECTOR);
-	irqnr = irq_find_mapping(icoll_domain, irqnr);
-	handle_IRQ(irqnr, regs);
+	handle_domain_irq(icoll_domain, irqnr, regs);
 }
 
 static int icoll_irq_domain_map(struct irq_domain *d, unsigned int virq,
-- 
2.0.4

