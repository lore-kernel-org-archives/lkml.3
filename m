Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414AbaG1VRv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 17:17:51 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:37270 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159AbaG1VRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
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
Subject: [PATCH 12/35] arm: omap: irq: make intc_of_init static
Date: Mon, 28 Jul 2014 16:16:00 -0500
Message-ID: <1406582183-696-13-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 2.0.1.563.g66f467c
In-Reply-To: <1406582183-696-1-git-send-email-balbi@ti.com>
References: <1406582183-696-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nobody uses that function outside of this file,
so we don't need to expose it.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 arch/arm/mach-omap2/common.h | 10 ----------
 arch/arm/mach-omap2/irq.c    |  2 +-
 2 files changed, 1 insertion(+), 11 deletions(-)

diff --git a/arch/arm/mach-omap2/common.h b/arch/arm/mach-omap2/common.h
index dc571f1..bbb0623 100644
--- a/arch/arm/mach-omap2/common.h
+++ b/arch/arm/mach-omap2/common.h
@@ -229,16 +229,6 @@ extern void __iomem *omap4_get_l2cache_base(void);
 #endif
 
 struct device_node;
-#ifdef CONFIG_OF
-int __init intc_of_init(struct device_node *node,
-			     struct device_node *parent);
-#else
-int __init intc_of_init(struct device_node *node,
-			     struct device_node *parent)
-{
-	return 0;
-}
-#endif
 
 #ifdef CONFIG_SMP
 extern void __iomem *omap4_get_scu_base(void);
diff --git a/arch/arm/mach-omap2/irq.c b/arch/arm/mach-omap2/irq.c
index 266dc0c..e6997c5 100644
--- a/arch/arm/mach-omap2/irq.c
+++ b/arch/arm/mach-omap2/irq.c
@@ -295,7 +295,7 @@ asmlinkage void __exception_irq_entry omap2_intc_handle_irq(struct pt_regs *regs
 	omap_intc_handle_irq(regs);
 }
 
-int __init intc_of_init(struct device_node *node,
+static int __init intc_of_init(struct device_node *node,
 			     struct device_node *parent)
 {
 	struct resource res;
-- 
2.0.1.563.g66f467c

