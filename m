Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044AbaGHNVP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 09:21:15 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:33434 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754776AbaGHNVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 09:21:13 -0400
X-Greylist: delayed 622 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Jul 2014 09:21:13 EDT
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
Subject: [PATCH 11/15] irqchip: sun4i: convert to handle_domain_irq
Date: Tue,  8 Jul 2014 14:10:34 +0100
Message-Id: <1404825038-547-12-git-send-email-marc.zyngier@arm.com>
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
 drivers/irqchip/irq-sun4i.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/irqchip/irq-sun4i.c b/drivers/irqchip/irq-sun4i.c
index 6fcef4a..64155b6 100644
--- a/drivers/irqchip/irq-sun4i.c
+++ b/drivers/irqchip/irq-sun4i.c
@@ -136,7 +136,7 @@ IRQCHIP_DECLARE(allwinner_sun4i_ic, "allwinner,sun4i-a10-ic", sun4i_of_init);
 
 static void __exception_irq_entry sun4i_handle_irq(struct pt_regs *regs)
 {
-	u32 irq, hwirq;
+	u32 hwirq;
 
 	/*
 	 * hwirq == 0 can mean one of 3 things:
@@ -154,8 +154,7 @@ static void __exception_irq_entry sun4i_handle_irq(struct pt_regs *regs)
 		return;
 
 	do {
-		irq = irq_find_mapping(sun4i_irq_domain, hwirq);
-		handle_IRQ(irq, regs);
+		handle_domain_irq(sun4i_irq_domain, hwirq, regs);
 		hwirq = readl(sun4i_irq_base + SUN4I_IRQ_VECTOR_REG) >> 2;
 	} while (hwirq != 0);
 }
-- 
2.0.0

