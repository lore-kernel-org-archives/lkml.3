Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089AbaB0Mbs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 07:31:48 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:49400 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbaB0Mbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 07:31:46 -0500
Date: Thu, 27 Feb 2014 17:59:31 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        josh@joshtriplett.org
Subject: [PATCH 41/46] kernel: Mark functions as static in sched/core.c
Message-ID: <857e6dabbec99c492a6f6008b6d6d888ebaf5f6e.1393493277.git.rashika.kheria@gmail.com>
References: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark functions as static in kernel/sched/core.c because they are not
used outside this file.

This eliminates the following warning in kernel/sched/core.c:
kernel/sched/core.c:6346:22: warning: no previous prototype for ‘build_sched_domain’ [-Wmissing-prototypes]
kernel/sched/core.c:7733:5: warning: no previous prototype for ‘tg_set_cfs_quota’ [-Wmissing-prototypes]
kernel/sched/core.c:7746:6: warning: no previous prototype for ‘tg_get_cfs_quota’ [-Wmissing-prototypes]
kernel/sched/core.c:7759:5: warning: no previous prototype for ‘tg_set_cfs_period’ [-Wmissing-prototypes]
kernel/sched/core.c:7769:6: warning: no previous prototype for ‘tg_get_cfs_period’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/sched/core.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 9c3df36..7e1d58f 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6342,7 +6342,8 @@ static void __sdt_free(const struct cpumask *cpu_map)
 	}
 }
 
-struct sched_domain *build_sched_domain(struct sched_domain_topology_level *tl,
+static struct sched_domain *build_sched_domain(
+		struct sched_domain_topology_level *tl,
 		const struct cpumask *cpu_map, struct sched_domain_attr *attr,
 		struct sched_domain *child, int cpu)
 {
@@ -7729,7 +7730,7 @@ out_unlock:
 	return ret;
 }
 
-int tg_set_cfs_quota(struct task_group *tg, long cfs_quota_us)
+static int tg_set_cfs_quota(struct task_group *tg, long cfs_quota_us)
 {
 	u64 quota, period;
 
@@ -7742,7 +7743,7 @@ int tg_set_cfs_quota(struct task_group *tg, long cfs_quota_us)
 	return tg_set_cfs_bandwidth(tg, period, quota);
 }
 
-long tg_get_cfs_quota(struct task_group *tg)
+static long tg_get_cfs_quota(struct task_group *tg)
 {
 	u64 quota_us;
 
@@ -7755,7 +7756,7 @@ long tg_get_cfs_quota(struct task_group *tg)
 	return quota_us;
 }
 
-int tg_set_cfs_period(struct task_group *tg, long cfs_period_us)
+static int tg_set_cfs_period(struct task_group *tg, long cfs_period_us)
 {
 	u64 quota, period;
 
@@ -7765,7 +7766,7 @@ int tg_set_cfs_period(struct task_group *tg, long cfs_period_us)
 	return tg_set_cfs_bandwidth(tg, period, quota);
 }
 
-long tg_get_cfs_period(struct task_group *tg)
+static long tg_get_cfs_period(struct task_group *tg)
 {
 	u64 cfs_period_us;
 
-- 
1.7.9.5

