Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab3H0VaU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 17:30:20 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:64974 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696Ab3H0V2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 17:28:25 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH RFC v2 10/16] ARM: rockchip: remove custom .init_time hook
Date: Tue, 27 Aug 2013 23:28:04 +0200
Message-Id: <1377638890-371-11-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.2.5
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
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/mach-rockchip/rockchip.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

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
1.7.2.5

