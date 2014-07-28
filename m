Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbaG1V3G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 17:29:06 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:33654 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971AbaG1VRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 17:17:31 -0400
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
Subject: [PATCH 04/35] arm: omap: irq: add a global omap_nr_irqs variable
Date: Mon, 28 Jul 2014 16:15:52 -0500
Message-ID: <1406582183-696-5-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 2.0.1.563.g66f467c
In-Reply-To: <1406582183-696-1-git-send-email-balbi@ti.com>
References: <1406582183-696-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this will cache number of irqs. Also in preparation
for removal of irq_banks array.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 arch/arm/mach-omap2/irq.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/mach-omap2/irq.c b/arch/arm/mach-omap2/irq.c
index 83163d0..3870853 100644
--- a/arch/arm/mach-omap2/irq.c
+++ b/arch/arm/mach-omap2/irq.c
@@ -70,6 +70,7 @@ static struct omap_irq_bank {
 
 static struct irq_domain *domain;
 static void __iomem *omap_irq_base;
+static int omap_nr_irqs = 96;
 
 /* Structure to save interrupt controller context */
 struct omap3_intc_regs {
@@ -170,6 +171,8 @@ static void __init omap_init_irq(u32 base, int nr_irqs,
 	if (WARN_ON(!omap_irq_base))
 		return;
 
+	omap_nr_irqs = nr_irqs;
+
 	irq_base = irq_alloc_descs(-1, 0, nr_irqs, 0);
 	if (irq_base < 0) {
 		pr_warn("Couldn't allocate IRQ numbers\n");
-- 
2.0.1.563.g66f467c

