Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934476AbaJ1Dzm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:55:42 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:34375 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932743AbaJ1Dzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:55:39 -0400
From: Yao Dongdong <yaodongdong@huawei.com>
To: <peterz@infradead.org>, <mingo@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <srikar@linux.vnet.ibm.com>,
        <yaodongdong@huawei.com>
Subject: [PATCH resend] sched:check if got a shallowest_idle_cpu before search for least_loaded_cpu
Date: Tue, 28 Oct 2014 04:08:06 +0000
Message-ID: <1414469286-6023-1-git-send-email-yaodongdong@huawei.com>
X-Mailer: git-send-email 1.8.3.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.189]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020202.544F1308.00B1,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 6b8cb5b1e0010824164ca1a1987f65a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Idle cpu is idler than non-idle cpu, so we needn't search for least_loaded_cpu
after we have found an idle cpu.

Signed-off-by: Yao Dongdong <yaodongdong@huawei.com>
Reviewed-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
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
-		} else {
+		} else if (shallowest_idle_cpu == -1) {
 			load = weighted_cpuload(i);
 			if (load < min_load || (load == min_load && i == this_cpu)) {
 				min_load = load;
-- 
1.8.3.4

