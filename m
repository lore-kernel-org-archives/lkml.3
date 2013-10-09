Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757120Ab3JIXZi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 19:25:38 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:34978 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756637Ab3JIXZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 19:25:31 -0400
From: Nishanth Menon <nm@ti.com>
To: Kevin Hilman <khilman@linaro.org>, Benoit Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>, Tero Kristo <t-kristo@ti.com>
CC: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Nishanth Menon <nm@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Paul Walmsley <paul@pwsan.com>
Subject: [PATCH V6 03/15] ARM: OMAP2+: AM43XX: add lateinit hook for calling pm late init
Date: Wed, 9 Oct 2013 18:24:46 -0500
Message-ID: <1381361098-8283-2-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381361098-8283-1-git-send-email-nm@ti.com>
References: <1381354144-7134-1-git-send-email-nm@ti.com>
 <1381361098-8283-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call OMAP2+ generic lateinit hook from AM43x specific late init hook.
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
index b474498..d4371c7 100644
--- a/arch/arm/mach-omap2/board-generic.c
+++ b/arch/arm/mach-omap2/board-generic.c
@@ -235,6 +235,7 @@ static const char *am43_boards_compat[] __initdata = {
 DT_MACHINE_START(AM43_DT, "Generic AM43 (Flattened Device Tree)")
 	.map_io		= am33xx_map_io,
 	.init_early	= am43xx_init_early,
+	.init_late	= am43xx_init_late,
 	.init_irq	= omap_gic_of_init,
 	.init_machine	= omap_generic_init,
 	.init_time	= omap3_sync32k_timer_init,
diff --git a/arch/arm/mach-omap2/common.h b/arch/arm/mach-omap2/common.h
index 049c58d..09f6736 100644
--- a/arch/arm/mach-omap2/common.h
+++ b/arch/arm/mach-omap2/common.h
@@ -98,6 +98,7 @@ void am35xx_init_early(void);
 void ti81xx_init_early(void);
 void am33xx_init_early(void);
 void am43xx_init_early(void);
+void am43xx_init_late(void);
 void omap4430_init_early(void);
 void omap5_init_early(void);
 void omap3_init_late(void);	/* Do not use this one */
diff --git a/arch/arm/mach-omap2/io.c b/arch/arm/mach-omap2/io.c
index 38678bf..300eac0 100644
--- a/arch/arm/mach-omap2/io.c
+++ b/arch/arm/mach-omap2/io.c
@@ -613,6 +613,12 @@ void __init am43xx_init_early(void)
 	omap2_set_globals_cm(AM33XX_L4_WK_IO_ADDRESS(AM43XX_PRCM_BASE), NULL);
 	omap3xxx_check_revision();
 }
+
+void __init am43xx_init_late(void)
+{
+	omap2_common_pm_late_init();
+}
+
 #endif
 
 #ifdef CONFIG_ARCH_OMAP4
-- 
1.7.9.5

