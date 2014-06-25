Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794AbaFYJSZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 05:18:25 -0400
Received: from 33.106-14-84.ripe.coltfrance.com ([84.14.106.33]:44646 "EHLO
	proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754634AbaFYJSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 05:18:23 -0400
X-Greylist: delayed 465 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Jun 2014 05:18:22 EDT
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
To: mingo@redhat.com, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH] sched: fix warnings in linux/sched.h
Date: Wed, 25 Jun 2014 11:10:11 +0200
Message-Id: <1403687411-27059-1-git-send-email-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seen when compiling with W=1.

Warnings were:
In file included from arch/x86/kernel/asm-offsets.c:9:0:
include/linux/sched.h:875:25: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
include/linux/sched.h:882:25: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
include/linux/sched.h:1002:21: warning: type qualifiers ignored on function return type [-Wignored-qualifiers]

It was introduced by commit 143e1e28cb40 ("sched: Rework sched_domain topology
definition").

CC: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 include/linux/sched.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 306f4f0c987a..0376b054a0d0 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -872,21 +872,21 @@ enum cpu_idle_type {
 #define SD_NUMA			0x4000	/* cross-node balancing */
 
 #ifdef CONFIG_SCHED_SMT
-static inline const int cpu_smt_flags(void)
+static inline int cpu_smt_flags(void)
 {
 	return SD_SHARE_CPUCAPACITY | SD_SHARE_PKG_RESOURCES;
 }
 #endif
 
 #ifdef CONFIG_SCHED_MC
-static inline const int cpu_core_flags(void)
+static inline int cpu_core_flags(void)
 {
 	return SD_SHARE_PKG_RESOURCES;
 }
 #endif
 
 #ifdef CONFIG_NUMA
-static inline const int cpu_numa_flags(void)
+static inline int cpu_numa_flags(void)
 {
 	return SD_NUMA;
 }
@@ -999,7 +999,7 @@ void free_sched_domains(cpumask_var_t doms[], unsigned int ndoms);
 bool cpus_share_cache(int this_cpu, int that_cpu);
 
 typedef const struct cpumask *(*sched_domain_mask_f)(int cpu);
-typedef const int (*sched_domain_flags_f)(void);
+typedef int (*sched_domain_flags_f)(void);
 
 #define SDTL_OVERLAP	0x01
 
-- 
1.9.0

