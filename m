Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262AbaFQNY0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 09:24:26 -0400
Received: from relay.parallels.com ([195.214.232.42]:34378 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755120AbaFQNYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 09:24:20 -0400
Message-ID: <1403011456.27674.45.camel@tkhai>
Subject: [PATCH 2/3] sched/rt: __disable_runtime: Enqueue just unthrottled
 rt_rq back on the stack
From: Kirill Tkhai <ktkhai@parallels.com>
To: <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        <tkhai@yandex.ru>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "Mike Galbraith" <umgwanakikbuti@gmail.com>,
        Konstantin Khorenko <khorenko@parallels.com>
Date: Tue, 17 Jun 2014 17:24:16 +0400
In-Reply-To: <20140617130442.29933.54945.stgit@tkhai>
References: <20140617130442.29933.54945.stgit@tkhai>
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Make rt_rq available for pick_next_task(). Otherwise, their tasks
stay prisoned long time till dead cpu becomes alive again.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
CC: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
CC: Mike Galbraith <umgwanakikbuti@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/rt.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index a490831..671a8b5 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -740,6 +740,9 @@ balanced:
 		rt_rq->rt_throttled = 0;
 		raw_spin_unlock(&rt_rq->rt_runtime_lock);
 		raw_spin_unlock(&rt_b->rt_runtime_lock);
+
+		/* Make rt_rq available for pick_next_task() */
+		sched_rt_rq_enqueue(rt_rq);
 	}
 }
 



