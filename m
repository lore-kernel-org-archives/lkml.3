Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934871AbaHZKLB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 06:11:01 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:20798 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934530AbaHZKEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 06:04:22 -0400
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
Subject: [PATCH v2 10/26] irqchip: orion: convert to handle_domain_irq
Date: Tue, 26 Aug 2014 11:03:25 +0100
Message-Id: <1409047421-27649-11-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1409047421-27649-1-git-send-email-marc.zyngier@arm.com>
References: <1409047421-27649-1-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new handle_domain_irq method to handle interrupts.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-orion.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/irqchip/irq-orion.c b/drivers/irqchip/irq-orion.c
index 34d18b4..ad0c0f6 100644
--- a/drivers/irqchip/irq-orion.c
+++ b/drivers/irqchip/irq-orion.c
@@ -43,9 +43,8 @@ __exception_irq_entry orion_handle_irq(struct pt_regs *regs)
 			gc->mask_cache;
 		while (stat) {
 			u32 hwirq = __fls(stat);
-			u32 irq = irq_find_mapping(orion_irq_domain,
-						   gc->irq_base + hwirq);
-			handle_IRQ(irq, regs);
+			handle_domain_irq(orion_irq_domain,
+					  gc->irq_base + hwirq, regs);
 			stat &= ~(1 << hwirq);
 		}
 	}
-- 
2.0.4

