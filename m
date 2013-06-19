Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443Ab3FSSlZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 14:41:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40169 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756904Ab3FSSlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 14:41:21 -0400
Date: Wed, 19 Jun 2013 11:40:54 -0700
From: tip-bot for Viresh Kumar <tipbot@zytor.com>
Message-ID: <tip-0936629f01bb1b11772db8c36be421365238cbec@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, viresh.kumar@linaro.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, viresh.kumar@linaro.org, tglx@linutronix.de
In-Reply-To: <834ecd507071ad88aff039352dbc7e063dd996a7.1370948150.git.viresh.kumar@linaro.org>
References: <834ecd507071ad88aff039352dbc7e063dd996a7.1370948150.git.viresh.kumar@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Use cached value of span instead of calling sched_domain_span()
Git-Commit-ID: 0936629f01bb1b11772db8c36be421365238cbec
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 19 Jun 2013 11:41:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0936629f01bb1b11772db8c36be421365238cbec
Gitweb:     http://git.kernel.org/tip/0936629f01bb1b11772db8c36be421365238cbec
Author:     Viresh Kumar <viresh.kumar@linaro.org>
AuthorDate: Tue, 11 Jun 2013 16:32:43 +0530
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 19 Jun 2013 12:58:46 +0200

sched: Use cached value of span instead of calling sched_domain_span()

In the beginning of build_sched_groups() we called sched_domain_span() and
cached its return value in span. Few statements later we are calling it again to
get the same pointer.

Lets use the cached value instead as it hasn't changed in between.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/834ecd507071ad88aff039352dbc7e063dd996a7.1370948150.git.viresh.kumar@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 547b7d3..3388387 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5347,7 +5347,7 @@ build_sched_groups(struct sched_domain *sd, int cpu)
 	get_group(cpu, sdd, &sd->groups);
 	atomic_inc(&sd->groups->ref);
 
-	if (cpu != cpumask_first(sched_domain_span(sd)))
+	if (cpu != cpumask_first(span))
 		return 0;
 
 	lockdep_assert_held(&sched_domains_mutex);
