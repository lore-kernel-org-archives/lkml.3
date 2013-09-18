Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab3IRRye (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 13:54:34 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63706 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193Ab3IRRyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 13:54:16 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 25/26] ARM: vexpress: remove custom .init_time hook
Date: Wed, 18 Sep 2013 19:53:58 +0200
Message-Id: <1379526839-14798-26-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1379526839-14798-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1379526839-14798-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With arch/arm calling of_clk_init(NULL) from time_init(), we can now
remove custom .init_time hooks. The call to versatile_sched_clock_init
is moved to .init_early instead, were it is also for non-DT boards.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Tested-by: Jon Medhurst (Tixy) <tixy@linaro.org>
---
Cc: Olof Johansson <olof@lixom.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Jon Medhurst (Tixy) <tixy@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/mach-vexpress/v2m.c |   14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/arch/arm/mach-vexpress/v2m.c b/arch/arm/mach-vexpress/v2m.c
index 95a469e..4f8b8cb 100644
--- a/arch/arm/mach-vexpress/v2m.c
+++ b/arch/arm/mach-vexpress/v2m.c
@@ -1,12 +1,10 @@
 /*
  * Versatile Express V2M Motherboard Support
  */
-#include <linux/clocksource.h>
 #include <linux/device.h>
 #include <linux/amba/bus.h>
 #include <linux/amba/mmci.h>
 #include <linux/io.h>
-#include <linux/clocksource.h>
 #include <linux/smp.h>
 #include <linux/init.h>
 #include <linux/of_address.h>
@@ -22,7 +20,6 @@
 #include <linux/regulator/fixed.h>
 #include <linux/regulator/machine.h>
 #include <linux/vexpress.h>
-#include <linux/clk-provider.h>
 #include <linux/clkdev.h>
 
 #include <asm/mach-types.h>
@@ -422,16 +419,8 @@ void __init v2m_dt_init_early(void)
 			pr_warning("vexpress: DT HBI (%x) is not matching "
 					"hardware (%x)!\n", dt_hbi, hbi);
 	}
-}
-
-static void __init v2m_dt_timer_init(void)
-{
-	of_clk_init(NULL);
 
-	clocksource_of_init();
-
-	versatile_sched_clock_init(vexpress_get_24mhz_clock_base(),
-				24000000);
+	versatile_sched_clock_init(vexpress_get_24mhz_clock_base(), 24000000);
 }
 
 static const struct of_device_id v2m_dt_bus_match[] __initconst = {
@@ -458,6 +447,5 @@ DT_MACHINE_START(VEXPRESS_DT, "ARM-Versatile Express")
 	.smp_init	= smp_init_ops(vexpress_smp_init_ops),
 	.map_io		= v2m_dt_map_io,
 	.init_early	= v2m_dt_init_early,
-	.init_time	= v2m_dt_timer_init,
 	.init_machine	= v2m_dt_init,
 MACHINE_END
-- 
1.7.10.4

