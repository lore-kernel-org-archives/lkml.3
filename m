Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874AbaILNlV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 09:41:21 -0400
Received: from relay.parallels.com ([195.214.232.42]:35600 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277AbaILNlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 09:41:19 -0400
Message-ID: <1410529276.3569.24.camel@tkhai>
Subject: [PATCH 2/5] sched/fair: cleanup: Remove useless assignment in
 select_task_rq_fair()
From: Kirill Tkhai <ktkhai@parallels.com>
To: <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        <tkhai@yandex.ru>
Date: Fri, 12 Sep 2014 17:41:16 +0400
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


new_cpu is reassigned below, so we do not need this here.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
---
 kernel/sched/fair.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index be9e97b..3d1c08a 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4513,11 +4513,8 @@ select_task_rq_fair(struct task_struct *p, int prev_cpu, int sd_flag, int wake_f
 	if (p->nr_cpus_allowed == 1)
 		return prev_cpu;
 
-	if (sd_flag & SD_BALANCE_WAKE) {
-		if (cpumask_test_cpu(cpu, tsk_cpus_allowed(p)))
-			want_affine = 1;
-		new_cpu = prev_cpu;
-	}
+	if (sd_flag & SD_BALANCE_WAKE)
+		want_affine = cpumask_test_cpu(cpu, tsk_cpus_allowed(p));
 
 	rcu_read_lock();
 	for_each_domain(cpu, tmp) {



