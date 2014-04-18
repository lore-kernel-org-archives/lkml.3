Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152AbaDRLf0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 07:35:26 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:33050 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbaDRLfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 07:35:21 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: peterz@infradead.org
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, dietmar.eggemann@arm.com,
        preeti@linux.vnet.ibm.com, linaro-kernel@lists.linaro.org,
        tony.luck@intel.com, fenghua.yu@intel.com, schwidefsky@de.ibm.com,
        cmetcalf@tilera.com, benh@kernel.crashing.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH] fix: sched: rework of sched_domain topology definition
Date: Fri, 18 Apr 2014 13:34:06 +0200
Message-Id: <1397820846-32603-1-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <20140418105601.GU11182@twins.programming.kicks-ass.net>
References: <20140418105601.GU11182@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix missing change from int to pointer function for numa flags

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 include/linux/sched.h | 7 +++++++
 kernel/sched/core.c   | 2 +-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 18464cb..d2b981c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -887,6 +887,13 @@ static inline const int cpu_core_flags(void)
 }
 #endif
 
+#ifdef CONFIG_NUMA
+static inline const int cpu_numa_flags(void)
+{
+	return SD_NUMA;
+}
+#endif
+
 struct sched_domain_attr {
 	int relax_domain_level;
 };
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index a30b0b4..24d0831 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6235,7 +6235,7 @@ static void sched_init_numa(void)
 	for (j = 0; j < level; i++, j++) {
 		tl[i] = (struct sched_domain_topology_level){
 			.mask = sd_numa_mask,
-			.sd_flags = SD_NUMA,
+			.sd_flags = cpu_numa_flags,
 			.flags = SDTL_OVERLAP,
 			.numa_level = j,
 			SD_INIT_NAME(NUMA)
-- 
1.9.1

