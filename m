Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093AbaGHNZT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 09:25:19 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:58216 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754427AbaGHNZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 09:25:09 -0400
From: Marc Zyngier <marc.zyngier@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Alexander Shiyan <shc_work@mail.ru>, Barry Song <baohua@kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Kevin Hilman <khilman@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Larry Bassel <larry.bassel@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH 06/15] irqchip: mmp: convert to handle_domain_irq
Date: Tue,  8 Jul 2014 14:10:29 +0100
Message-Id: <1404825038-547-7-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404825038-547-1-git-send-email-marc.zyngier@arm.com>
References: <1404825038-547-1-git-send-email-marc.zyngier@arm.com>
X-SA-Exim-Connect-IP: 176.25.195.83
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux@arm.linux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, tglx@linutronix.de, jason@lakedaemon.net, shc_work@mail.ru, baohua@kernel.org, maxime.ripard@free-electrons.com, khilman@linaro.org, daniel.lezcano@linaro.org, lorenzo.pieralisi@arm.com, larry.bassel@linaro.org, mark.rutland@arm.com, sudeep.holla@arm.com
X-SA-Exim-Mail-From: marc.zyngier@arm.com
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
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
2.0.0

