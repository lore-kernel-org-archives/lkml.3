Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916AbaILNmH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 09:42:07 -0400
Received: from relay.parallels.com ([195.214.232.42]:35706 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754750AbaILNmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 09:42:05 -0400
Message-ID: <1410529321.3569.26.camel@tkhai>
Subject: [PATCH 4/5] sched/rt: Remove useless if from cleanup
 pick_next_task_rt()
From: Kirill Tkhai <ktkhai@parallels.com>
To: <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        <tkhai@yandex.ru>
Date: Fri, 12 Sep 2014 17:42:01 +0400
In-Reply-To: <20140912132709.26840.4893.stgit@tkhai>
References: <20140912132709.26840.4893.stgit@tkhai>
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


_pick_next_task_rt() never returns NULL.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
---
 kernel/sched/rt.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 4feac8f..2e6a774 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1468,8 +1468,7 @@ pick_next_task_rt(struct rq *rq, struct task_struct *prev)
 	p = _pick_next_task_rt(rq);
 
 	/* The running task is never eligible for pushing */
-	if (p)
-		dequeue_pushable_task(rq, p);
+	dequeue_pushable_task(rq, p);
 
 	set_post_schedule(rq);
 



