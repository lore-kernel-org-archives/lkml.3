Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab3KGJFL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 04:05:11 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:19346 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752384Ab3KGJFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 04:05:08 -0500
From: Jisheng Zhang <jszhang@marvell.com>
To: <andrew@lunn.ch>, <jason@lakedaemon.net>,
        <gregory.clement@free-electrons.com>,
        <sebastian.hesselbarth@gmail.com>, <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Jisheng Zhang <jszhang@marvell.com>
Subject: [PATCH] arm: mvebu: fix some sparse warnings
Date: Thu, 7 Nov 2013 17:02:38 +0800
Message-ID: <1383814958-5272-1-git-send-email-jszhang@marvell.com>
X-Mailer: git-send-email 1.8.4.2
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-11-07_03:2013-11-06,2013-11-07,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1311070014
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes conflicting types for 'set_cpu_coherent' and fixes the
following sparse warnings.

arch/arm/mach-mvebu/system-controller.c:42:38:
warning: symbol 'armada_370_xp_system_controller' was not declared. Should it be static?
arch/arm/mach-mvebu/system-controller.c:49:38:
warning: symbol 'orion_system_controller' was not declared. Should it be static?
arch/arm/mach-mvebu/system-controller.c:67:6:
warning: symbol 'mvebu_restart' was not declared. Should it be static?
arch/arm/mach-mvebu/coherency.c:31:15:
warning: symbol 'coherency_phys_base' was not declared. Should it be static?
arch/arm/mach-mvebu/coherency.c:48:5:
warning: symbol 'set_cpu_coherent' was not declared. Should it be static?
arch/arm/mach-mvebu/coherency.c:123:12:
warning: symbol 'coherency_init' was not declared. Should it be static?
arch/arm/mach-mvebu/pmsu.c:38:5: warning:
symbol 'armada_xp_boot_cpu' was not declared. Should it be static?
arch/arm/mach-mvebu/pmsu.c:61:12: warning:
symbol 'armada_370_xp_pmsu_init' was not declared. Should it be static?
arch/arm/mach-mvebu/platsmp.c:49:13: warning:
symbol 'set_secondary_cpus_clock' was not declared. Should it be static?
arch/arm/mach-mvebu/platsmp.c:97:13: warning:
symbol 'armada_xp_smp_prepare_cpus' was not declared. Should it be static?
arch/arm/mach-mvebu/hotplug.c:24:12: warning:
symbol 'armada_xp_cpu_die' was not declared. Should it be static?

Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
---
 arch/arm/mach-mvebu/coherency.c         | 1 +
 arch/arm/mach-mvebu/coherency.h         | 4 +++-
 arch/arm/mach-mvebu/common.h            | 1 -
 arch/arm/mach-mvebu/hotplug.c           | 1 +
 arch/arm/mach-mvebu/platsmp.c           | 4 ++--
 arch/arm/mach-mvebu/pmsu.c              | 3 ++-
 arch/arm/mach-mvebu/system-controller.c | 5 +++--
 7 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-mvebu/coherency.c b/arch/arm/mach-mvebu/coherency.c
index 58adf2f..4e9d581 100644
--- a/arch/arm/mach-mvebu/coherency.c
+++ b/arch/arm/mach-mvebu/coherency.c
@@ -27,6 +27,7 @@
 #include <asm/smp_plat.h>
 #include <asm/cacheflush.h>
 #include "armada-370-xp.h"
+#include "coherency.h"
 
 unsigned long coherency_phys_base;
 static void __iomem *coherency_base;
diff --git a/arch/arm/mach-mvebu/coherency.h b/arch/arm/mach-mvebu/coherency.h
index df33ad8..760226c 100644
--- a/arch/arm/mach-mvebu/coherency.h
+++ b/arch/arm/mach-mvebu/coherency.h
@@ -14,7 +14,9 @@
 #ifndef __MACH_370_XP_COHERENCY_H
 #define __MACH_370_XP_COHERENCY_H
 
-int set_cpu_coherent(int cpu_id, int smp_group_id);
+extern unsigned long coherency_phys_base;
+
+int set_cpu_coherent(unsigned int cpu_id, int smp_group_id);
 int coherency_init(void);
 
 #endif	/* __MACH_370_XP_COHERENCY_H */
