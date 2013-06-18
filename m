Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932595Ab3FRL7r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 07:59:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56093 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755156Ab3FRLok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 07:44:40 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@linaro.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 45/93] ARM: 7742/1: topology: export cpu_topology
Date: Tue, 18 Jun 2013 12:42:53 +0100
Message-Id: <1371555821-12820-46-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
References: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit 92bdd3f5eba299b33c2f4407977d6fa2e2a6a0da upstream.

The cpu_topology symbol is required by any driver using the topology
interfaces, which leads to a couple of build errors:

ERROR: "cpu_topology" [drivers/net/ethernet/sfc/sfc.ko] undefined!
ERROR: "cpu_topology" [drivers/cpufreq/arm_big_little.ko] undefined!
ERROR: "cpu_topology" [drivers/block/mtip32xx/mtip32xx.ko] undefined!

The obvious solution is to export this symbol.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Will Deacon <will.deacon@arm.com>
Cc: Nicolas Pitre <nico@linaro.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
[ luis: backport to 3.5: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/kernel/topology.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
index 8200dea..140c817 100644
--- a/arch/arm/kernel/topology.c
+++ b/arch/arm/kernel/topology.c
@@ -13,6 +13,7 @@
 
 #include <linux/cpu.h>
 #include <linux/cpumask.h>
+#include <linux/export.h>
 #include <linux/init.h>
 #include <linux/percpu.h>
 #include <linux/node.h>
@@ -42,6 +43,7 @@
 #define MPIDR_LEVEL2_SHIFT 16
 
 struct cputopo_arm cpu_topology[NR_CPUS];
+EXPORT_SYMBOL_GPL(cpu_topology);
 
 const struct cpumask *cpu_coregroup_mask(int cpu)
 {
-- 
1.8.1.2

