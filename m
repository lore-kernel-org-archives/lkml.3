Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759219Ab3FDGYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 02:24:18 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:57313 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755826Ab3FDGYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 02:24:16 -0400
Message-ID: <51AD8808.7020608@linux.vnet.ibm.com>
Date: Tue, 04 Jun 2013 14:24:08 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 3/3] sched: remove the useless declaration in kernel/sched/fair.c
References: <51AD87A8.6080608@linux.vnet.ibm.com>
In-Reply-To: <51AD87A8.6080608@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060406-3864-0000-0000-0000087122C3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

default_cfs_period(), do_sched_cfs_period_timer(), do_sched_cfs_slack_timer()
already defined previously, no need to declare again.

CC: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 kernel/sched/fair.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c61a614..73cad33 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2599,10 +2599,6 @@ static void check_cfs_rq_runtime(struct cfs_rq *cfs_rq)
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

