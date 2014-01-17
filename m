Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512AbaAQQpJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 11:45:09 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:60221 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbaAQQpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 11:45:05 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: peterz@infradead.org
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, alex.shi@linaro.org
Subject: [PATCH 1/2] sched/deadline: Fix compilation error
Date: Fri, 17 Jan 2014 17:45:01 +0100
Message-Id: <1389977102-4420-1-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <52D95C5E.4070209@linaro.org>
References: <52D95C5E.4070209@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pick_next_task function prototype changed with the previous patches.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 kernel/sched/deadline.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 0de2482..db4fb9c 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -989,7 +989,7 @@ static struct sched_dl_entity *pick_next_dl_entity(struct rq *rq,
 	return rb_entry(left, struct sched_dl_entity, rb_node);
 }
 
-struct task_struct *pick_next_task_dl(struct rq *rq)
+struct task_struct *pick_next_task_dl(struct rq *rq, struct task_struct *prev)
 {
 	struct sched_dl_entity *dl_se;
 	struct task_struct *p;
-- 
1.7.9.5

