Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935114Ab3FSSj3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 14:39:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40047 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757226Ab3FSSjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 14:39:24 -0400
Date: Wed, 19 Jun 2013 11:38:49 -0700
From: tip-bot for Mischa Jonker <tipbot@zytor.com>
Message-ID: <tip-03d8e80beb7db78a13c192431205b9c83f7e0cd1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, Mischa.Jonker@synopsys.com, hpa@zytor.com,
        mingo@kernel.org, mjonker@synopsys.com, peterz@infradead.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, Mischa.Jonker@synopsys.com,
        linux-kernel@vger.kernel.org, mjonker@synopsys.com,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1370339148-5566-1-git-send-email-mjonker@synopsys.com>
References: <1370339148-5566-1-git-send-email-mjonker@synopsys.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Add const qualifier to perf_pmu_register's 
 'name' arg
Git-Commit-ID: 03d8e80beb7db78a13c192431205b9c83f7e0cd1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 19 Jun 2013 11:38:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  03d8e80beb7db78a13c192431205b9c83f7e0cd1
Gitweb:     http://git.kernel.org/tip/03d8e80beb7db78a13c192431205b9c83f7e0cd1
Author:     Mischa Jonker <Mischa.Jonker@synopsys.com>
AuthorDate: Tue, 4 Jun 2013 11:45:48 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 19 Jun 2013 12:50:23 +0200

perf: Add const qualifier to perf_pmu_register's 'name' arg

This allows us to use pdev->name for registering a PMU device.
IMO the name is not supposed to be changed anyway.

Signed-off-by: Mischa Jonker <mjonker@synopsys.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1370339148-5566-1-git-send-email-mjonker@synopsys.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/metag/kernel/perf/perf_event.c | 2 +-
 include/linux/perf_event.h          | 4 ++--
 kernel/events/core.c                | 2 +-
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
index 74a4e14..4bc57d0 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -188,7 +188,7 @@ struct pmu {
 
 	struct device			*dev;
 	const struct attribute_group	**attr_groups;
-	char				*name;
+	const char			*name;
 	int				type;
 
 	int * __percpu			pmu_disable_count;
@@ -519,7 +519,7 @@ struct perf_output_handle {
 
 #ifdef CONFIG_PERF_EVENTS
 
-extern int perf_pmu_register(struct pmu *pmu, char *name, int type);
+extern int perf_pmu_register(struct pmu *pmu, const char *name, int type);
 extern void perf_pmu_unregister(struct pmu *pmu);
 
 extern int perf_num_counters(void);
diff --git a/kernel/events/core.c b/kernel/events/core.c
index aca95bc..9c89207 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6179,7 +6179,7 @@ free_dev:
 static struct lock_class_key cpuctx_mutex;
 static struct lock_class_key cpuctx_lock;
 
-int perf_pmu_register(struct pmu *pmu, char *name, int type)
+int perf_pmu_register(struct pmu *pmu, const char *name, int type)
 {
 	int cpu, ret;
 
