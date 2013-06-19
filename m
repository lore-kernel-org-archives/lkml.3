Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964920Ab3FSSls (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 14:41:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40183 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756904Ab3FSSll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 14:41:41 -0400
Date: Wed, 19 Jun 2013 11:41:12 -0700
From: tip-bot for Viresh Kumar <tipbot@zytor.com>
Message-ID: <tip-94c95ba69f31e435416988ddb223c92e5b0e9e83@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, viresh.kumar@linaro.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, viresh.kumar@linaro.org, tglx@linutronix.de
In-Reply-To: <2bbe633cd74b431c05253a8ce61fdfd5066a531b.1370948150.git.viresh.kumar@linaro.org>
References: <2bbe633cd74b431c05253a8ce61fdfd5066a531b.1370948150.git.viresh.kumar@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Remove WARN_ON(!sd)
  from init_sched_groups_power()
Git-Commit-ID: 94c95ba69f31e435416988ddb223c92e5b0e9e83
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 19 Jun 2013 11:41:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  94c95ba69f31e435416988ddb223c92e5b0e9e83
Gitweb:     http://git.kernel.org/tip/94c95ba69f31e435416988ddb223c92e5b0e9e83
Author:     Viresh Kumar <viresh.kumar@linaro.org>
AuthorDate: Tue, 11 Jun 2013 16:32:45 +0530
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 19 Jun 2013 12:58:47 +0200

sched: Remove WARN_ON(!sd) from init_sched_groups_power()

sd can't be NULL in init_sched_groups_power() and so checking it for NULL isn't
useful. In case it is required, then also we need to rearrange the code a bit as
we already accessed invalid pointer sd to get sg: sg = sd->groups.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/2bbe633cd74b431c05253a8ce61fdfd5066a531b.1370948150.git.viresh.kumar@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 014c97f..21b1403 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5400,7 +5400,7 @@ static void init_sched_groups_power(int cpu, struct sched_domain *sd)
 {
 	struct sched_group *sg = sd->groups;
 
-	WARN_ON(!sd || !sg);
+	WARN_ON(!sg);
 
 	do {
 		sg->group_weight = cpumask_weight(sched_group_cpus(sg));
