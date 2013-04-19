Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968424Ab3DSQWj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 12:22:39 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:13957 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756979Ab3DSQTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 12:19:49 -0400
X-IronPort-AV: E=Sophos;i="4.87,510,1363158000"; 
   d="scan'208";a="39954135"
From: Stephen Boyd <sboyd@codeaurora.org>
To: arm@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCHv5 05/11] ARM: OMAP2+: Divorce from local timer API
Date: Fri, 19 Apr 2013 09:19:39 -0700
Message-Id: <1366388385-30722-6-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1.392.g85e7e81
In-Reply-To: <1366388385-30722-1-git-send-email-sboyd@codeaurora.org>
References: <1366388385-30722-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the TWD doesn't rely on the local timer API, OMAP can
stop selecting it in Kconfig and relying on the config option to
decide if it should call smp_twd functions.

Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Acked-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-omap2/Kconfig | 1 -
 arch/arm/mach-omap2/timer.c | 7 -------
 2 files changed, 8 deletions(-)

diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index 568bb74..ff185ef 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -91,7 +91,6 @@ config ARCH_OMAP4
 	select HAVE_ARM_SCU if SMP
 	select HAVE_ARM_TWD if SMP
 	select HAVE_SMP
-	select LOCAL_TIMERS if SMP
 	select OMAP_INTERCONNECT
 	select PL310_ERRATA_588369
 	select PL310_ERRATA_727915
diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
index ce57228..7f2ef6c 100644
--- a/arch/arm/mach-omap2/timer.c
+++ b/arch/arm/mach-omap2/timer.c
@@ -600,7 +600,6 @@ static OMAP_SYS_32K_TIMER_INIT(4, 1, "timer_32k_ck", "ti,timer-alwon",
 #endif
 
 #ifdef CONFIG_ARCH_OMAP4
-#ifdef CONFIG_LOCAL_TIMERS
 static DEFINE_TWD_LOCAL_TIMER(twd_local_timer, OMAP44XX_LOCAL_TWD_BASE, 29);
 void __init omap4_local_timer_init(void)
 {
@@ -619,12 +618,6 @@ void __init omap4_local_timer_init(void)
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

