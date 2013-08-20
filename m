Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867Ab3HTCEl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 22:04:41 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:43486 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777Ab3HTCEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 22:04:35 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Jason Cooper <jason@lakedaemon.net>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [RFC 03/17] ARM: dove: remove custom .init_time hook
Date: Tue, 20 Aug 2013 04:04:17 +0200
Message-Id: <1376964271-22715-4-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With arch/arm calling of_clk_init(NULL) from time_init(), we can now
remove custom .init_time hooks. While at it, also remove some obsolete
includes.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/mach-dove/board-dt.c |   16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff --git a/arch/arm/mach-dove/board-dt.c b/arch/arm/mach-dove/board-dt.c
index 9a116d7..5ea4491 100644
--- a/arch/arm/mach-dove/board-dt.c
+++ b/arch/arm/mach-dove/board-dt.c
@@ -9,26 +9,13 @@
  */
 
 #include <linux/init.h>
-#include <linux/clk-provider.h>
-#include <linux/clocksource.h>
-#include <linux/irqchip.h>
+#include <linux/mbus.h>
 #include <linux/of.h>
 #include <linux/of_platform.h>
-#include <linux/platform_data/usb-ehci-orion.h>
 #include <asm/hardware/cache-tauros2.h>
 #include <asm/mach/arch.h>
-#include <mach/dove.h>
-#include <mach/pm.h>
-#include <plat/common.h>
-#include <plat/irq.h>
 #include "common.h"
 
-static void __init dove_dt_time_init(void)
-{
-	of_clk_init(NULL);
-	clocksource_of_init();
-}
-
 static void __init dove_dt_init(void)
 {
 	pr_info("Dove 88AP510 SoC\n");
@@ -47,7 +34,6 @@ static const char * const dove_dt_board_compat[] = {
 
 DT_MACHINE_START(DOVE_DT, "Marvell Dove (Flattened Device Tree)")
 	.map_io		= dove_map_io,
-	.init_time	= dove_dt_time_init,
 	.init_machine	= dove_dt_init,
 	.restart	= dove_restart,
 	.dt_compat	= dove_dt_board_compat,
-- 
1.7.10.4

