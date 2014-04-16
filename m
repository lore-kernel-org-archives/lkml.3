Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291AbaDPFde (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 01:33:34 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:60074 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897AbaDPFdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 01:33:32 -0400
From: Daeseok Youn <daeseok.youn@gmail.com>
To: tj@kernel.org
Cc: laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] workqueue: jumps to use_dfl_pwq if the target cpumask is equal wq's
Date: Wed, 16 Apr 2014 14:33:27 +0900
Message-ID: <4114063.RkqNFBsH49@daeseok-laptop.cloud.net>
User-Agent: KMail/4.8.5 (Linux/3.2.0-58-generic; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Replace blocks of code which checks whether pwq is defalut with
jump to use_dfl_pwq. It is same as before.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 kernel/workqueue.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 3150b21..0679854 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -4087,10 +4087,7 @@ static void wq_update_unbound_numa(struct workqueue_struct *wq, int cpu,
 		if (cpumask_equal(cpumask, pwq->pool->attrs->cpumask))
 			goto out_unlock;
 	} else {
-		if (pwq == wq->dfl_pwq)
-			goto out_unlock;
-		else
-			goto use_dfl_pwq;
+		goto use_dfl_pwq;
 	}
 
 	mutex_unlock(&wq->mutex);
-- 
1.7.4.4


