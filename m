Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054Ab3HTCIh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 22:08:37 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:35292 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab3HTCEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 22:04:37 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Jason Cooper <jason@lakedaemon.net>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [RFC 07/17] ARM: kirkwood: remove custom .init_time hook
Date: Tue, 20 Aug 2013 04:04:21 +0200
Message-Id: <1376964271-22715-8-git-send-email-sebastian.hesselbarth@gmail.com>
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
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/mach-kirkwood/board-dt.c |    8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/arm/mach-kirkwood/board-dt.c b/arch/arm/mach-kirkwood/board-dt.c
index 82d3ad8..a32a3e5 100644
--- a/arch/arm/mach-kirkwood/board-dt.c
+++ b/arch/arm/mach-kirkwood/board-dt.c
@@ -15,7 +15,6 @@
 #include <linux/of.h>
 #include <linux/of_platform.h>
 #include <linux/clk-provider.h>
-#include <linux/clocksource.h>
 #include <linux/dma-mapping.h>
 #include <linux/irqchip.h>
 #include <linux/kexec.h>
@@ -66,12 +65,6 @@ static void __init kirkwood_legacy_clk_init(void)
 	clk_prepare_enable(clk);
 }
 
-static void __init kirkwood_dt_time_init(void)
-{
-	of_clk_init(NULL);
-	clocksource_of_init();
-}
-
 static void __init kirkwood_dt_init_early(void)
 {
 	mvebu_mbus_init("marvell,kirkwood-mbus",
@@ -122,7 +115,6 @@ DT_MACHINE_START(KIRKWOOD_DT, "Marvell Kirkwood (Flattened Device Tree)")
 	/* Maintainer: Jason Cooper <jason@lakedaemon.net> */
 	.map_io		= kirkwood_map_io,
 	.init_early	= kirkwood_dt_init_early,
-	.init_time	= kirkwood_dt_time_init,
 	.init_machine	= kirkwood_dt_init,
 	.restart	= kirkwood_restart,
 	.dt_compat	= kirkwood_dt_board_compat,
-- 
1.7.10.4

