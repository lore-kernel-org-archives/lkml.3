Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450Ab3IRRyh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 13:54:37 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:38312 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226Ab3IRRyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 13:54:16 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Alessandro Rubini <rubini@unipv.it>,
        Linus Walleij <linus.walleij@linaro.org>,
        STEricsson <STEricsson_nomadik_linux@list.st.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 17/26] ARM: nomadik: remove custom .init_time hook
Date: Wed, 18 Sep 2013 19:53:50 +0200
Message-Id: <1379526839-14798-18-git-send-email-sebastian.hesselbarth@gmail.com>
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
Cc: Alessandro Rubini <rubini@unipv.it>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: STEricsson <STEricsson_nomadik_linux@list.st.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/mach-nomadik/cpu-8815.c |    9 ---------
 1 file changed, 9 deletions(-)

diff --git a/arch/arm/mach-nomadik/cpu-8815.c b/arch/arm/mach-nomadik/cpu-8815.c
index 2be38a0..53fbf63 100644
--- a/arch/arm/mach-nomadik/cpu-8815.c
+++ b/arch/arm/mach-nomadik/cpu-8815.c
@@ -25,8 +25,6 @@
 #include <linux/slab.h>
 #include <linux/irq.h>
 #include <linux/dma-mapping.h>
-#include <linux/clk-provider.h>
-#include <linux/clocksource.h>
 #include <linux/of_irq.h>
 #include <linux/of_gpio.h>
 #include <linux/of_address.h>
@@ -113,12 +111,6 @@ static void cpu8815_restart(enum reboot_mode mode, const char *cmd)
 	writel(1, srcbase + 0x18);
 }
 
-static void __init cpu8815_timer_init_of(void)
-{
-	of_clk_init(NULL);
-	clocksource_of_init();
-}
-
 static struct fsmc_nand_timings cpu8815_nand_timings = {
 	.thiz	= 0,
 	.thold	= 0x10,
@@ -232,7 +224,6 @@ static const char * cpu8815_board_compat[] = {
 
 DT_MACHINE_START(NOMADIK_DT, "Nomadik STn8815")
 	.map_io		= cpu8815_map_io,
-	.init_time	= cpu8815_timer_init_of,
 	.init_machine	= cpu8815_init_of,
 	.restart	= cpu8815_restart,
 	.dt_compat      = cpu8815_board_compat,
-- 
1.7.10.4

