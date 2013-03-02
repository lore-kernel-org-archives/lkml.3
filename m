Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741Ab3CBD33 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 22:29:29 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:65246 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747Ab3CBDZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 22:25:03 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com
Cc: axboe@kernel.dk, jmoyer@redhat.com, zab@redhat.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 20/31] workqueue: add pool ID to the names of unbound kworkers
Date: Fri,  1 Mar 2013 19:24:11 -0800
Message-Id: <1362194662-2344-21-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362194662-2344-1-git-send-email-tj@kernel.org>
References: <1362194662-2344-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are gonna be multiple unbound pools.  Include pool ID in the
name of unbound kworkers.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 95a3dcc..1695bd6 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1705,7 +1705,8 @@ static struct worker *create_worker(struct worker_pool *pool)
 					"kworker/%d:%d%s", pool->cpu, id, pri);
 	else
 		worker->task = kthread_create(worker_thread, worker,
-					      "kworker/u:%d%s", id, pri);
+					      "kworker/%du:%d%s",
+					      pool->id, id, pri);
 	if (IS_ERR(worker->task))
 		goto fail;
 
-- 
1.8.1.2

