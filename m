Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751509Ab3CAJLS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 04:11:18 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:2446 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750799Ab3CAJLQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 04:11:16 -0500
X-IronPort-AV: E=Sophos;i="4.84,760,1355068800"; 
   d="scan'208";a="6793627"
From: liguang <lig.fnst@cn.fujitsu.com>
To: luciarosculete@gmail.com, jkosina@suse.cz, linux-kernel@vger.kernel.org
Cc: liguang <lig.fnst@cn.fujitsu.com>
Subject: [PATCH 1/2] semaphore: give an unlikely for down's timeout
Date: Fri, 1 Mar 2013 17:03:47 +0800
Message-Id: <1362128628-18457-1-git-send-email-lig.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.2.5
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/01 17:03:18,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/01 17:03:20,
	Serialize complete at 2013/03/01 17:03:20
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
---
 kernel/semaphore.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/semaphore.c b/kernel/semaphore.c
index 4567fc0..9c7017d 100644
--- a/kernel/semaphore.c
+++ b/kernel/semaphore.c
@@ -214,7 +214,7 @@ static inline int __sched __down_common(struct semaphore *sem, long state,
 	for (;;) {
 		if (signal_pending_state(state, task))
 			goto interrupted;
-		if (timeout <= 0)
+		if (unlikely(timeout <= 0))
 			goto timed_out;
 		__set_task_state(task, state);
 		raw_spin_unlock_irq(&sem->lock);
-- 
1.7.2.5

