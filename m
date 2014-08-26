Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934739AbaHZKFT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 06:05:19 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:21287 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934684AbaHZKFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 06:05:15 -0400
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
Subject: [PATCH v2 25/26] arm64: get rid of handle_IRQ
Date: Tue, 26 Aug 2014 11:03:40 +0100
Message-Id: <1409047421-27649-26-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1409047421-27649-1-git-send-email-marc.zyngier@arm.com>
References: <1409047421-27649-1-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the arm64 irqchip drivers have been converted to handle_domain_irq,
making it possible to remove the handle_IRQ stub entierely.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/hardirq.h |  2 --
 arch/arm64/kernel/irq.c          | 11 -----------
 2 files changed, 13 deletions(-)

diff --git a/arch/arm64/include/asm/hardirq.h b/arch/arm64/include/asm/hardirq.h
index 0be6782..e8a3268 100644
--- a/arch/arm64/include/asm/hardirq.h
+++ b/arch/arm64/include/asm/hardirq.h
@@ -47,8 +47,6 @@ static inline void ack_bad_irq(unsigned int irq)
 	irq_err_count++;
 }
 
-extern void handle_IRQ(unsigned int, struct pt_regs *);
-
 /*
  * No arch-specific IRQ flags.
  */
diff --git a/arch/arm64/kernel/irq.c b/arch/arm64/kernel/irq.c
index 2c0e2a7..67ca197 100644
--- a/arch/arm64/kernel/irq.c
+++ b/arch/arm64/kernel/irq.c
@@ -40,17 +40,6 @@ int arch_show_interrupts(struct seq_file *p, int prec)
 	return 0;
 }
 
-/*
- * handle_IRQ handles all hardware IRQ's.  Decoded IRQs should
- * not come via this function.  Instead, they should provide their
- * own 'handler'.  Used by platform code implementing C-based 1st
- * level decoding.
- */
-void handle_IRQ(unsigned int irq, struct pt_regs *regs)
-{
-	__handle_domain_irq(NULL, irq, false, regs);
-}
-
 void __init set_handle_irq(void (*handle_irq)(struct pt_regs *))
 {
 	if (handle_arch_irq)
-- 
2.0.4

