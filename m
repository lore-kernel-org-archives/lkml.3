Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751456AbaDYDS5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 23:18:57 -0400
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:2358 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbaDYDSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 23:18:55 -0400
X-IronPort-AV: E=Sophos;i="4.97,924,1389772800"; 
   d="scan'208";a="25985942"
From: Zi Shen Lim <zlim@broadcom.com>
To: Mark Brown <broonie@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Will Deacon <will.deacon@arm.com>
CC: Zi Shen Lim <zlim@broadcom.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCHv2 1/2] arm64, sched: Remove unused mc_capable() and smt_capable()
Date: Thu, 24 Apr 2014 20:18:41 -0700
Message-ID: <1398395922-7482-2-git-send-email-zlim@broadcom.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1398395922-7482-1-git-send-email-zlim@broadcom.com>
References: <1398395922-7482-1-git-send-email-zlim@broadcom.com>
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

Reviewed-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Zi Shen Lim <zlim@broadcom.com>
---
v1->v2: No changes.
 - Added Mark's review-by.

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

