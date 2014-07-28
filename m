Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084AbaG1VZV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 17:25:21 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:33666 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198AbaG1VRl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 17:17:41 -0400
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
Subject: [PATCH 17/35] arm: omap: irq: use compatible flag to figure out number of IRQ lines
Date: Mon, 28 Jul 2014 16:16:05 -0500
Message-ID: <1406582183-696-18-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 2.0.1.563.g66f467c
In-Reply-To: <1406582183-696-1-git-send-email-balbi@ti.com>
References: <1406582183-696-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

so far, only am33xx has 128 lines, all other devices
have only 96.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 arch/arm/mach-omap2/irq.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/mach-omap2/irq.c b/arch/arm/mach-omap2/irq.c
index 97845df..7a4ead3 100644
--- a/arch/arm/mach-omap2/irq.c
+++ b/arch/arm/mach-omap2/irq.c
@@ -310,6 +310,9 @@ static int __init intc_of_init(struct device_node *node,
 		return -EINVAL;
 	}
 
+	if (of_device_is_compatible(node, "ti,am33xx-intc"))
+		nr_irq = 128;
+
 	if (of_property_read_u32(node, "ti,intc-size", &nr_irq))
 		pr_warn("unable to get intc-size, default to %d\n", nr_irq);
 
-- 
2.0.1.563.g66f467c

