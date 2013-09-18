Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab3IRRyi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 13:54:38 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:34155 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231Ab3IRRyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 13:54:17 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@arm.linux.org.uk>,
        Daniel Tang <dt.tangr@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 18/26] ARM: nspire: remove custom .init_time hook
Date: Wed, 18 Sep 2013 19:53:51 +0200
Message-Id: <1379526839-14798-19-git-send-email-sebastian.hesselbarth@gmail.com>
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
Cc: Daniel Tang <dt.tangr@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/mach-nspire/nspire.c |    9 ---------
 1 file changed, 9 deletions(-)

diff --git a/arch/arm/mach-nspire/nspire.c b/arch/arm/mach-nspire/nspire.c
index 99e2609..4b2ed2e 100644
--- a/arch/arm/mach-nspire/nspire.c
+++ b/arch/arm/mach-nspire/nspire.c
@@ -14,11 +14,9 @@
 #include <linux/of_platform.h>
 #include <linux/irqchip.h>
 #include <linux/irqchip/arm-vic.h>
-#include <linux/clk-provider.h>
 #include <linux/clkdev.h>
 #include <linux/amba/bus.h>
 #include <linux/amba/clcd.h>
-#include <linux/clocksource.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach-types.h>
@@ -65,12 +63,6 @@ static void __init nspire_init(void)
 			nspire_auxdata, NULL);
 }
 
-static void __init nspire_init_time(void)
-{
-	of_clk_init(NULL);
-	clocksource_of_init();
-}
-
 static void nspire_restart(char mode, const char *cmd)
 {
 	void __iomem *base = ioremap(NSPIRE_MISC_PHYS_BASE, SZ_4K);
@@ -83,7 +75,6 @@ static void nspire_restart(char mode, const char *cmd)
 DT_MACHINE_START(NSPIRE, "TI-NSPIRE")
 	.dt_compat	= nspire_dt_match,
 	.map_io		= nspire_map_io,
-	.init_time	= nspire_init_time,
 	.init_machine	= nspire_init,
 	.restart	= nspire_restart,
 MACHINE_END
-- 
1.7.10.4

