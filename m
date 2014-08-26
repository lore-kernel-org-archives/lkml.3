Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934519AbaHZKER (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 06:04:17 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:20736 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934418AbaHZKEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 06:04:14 -0400
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
Subject: [PATCH v2 08/26] irqchip: mmp: convert to handle_domain_irq
Date: Tue, 26 Aug 2014 11:03:23 +0100
Message-Id: <1409047421-27649-9-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1409047421-27649-1-git-send-email-marc.zyngier@arm.com>
References: <1409047421-27649-1-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new handle_domain_irq method to handle interrupts.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-mmp.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/irqchip/irq-mmp.c b/drivers/irqchip/irq-mmp.c
index 1c3e2c9..c0da57b 100644
--- a/drivers/irqchip/irq-mmp.c
+++ b/drivers/irqchip/irq-mmp.c
@@ -196,26 +196,24 @@ static struct mmp_intc_conf mmp2_conf = {
 
 static void __exception_irq_entry mmp_handle_irq(struct pt_regs *regs)
 {
-	int irq, hwirq;
+	int hwirq;
 
 	hwirq = readl_relaxed(mmp_icu_base + PJ1_INT_SEL);
 	if (!(hwirq & SEL_INT_PENDING))
 		return;
 	hwirq &= SEL_INT_NUM_MASK;
-	irq = irq_find_mapping(icu_data[0].domain, hwirq);
-	handle_IRQ(irq, regs);
+	handle_domain_irq(icu_data[0].domain, hwirq, regs);
 }
 
 static void __exception_irq_entry mmp2_handle_irq(struct pt_regs *regs)
 {
-	int irq, hwirq;
+	int hwirq;
 
 	hwirq = readl_relaxed(mmp_icu_base + PJ4_INT_SEL);
 	if (!(hwirq & SEL_INT_PENDING))
 		return;
 	hwirq &= SEL_INT_NUM_MASK;
-	irq = irq_find_mapping(icu_data[0].domain, hwirq);
-	handle_IRQ(irq, regs);
+	handle_domain_irq(icu_data[0].domain, hwirq, regs);
 }
 
 /* MMP (ARMv5) */
-- 
2.0.4

