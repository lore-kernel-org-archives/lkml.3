Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbaATMkO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 07:40:14 -0500
Received: from service87.mimecast.com ([91.220.42.44]:51581 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbaATMkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 07:40:05 -0500
From: dietmar.eggemann@arm.com
To: peterz@infradead.org, mingo@redhat.com, vincent.guittot@linaro.org,
        morten.rasmussen@arm.com, chris.redpath@arm.com
Cc: linux-kernel@vger.kernel.org, dietmar.eggemann@arm.com
Subject: [RFC v2 PATCH 02/11] sched: export cpu_smt_mask() and cpu_cpu_mask()
Date: Mon, 20 Jan 2014 12:39:39 +0000
Message-Id: <1390221588-20473-3-git-send-email-dietmar.eggemann@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1390221588-20473-1-git-send-email-dietmar.eggemann@arm.com>
References: <1390221588-20473-1-git-send-email-dietmar.eggemann@arm.com>
X-OriginalArrivalTime: 20 Jan 2014 12:40:02.0441 (UTC) FILETIME=[BCF84790:01CF15DC]
X-MC-Unique: 114012012400312601
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s0KCebZU003782

From: Dietmar Eggemann <dietmar.eggemann@arm.com>

Move cpu_smt_mask() and cpu_cpu_mask() from scheduler code into the
include/linux/topology.h so that an arch can use them for specifying cpu
masks for its topology info array.

Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
---
 include/linux/topology.h |   12 ++++++++++++
 kernel/sched/core.c      |   12 ------------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/linux/topology.h b/include/linux/topology.h
index 12ae6ce997d6..0bfcead0ace7 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -295,4 +295,16 @@ static inline int cpu_to_mem(int cpu)
 #define topology_core_cpumask(cpu)		cpumask_of(cpu)
 #endif
 
+#ifdef CONFIG_SCHED_SMT
+static inline const struct cpumask *cpu_smt_mask(int cpu)
+{
+	return topology_thread_cpumask(cpu);
+}
+#endif
+
+static inline const struct cpumask *cpu_cpu_mask(int cpu)
+{
+	return cpumask_of_node(cpu_to_node(cpu));
+}
+
 #endif /* _LINUX_TOPOLOGY_H */
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 8b8a37697a7d..523bb43756d6 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4988,11 +4988,6 @@ static int __init isolated_cpu_setup(char *str)
 
 __setup("isolcpus=", isolated_cpu_setup);
 
-static const struct cpumask *cpu_cpu_mask(int cpu)
-{
-	return cpumask_of_node(cpu_to_node(cpu));
-}
-
 struct sd_data {
 	struct sched_domain **__percpu sd;
 	struct sched_group **__percpu sg;
@@ -5368,13 +5363,6 @@ static void claim_allocations(int cpu, struct sched_domain *sd)
 		*per_cpu_ptr(sdd->sgp, cpu) = NULL;
 }
 
-#ifdef CONFIG_SCHED_SMT
-static const struct cpumask *cpu_smt_mask(int cpu)
-{
-	return topology_thread_cpumask(cpu);
-}
-#endif
-
 /*
  * Topology list, bottom-up.
  */
-- 
1.7.9.5


