Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763AbaIDHf3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 03:35:29 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:33214 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbaIDHfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 03:35:25 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        preeti@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org
Cc: riel@redhat.com, Morten.Rasmussen@arm.com, efault@gmx.de,
        nicolas.pitre@linaro.org, linaro-kernel@lists.linaro.org,
        daniel.lezcano@linaro.org, dietmar.eggemann@arm.com,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: Re: [PATCH v5 09/11] sched: add usage_load_avg
Date: Thu,  4 Sep 2014 09:34:39 +0200
Message-Id: <1409816079-10131-1-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409051215-16788-10-git-send-email-vincent.guittot@linaro.org>
References: <1409051215-16788-10-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The update of update_rq_runnable_avg interface is missing for
CONFIG_FAIR_GROUP_SCHED in the original patch
"[PATCH v5 09/12] sched: add usage_load_avg"

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---

Hi Peter,

Do you prefer that I sent a new version of 
"[PATCH v5 09/12] sched: add usage_load_avg" patch with the fix or this fix is
enough ?

Regards,
Vincent

 kernel/sched/fair.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 1fd2131..cbe3eff 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2462,7 +2462,8 @@ static inline void __update_group_entity_contrib(struct sched_entity *se)
 
 static inline void update_rq_runnable_avg(struct rq *rq, int runnable)
 {
-	__update_entity_runnable_avg(rq_clock_task(rq), &rq->avg, runnable);
+	__update_entity_runnable_avg(rq_clock_task(rq), &rq->avg, runnable,
+			runnable);
 	__update_tg_runnable_avg(&rq->avg, &rq->cfs);
 }
 #else /* CONFIG_FAIR_GROUP_SCHED */
-- 
1.9.1

