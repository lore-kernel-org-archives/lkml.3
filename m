Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042AbaHIRyT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 13:54:19 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:49047 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbaHIRyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 13:54:18 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>, Huacai Chen <chenhc@lemote.com>,
        Andreas Herrmann <andreas.herrmann@caviumnetworks.com>
Subject: [PATCH] mips: Fix nlm_xlp_defconfig build error
Date: Sat,  9 Aug 2014 10:54:03 -0700
Message-Id: <1407606843-12984-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The nlm_xlp_defconfig build fails with

./arch/mips/include/asm/mach-netlogic/topology.h:15:0:
			error: "topology_core_id" redefined [-Werror]
In file included from include/linux/smp.h:59:0,
	[ ...]
                 from arch/mips/mm/dma-default.c:12:
./arch/mips/include/asm/smp.h:41:0:
			note: this is the location of the previous definition

and similar errors.

This is caused by commit bda4584cd943d7 ("MIPS: Support CPU topology files
in sysfs") which adds the defines to arch/mips/include/asm/smp.h.

Remove the defines from arch/mips/include/asm/mach-netlogic/topology.h
as no longer necessary.

Cc: Huacai Chen <chenhc@lemote.com>
Cc: Andreas Herrmann <andreas.herrmann@caviumnetworks.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 arch/mips/include/asm/mach-netlogic/topology.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/arch/mips/include/asm/mach-netlogic/topology.h b/arch/mips/include/asm/mach-netlogic/topology.h
index ceeb1f5..0eb43c8 100644
--- a/arch/mips/include/asm/mach-netlogic/topology.h
+++ b/arch/mips/include/asm/mach-netlogic/topology.h
@@ -10,13 +10,6 @@
 
 #include <asm/mach-netlogic/multi-node.h>
 
-#ifdef CONFIG_SMP
-#define topology_physical_package_id(cpu)	cpu_to_node(cpu)
-#define topology_core_id(cpu)	(cpu_logical_map(cpu) / NLM_THREADS_PER_CORE)
-#define topology_thread_cpumask(cpu)		(&cpu_sibling_map[cpu])
-#define topology_core_cpumask(cpu)	cpumask_of_node(cpu_to_node(cpu))
-#endif
-
 #include <asm-generic/topology.h>
 
 #endif /* _ASM_MACH_NETLOGIC_TOPOLOGY_H */
-- 
1.9.1

