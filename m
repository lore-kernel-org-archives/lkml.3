Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065Ab3HTCJO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 22:09:14 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:33987 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab3HTCEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 22:04:35 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [RFC 04/17] ARM: exynos: remove custom .init_time hook
Date: Tue, 20 Aug 2013 04:04:18 +0200
Message-Id: <1376964271-22715-5-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With arch/arm calling of_clk_init(NULL) from time_init(), we can now
remove custom .init_time hooks.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/mach-exynos/common.c          |    7 -------
 arch/arm/mach-exynos/common.h          |    1 -
 arch/arm/mach-exynos/mach-exynos4-dt.c |    1 -
 arch/arm/mach-exynos/mach-exynos5-dt.c |    1 -
 4 files changed, 10 deletions(-)

diff --git a/arch/arm/mach-exynos/common.c b/arch/arm/mach-exynos/common.c
index ba95e5d..587625b 100644
--- a/arch/arm/mach-exynos/common.c
+++ b/arch/arm/mach-exynos/common.c
@@ -27,7 +27,6 @@
 #include <linux/irqdomain.h>
 #include <linux/of_address.h>
 #include <linux/clocksource.h>
-#include <linux/clk-provider.h>
 #include <linux/irqchip/arm-gic.h>
 #include <linux/irqchip/chained_irq.h>
 
@@ -367,12 +366,6 @@ static void __init exynos5_map_io(void)
 		iotable_init(exynos5250_iodesc, ARRAY_SIZE(exynos5250_iodesc));
 }
 
-void __init exynos_init_time(void)
-{
-	of_clk_init(NULL);
-	clocksource_of_init();
-}
-
 struct bus_type exynos_subsys = {
 	.name		= "exynos-core",
 	.dev_name	= "exynos-core",
diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
index 8646a14..f0fa205 100644
--- a/arch/arm/mach-exynos/common.h
+++ b/arch/arm/mach-exynos/common.h
@@ -16,7 +16,6 @@
 #include <linux/of.h>
 
 void mct_init(void __iomem *base, int irq_g0, int irq_l0, int irq_l1);
-void exynos_init_time(void);
 
 struct map_desc;
 void exynos_init_io(void);
diff --git a/arch/arm/mach-exynos/mach-exynos4-dt.c b/arch/arm/mach-exynos/mach-exynos4-dt.c
index 0099c6c..7458dd4 100644
--- a/arch/arm/mach-exynos/mach-exynos4-dt.c
+++ b/arch/arm/mach-exynos/mach-exynos4-dt.c
@@ -54,7 +54,6 @@ DT_MACHINE_START(EXYNOS4210_DT, "Samsung Exynos4 (Flattened Device Tree)")
 	.init_early	= exynos_firmware_init,
 	.init_machine	= exynos4_dt_machine_init,
 	.init_late	= exynos_init_late,
-	.init_time	= exynos_init_time,
 	.dt_compat	= exynos4_dt_compat,
 	.restart        = exynos4_restart,
 	.reserve	= exynos4_reserve,
diff --git a/arch/arm/mach-exynos/mach-exynos5-dt.c b/arch/arm/mach-exynos/mach-exynos5-dt.c
index f874b77..8829da2 100644
--- a/arch/arm/mach-exynos/mach-exynos5-dt.c
+++ b/arch/arm/mach-exynos/mach-exynos5-dt.c
@@ -76,7 +76,6 @@ DT_MACHINE_START(EXYNOS5_DT, "SAMSUNG EXYNOS5 (Flattened Device Tree)")
 	.map_io		= exynos_init_io,
 	.init_machine	= exynos5_dt_machine_init,
 	.init_late	= exynos_init_late,
-	.init_time	= exynos_init_time,
 	.dt_compat	= exynos5_dt_compat,
 	.restart        = exynos5_restart,
 	.reserve	= exynos5_reserve,
-- 
1.7.10.4

