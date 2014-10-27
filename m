Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217AbaJ0DNh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 23:13:37 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:1976 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbaJ0DNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 23:13:36 -0400
Message-ID: <544DB84D.1030504@huawei.com>
Date: Mon, 27 Oct 2014 11:13:17 +0800
From: Yao Dongdong <yaodongdong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
CC: LKML <linux-kernel@vger.kernel.org>, <yaodongdong@huawei.com>
Subject: [PATCH] sched:skip loop non-idle cpus after find an idle cpu while
 find_idlest_cpu
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.110.51.36]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Idle cpu is idler than non-idle cpu, so we needn't loop non-idle cpus after find an idle cpu.

Signed-off-by:yaodongdong@huawei.com

---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 0b069bf..2445a23 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4446,7 +4446,7 @@ find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
                                latest_idle_timestamp = rq->idle_stamp;
                                shallowest_idle_cpu = i;
                        }
-               } else {
+               } else if (shallowest_idle_cpu == -1) {
                        load = weighted_cpuload(i);
                        if (load < min_load || (load == min_load && i == this_cpu)) {
                                min_load = load;
--
1.8.0.1

