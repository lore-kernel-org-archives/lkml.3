Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965155Ab3GCTFs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:05:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20027 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965019Ab3GCTAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 15:00:30 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=tiUWh7hqIgMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=xTY4OawwTogA:10 a=7CQSdrXTAAAA:8 a=VwQbUJbxAAAA:8 a=KKAkSRfTAAAA:8 a=drOt6m5kAAAA:8 a=fBeKd2HRWbP4T1pgm1MA:9 a=JTMqrY5UvyEA:10 a=ESTKKtUg-DoA:10 a=WwgC8nHKvroA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184059.678186652@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:40:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>,
        Nicolas Pitre <nico@linaro.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [088/141] ARM: 7742/1: topology: export cpu_topology
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0088-ARM-7742-1-topology-export-cpu_topology.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 92bdd3f5eba299b33c2f4407977d6fa2e2a6a0da ]

The cpu_topology symbol is required by any driver using the topology
interfaces, which leads to a couple of build errors:

ERROR: "cpu_topology" [drivers/net/ethernet/sfc/sfc.ko] undefined!
ERROR: "cpu_topology" [drivers/cpufreq/arm_big_little.ko] undefined!
ERROR: "cpu_topology" [drivers/block/mtip32xx/mtip32xx.ko] undefined!

The obvious solution is to export this symbol.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Will Deacon <will.deacon@arm.com>
Cc: stable@vger.kernel.org
Cc: Nicolas Pitre <nico@linaro.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/arm/kernel/topology.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
index 26c12c6..2d064f9 100644
--- a/arch/arm/kernel/topology.c
+++ b/arch/arm/kernel/topology.c
@@ -13,6 +13,7 @@
 
 #include <linux/cpu.h>
 #include <linux/cpumask.h>
+#include <linux/export.h>
 #include <linux/init.h>
 #include <linux/percpu.h>
 #include <linux/node.h>
@@ -225,6 +226,7 @@ static inline void update_cpu_power(unsigned int cpuid, unsigned int mpidr) {}
  * cpu topology table
  */
 struct cputopo_arm cpu_topology[NR_CPUS];
+EXPORT_SYMBOL_GPL(cpu_topology);
 
 const struct cpumask *cpu_coregroup_mask(int cpu)
 {
-- 
1.7.10.4


