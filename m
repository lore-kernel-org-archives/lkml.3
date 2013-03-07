Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932283Ab3CGAGp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 19:06:45 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:36444 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757586Ab3CGAEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 19:04:09 -0500
X-IronPort-AV: E=Sophos;i="4.84,798,1355126400"; 
   d="scan'208";a="27738010"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 04/10] ARM: OMAP2+: Divorce from local timer API
Date: Wed,  6 Mar 2013 16:04:00 -0800
Message-Id: <1362614646-24113-5-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.2.rc2.4.g7799588
In-Reply-To: <1362614646-24113-1-git-send-email-sboyd@codeaurora.org>
References: <1362614646-24113-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the TWD doesn't rely on the local timer API, OMAP can
stop selecting it in Kconfig and relying on the config option to
decide if it should call smp_twd functions.

Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Tony Lindgren <tony@atomide.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-omap2/Kconfig | 1 -
 arch/arm/mach-omap2/timer.c | 7 -------
 2 files changed, 8 deletions(-)

diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index 49ac3df..6e1f871 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -88,7 +88,6 @@ config ARCH_OMAP4
 	select CACHE_L2X0
 	select CPU_V7
 	select HAVE_SMP
-	select LOCAL_TIMERS if SMP
 	select OMAP_INTERCONNECT
 	select PL310_ERRATA_588369
 	select PL310_ERRATA_727915
diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
index 2bdd4cf..c00a8f8 100644
--- a/arch/arm/mach-omap2/timer.c
+++ b/arch/arm/mach-omap2/timer.c
@@ -587,7 +587,6 @@ OMAP_SYS_GP_TIMER_INIT(3_am33xx, 1, OMAP4_MPU_SOURCE, "ti,timer-alwon",
 #ifdef CONFIG_ARCH_OMAP4
 OMAP_SYS_32K_TIMER_INIT(4, 1, OMAP4_32K_SOURCE, "ti,timer-alwon",
 			2, OMAP4_MPU_SOURCE);
-#ifdef CONFIG_LOCAL_TIMERS
 static DEFINE_TWD_LOCAL_TIMER(twd_local_timer, OMAP44XX_LOCAL_TWD_BASE, 29);
 void __init omap4_local_timer_init(void)
 {
@@ -606,12 +605,6 @@ void __init omap4_local_timer_init(void)
 			pr_err("twd_local_timer_register failed %d\n", err);
 	}
 }
-#else /* CONFIG_LOCAL_TIMERS */
-void __init omap4_local_timer_init(void)
-{
-	omap4_sync32k_timer_init();
-}
-#endif /* CONFIG_LOCAL_TIMERS */
 #endif /* CONFIG_ARCH_OMAP4 */
 
 #ifdef CONFIG_SOC_OMAP5
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

