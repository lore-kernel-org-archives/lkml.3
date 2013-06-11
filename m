Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530Ab3FKLEL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 07:04:11 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:65398 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530Ab3FKLEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 07:04:10 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: mingo@redhat.com, peterz@infradead.org
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 1/3] sched: Use cached value of span instead of calling sched_domain_span()
Date: Tue, 11 Jun 2013 16:32:43 +0530
Message-Id: <834ecd507071ad88aff039352dbc7e063dd996a7.1370948150.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1370948150.git.viresh.kumar@linaro.org>
References: <cover.1370948150.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1370948150.git.viresh.kumar@linaro.org>
References: <cover.1370948150.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the beginning of build_sched_groups() we called sched_domain_span() and
cached its return value in span. Few statements later we are calling it again to
get the same pointer.

Lets use the cached value instead as it hasn't changed in between.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/sched/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index e585e10..4abc743 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5334,7 +5334,7 @@ build_sched_groups(struct sched_domain *sd, int cpu)
 	get_group(cpu, sdd, &sd->groups);
 	atomic_inc(&sd->groups->ref);
 
-	if (cpu != cpumask_first(sched_domain_span(sd)))
+	if (cpu != cpumask_first(span))
 		return 0;
 
 	lockdep_assert_held(&sched_domains_mutex);
-- 
1.7.12.rc2.18.g61b472e

