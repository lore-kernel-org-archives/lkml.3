Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885AbaB0KYa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 05:24:30 -0500
Received: from relay.parallels.com ([195.214.232.42]:47212 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbaB0KY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 05:24:29 -0500
Message-ID: <1393496657.3522.3.camel@tkhai>
Subject: [PATCH]sched/core: Return possibility to set RT and DL classes back
From: Kirill Tkhai <ktkhai@parallels.com>
To: <linux-kernel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        <tkhai@yandex.ru>
Date: Thu, 27 Feb 2014 14:24:17 +0400
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH]sched/core: Return possibility to set RT and DL classes back

I found that it's impossible to set RT policy for tasks at the moment.

This is regression after commit [sched: Consider pi boosting in setscheduler()]
				[c365c292d05908c6ea6f32708f331e21033fe71d     ]
Fix that.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@redhat.com>
---
 kernel/sched/core.c | 4 ++++
 1 file changed, 4 insertions(+)
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 84b23ce..30cf9ad 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3193,6 +3193,10 @@ static void __setscheduler_params(struct task_struct *p,
 	 * getparam()/getattr() don't report silly values for !rt tasks.
 	 */
 	p->rt_priority = attr->sched_priority;
+
+	p->normal_prio = normal_prio(p);
+	p->prio = rt_mutex_getprio(p);
+
 	set_load_weight(p);
 }
 


