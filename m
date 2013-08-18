Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398Ab3HRI1B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 04:27:01 -0400
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:35869 "EHLO
	na3sys009aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755100Ab3HRI0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 04:26:54 -0400
From: Lei Wen <leiwen@marvell.com>
To: Paul Turner <pjt@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, <mingo@redhat.com>, <leiwen@marvell.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/8] sched: change update_sg_lb_stats to h_nr_running
Date: Sun, 18 Aug 2013 16:25:19 +0800
Message-ID: <1376814322-7320-6-git-send-email-leiwen@marvell.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1376814322-7320-1-git-send-email-leiwen@marvell.com>
References: <1376814322-7320-1-git-send-email-leiwen@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since update_sg_lb_stats is used to calculate sched_group load
difference of cfs type task, it should use h_nr_running instead of
nr_running of rq.

Signed-off-by: Lei Wen <leiwen@marvell.com>
---
 kernel/sched/fair.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 33576eb..e026001 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4488,7 +4488,7 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 	for_each_cpu_and(i, sched_group_cpus(group), env->cpus) {
 		struct rq *rq = cpu_rq(i);
 
-		nr_running = rq->nr_running;
+		nr_running = rq->cfs.h_nr_running;
 
 		/* Bias balancing toward cpus of our domain */
 		if (local_group) {
-- 
1.7.5.4

