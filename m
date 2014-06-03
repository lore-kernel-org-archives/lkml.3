Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932430AbaFCH2N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 03:28:13 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:11852 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932080AbaFCH2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 03:28:10 -0400
X-IronPort-AV: E=Sophos;i="4.98,963,1392134400"; 
   d="scan'208";a="31368513"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH] workqueue: remove useless WARN_ON_ONCE()
Date: Tue, 3 Jun 2014 15:32:41 +0800
Message-ID: <1401780761-12229-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The @cpu is fetched via smp_processor_id() in this function,
so the check is useless.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 6b6e9f2..7dc6e66 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -4461,8 +4461,6 @@ static void wq_unbind_fn(struct work_struct *work)
 	struct worker *worker;
 
 	for_each_cpu_worker_pool(pool, cpu) {
-		WARN_ON_ONCE(cpu != smp_processor_id());
-
 		mutex_lock(&pool->attach_mutex);
 		spin_lock_irq(&pool->lock);
 
-- 
1.7.4.4

