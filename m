Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757100Ab3FKUOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:14:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41940 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756677Ab3FKUD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:03:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>,
        Nicolas Pitre <nico@linaro.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 39/79] ARM: 7742/1: topology: export cpu_topology
Date: Tue, 11 Jun 2013 13:03:05 -0700
Message-Id: <20130611195321.058507214@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130611195312.352656079@linuxfoundation.org>
References: <20130611195312.352656079@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/kernel/topology.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm/kernel/topology.c
+++ b/arch/arm/kernel/topology.c
@@ -13,6 +13,7 @@
 
 #include <linux/cpu.h>
 #include <linux/cpumask.h>
+#include <linux/export.h>
 #include <linux/init.h>
 #include <linux/percpu.h>
 #include <linux/node.h>
@@ -200,6 +201,7 @@ static inline void update_cpu_power(unsi
  * cpu topology table
  */
 struct cputopo_arm cpu_topology[NR_CPUS];
+EXPORT_SYMBOL_GPL(cpu_topology);
 
 const struct cpumask *cpu_coregroup_mask(int cpu)
 {