diff --git a/arch/arm/mach-mvebu/common.h b/arch/arm/mach-mvebu/common.h
index e366010..0e6016f 100644
--- a/arch/arm/mach-mvebu/common.h
+++ b/arch/arm/mach-mvebu/common.h
@@ -26,7 +26,6 @@ void armada_370_xp_handle_irq(struct pt_regs *regs);
 
 void armada_xp_cpu_die(unsigned int cpu);
 int armada_370_xp_coherency_init(void);
-int armada_370_xp_pmsu_init(void);
 void armada_xp_secondary_startup(void);
 extern struct smp_operations armada_xp_smp_ops;
 #endif
diff --git a/arch/arm/mach-mvebu/hotplug.c b/arch/arm/mach-mvebu/hotplug.c
index b228b6a..d95e910 100644
--- a/arch/arm/mach-mvebu/hotplug.c
+++ b/arch/arm/mach-mvebu/hotplug.c
@@ -15,6 +15,7 @@
 #include <linux/errno.h>
 #include <linux/smp.h>
 #include <asm/proc-fns.h>
+#include "common.h"
 
 /*
  * platform-specific code to shutdown a CPU
diff --git a/arch/arm/mach-mvebu/platsmp.c b/arch/arm/mach-mvebu/platsmp.c
index ff69c2d..a6da03f 100644
--- a/arch/arm/mach-mvebu/platsmp.c
+++ b/arch/arm/mach-mvebu/platsmp.c
@@ -46,7 +46,7 @@ static struct clk *__init get_cpu_clk(int cpu)
 	return cpu_clk;
 }
 
-void __init set_secondary_cpus_clock(void)
+static void __init set_secondary_cpus_clock(void)
 {
 	int thiscpu, cpu;
 	unsigned long rate;
@@ -94,7 +94,7 @@ static void __init armada_xp_smp_init_cpus(void)
 	set_smp_cross_call(armada_mpic_send_doorbell);
 }
 
-void __init armada_xp_smp_prepare_cpus(unsigned int max_cpus)
+static void __init armada_xp_smp_prepare_cpus(unsigned int max_cpus)
 {
 	struct device_node *node;
 	struct resource res;
diff --git a/arch/arm/mach-mvebu/pmsu.c b/arch/arm/mach-mvebu/pmsu.c
index 27fc4f0..d71ef53 100644
--- a/arch/arm/mach-mvebu/pmsu.c
+++ b/arch/arm/mach-mvebu/pmsu.c
@@ -22,6 +22,7 @@
 #include <linux/io.h>
 #include <linux/smp.h>
 #include <asm/smp_plat.h>
+#include "pmsu.h"
 
 static void __iomem *pmsu_mp_base;
 static void __iomem *pmsu_reset_base;
@@ -58,7 +59,7 @@ int armada_xp_boot_cpu(unsigned int cpu_id, void *boot_addr)
 }
 #endif
 
-int __init armada_370_xp_pmsu_init(void)
+static int __init armada_370_xp_pmsu_init(void)
 {
 	struct device_node *np;
 
diff --git a/arch/arm/mach-mvebu/system-controller.c b/arch/arm/mach-mvebu/system-controller.c
index 5175083c..a7fb89a 100644
--- a/arch/arm/mach-mvebu/system-controller.c
+++ b/arch/arm/mach-mvebu/system-controller.c
@@ -27,6 +27,7 @@
 #include <linux/of_address.h>
 #include <linux/io.h>
 #include <linux/reboot.h>
+#include "common.h"
 
 static void __iomem *system_controller_base;
 
@@ -39,14 +40,14 @@ struct mvebu_system_controller {
 };
 static struct mvebu_system_controller *mvebu_sc;
 
-const struct mvebu_system_controller armada_370_xp_system_controller = {
+static const struct mvebu_system_controller armada_370_xp_system_controller = {
 	.rstoutn_mask_offset = 0x60,
 	.system_soft_reset_offset = 0x64,
 	.rstoutn_mask_reset_out_en = 0x1,
 	.system_soft_reset = 0x1,
 };
 
-const struct mvebu_system_controller orion_system_controller = {
+static const struct mvebu_system_controller orion_system_controller = {
 	.rstoutn_mask_offset = 0x108,
 	.system_soft_reset_offset = 0x10c,
 	.rstoutn_mask_reset_out_en = 0x4,
-- 
1.8.4.2

