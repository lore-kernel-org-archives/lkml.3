Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159Ab3FJK7R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 06:59:17 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:47780 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab3FJK7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 06:59:16 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: mingo@redhat.com, peterz@infradead.org
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 1/3] sched: don't initialize alloc_state in build_sched_domains
Date: Mon, 10 Jun 2013 16:27:18 +0530
Message-Id: <df57734a075cc5ad130e1ae498702e24f2529ab8.1370861520.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1370861520.git.viresh.kumar@linaro.org>
References: <cover.1370861520.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1370861520.git.viresh.kumar@linaro.org>
References: <cover.1370861520.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

alloc_state will be overwritten by __visit_domain_allocation_hell() and so we
don't actually need to initialize alloc_state.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/sched/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 0623703..5faa748 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5956,7 +5956,7 @@ struct sched_domain *build_sched_domain(struct sched_domain_topology_level *tl,
 static int build_sched_domains(const struct cpumask *cpu_map,
 			       struct sched_domain_attr *attr)
 {
-	enum s_alloc alloc_state = sa_none;
+	enum s_alloc alloc_state;
 	struct sched_domain *sd;
 	struct s_data d;
 	int i, ret = -ENOMEM;
-- 
1.7.12.rc2.18.g61b472e

