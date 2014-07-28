Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505AbaG1VR4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 17:17:56 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:33663 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752152AbaG1VRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 17:17:39 -0400
From: Felipe Balbi <balbi@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        <bcousson@baylibre.com>, <linux@arm.linux.org.uk>,
        <khilman@deeprootsystems.com>, <tglx@linutronix.de>,
        <jason@lakedaemon.net>, <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 10/35] arm: omap: irq: always define omap3 support
Date: Mon, 28 Jul 2014 16:15:58 -0500
Message-ID: <1406582183-696-11-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 2.0.1.563.g66f467c
In-Reply-To: <1406582183-696-1-git-send-email-balbi@ti.com>
References: <1406582183-696-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove ifdef around omap3 INTC support. This
will make it easier to reuse code for PM.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 arch/arm/mach-omap2/irq.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm/mach-omap2/irq.c b/arch/arm/mach-omap2/irq.c
index 93fe0be..adc2d33 100644
--- a/arch/arm/mach-omap2/irq.c
+++ b/arch/arm/mach-omap2/irq.c
@@ -265,7 +265,6 @@ void __init omap_intc_of_init(void)
 	of_irq_init(irq_match);
 }
 
-#if defined(CONFIG_ARCH_OMAP3) || defined(CONFIG_SOC_AM33XX)
 static struct omap_intc_regs intc_context;
 
 void omap_intc_save_context(void)
@@ -333,4 +332,3 @@ asmlinkage void __exception_irq_entry omap3_intc_handle_irq(struct pt_regs *regs
 {
 	omap_intc_handle_irq(regs);
 }
-#endif /* CONFIG_ARCH_OMAP3 */
-- 
2.0.1.563.g66f467c

