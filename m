Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbbAXOEW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 09:04:22 -0500
Received: from mail-qg0-f42.google.com ([209.85.192.42]:48828 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434AbbAXOER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 09:04:17 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 18/32] workqueue: use %*pb[l] to format bitmaps including cpumasks and nodemasks
Date: Sat, 24 Jan 2015 09:03:24 -0500
Message-Id: <1422108218-25398-19-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1422108218-25398-1-git-send-email-tj@kernel.org>
References: <1422108218-25398-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

printk and friends can now formap bitmaps using '%*pb[l]'.  cpumask
and nodemask also provide cpumask_pr_args() and nodemask_pr_args()
respectively which can be used to generate the two printf arguments
necessary to format the specified cpu/nodemask.

This patch is dependent on the following two patches.

 lib/vsprintf: implement bitmap printing through '%*pb[l]'
 cpumask, nodemask: implement cpumask/nodemask_pr_args()

Please wait till the forementioned patches are merged to mainline
before applying to subsystem trees.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index beeeac9..f288493 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3083,10 +3083,9 @@ static ssize_t wq_cpumask_show(struct device *dev,
 	int written;
 
 	mutex_lock(&wq->mutex);
-	written = cpumask_scnprintf(buf, PAGE_SIZE, wq->unbound_attrs->cpumask);
+	written = scnprintf(buf, PAGE_SIZE, "%*pb\n",
+			    cpumask_pr_args(wq->unbound_attrs->cpumask));
 	mutex_unlock(&wq->mutex);
-
-	written += scnprintf(buf + written, PAGE_SIZE - written, "\n");
 	return written;
 }
 
-- 
2.1.0

