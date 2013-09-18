Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332Ab3IRRya (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 13:54:30 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:51384 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893Ab3IRRyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 13:54:14 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-rpi-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 10/26] ARM: bcm2835: remove custom .init_time hook
Date: Wed, 18 Sep 2013 19:53:43 +0200
Message-Id: <1379526839-14798-11-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1379526839-14798-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1379526839-14798-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With arch/arm calling of_clk_init(NULL) from time_init(), we can now
remove custom .init_time hooks. Also remove call to of_clk_init from
clk-bcm2835 with core fixed_clock match, as this has already been
registered now.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Olof Johansson <olof@lixom.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-rpi-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/mach-bcm2835/bcm2835.c |    2 --
 drivers/clk/clk-bcm2835.c       |    8 --------
 2 files changed, 10 deletions(-)

diff --git a/arch/arm/mach-bcm2835/bcm2835.c b/arch/arm/mach-bcm2835/bcm2835.c
index 40686d7..d50135b 100644
--- a/arch/arm/mach-bcm2835/bcm2835.c
+++ b/arch/arm/mach-bcm2835/bcm2835.c
@@ -18,7 +18,6 @@
 #include <linux/of_address.h>
 #include <linux/of_platform.h>
 #include <linux/clk/bcm2835.h>
-#include <linux/clocksource.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
@@ -134,7 +133,6 @@ DT_MACHINE_START(BCM2835, "BCM2835")
 	.init_irq = bcm2835_init_irq,
 	.handle_irq = bcm2835_handle_irq,
 	.init_machine = bcm2835_init,
-	.init_time = clocksource_of_init,
 	.restart = bcm2835_restart,
 	.dt_compat = bcm2835_compat
 MACHINE_END
diff --git a/drivers/clk/clk-bcm2835.c b/drivers/clk/clk-bcm2835.c
index 5fb4ff5..6b950ca 100644
--- a/drivers/clk/clk-bcm2835.c
+++ b/drivers/clk/clk-bcm2835.c
@@ -20,14 +20,8 @@
 #include <linux/clk-provider.h>
 #include <linux/clkdev.h>
 #include <linux/clk/bcm2835.h>
-#include <linux/clk-provider.h>
 #include <linux/of.h>
 
-static const struct of_device_id clk_match[] __initconst = {
-	{ .compatible = "fixed-clock", .data = of_fixed_clk_setup, },
-	{ }
-};
-
 /*
  * These are fixed clocks. They're probably not all root clocks and it may
  * be possible to turn them on and off but until this is mapped out better
@@ -63,6 +57,4 @@ void __init bcm2835_init_clocks(void)
 	ret = clk_register_clkdev(clk, NULL, "20215000.uart");
 	if (ret)
 		pr_err("uart1_pclk alias not registered\n");
-
-	of_clk_init(clk_match);
 }
-- 
1.7.10.4

