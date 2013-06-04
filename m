Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759Ab3FDLVA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 07:21:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63667 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114Ab3FDLU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 07:20:59 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: mingo@redhat.com, peterz@infradead.org
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 2/2] sched: Remove unused params of build_sched_domain()
Date: Tue,  4 Jun 2013 16:50:19 +0530
Message-Id: <c959237aded3ae102740d4ecd6299fad5bee3dbe.1370344689.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <d226c91fed3dfa2dca644d14c88b1d1ff9d2e722.1370344689.git.viresh.kumar@linaro.org>
References: <d226c91fed3dfa2dca644d14c88b1d1ff9d2e722.1370344689.git.viresh.kumar@linaro.org>
In-Reply-To: <d226c91fed3dfa2dca644d14c88b1d1ff9d2e722.1370344689.git.viresh.kumar@linaro.org>
References: <d226c91fed3dfa2dca644d14c88b1d1ff9d2e722.1370344689.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

build_sched_domain() never uses parameter struct s_data *d and so passing it is
useless.

Remove it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/sched/core.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 638f6cb..4210c54 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6490,9 +6490,8 @@ static void __sdt_free(const struct cpumask *cpu_map)
 }
 
 struct sched_domain *build_sched_domain(struct sched_domain_topology_level *tl,
-		struct s_data *d, const struct cpumask *cpu_map,
-		struct sched_domain_attr *attr, struct sched_domain *child,
-		int cpu)
+		const struct cpumask *cpu_map, struct sched_domain_attr *attr,
+		struct sched_domain *child, int cpu)
 {
 	struct sched_domain *sd = tl->init(tl, cpu);
 	if (!sd)
@@ -6532,7 +6531,7 @@ static int build_sched_domains(const struct cpumask *cpu_map,
 
 		sd = NULL;
 		for (tl = sched_domain_topology; tl->init; tl++) {
-			sd = build_sched_domain(tl, &d, cpu_map, attr, sd, i);
+			sd = build_sched_domain(tl, cpu_map, attr, sd, i);
 			if (!*per_cpu_ptr(d.sd, i))
 				*per_cpu_ptr(d.sd, i) = sd;
 			if (tl->flags & SDTL_OVERLAP || sched_feat(FORCE_SD_OVERLAP))
-- 
1.7.12.rc2.18.g61b472e

