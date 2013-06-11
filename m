Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab3FKLG5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 07:06:57 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:33120 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300Ab3FKLG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 07:06:56 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: mingo@redhat.com, peterz@infradead.org
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 3/3] sched: remove WARN_ON(!sd) from init_sched_groups_power()
Date: Tue, 11 Jun 2013 16:32:45 +0530
Message-Id: <2bbe633cd74b431c05253a8ce61fdfd5066a531b.1370948150.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1370948150.git.viresh.kumar@linaro.org>
References: <cover.1370948150.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1370948150.git.viresh.kumar@linaro.org>
References: <cover.1370948150.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sd can't be NULL in init_sched_groups_power() and so checking it for NULL isn't
useful. In case it is required, then also we need to rearrange the code a bit as
we already accessed invalid pointer sd to get sg: sg = sd->groups.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/sched/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 27842f5..c949f6d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5387,7 +5387,7 @@ static void init_sched_groups_power(int cpu, struct sched_domain *sd)
 {
 	struct sched_group *sg = sd->groups;
 
-	WARN_ON(!sd || !sg);
+	WARN_ON(!sg);
 
 	do {
 		sg->group_weight = cpumask_weight(sched_group_cpus(sg));
-- 
1.7.12.rc2.18.g61b472e

