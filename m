Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758501Ab3G0DFN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 23:05:13 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:62027 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993Ab3G0DFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 23:05:08 -0400
From: Hanjun Guo <hanjun.guo@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Chris Metcalf <cmetcalf@tilera.com>
Cc: patches@linaro.org, linaro-kernel@lists.linaro.org,
        Mike Travis <travis@sgi.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linaro-acpi@lists.linaro.org, Al Stone <al.stone@linaro.org>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Naresh Bhat <naresh.bhat@linaro.org>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>,
        Hanjun Guo <hanjun.guo@linaro.org>
Subject: [PATCH 2/3] x86 / cpu topology: remove the stale macro arch_provides_topology_pointers
Date: Sat, 27 Jul 2013 11:00:50 +0800
Message-Id: <1374894051-31634-2-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374894051-31634-1-git-send-email-hanjun.guo@linaro.org>
References: <1374894051-31634-1-git-send-email-hanjun.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Macro arch_provides_topology_pointers is pointless now, remove it.

Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 arch/x86/include/asm/topology.h |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index 095b215..d35f24e 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -124,9 +124,6 @@ extern const struct cpumask *cpu_coregroup_mask(int cpu);
 #define topology_core_id(cpu)			(cpu_data(cpu).cpu_core_id)
 #define topology_core_cpumask(cpu)		(per_cpu(cpu_core_map, cpu))
 #define topology_thread_cpumask(cpu)		(per_cpu(cpu_sibling_map, cpu))
-
-/* indicates that pointers to the topology cpumask_t maps are valid */
-#define arch_provides_topology_pointers		yes
 #endif
 
 static inline void arch_fix_phys_package_id(int num, u32 slot)
-- 
1.7.9.5

