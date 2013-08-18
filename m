Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab3HRI1r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 04:27:47 -0400
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:46852 "EHLO
	na3sys009aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755384Ab3HRI1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 04:27:24 -0400
From: Lei Wen <leiwen@marvell.com>
To: Paul Turner <pjt@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, <mingo@redhat.com>, <leiwen@marvell.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/8] sched: change find_busiest_queue to h_nr_running
Date: Sun, 18 Aug 2013 16:25:20 +0800
Message-ID: <1376814322-7320-7-git-send-email-leiwen@marvell.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1376814322-7320-1-git-send-email-leiwen@marvell.com>
References: <1376814322-7320-1-git-send-email-leiwen@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since find_busiest_queue try to avoid do load balance for runqueue
which has only one cfs task and its load is above the imbalance
value calculated, we should use h_nr_running of cfs instead of
nr_running of rq.

Signed-off-by: Lei Wen <leiwen@marvell.com>
---
 kernel/sched/fair.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index e026001..3656603 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4990,7 +4990,8 @@ static struct rq *find_busiest_queue(struct lb_env *env,
 		 * When comparing with imbalance, use weighted_cpuload()
 		 * which is not scaled with the cpu power.
 		 */
-		if (capacity && rq->nr_running == 1 && wl > env->imbalance)
+		if (capacity && rq->cfs.h_nr_running == 1
+			     && wl > env->imbalance)
 			continue;
 
 		/*
-- 
1.7.5.4

