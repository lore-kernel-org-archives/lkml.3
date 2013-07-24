Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751677Ab3GXDxK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 23:53:10 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:49391 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415Ab3GXDxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 23:53:08 -0400
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Magnus Damm <magnus.damm@gmail.com>, horms@verge.net.au,
        g.liakhovetski@gmx.de, linux-sh@vger.kernel.org
Date: Wed, 24 Jul 2013 12:53:15 +0900
Message-Id: <20130724035315.30631.28824.sendpatchset@w520>
Subject: [PATCH] ARM: shmobile: r8a73a4: Remove ->init_machine() special case
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

No need to special case r8a73a4 ->init_machine(),
so get rid of undesired cpufreq platform device
from the generic long term r8a73a4 DT support code.

For short term support on APE6EVM the DT reference
implementation already adds a "cpufreq-cpu0" platform
device so that can be used for development.

Regarding more long term cpufreq support, perhaps
it makes sense to adjust the cpufreq driver to check
for DT information directly instead of using a
platform device for software configuration and DT
for hardware parameters.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 arch/arm/mach-shmobile/setup-r8a73a4.c |    6 ------
 1 file changed, 6 deletions(-)

--- 0001/arch/arm/mach-shmobile/setup-r8a73a4.c
+++ work/arch/arm/mach-shmobile/setup-r8a73a4.c	2013-07-23 16:22:29.000000000 +0900
@@ -215,11 +215,6 @@ void __init r8a73a4_init_delay(void)
 }
 
 #ifdef CONFIG_USE_OF
-void __init r8a73a4_add_standard_devices_dt(void)
-{
-	platform_device_register_simple("cpufreq-cpu0", -1, NULL, 0);
-	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
-}
 
 static const char *r8a73a4_boards_compat_dt[] __initdata = {
 	"renesas,r8a73a4",
@@ -228,7 +223,6 @@ static const char *r8a73a4_boards_compat
 
 DT_MACHINE_START(R8A73A4_DT, "Generic R8A73A4 (Flattened Device Tree)")
 	.init_early	= r8a73a4_init_delay,
-	.init_machine	= r8a73a4_add_standard_devices_dt,
 	.init_time	= shmobile_timer_init,
 	.dt_compat	= r8a73a4_boards_compat_dt,
 MACHINE_END
