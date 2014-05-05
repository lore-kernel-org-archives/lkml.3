Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204AbaEEDQb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 23:16:31 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35139 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752122AbaEEDQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 23:16:30 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>, wim@iguana.be, dbaryshkov@gmail.com,
        dwmw2@infradead.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 4/6] ARM: sunxi: Remove init_machine callback
Date: Sun,  4 May 2014 22:08:02 -0500
Message-Id: <1399259284-6282-5-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399259284-6282-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1399259284-6282-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The init_machine hook is now at its default value. We can remove it.

Even though the sun4i and sun7i machines are nothing more than generic machines
now, leave them in so that we won't have to add them back if needed, and so
that the machine is still displayed in /proc/cpuinfo.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/mach-sunxi/sunxi.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/arch/arm/mach-sunxi/sunxi.c b/arch/arm/mach-sunxi/sunxi.c
index 1c62a0a021d7..efb2f93b02e6 100644
--- a/arch/arm/mach-sunxi/sunxi.c
+++ b/arch/arm/mach-sunxi/sunxi.c
@@ -12,17 +12,11 @@
 
 #include <linux/clk-provider.h>
 #include <linux/clocksource.h>
-#include <linux/of_platform.h>
 
 #include <asm/mach/arch.h>
 
 #include "common.h"
 
-static void __init sunxi_dt_init(void)
-{
-	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
-}
-
 static const char * const sunxi_board_dt_compat[] = {
 	"allwinner,sun4i-a10",
 	"allwinner,sun5i-a10s",
@@ -31,7 +25,6 @@ static const char * const sunxi_board_dt_compat[] = {
 };
 
 DT_MACHINE_START(SUNXI_DT, "Allwinner A1X (Device Tree)")
-	.init_machine	= sunxi_dt_init,
 	.dt_compat	= sunxi_board_dt_compat,
 MACHINE_END
 
@@ -49,7 +42,6 @@ static void __init sun6i_timer_init(void)
 }
 
 DT_MACHINE_START(SUN6I_DT, "Allwinner sun6i (A31) Family")
-	.init_machine	= sunxi_dt_init,
 	.init_time	= sun6i_timer_init,
 	.dt_compat	= sun6i_board_dt_compat,
 	.smp		= smp_ops(sun6i_smp_ops),
@@ -61,6 +53,5 @@ static const char * const sun7i_board_dt_compat[] = {
 };
 
 DT_MACHINE_START(SUN7I_DT, "Allwinner sun7i (A20) Family")
-	.init_machine	= sunxi_dt_init,
 	.dt_compat	= sun7i_board_dt_compat,
 MACHINE_END
-- 
1.9.1

