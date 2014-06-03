Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932472AbaFCH2i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 03:28:38 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:59594 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932080AbaFCH2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 03:28:37 -0400
X-IronPort-AV: E=Sophos;i="4.98,963,1392134400"; 
   d="scan'208";a="31368534"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH] workqueue: sanity check pool->cpu in wq_worker_sleeping()
Date: Tue, 3 Jun 2014 15:33:08 +0800
Message-ID: <1401780788-12297-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In theory, pool->cpu is equals to @cpu in wq_worker_sleeping() after
worker->flags is checked.

And "pool->cpu != cpu" sanity check will help us if something wrong.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 9f53abd..61381a2 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -843,7 +843,7 @@ struct task_struct *wq_worker_sleeping(struct task_struct *task, int cpu)
 	pool = worker->pool;
 
 	/* this can only happen on the local cpu */
-	if (WARN_ON_ONCE(cpu != raw_smp_processor_id()))
+	if (WARN_ON_ONCE(cpu != raw_smp_processor_id() || pool->cpu != cpu))
 		return NULL;
 
 	/*
-- 
1.7.4.4

