Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757073Ab3JIXZh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 19:25:37 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:34977 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756623Ab3JIXZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 19:25:31 -0400
From: Nishanth Menon <nm@ti.com>
To: Kevin Hilman <khilman@linaro.org>, Benoit Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>, Tero Kristo <t-kristo@ti.com>
CC: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Nishanth Menon <nm@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Paul Walmsley <paul@pwsan.com>
Subject: [PATCH V6 02/15] ARM: OMAP2+: AM33XX: add lateinit hook for calling pm late init
Date: Wed, 9 Oct 2013 18:24:45 -0500
Message-ID: <1381361098-8283-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381354144-7134-1-git-send-email-nm@ti.com>
References: <1381354144-7134-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call OMAP2+ generic lateinit hook from AM specific late init hook.
This allows the generic late initializations such as cpufreq hooks
to be active.

Cc: Benoit Cousson <bcousson@baylibre.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Paul Walmsley <paul@pwsan.com>
Cc: Tony Lindgren <tony@atomide.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
---
 arch/arm/mach-omap2/board-generic.c |    1 +
 arch/arm/mach-omap2/common.h        |    1 +
 arch/arm/mach-omap2/io.c            |    6 ++++++
 3 files changed, 8 insertions(+)

diff --git a/arch/arm/mach-omap2/board-generic.c b/arch/arm/mach-omap2/board-generic.c
index 87162e1..b474498 100644
--- a/arch/arm/mach-omap2/board-generic.c
+++ b/arch/arm/mach-omap2/board-generic.c
@@ -180,6 +180,7 @@ DT_MACHINE_START(AM33XX_DT, "Generic AM33XX (Flattened Device Tree)")
 	.init_irq	= omap_intc_of_init,
 	.handle_irq	= omap3_intc_handle_irq,
 	.init_machine	= omap_generic_init,
+	.init_late	= am33xx_init_late,
 	.init_time	= omap3_gptimer_timer_init,
 	.dt_compat	= am33xx_boards_compat,
 	.restart	= am33xx_restart,
diff --git a/arch/arm/mach-omap2/common.h b/arch/arm/mach-omap2/common.h
index 4a5684b..049c58d 100644
--- a/arch/arm/mach-omap2/common.h
+++ b/arch/arm/mach-omap2/common.h
@@ -109,6 +109,7 @@ void omap35xx_init_late(void);
 void omap3630_init_late(void);
 void am35xx_init_late(void);
 void ti81xx_init_late(void);
+void am33xx_init_late(void);
 int omap2_common_pm_late_init(void);
 void dra7xx_init_early(void);
 
diff --git a/arch/arm/mach-omap2/io.c b/arch/arm/mach-omap2/io.c
index a9896ea..38678bf 100644
--- a/arch/arm/mach-omap2/io.c
+++ b/arch/arm/mach-omap2/io.c
@@ -594,6 +594,12 @@ void __init am33xx_init_early(void)
 	omap_hwmod_init_postsetup();
 	omap_clk_init = am33xx_dt_clk_init;
 }
+
+void __init am33xx_init_late(void)
+{
+	omap2_common_pm_late_init();
+}
+
 #endif
 
 #ifdef CONFIG_SOC_AM43XX
-- 
1.7.9.5

