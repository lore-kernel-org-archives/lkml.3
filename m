Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661AbaG1VSK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 17:18:10 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:33668 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752256AbaG1VRm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 17:17:42 -0400
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
Subject: [PATCH 19/35] arm: omap: irq: drop ti,intc-size support
Date: Mon, 28 Jul 2014 16:16:07 -0500
Message-ID: <1406582183-696-20-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 2.0.1.563.g66f467c
In-Reply-To: <1406582183-696-1-git-send-email-balbi@ti.com>
References: <1406582183-696-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we don't need that anymore since specific
devices are passing correct compatible flags.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 arch/arm/mach-omap2/irq.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm/mach-omap2/irq.c b/arch/arm/mach-omap2/irq.c
index 7a4ead3..e70c26e 100644
--- a/arch/arm/mach-omap2/irq.c
+++ b/arch/arm/mach-omap2/irq.c
@@ -313,9 +313,6 @@ static int __init intc_of_init(struct device_node *node,
 	if (of_device_is_compatible(node, "ti,am33xx-intc"))
 		nr_irq = 128;
 
-	if (of_property_read_u32(node, "ti,intc-size", &nr_irq))
-		pr_warn("unable to get intc-size, default to %d\n", nr_irq);
-
 	omap_init_irq(res.start, nr_irq, of_node_get(node));
 
 	set_handle_irq(omap2_intc_handle_irq);
-- 
2.0.1.563.g66f467c

