Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601Ab3FDJq1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 05:46:27 -0400
Received: from us02smtp1.synopsys.com ([198.182.60.75]:44672 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab3FDJqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 05:46:24 -0400
From: Mischa Jonker <Mischa.Jonker@synopsys.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        James Hogan <james.hogan@imgtec.com>, linux-kernel@vger.kernel.org,
        Vineet.Gupta1@synopsys.com
Cc: Mischa Jonker <Mischa.Jonker@synopsys.com>
Subject: [PATCH] perf: add const qualifier to perf_pmu_register's 'name' arg
Date: Tue,  4 Jun 2013 11:45:48 +0200
Message-Id: <1370339148-5566-1-git-send-email-mjonker@synopsys.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows us to use pdev->name for registering a PMU device.
IMO the name is not supposed to be changed anyway.

Signed-off-by: Mischa Jonker <mjonker@synopsys.com>
---
 arch/metag/kernel/perf/perf_event.c |    2 +-
 include/linux/perf_event.h          |    4 ++--
 kernel/events/core.c                |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/metag/kernel/perf/perf_event.c b/arch/metag/kernel/perf/perf_event.c
index 3665694..5b18888 100644
--- a/arch/metag/kernel/perf/perf_event.c
+++ b/arch/metag/kernel/perf/perf_event.c
@@ -882,7 +882,7 @@ static int __init init_hw_perf_events(void)
 	}
 
 	register_cpu_notifier(&metag_pmu_notifier);
-	ret = perf_pmu_register(&pmu, (char *)metag_pmu->name, PERF_TYPE_RAW);
+	ret = perf_pmu_register(&pmu, metag_pmu->name, PERF_TYPE_RAW);
 out:
 	return ret;
 }
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index f463a46..65a462c 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -188,7 +188,7 @@ struct pmu {
 
 	struct device			*dev;
 	const struct attribute_group	**attr_groups;
-	char				*name;
+	const char			*name;
 	int				type;
 
 	int * __percpu			pmu_disable_count;
@@ -518,7 +518,7 @@ struct perf_output_handle {
 
 #ifdef CONFIG_PERF_EVENTS
 
-extern int perf_pmu_register(struct pmu *pmu, char *name, int type);
+extern int perf_pmu_register(struct pmu *pmu, const char *name, int type);
 extern void perf_pmu_unregister(struct pmu *pmu);
 
 extern int perf_num_counters(void);
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 9dc297f..7003d6f 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5952,7 +5952,7 @@ free_dev:
 static struct lock_class_key cpuctx_mutex;
 static struct lock_class_key cpuctx_lock;
 
-int perf_pmu_register(struct pmu *pmu, char *name, int type)
+int perf_pmu_register(struct pmu *pmu, const char *name, int type)
 {
 	int cpu, ret;
 
-- 
1.7.0.4

