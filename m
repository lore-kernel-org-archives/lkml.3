Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220AbaC1VM5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 17:12:57 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:34195 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122AbaC1VMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 17:12:48 -0400
From: Alex Elder <elder@linaro.org>
To: linux@arm.linux.org.uk, linus.walleij@linaro.org, viresh.linux@gmail.com,
        shiraz.hashim@gmail.com, catalin.marinas@arm.com
Cc: spear-devel@list.st.com, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 4/7] ARM: vexpress: use central SMP spin-table routines
Date: Fri, 28 Mar 2014 16:12:57 -0500
Message-Id: <1396041180-29897-5-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1396041180-29897-1-git-send-email-elder@linaro.org>
References: <1396041180-29897-1-git-send-email-elder@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the second patch involved replacing the use of smp
operations defined under arch/arm/mach-versatile.  Both realview and
vexpress use the same smp_boot_secondary and smp_secondary_init
functions, and those are equivalent to the common ones now available
in arch/arm/kernel/smp.c.

This converts mach-vexpress to use the common routines.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 arch/arm/mach-vexpress/platsmp.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-vexpress/platsmp.c b/arch/arm/mach-vexpress/platsmp.c
index 993c9ae..1ed4078 100644
--- a/arch/arm/mach-vexpress/platsmp.c
+++ b/arch/arm/mach-vexpress/platsmp.c
@@ -22,8 +22,6 @@
 
 #include <mach/motherboard.h>
 
-#include <plat/platsmp.h>
-
 #include "core.h"
 
 #if defined(CONFIG_OF)
@@ -193,14 +191,14 @@ static void __init vexpress_smp_prepare_cpus(unsigned int max_cpus)
 	 * until it receives a soft interrupt, and then the
 	 * secondary CPU branches to this address.
 	 */
-	vexpress_flags_set(virt_to_phys(versatile_secondary_startup));
+	vexpress_flags_set(virt_to_phys(secondary_holding_pen));
 }
 
 struct smp_operations __initdata vexpress_smp_ops = {
 	.smp_init_cpus		= vexpress_smp_init_cpus,
 	.smp_prepare_cpus	= vexpress_smp_prepare_cpus,
-	.smp_secondary_init	= versatile_secondary_init,
-	.smp_boot_secondary	= versatile_boot_secondary,
+	.smp_secondary_init	= smp_secondary_init,
+	.smp_boot_secondary	= smp_boot_secondary,
 #ifdef CONFIG_HOTPLUG_CPU
 	.cpu_die		= vexpress_cpu_die,
 #endif
-- 
1.7.9.5

