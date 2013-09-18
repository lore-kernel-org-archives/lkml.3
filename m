Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492Ab3IRRyk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 13:54:40 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:48702 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233Ab3IRRyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 13:54:17 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Barry Song <baohua.song@csr.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 19/26] ARM: prima2: remove custom .init_time hook
Date: Wed, 18 Sep 2013 19:53:52 +0200
Message-Id: <1379526839-14798-20-git-send-email-sebastian.hesselbarth@gmail.com>
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
Cc: Barry Song <baohua.song@csr.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/mach-prima2/common.c |   11 -----------
 1 file changed, 11 deletions(-)

diff --git a/arch/arm/mach-prima2/common.c b/arch/arm/mach-prima2/common.c
index 9b7663d..d49aff7 100644
--- a/arch/arm/mach-prima2/common.c
+++ b/arch/arm/mach-prima2/common.c
@@ -6,8 +6,6 @@
  * Licensed under GPLv2 or later.
  */
 
-#include <linux/clk-provider.h>
-#include <linux/clocksource.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <asm/sizes.h>
@@ -22,12 +20,6 @@ void __init sirfsoc_init_late(void)
 	sirfsoc_pm_init();
 }
 
-static __init void sirfsoc_init_time(void)
-{
-	of_clk_init(NULL);
-	clocksource_of_init();
-}
-
 static __init void sirfsoc_map_io(void)
 {
 	sirfsoc_map_lluart();
@@ -43,7 +35,6 @@ static const char *atlas6_dt_match[] __initdata = {
 DT_MACHINE_START(ATLAS6_DT, "Generic ATLAS6 (Flattened Device Tree)")
 	/* Maintainer: Barry Song <baohua.song@csr.com> */
 	.map_io         = sirfsoc_map_io,
-	.init_time	= sirfsoc_init_time,
 	.init_late	= sirfsoc_init_late,
 	.dt_compat      = atlas6_dt_match,
 	.restart	= sirfsoc_restart,
@@ -59,7 +50,6 @@ static const char *prima2_dt_match[] __initdata = {
 DT_MACHINE_START(PRIMA2_DT, "Generic PRIMA2 (Flattened Device Tree)")
 	/* Maintainer: Barry Song <baohua.song@csr.com> */
 	.map_io         = sirfsoc_map_io,
-	.init_time	= sirfsoc_init_time,
 	.dma_zone_size	= SZ_256M,
 	.init_late	= sirfsoc_init_late,
 	.dt_compat      = prima2_dt_match,
@@ -77,7 +67,6 @@ DT_MACHINE_START(MARCO_DT, "Generic MARCO (Flattened Device Tree)")
 	/* Maintainer: Barry Song <baohua.song@csr.com> */
 	.smp            = smp_ops(sirfsoc_smp_ops),
 	.map_io         = sirfsoc_map_io,
-	.init_time	= sirfsoc_init_time,
 	.init_late	= sirfsoc_init_late,
 	.dt_compat      = marco_dt_match,
 	.restart	= sirfsoc_restart,
-- 
1.7.10.4

