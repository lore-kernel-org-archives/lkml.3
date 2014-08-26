Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934849AbaHZKJe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 06:09:34 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:20980 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934596AbaHZKEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 06:04:45 -0400
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
Subject: [PATCH v2 15/26] irqchip: vic: convert to handle_domain_irq
Date: Tue, 26 Aug 2014 11:03:30 +0100
Message-Id: <1409047421-27649-16-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1409047421-27649-1-git-send-email-marc.zyngier@arm.com>
References: <1409047421-27649-1-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new handle_domain_irq method to handle interrupts.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-vic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-vic.c b/drivers/irqchip/irq-vic.c
index 7d35287..54089de 100644
--- a/drivers/irqchip/irq-vic.c
+++ b/drivers/irqchip/irq-vic.c
@@ -219,7 +219,7 @@ static int handle_one_vic(struct vic_device *vic, struct pt_regs *regs)
 
 	while ((stat = readl_relaxed(vic->base + VIC_IRQ_STATUS))) {
 		irq = ffs(stat) - 1;
-		handle_IRQ(irq_find_mapping(vic->domain, irq), regs);
+		handle_domain_irq(vic->domain, irq, regs);
 		handled = 1;
 	}
 
-- 
2.0.4

