Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964905Ab3FSSk7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 14:40:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40139 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964843Ab3FSSk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 14:40:57 -0400
Date: Wed, 19 Jun 2013 11:40:27 -0700
From: tip-bot for Viresh Kumar <tipbot@zytor.com>
Message-ID: <tip-1c6321694074163b5863c13d71c19ca953a3fb08@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, viresh.kumar@linaro.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, viresh.kumar@linaro.org, tglx@linutronix.de
In-Reply-To: <df57734a075cc5ad130e1ae498702e24f2529ab8.1370861520.git.viresh.kumar@linaro.org>
References: <df57734a075cc5ad130e1ae498702e24f2529ab8.1370861520.git.viresh.kumar@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Don'
 t initialize alloc_state in build_sched_domains()
Git-Commit-ID: 1c6321694074163b5863c13d71c19ca953a3fb08
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 19 Jun 2013 11:40:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1c6321694074163b5863c13d71c19ca953a3fb08
Gitweb:     http://git.kernel.org/tip/1c6321694074163b5863c13d71c19ca953a3fb08
Author:     Viresh Kumar <viresh.kumar@linaro.org>
AuthorDate: Mon, 10 Jun 2013 16:27:18 +0530
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 19 Jun 2013 12:58:44 +0200

sched: Don't initialize alloc_state in build_sched_domains()

alloc_state will be overwritten by __visit_domain_allocation_hell() and so we
don't actually need to initialize alloc_state.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/df57734a075cc5ad130e1ae498702e24f2529ab8.1370861520.git.viresh.kumar@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 137dcc0..3de6264 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5969,7 +5969,7 @@ struct sched_domain *build_sched_domain(struct sched_domain_topology_level *tl,
 static int build_sched_domains(const struct cpumask *cpu_map,
 			       struct sched_domain_attr *attr)
 {
-	enum s_alloc alloc_state = sa_none;
+	enum s_alloc alloc_state;
 	struct sched_domain *sd;
 	struct s_data d;
 	int i, ret = -ENOMEM;
