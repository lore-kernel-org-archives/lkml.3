Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443AbaL2Gjy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 01:39:54 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:2417 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbaL2Gji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 01:39:38 -0500
From: Yao Dongdong <yaodongdong@huawei.com>
To: <mingo@redhat.com>, <peterz@infradead.org>
CC: <linux-kernel@vger.kernel.org>, <lizefan@huawei.com>
Subject: [PATCH] sched/core: remove check of p->sched_class
Date: Mon, 29 Dec 2014 14:41:43 +0800
Message-ID: <1419835303-28958-1-git-send-email-yaodongdong@huawei.com>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.190]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020202.54A0F736.00F5,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: e25fba76a3d590614fae752a81f71516
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Search all usage of p->sched_class in sched/core.c, no one check it
before use, so it seems that every task must belong to one sched_class.

Signed-off-by: Yao Dongdong <yaodongdong@huawei.com>
---
 kernel/sched/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b5797b7..bdab49b 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4740,7 +4740,7 @@ static struct rq *move_queued_task(struct task_struct *p, int new_cpu)
 
 void do_set_cpus_allowed(struct task_struct *p, const struct cpumask *new_mask)
 {
-	if (p->sched_class && p->sched_class->set_cpus_allowed)
+	if (p->sched_class->set_cpus_allowed)
 		p->sched_class->set_cpus_allowed(p, new_mask);
 
 	cpumask_copy(&p->cpus_allowed, new_mask);
-- 
2.1.0

