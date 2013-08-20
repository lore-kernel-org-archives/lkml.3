Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897Ab3HTCEp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 22:04:45 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:60273 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870Ab3HTCEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 22:04:42 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [RFC 15/17] ARM: vexpress: remove custom .init_time hook
Date: Tue, 20 Aug 2013 04:04:29 +0200
Message-Id: <1376964271-22715-16-git-send-email-sebastian.hesselbarth@gmail.com>
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
Notes:
- call to versatile_sched_clock_init is moved to .init_early. It is
  there for non-DT and existing DT init_early takes care of mapping
  its registers.

Cc: Russell King <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
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

