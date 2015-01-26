Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686AbbAZKox (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:44:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39837 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754952AbbAZKoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 05:44:44 -0500
Date: Mon, 26 Jan 2015 02:44:33 -0800
From: tip-bot for Tony Lindgren <tipbot@zytor.com>
Message-ID: <tip-c7f2a2ac377626897ad68e63d24d85ee21f47bb1@git.kernel.org>
Cc: jason@lakedaemon.net, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        balbi@ti.com, tony@atomide.com, hpa@zytor.com, mingo@kernel.org
Reply-To: mingo@kernel.org, tony@atomide.com, hpa@zytor.com, balbi@ti.com,
        tglx@linutronix.de, linux-kernel@vger.kernel.org, jason@lakedaemon.net
In-Reply-To: <1421187806-6804-3-git-send-email-tony@atomide.com>
References: <1421187806-6804-3-git-send-email-tony@atomide.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] irqchip: omap-intc:
  Remove unused legacy interface for omap2
Git-Commit-ID: c7f2a2ac377626897ad68e63d24d85ee21f47bb1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c7f2a2ac377626897ad68e63d24d85ee21f47bb1
Gitweb:     http://git.kernel.org/tip/c7f2a2ac377626897ad68e63d24d85ee21f47bb1
Author:     Tony Lindgren <tony@atomide.com>
AuthorDate: Tue, 13 Jan 2015 14:23:26 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 26 Jan 2015 11:38:23 +0100

irqchip: omap-intc: Remove unused legacy interface for omap2

Nowadays omap2 is booting in device tree only mode so there is no
need to keep the legacy interface around for omap2_init_irq().

Signed-off-by: Tony Lindgren <tony@atomide.com>
Reviewed-by: Felipe Balbi <balbi@ti.com>
Cc: Jason Cooper <jason@lakedaemon.net>
Link: http://lkml.kernel.org/r/1421187806-6804-3-git-send-email-tony@atomide.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/irqchip/irq-omap-intc.c       | 8 --------
 include/linux/irqchip/irq-omap-intc.h | 1 -
 2 files changed, 9 deletions(-)

diff --git a/drivers/irqchip/irq-omap-intc.c b/drivers/irqchip/irq-omap-intc.c
index b444d0e..a569c6d 100644
--- a/drivers/irqchip/irq-omap-intc.c
+++ b/drivers/irqchip/irq-omap-intc.c
@@ -364,14 +364,6 @@ out:
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
