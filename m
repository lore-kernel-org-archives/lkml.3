Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879Ab3GDSsZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 14:48:25 -0400
Received: from forward13.mail.yandex.net ([95.108.130.120]:36624 "EHLO
	forward13.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954Ab3GDSsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 14:48:24 -0400
From: Kirill Tkhai <tkhai@yandex.ru>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Subject: [PATCH] sched, __wake_up_sync_key: Fix nr_exclusive tasks which lead to WF_SYNC clearing
MIME-Version: 1.0
Message-Id: <512421372963700@web25f.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Thu, 04 Jul 2013 22:48:20 +0400
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only one task can replace waker.

Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 9d06ad6..4ff7404 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2658,7 +2658,7 @@ void __wake_up_sync_key(wait_queue_head_t *q, unsigned int mode,
 	if (unlikely(!q))
 		return;
 
-	if (unlikely(!nr_exclusive))
+	if (unlikely(nr_exclusive != 1))
 		wake_flags = 0;
 
 	spin_lock_irqsave(&q->lock, flags);
