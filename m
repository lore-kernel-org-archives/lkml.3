Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab3HRI06 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 04:26:58 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:33229 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755093Ab3HRI0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 04:26:54 -0400
From: Lei Wen <leiwen@marvell.com>
To: Paul Turner <pjt@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, <mingo@redhat.com>, <leiwen@marvell.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/8] sched: change pick_next_task_fair to h_nr_running
Date: Sun, 18 Aug 2013 16:25:18 +0800
Message-ID: <1376814322-7320-5-git-send-email-leiwen@marvell.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1376814322-7320-1-git-send-email-leiwen@marvell.com>
References: <1376814322-7320-1-git-send-email-leiwen@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since pick_next_task_fair only want to ensure there is some task in the
run queue to be picked up, it should use the h_nr_running instead of
nr_running, since nr_running cannot present all tasks if group existed.

Signed-off-by: Lei Wen <leiwen@marvell.com>
---
 kernel/sched/fair.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 9869d4d..33576eb 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3653,7 +3653,7 @@ static struct task_struct *pick_next_task_fair(struct rq *rq)
 	struct cfs_rq *cfs_rq = &rq->cfs;
 	struct sched_entity *se;
 
-	if (!cfs_rq->nr_running)
+	if (!cfs_rq->h_nr_running)
 		return NULL;
 
 	do {
-- 
1.7.5.4

