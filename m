Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964862Ab3FSSkl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 14:40:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40118 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964819Ab3FSSkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 14:40:37 -0400
Date: Wed, 19 Jun 2013 11:40:10 -0700
From: tip-bot for Viresh Kumar <tipbot@zytor.com>
Message-ID: <tip-4a850cbefa9592ddde3670a41c10c9576a657c43@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, viresh.kumar@linaro.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, viresh.kumar@linaro.org, tglx@linutronix.de
In-Reply-To: <545e0b4536166a15b4475abcafe5ed0db4ad4a2c.1370436120.git.viresh.kumar@linaro.org>
References: <545e0b4536166a15b4475abcafe5ed0db4ad4a2c.1370436120.git.viresh.kumar@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Remove unused params of build_sched_domain()
Git-Commit-ID: 4a850cbefa9592ddde3670a41c10c9576a657c43
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 19 Jun 2013 11:40:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4a850cbefa9592ddde3670a41c10c9576a657c43
Gitweb:     http://git.kernel.org/tip/4a850cbefa9592ddde3670a41c10c9576a657c43
Author:     Viresh Kumar <viresh.kumar@linaro.org>
AuthorDate: Tue, 4 Jun 2013 16:12:43 +0530
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 19 Jun 2013 12:58:42 +0200

sched: Remove unused params of build_sched_domain()

build_sched_domain() never uses parameter struct s_data *d and so passing it is
useless.

Remove it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/545e0b4536166a15b4475abcafe5ed0db4ad4a2c.1370436120.git.viresh.kumar@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index d8f071c..342e744 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5943,9 +5943,8 @@ static void __sdt_free(const struct cpumask *cpu_map)
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
@@ -5985,7 +5984,7 @@ static int build_sched_domains(const struct cpumask *cpu_map,
 
 		sd = NULL;
 		for (tl = sched_domain_topology; tl->init; tl++) {
-			sd = build_sched_domain(tl, &d, cpu_map, attr, sd, i);
+			sd = build_sched_domain(tl, cpu_map, attr, sd, i);
 			if (tl->flags & SDTL_OVERLAP || sched_feat(FORCE_SD_OVERLAP))
 				sd->flags |= SD_OVERLAP;
 			if (cpumask_equal(cpu_map, sched_domain_span(sd)))
