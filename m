Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932920Ab3DYRbr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 13:31:47 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:60706 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932752Ab3DYR3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 13:29:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>, Nicolas Pitre <nico@linaro.org>,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH 01/21] ARM: topology: export cpu_topology
Date: Thu, 25 Apr 2013 19:28:44 +0200
Message-Id: <1366910944-3033663-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366910944-3033663-1-git-send-email-arnd@arndb.de>
References: <1366910944-3033663-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:lZPl+ggQNxUEBOvhH2MvbI4nbDry/yu4AA7hgpHQME8
 0CmPpOlwEGtk8R3DeowCvfS0KLGvPwhDCqo3HcyO7ulU9m03Ug
 wR3xy0QMW0l8HMiedHv6WOqIlr2p+razw89FVBwvVYxMR5wd90
 hVjXYlnvJaFP9pGwY1x2Qxlx1GFgy6WjHOmQUFokaTpLsUzA+T
 PjUzaDKm7zP5OxjZisJl7bzLj820Vltz5xWnYlK2sZgDbbcFLB
 9yMqJ+GCTov6is2/09tuPT8Y2Du2xJB+OnvZF45wdRr0iuq6gr
 yVdw0rj2pqmMWF8l6I9MpSZG+PR+NoNJfBjUq/hqjxVRRvlFNv
 Zw8t9hj97uI/tX/ebZXao0YDZ7rNvJYDAF1cMlYj6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cpu_topology symbol is required by any driver using the topology
interfaces, which leads to a couple of build errors:

ERROR: "cpu_topology" [drivers/net/ethernet/sfc/sfc.ko] undefined!
ERROR: "cpu_topology" [drivers/cpufreq/arm_big_little.ko] undefined!
ERROR: "cpu_topology" [drivers/block/mtip32xx/mtip32xx.ko] undefined!

The obvious solution is to export this symbol.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Nicolas Pitre <nico@linaro.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
---
 arch/arm/kernel/topology.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
index f10316b..7ac5714 100644
--- a/arch/arm/kernel/topology.c
+++ b/arch/arm/kernel/topology.c
@@ -200,6 +200,7 @@ static inline void update_cpu_power(unsigned int cpuid, unsigned int mpidr) {}
  * cpu topology table
  */
 struct cputopo_arm cpu_topology[NR_CPUS];
+EXPORT_SYMBOL_GPL(cpu_topology);
 
 const struct cpumask *cpu_coregroup_mask(int cpu)
 {
-- 
1.8.1.2

