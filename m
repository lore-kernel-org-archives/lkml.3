Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab3IRSBb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 14:01:31 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:41086 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456Ab3IRSBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 14:01:30 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@arm.linux.org.uk>,
        Heiko Stuebner <heiko@sntech.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 20/26] ARM: rockchip: remove custom .init_time hook
Date: Wed, 18 Sep 2013 19:53:53 +0200
Message-Id: <1379526839-14798-21-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1379526839-14798-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1379526839-14798-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With arch/arm calling of_clk_init(NULL) from time_init(), we can now
remove custom .init_time hooks.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Olof Johansson <olof@lixom.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Heiko Stuebner <heiko@sntech.de>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/mach-rockchip/rockchip.c |    9 ---------
 1 file changed, 9 deletions(-)

diff --git a/arch/arm/mach-rockchip/rockchip.c b/arch/arm/mach-rockchip/rockchip.c
index 724d2d8..82c0b07 100644
--- a/arch/arm/mach-rockchip/rockchip.c
+++ b/arch/arm/mach-rockchip/rockchip.c
@@ -19,18 +19,10 @@
 #include <linux/init.h>
 #include <linux/of_platform.h>
 #include <linux/irqchip.h>
-#include <linux/dw_apb_timer.h>
-#include <linux/clk-provider.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
 #include <asm/hardware/cache-l2x0.h>
 
-static void __init rockchip_timer_init(void)
-{
-	of_clk_init(NULL);
-	clocksource_of_init();
-}
-
 static void __init rockchip_dt_init(void)
 {
 	l2x0_of_init(0, ~0UL);
@@ -47,6 +39,5 @@ static const char * const rockchip_board_dt_compat[] = {
 
 DT_MACHINE_START(ROCKCHIP_DT, "Rockchip Cortex-A9 (Device Tree)")
 	.init_machine	= rockchip_dt_init,
-	.init_time	= rockchip_timer_init,
 	.dt_compat	= rockchip_board_dt_compat,
 MACHINE_END
-- 
1.7.10.4

