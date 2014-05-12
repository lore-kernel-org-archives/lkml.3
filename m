Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158AbaELH7Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 03:59:16 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:17384 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102AbaELH7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 03:59:14 -0400
From: "xiaofeng.yan" <xiaofeng.yan@huawei.com>
To: <linux-kernel@vger.kernel.org>, <mingo@redhat.com>, <peterz@infradead.org>
CC: <xiaofeng.yan2012@gmail.com>, "xiaofeng.yan" <xiaofeng.yan@huawei.com>
Subject: [PATCH] sched/rt: Fix a comment in deadline.c
Date: Mon, 12 May 2014 07:41:17 +0000
Message-ID: <1399880477-23376-1-git-send-email-xiaofeng.yan@huawei.com>
X-Mailer: git-send-email 1.8.3.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EDF use sched_setattr() instead of sched_setscheduler().

Signed-off-by: xiaofeng.yan <xiaofeng.yan@huawei.com>
---
 kernel/sched/deadline.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index b080957..558e41a 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -520,7 +520,7 @@ static enum hrtimer_restart dl_task_timer(struct hrtimer *timer)
 	 * We need to take care of a possible races here. In fact, the
 	 * task might have changed its scheduling policy to something
 	 * different from SCHED_DEADLINE or changed its reservation
-	 * parameters (through sched_setscheduler()).
+	 * parameters (through sched_setattr()).
 	 */
 	if (!dl_task(p) || dl_se->dl_new)
 		goto unlock;
-- 
1.7.9.5

