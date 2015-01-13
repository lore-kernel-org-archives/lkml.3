Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961AbbAMW1b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 17:27:31 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:11002 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751609AbbAMW10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 17:27:26 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18bGtTPT3kzvOAMBZOCgxz/
From: Tony Lindgren <tony@atomide.com>
To: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 2/2] irqchip: omap-intc: Remove unused legacy interface for omap2
Date: Tue, 13 Jan 2015 14:23:26 -0800
Message-Id: <1421187806-6804-3-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421187806-6804-1-git-send-email-tony@atomide.com>
References: <1421187806-6804-1-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nowadays omap2 is booting in device tree only mode so there is no
need to keep the legacy interface around for omap2_init_irq().

Cc: Felipe Balbi <balbi@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 drivers/irqchip/irq-omap-intc.c       | 8 --------
 include/linux/irqchip/irq-omap-intc.h | 1 -
 2 files changed, 9 deletions(-)

diff --git a/drivers/irqchip/irq-omap-intc.c b/drivers/irqchip/irq-omap-intc.c
index b75a44a..ece8624 100644
--- a/drivers/irqchip/irq-omap-intc.c
+++ b/drivers/irqchip/irq-omap-intc.c
@@ -348,14 +348,6 @@ out:
 		omap_ack_irq(NULL);
 }
 
-void __init omap2_init_irq(void)
-{
-	omap_nr_irqs = 96;
-	omap_nr_pending = 3;
-	omap_init_irq(OMAP24XX_IC_BASE, NULL);
-	set_handle_irq(omap_intc_handle_irq);
-}
-
 void __init omap3_init_irq(void)
 {
 	omap_nr_irqs = 96;
diff --git a/include/linux/irqchip/irq-omap-intc.h b/include/linux/irqchip/irq-omap-intc.h
index bda426a..2e3d1af 100644
--- a/include/linux/irqchip/irq-omap-intc.h
+++ b/include/linux/irqchip/irq-omap-intc.h
@@ -18,7 +18,6 @@
 #ifndef __INCLUDE_LINUX_IRQCHIP_IRQ_OMAP_INTC_H
 #define __INCLUDE_LINUX_IRQCHIP_IRQ_OMAP_INTC_H
 
-void omap2_init_irq(void);
 void omap3_init_irq(void);
 
 int omap_irq_pending(void);
-- 
2.1.4

