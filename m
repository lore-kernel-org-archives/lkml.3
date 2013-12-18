Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638Ab3LRKgG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 05:36:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44792 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754312Ab3LRKeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 05:34:02 -0500
Date: Wed, 18 Dec 2013 02:33:17 -0800
From: tip-bot for Wanpeng Li <tipbot@zytor.com>
Message-ID: <tip-e777b63bbd589248eb151a3191ee92331a701385@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        liwanp@linux.vnet.ibm.com, peterz@infradead.org,
        n-horiguchi@ah.jp.nec.com, riel@redhat.com, akpm@linux-foundation.org,
        mgorman@suse.de, tglx@linutronix.de, rientjes@google.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        liwanp@linux.vnet.ibm.com, peterz@infradead.org,
        n-horiguchi@ah.jp.nec.com, riel@redhat.com, akpm@linux-foundation.org,
        mgorman@suse.de, tglx@linutronix.de, rientjes@google.com
In-Reply-To: <1386833006-6600-4-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1386833006-6600-4-git-send-email-liwanp@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa: Fix period_slot recalculation
Git-Commit-ID: e777b63bbd589248eb151a3191ee92331a701385
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 18 Dec 2013 02:33:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e777b63bbd589248eb151a3191ee92331a701385
Gitweb:     http://git.kernel.org/tip/e777b63bbd589248eb151a3191ee92331a701385
Author:     Wanpeng Li <liwanp@linux.vnet.ibm.com>
AuthorDate: Thu, 12 Dec 2013 15:23:26 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 17 Dec 2013 15:24:41 +0100

sched/numa: Fix period_slot recalculation

The original code is as intended and was meant to scale the difference
between the NUMA_PERIOD_THRESHOLD and local/remote ratio when adjusting
the scan period. The period_slot recalculation can be dropped.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>
Link: http://lkml.kernel.org/r/1386833006-6600-4-git-send-email-liwanp@linux.vnet.ibm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 37892d7..4316af2 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1342,7 +1342,6 @@ static void update_task_scan_period(struct task_struct *p,
 		 * scanning faster if shared accesses dominate as it may
 		 * simply bounce migrations uselessly
 		 */
-		period_slot = DIV_ROUND_UP(diff, NUMA_PERIOD_SLOTS);
 		ratio = DIV_ROUND_UP(private * NUMA_PERIOD_SLOTS, (private + shared));
 		diff = (diff * ratio) / NUMA_PERIOD_SLOTS;
 	}
