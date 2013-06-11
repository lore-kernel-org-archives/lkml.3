Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495Ab3FKLFg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 07:05:36 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:38524 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530Ab3FKLFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 07:05:35 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: mingo@redhat.com, peterz@infradead.org
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 2/3] sched: don't call get_group() for covered cpus
Date: Tue, 11 Jun 2013 16:32:44 +0530
Message-Id: <7a61e955abdcbb1dfa9fe493f11a5ec53a11ddd3.1370948150.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1370948150.git.viresh.kumar@linaro.org>
References: <cover.1370948150.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1370948150.git.viresh.kumar@linaro.org>
References: <cover.1370948150.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In build_sched_groups() we don't need to call get_group() for cpus which are
already covered in previous iterations. So, call get_group() after checking if
cpu is covered or not.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/sched/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 4abc743..27842f5 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5344,12 +5344,12 @@ build_sched_groups(struct sched_domain *sd, int cpu)
 
 	for_each_cpu(i, span) {
 		struct sched_group *sg;
-		int group = get_group(i, sdd, &sg);
-		int j;
+		int group, j;
 
 		if (cpumask_test_cpu(i, covered))
 			continue;
 
+		group = get_group(i, sdd, &sg);
 		cpumask_clear(sched_group_cpus(sg));
 		sg->sgp->power = 0;
 		cpumask_setall(sched_group_mask(sg));
-- 
1.7.12.rc2.18.g61b472e

