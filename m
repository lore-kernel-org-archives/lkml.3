Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964924Ab3GLNak (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 09:30:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59594 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964802Ab3GLNa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 09:30:26 -0400
Date: Fri, 12 Jul 2013 06:29:49 -0700
From: tip-bot for Kirill Tkhai <tipbot@zytor.com>
Message-ID: <tip-cedce3e730833d26a37826a96e1905b6ef387df9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rostedt@goodmis.org, peterz@infradead.org, tkhai@yandex.ru,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, peterz@infradead.org, tkhai@yandex.ru,
        tglx@linutronix.de
In-Reply-To: <512421372963700@web25f.yandex.ru>
References: <512421372963700@web25f.yandex.ru>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/__wake_up_sync_key():
  Fix nr_exclusive tasks which lead to WF_SYNC clearing
Git-Commit-ID: cedce3e730833d26a37826a96e1905b6ef387df9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 12 Jul 2013 06:29:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cedce3e730833d26a37826a96e1905b6ef387df9
Gitweb:     http://git.kernel.org/tip/cedce3e730833d26a37826a96e1905b6ef387df9
Author:     Kirill Tkhai <tkhai@yandex.ru>
AuthorDate: Thu, 4 Jul 2013 22:48:20 +0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 12 Jul 2013 13:54:03 +0200

sched/__wake_up_sync_key(): Fix nr_exclusive tasks which lead to WF_SYNC clearing

Only one task can replace the waker.

Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
CC: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/512421372963700@web25f.yandex.ru
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 0d8eb45..f737871 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2660,7 +2660,7 @@ void __wake_up_sync_key(wait_queue_head_t *q, unsigned int mode,
 	if (unlikely(!q))
 		return;
 
-	if (unlikely(!nr_exclusive))
+	if (unlikely(nr_exclusive != 1))
 		wake_flags = 0;
 
 	spin_lock_irqsave(&q->lock, flags);
