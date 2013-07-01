Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab3GAMhF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 08:37:05 -0400
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:50041 "EHLO
	na3sys009aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752695Ab3GAMhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 08:37:03 -0400
From: Lei Wen <leiwen@marvell.com>
To: Paul Turner <pjt@google.com>, Alex Shi <alex.shi@intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        <mingo@redhat.com>, Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Lei Wen <leiwen@marvell.com>, <linux-kernel@vger.kernel.org>
Subject: [V2 2/2] sched: update cfs_rq weight earlier in enqueue_entity
Date: Mon, 1 Jul 2013 20:33:22 +0800
Message-ID: <1372682002-15373-3-git-send-email-leiwen@marvell.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1372682002-15373-1-git-send-email-leiwen@marvell.com>
References: <1372662634-12833-1-git-send-email-leiwen@marvell.com>
 <1372682002-15373-1-git-send-email-leiwen@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we are going to calculate cfs_rq's average ratio by
runnable_load_avg/load.weight, if not increase the load.weight prior to
enqueue_entity_load_avg, it may lead to one cfs_rq's avg ratio higher
than 100%.

Adjust the sequence, so that all ratio is kept below 100%.

Signed-off-by: Lei Wen <leiwen@marvell.com>
---
 kernel/sched/fair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 07bd74c..d1eee84 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1788,8 +1788,8 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
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

