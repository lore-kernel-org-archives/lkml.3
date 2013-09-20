Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954Ab3ITQJW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 12:09:22 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50505 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752780Ab3ITQJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 12:09:19 -0400
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Nishanth Menon <nm@ti.com>
Subject: [RFC PATCH] ARM: OMAP3630: Add generic machine descriptor
Date: Fri, 20 Sep 2013 11:08:52 -0500
Message-ID: <1379693332-10585-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add generic machine which can handle inits for omap3630.
Currently beagle-xm would matchup with ti,omap3 which invokes
omap3430_init_early instead of omap3630_init_early

This defeats the purpose of having SoC specific init_early handlers,
example: clock nodes are not the same between 3430 and 3630.

Signed-off-by: Nishanth Menon <nm@ti.com>
---

An alternative approach may be to (for all SoCs):
1. define every SoC entry - ti,omap3430 ti,omap3630...
2. have a generic omap3_init which uses "if (of_machine_is_compatible("ti,omap3630"))"
to invoke the appropriate omap3xxx_init_early.

 arch/arm/mach-omap2/board-generic.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm/mach-omap2/board-generic.c b/arch/arm/mach-omap2/board-generic.c
index 39c7838..cd85b36 100644
--- a/arch/arm/mach-omap2/board-generic.c
+++ b/arch/arm/mach-omap2/board-generic.c
@@ -147,6 +147,24 @@ DT_MACHINE_START(OMAP3_GP_DT, "Generic OMAP3-GP (Flattened Device Tree)")
 	.dt_compat	= omap3_gp_boards_compat,
 	.restart	= omap3xxx_restart,
 MACHINE_END
+
+static const char *omap3630_gp_boards_compat[] __initdata = {
+	"ti,omap3-beagle-xm",
+	NULL,
+};
+
+DT_MACHINE_START(OMAP3630_GP_DT, "Generic OMAP3630-GP (Flattened Device Tree)")
+	.reserve	= omap_reserve,
+	.map_io		= omap3_map_io,
+	.init_early	= omap3630_init_early,
+	.init_irq	= omap_intc_of_init,
+	.handle_irq	= omap3_intc_handle_irq,
+	.init_machine	= omap_generic_init,
+	.init_late	= omap3_init_late,
+	.init_time	= omap3_secure_sync32k_timer_init,
+	.dt_compat	= omap3630_gp_boards_compat,
+	.restart	= omap3xxx_restart,
+MACHINE_END
 #endif
 
 #ifdef CONFIG_SOC_AM33XX
-- 
1.7.9.5

