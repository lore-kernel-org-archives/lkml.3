Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756998Ab3FFCkE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 22:40:04 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:32860 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756827Ab3FFCkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 22:40:00 -0400
Message-ID: <51AFF677.3090308@linux.vnet.ibm.com>
Date: Thu, 06 Jun 2013 10:39:51 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH v2 3/3] sched: remove the useless declaration in kernel/sched/fair.c
References: <51AD87A8.6080608@linux.vnet.ibm.com> <51AD8808.7020608@linux.vnet.ibm.com>
In-Reply-To: <51AD8808.7020608@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060602-1618-0000-0000-0000040691D5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2:
	re-based on latest tip/master

default_cfs_period(), do_sched_cfs_period_timer(), do_sched_cfs_slack_timer()
already defined previously, no need to declare again.

CC: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 kernel/sched/fair.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 0cea941..9efc50f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2618,10 +2618,6 @@ static void check_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 	throttle_cfs_rq(cfs_rq);
 }
 
-static inline u64 default_cfs_period(void);
-static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun);
-static void do_sched_cfs_slack_timer(struct cfs_bandwidth *cfs_b);
-
 static enum hrtimer_restart sched_cfs_slack_timer(struct hrtimer *timer)
 {
 	struct cfs_bandwidth *cfs_b =
-- 
1.7.4.1

