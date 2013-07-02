Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011Ab3GBMVE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 08:21:04 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:47958 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752338Ab3GBMVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 08:21:02 -0400
From: Lei Wen <leiwen@marvell.com>
To: Paul Turner <pjt@google.com>, Alex Shi <alex.shi@intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        <mingo@redhat.com>, Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Lei Wen <leiwen@marvell.com>, <linux-kernel@vger.kernel.org>
Subject: [V3 2/2] sched: update cfs_rq weight earlier in enqueue_entity
Date: Tue, 2 Jul 2013 20:15:06 +0800
Message-ID: <1372767306-9478-3-git-send-email-leiwen@marvell.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1372767306-9478-1-git-send-email-leiwen@marvell.com>
References: <1372682002-15373-1-git-send-email-leiwen@marvell.com>
 <1372767306-9478-1-git-send-email-leiwen@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are expecting runnable_load_avg is less than load.weight, 
So that runnable_load_avg/load.weight could well present out the system's
load distribution.

if not increase the load.weight prior to enqueue_entity_load_avg, it may
lead to runnable_load_avg is higher than load.weight, so that people
may get confused.

Signed-off-by: Lei Wen <leiwen@marvell.com>
Cc: Alex Shi <alex.shi@intel.com>
Cc: Paul Turner <pjt@google.com>
---
 kernel/sched/fair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 2290469..53224d1 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1778,8 +1778,8 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	 * Update run-time statistics of the 'current'.
 	 */
 	update_curr(cfs_rq);
-	enqueue_entity_load_avg(cfs_rq, se, flags & ENQUEUE_WAKEUP);
 	account_entity_enqueue(cfs_rq, se);
+	enqueue_entity_load_avg(cfs_rq, se, flags & ENQUEUE_WAKEUP);
 	update_cfs_shares(cfs_rq);
 
 	if (flags & ENQUEUE_WAKEUP) {
-- 
1.7.10.4

