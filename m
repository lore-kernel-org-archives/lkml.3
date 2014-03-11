Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019AbaCKQ05 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 12:26:57 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:59277 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbaCKQ04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 12:26:56 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH] sched: fix: remove double calculation in fix_small_imbalance
Date: Tue, 11 Mar 2014 17:26:06 +0100
Message-Id: <1394555166-22894-1-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tmp value has been already calculated in:
scaled_busy_load_per_task =
		(busiest->load_per_task * SCHED_POWER_SCALE) /
		busiest->group_power;

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 kernel/sched/fair.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index f1eedae..b301918 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6061,12 +6061,10 @@ void fix_small_imbalance(struct lb_env *env, struct sd_lb_stats *sds)
 	pwr_now /= SCHED_POWER_SCALE;
 
 	/* Amount of load we'd subtract */
-	tmp = (busiest->load_per_task * SCHED_POWER_SCALE) /
-		busiest->group_power;
-	if (busiest->avg_load > tmp) {
+	if (busiest->avg_load > scaled_busy_load_per_task) {
 		pwr_move += busiest->group_power *
 			    min(busiest->load_per_task,
-				busiest->avg_load - tmp);
+				busiest->avg_load - scaled_busy_load_per_task);
 	}
 
 	/* Amount of load we'd add */
-- 
1.9.0

