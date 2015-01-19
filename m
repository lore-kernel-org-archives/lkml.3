Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129AbbASQxI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 11:53:08 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:58041 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbbASQxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 11:53:05 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: arnd@arndb.de, olof@lixom.net, linux@arm.linux.org.uk
Cc: thomas.petazzoni@free-electrons.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] ARM: Marvell: Remove init cpus function
Date: Mon, 19 Jan 2015 17:52:59 +0100
Message-Id: <1421686381-12397-1-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the next patches, the init cpus function will be changed to be factored
out.

The function 'armada_xp_smp_init_cpus' does nothing more than a sanity check
after the DT has been parsed. Even if this code is valid, it does not give a
real benefit as the DT should be correctly filled.

Remove this callback.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 arch/arm/mach-mvebu/platsmp.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/arch/arm/mach-mvebu/platsmp.c b/arch/arm/mach-mvebu/platsmp.c
index 58cc8c1..3e93422 100644
--- a/arch/arm/mach-mvebu/platsmp.c
+++ b/arch/arm/mach-mvebu/platsmp.c
@@ -30,8 +30,6 @@
 #include "pmsu.h"
 #include "coherency.h"
 
-#define ARMADA_XP_MAX_CPUS 4
-
 #define AXP_BOOTROM_BASE 0xfff00000
 #define AXP_BOOTROM_SIZE 0x100000
 
@@ -114,14 +112,6 @@ static void armada_xp_secondary_init(unsigned int cpu)
 	mvebu_v7_pmsu_idle_exit();
 }
 
-static void __init armada_xp_smp_init_cpus(void)
-{
-	unsigned int ncores = num_possible_cpus();
-
-	if (ncores == 0 || ncores > ARMADA_XP_MAX_CPUS)
-		panic("Invalid number of CPUs in DT\n");
-}
-
 static void __init armada_xp_smp_prepare_cpus(unsigned int max_cpus)
 {
 	struct device_node *node;
@@ -171,7 +161,6 @@ static int armada_xp_cpu_kill(unsigned int cpu)
 #endif
 
 struct smp_operations armada_xp_smp_ops __initdata = {
-	.smp_init_cpus		= armada_xp_smp_init_cpus,
 	.smp_prepare_cpus	= armada_xp_smp_prepare_cpus,
 	.smp_boot_secondary	= armada_xp_boot_secondary,
 	.smp_secondary_init     = armada_xp_secondary_init,
-- 
1.9.1

