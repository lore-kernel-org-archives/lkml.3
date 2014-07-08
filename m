Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932206AbaGHN2Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 09:28:16 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:40805 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754771AbaGHNZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 09:25:32 -0400
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
Subject: [PATCH 14/15] irqchip: vt8500: convert to handle_domain_irq
Date: Tue,  8 Jul 2014 14:10:37 +0100
Message-Id: <1404825038-547-15-git-send-email-marc.zyngier@arm.com>
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
 drivers/irqchip/irq-vt8500.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/irqchip/irq-vt8500.c b/drivers/irqchip/irq-vt8500.c
index eb6e91e..b7af816 100644
--- a/drivers/irqchip/irq-vt8500.c
+++ b/drivers/irqchip/irq-vt8500.c
@@ -181,7 +181,7 @@ static struct irq_domain_ops vt8500_irq_domain_ops = {
 static void __exception_irq_entry vt8500_handle_irq(struct pt_regs *regs)
 {
 	u32 stat, i;
-	int irqnr, virq;
+	int irqnr;
 	void __iomem *base;
 
 	/* Loop through each active controller */
@@ -198,8 +198,7 @@ static void __exception_irq_entry vt8500_handle_irq(struct pt_regs *regs)
 				continue;
 		}
 
-		virq = irq_find_mapping(intc[i].domain, irqnr);
-		handle_IRQ(virq, regs);
+		handle_domain_irq(intc[i].domain, irqnr, regs);
 	}
 }
 
-- 
2.0.0

