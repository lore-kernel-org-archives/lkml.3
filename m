Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082Ab3HRI03 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 04:26:29 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:46194 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754464Ab3HRI0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 04:26:25 -0400
From: Lei Wen <leiwen@marvell.com>
To: Paul Turner <pjt@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, <mingo@redhat.com>, <leiwen@marvell.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/8] sched: change cpu_avg_load_per_task using h_nr_running
Date: Sun, 18 Aug 2013 16:25:16 +0800
Message-ID: <1376814322-7320-3-git-send-email-leiwen@marvell.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1376814322-7320-1-git-send-email-leiwen@marvell.com>
References: <1376814322-7320-1-git-send-email-leiwen@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since cpu_avg_load_per_task is used only by cfs scheduler, its meaning
should present the average cfs type task load in the current run queue.
Thus we change it to h_nr_running for well presenting its meaning.

Signed-off-by: Lei Wen <leiwen@marvell.com>
---
 kernel/sched/fair.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index d6153c8..e6b99b4 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3008,7 +3008,7 @@ static unsigned long power_of(int cpu)
 static unsigned long cpu_avg_load_per_task(int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
-	unsigned long nr_running = ACCESS_ONCE(rq->nr_running);
+	unsigned long nr_running = ACCESS_ONCE(rq->cfs.h_nr_running);
 	unsigned long load_avg = rq->cfs.runnable_load_avg;
 
 	if (nr_running)
-- 
1.7.5.4

