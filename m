Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980Ab3AVFwm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 00:52:42 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19712 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631Ab3AVFwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 00:52:40 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 21 Jan 2013 21:52:15 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <arnd@arndb.de>, <olof@lixom.net>, <santosh.shilimkar@ti.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>, Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: [v3 1/2] ARM: Add API to detect SCU base address from CP15
Date: Tue, 22 Jan 2013 07:52:01 +0200
Message-ID: <1358833924-24535-1-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add API to detect SCU base address from CP15.

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
Update: Use Russell's suggestion,
http://lists.infradead.org/pipermail/linux-arm-kernel/2013-January/143321.html
---
 arch/arm/include/asm/smp_scu.h |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/arm/include/asm/smp_scu.h b/arch/arm/include/asm/smp_scu.h
index 4eb6d00..006f026 100644
--- a/arch/arm/include/asm/smp_scu.h
+++ b/arch/arm/include/asm/smp_scu.h
@@ -6,6 +6,23 @@
 #define SCU_PM_POWEROFF	3
 
 #ifndef __ASSEMBLER__
+
+#include <asm/cputype.h>
+
+static inline bool scu_a9_has_base(void)
+{
+	return read_cpuid_part_number() == ARM_CPU_PART_CORTEX_A9;
+}
+
+static inline unsigned long scu_a9_get_base(void)
+{
+	unsigned long pa;
+
+	asm("mrc p15, 4, %0, c15, c0, 0" : "=r" (pa));
+
+	return pa;
+}
+
 unsigned int scu_get_core_count(void __iomem *);
 void scu_enable(void __iomem *);
 int scu_power_mode(void __iomem *, unsigned int);
-- 
1.7.9.5

