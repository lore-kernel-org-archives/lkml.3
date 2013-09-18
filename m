Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615Ab3IRRyr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 13:54:47 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:60004 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258Ab3IRRyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 13:54:18 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Tony Prisk <linux@prisktech.co.nz>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 26/26] ARM: vt8500: remove custom .init_time hook
Date: Wed, 18 Sep 2013 19:53:59 +0200
Message-Id: <1379526839-14798-27-git-send-email-sebastian.hesselbarth@gmail.com>
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
Cc: Tony Prisk <linux@prisktech.co.nz>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/mach-vt8500/vt8500.c |    9 ---------
 1 file changed, 9 deletions(-)

diff --git a/arch/arm/mach-vt8500/vt8500.c b/arch/arm/mach-vt8500/vt8500.c
index 5041563..4a73464 100644
--- a/arch/arm/mach-vt8500/vt8500.c
+++ b/arch/arm/mach-vt8500/vt8500.c
@@ -18,8 +18,6 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
-#include <linux/clk-provider.h>
-#include <linux/clocksource.h>
 #include <linux/io.h>
 #include <linux/pm.h>
 #include <linux/reboot.h>
@@ -74,12 +72,6 @@ static void vt8500_power_off(void)
 	asm("mcr%? p15, 0, %0, c7, c0, 4" : : "r" (0));
 }
 
-static void __init vt8500_init_time(void)
-{
-	of_clk_init(NULL);
-	clocksource_of_init();
-}
-
 void __init vt8500_init(void)
 {
 	struct device_node *np;
@@ -183,7 +175,6 @@ DT_MACHINE_START(WMT_DT, "VIA/Wondermedia SoC (Device Tree Support)")
 	.dt_compat	= vt8500_dt_compat,
 	.map_io		= vt8500_map_io,
 	.init_machine	= vt8500_init,
-	.init_time	= vt8500_init_time,
 	.restart	= vt8500_restart,
 MACHINE_END
 
-- 
1.7.10.4

