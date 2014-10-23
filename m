Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932333AbaJWSPK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 14:15:10 -0400
Received: from down.free-electrons.com ([37.187.137.238]:34359 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752865AbaJWSO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 14:14:58 -0400
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] ARM: mvebu: Clean-up the Armada XP support
Date: Thu, 23 Oct 2014 20:14:27 +0200
Message-Id: <1414088070-12510-2-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414088070-12510-1-git-send-email-gregory.clement@free-electrons.com>
References: <1414088070-12510-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the unneeded include of the armada-370-xp.h header.

It also moves some declarations from this file into more accurate
places.

Finally, it also adds a comment explaining that we can't remove yet the
smp field in the dt machine struct due to backward compatibly of the
device tree.

In a few releases, when the old device tree will be obsolete, we will be
able to remove the smp field and then the armada-370-xp.h header.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 arch/arm/mach-mvebu/armada-370-xp.h | 6 ------
 arch/arm/mach-mvebu/board-v7.c      | 4 ++++
 arch/arm/mach-mvebu/coherency.c     | 1 -
 arch/arm/mach-mvebu/cpu-reset.c     | 1 -
 arch/arm/mach-mvebu/platsmp.c       | 2 ++
 arch/arm/mach-mvebu/pmsu.c          | 1 -
 arch/arm/mach-mvebu/pmsu.h          | 1 +
 7 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mach-mvebu/armada-370-xp.h b/arch/arm/mach-mvebu/armada-370-xp.h
index 84cd90d9b860..c55bbf81de0e 100644
--- a/arch/arm/mach-mvebu/armada-370-xp.h
+++ b/arch/arm/mach-mvebu/armada-370-xp.h
@@ -16,14 +16,8 @@
 #define __MACH_ARMADA_370_XP_H
 
 #ifdef CONFIG_SMP
-#include <linux/cpumask.h>
-
-#define ARMADA_XP_MAX_CPUS 4
-
 void armada_xp_secondary_startup(void);
 extern struct smp_operations armada_xp_smp_ops;
 #endif
 
-int armada_370_xp_pmsu_idle_enter(unsigned long deepidle);
-
 #endif /* __MACH_ARMADA_370_XP_H */
diff --git a/arch/arm/mach-mvebu/board-v7.c b/arch/arm/mach-mvebu/board-v7.c
index 6478626e3ff6..e51bb1ddffbf 100644
--- a/arch/arm/mach-mvebu/board-v7.c
+++ b/arch/arm/mach-mvebu/board-v7.c
@@ -206,6 +206,10 @@ static const char * const armada_370_xp_dt_compat[] = {
 DT_MACHINE_START(ARMADA_370_XP_DT, "Marvell Armada 370/XP (Device Tree)")
 	.l2c_aux_val	= 0,
 	.l2c_aux_mask	= ~0,
+/*
+ * The following field (.smp) is stil needed to ensure backward
+ * compatibility with the old device trees
+ */
 	.smp		= smp_ops(armada_xp_smp_ops),
 	.init_machine	= mvebu_dt_init,
 	.init_irq       = mvebu_init_irq,
diff --git a/arch/arm/mach-mvebu/coherency.c b/arch/arm/mach-mvebu/coherency.c
index 2bdc3233abe2..d1b0a173e4a6 100644
--- a/arch/arm/mach-mvebu/coherency.c
+++ b/arch/arm/mach-mvebu/coherency.c
@@ -33,7 +33,6 @@
 #include <asm/smp_plat.h>
 #include <asm/cacheflush.h>
 #include <asm/mach/map.h>
-#include "armada-370-xp.h"
 #include "coherency.h"
 #include "mvebu-soc-id.h"
 
diff --git a/arch/arm/mach-mvebu/cpu-reset.c b/arch/arm/mach-mvebu/cpu-reset.c
index 60fb53787004..4a2cadd6b48e 100644
--- a/arch/arm/mach-mvebu/cpu-reset.c
+++ b/arch/arm/mach-mvebu/cpu-reset.c
@@ -15,7 +15,6 @@
 #include <linux/of_address.h>
 #include <linux/io.h>
 #include <linux/resource.h>
-#include "armada-370-xp.h"
 
 static void __iomem *cpu_reset_base;
 static size_t cpu_reset_size;
diff --git a/arch/arm/mach-mvebu/platsmp.c b/arch/arm/mach-mvebu/platsmp.c
index 895dc373c8a1..622315c185b2 100644
--- a/arch/arm/mach-mvebu/platsmp.c
+++ b/arch/arm/mach-mvebu/platsmp.c
@@ -30,6 +30,8 @@
 #include "pmsu.h"
 #include "coherency.h"
 
+#define ARMADA_XP_MAX_CPUS 4
+
 #define AXP_BOOTROM_BASE 0xfff00000
 #define AXP_BOOTROM_SIZE 0x100000
 
diff --git a/arch/arm/mach-mvebu/pmsu.c b/arch/arm/mach-mvebu/pmsu.c
index bbd8664d1bac..5af58927a56d 100644
--- a/arch/arm/mach-mvebu/pmsu.c
+++ b/arch/arm/mach-mvebu/pmsu.c
@@ -39,7 +39,6 @@
 #include <asm/suspend.h>
 #include <asm/tlbflush.h>
 #include "common.h"
-#include "armada-370-xp.h"
 
 
 #define PMSU_BASE_OFFSET    0x100
diff --git a/arch/arm/mach-mvebu/pmsu.h b/arch/arm/mach-mvebu/pmsu.h
index 6b58c1fe2b0d..e1eb4959a2d4 100644
--- a/arch/arm/mach-mvebu/pmsu.h
+++ b/arch/arm/mach-mvebu/pmsu.h
@@ -18,4 +18,5 @@ int mvebu_setup_boot_addr_wa(unsigned int crypto_eng_target,
 
 void mvebu_v7_pmsu_idle_exit(void);
 
+int armada_370_xp_pmsu_idle_enter(unsigned long deepidle);
 #endif	/* __MACH_370_XP_PMSU_H */
-- 
1.9.1

