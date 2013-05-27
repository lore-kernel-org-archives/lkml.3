Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932874Ab3E0Ohb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 10:37:31 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:38436 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932629Ab3E0Oh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 10:37:28 -0400
From: Afzal Mohammed <afzal@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        Benoit Cousson <benoit.cousson@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Ankur Kishore <a-kishore@ti.com>
Subject: [PATCH v2 10/14] ARM: OMAP2+: AM43x: basic dt support
Date: Mon, 27 May 2013 20:06:53 +0530
Message-ID: <2a3357fbbd9f103aa55cf720f64f6313d5133040.1369658705.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <cover.1369658705.git.afzal@ti.com>
References: <cover.1369658705.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Describe minimal DT boot machine details for AM43x based SoC's. AM43x
SoC's are ARM Cortex-A9 based with one core. AM43x is similar to
AM335x w.r.t L4 PER/WKUP memory map. AM43x has a sync timer, here that
is being used as clocksource, while 1ms dmtimer as clockevent.

Signed-off-by: Ankur Kishore <a-kishore@ti.com>
Signed-off-by: Afzal Mohammed <afzal@ti.com>
---

v2: Rely on dmtimer & synctimer for clockevent/source, map peripheral
	memory as in AM335x

 arch/arm/mach-omap2/board-generic.c | 16 ++++++++++++++++
 arch/arm/mach-omap2/timer.c         |  2 +-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/board-generic.c b/arch/arm/mach-omap2/board-generic.c
index 88aa6b1..e5fbfed 100644
--- a/arch/arm/mach-omap2/board-generic.c
+++ b/arch/arm/mach-omap2/board-generic.c
@@ -185,3 +185,19 @@ DT_MACHINE_START(OMAP5_DT, "Generic OMAP5 (Flattened Device Tree)")
 	.restart	= omap44xx_restart,
 MACHINE_END
 #endif
+
+#ifdef CONFIG_SOC_AM43XX
+static const char *am43_boards_compat[] __initdata = {
+	"ti,am43",
+	NULL,
+};
+
+DT_MACHINE_START(AM43_DT, "Generic AM43 (Flattened Device Tree)")
+	.map_io		= am33xx_map_io,
+	.init_early	= am43xx_init_early,
+	.init_irq	= omap_gic_of_init,
+	.init_machine	= omap_generic_init,
+	.init_time	= omap3_sync32k_timer_init,
+	.dt_compat	= am43_boards_compat,
+MACHINE_END
+#endif
diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
index 8e0c390..5f148e7 100644
--- a/arch/arm/mach-omap2/timer.c
+++ b/arch/arm/mach-omap2/timer.c
@@ -582,7 +582,7 @@ OMAP_SYS_32K_TIMER_INIT(2, 1, "timer_32k_ck", "ti,timer-alwon",
 			2, "timer_sys_ck", NULL);
 #endif /* CONFIG_ARCH_OMAP2 */
 
-#ifdef CONFIG_ARCH_OMAP3
+#if defined(CONFIG_ARCH_OMAP3) || defined(CONFIG_SOC_AM43XX)
 OMAP_SYS_32K_TIMER_INIT(3, 1, "timer_32k_ck", "ti,timer-alwon",
 			2, "timer_sys_ck", NULL);
 OMAP_SYS_32K_TIMER_INIT(3_secure, 12, "secure_32k_fck", "ti,timer-secure",
-- 
1.7.12

