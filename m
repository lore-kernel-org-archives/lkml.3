Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352AbaHZKEu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 06:04:50 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:21003 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934615AbaHZKEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 06:04:47 -0400
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
Subject: [PATCH v2 17/26] irqchip: zevio: convert to handle_domain_irq
Date: Tue, 26 Aug 2014 11:03:32 +0100
Message-Id: <1409047421-27649-18-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1409047421-27649-1-git-send-email-marc.zyngier@arm.com>
References: <1409047421-27649-1-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new handle_domain_irq method to handle interrupts.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-zevio.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-zevio.c b/drivers/irqchip/irq-zevio.c
index ceb3a43..e4ef74e 100644
--- a/drivers/irqchip/irq-zevio.c
+++ b/drivers/irqchip/irq-zevio.c
@@ -56,8 +56,7 @@ static void __exception_irq_entry zevio_handle_irq(struct pt_regs *regs)
 
 	while (readl(zevio_irq_io + IO_STATUS)) {
 		irqnr = readl(zevio_irq_io + IO_CURRENT);
-		irqnr = irq_find_mapping(zevio_irq_domain, irqnr);
-		handle_IRQ(irqnr, regs);
+		handle_domain_irq(zevio_irq_domain, irqnr, regs);
 	};
 }
 
-- 
2.0.4

