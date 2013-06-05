Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707Ab3FEHLo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 03:11:44 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:40988 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508Ab3FEHLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 03:11:42 -0400
Message-ID: <51AEE4A7.6050808@linux.vnet.ibm.com>
Date: Wed, 05 Jun 2013 15:11:35 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] workqueue: add a check point in pwq_activate_delayed_work()
References: <51AEE452.8080605@linux.vnet.ibm.com>
In-Reply-To: <51AEE452.8080605@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060518-3568-0000-0000-000003B8DEA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_work_pwq() is possible to return NULL, add a check point for that in
the context inside pwq_activate_delayed_work().

CC: Tejun Heo <tj@kernel.org>
Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 kernel/workqueue.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index ee8e29a..ea2ec38 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1072,6 +1072,7 @@ static void put_pwq_unlocked(struct pool_workqueue *pwq)
 static void pwq_activate_delayed_work(struct work_struct *work)
 {
 	struct pool_workqueue *pwq = get_work_pwq(work);
+	BUG_ON(!pwq);
 
 	trace_workqueue_activate_work(work);
 	move_linked_works(work, &pwq->pool->worklist, NULL);
-- 
1.7.4.1

