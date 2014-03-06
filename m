Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624AbaCFPQ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 10:16:26 -0500
Received: from relay.parallels.com ([195.214.232.42]:56506 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794AbaCFPQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 10:16:25 -0500
Message-ID: <1394118975.19290.104.camel@tkhai>
Subject: [PATCH tip] [PATCH]sched/fair: Fix endless loop in idle_balance()
From: Kirill Tkhai <ktkhai@parallels.com>
To: <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Date: Thu, 6 Mar 2014 19:16:15 +0400
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch must go on top of the series:

[tip 1/2] sched/fair: Push down check for high priority class task into idle_balance()
[tip 2/2] sched/core: Fix endless loop in pick_next_task()

Check for fair tasks number to decide, that we've pulled a task.
rq's nr_running may contain throttled RT tasks.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@redhat.com>

Peter, this finaly fixes problem with RT throttling.
Should I send all three patches as one series?
---
 kernel/sched/fair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 10db4a8..f1eedae 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6710,7 +6710,7 @@ static int idle_balance(struct rq *this_rq)
 	 * While browsing the domains, we released the rq lock.
 	 * A task could have be enqueued in the meantime
 	 */
-	if (this_rq->nr_running && !pulled_task) {
+	if (this_rq->cfs.h_nr_running && !pulled_task) {
 		pulled_task = 1;
 		goto out;
 	}



