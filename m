Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521AbaDWBkc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 21:40:32 -0400
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:13270 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204AbaDWBk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 21:40:28 -0400
X-IronPort-AV: E=Sophos;i="4.97,908,1389772800"; 
   d="scan'208";a="25608253"
From: Zi Shen Lim <zlim@broadcom.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Mark Brown <broonie@linaro.org>, Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>
CC: Zi Shen Lim <zlim@broadcom.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] arm64, sched: Remove unused mc_capable() and smt_capable()
Date: Tue, 22 Apr 2014 18:40:13 -0700
Message-ID: <1398217214-12204-2-git-send-email-zlim@broadcom.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1398217214-12204-1-git-send-email-zlim@broadcom.com>
References: <1398217214-12204-1-git-send-email-zlim@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused and deprecated mc_capable() and smt_capable().

Both were added recently by f6e763b93a6c ("arm64: topology:
Implement basic CPU topology support"). Uses of both were removed
by 8e7fbcbc22c1 ("sched: Remove stale power aware scheduling
remnants and dysfunctional knobs").

Signed-off-by: Zi Shen Lim <zlim@broadcom.com>
---
 arch/arm64/include/asm/topology.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm64/include/asm/topology.h b/arch/arm64/include/asm/topology.h
index 0172e6d..7ebcd31 100644
--- a/arch/arm64/include/asm/topology.h
+++ b/arch/arm64/include/asm/topology.h
@@ -20,9 +20,6 @@ extern struct cpu_topology cpu_topology[NR_CPUS];
 #define topology_core_cpumask(cpu)	(&cpu_topology[cpu].core_sibling)
 #define topology_thread_cpumask(cpu)	(&cpu_topology[cpu].thread_sibling)
 
-#define mc_capable()	(cpu_topology[0].cluster_id != -1)
-#define smt_capable()	(cpu_topology[0].thread_id != -1)
-
 void init_cpu_topology(void);
 void store_cpu_topology(unsigned int cpuid);
 const struct cpumask *cpu_coregroup_mask(int cpu);
-- 
1.8.4.3

