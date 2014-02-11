Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894AbaBKJSM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 04:18:12 -0500
Received: from www.linutronix.de ([62.245.132.108]:39799 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbaBKJSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 04:18:10 -0500
Date: Tue, 11 Feb 2014 10:17:58 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/6 v2] sched: Init idle->on_rq in init_idle()
Message-ID: <20140211091758.GA19477@linutronix.de>
References: <1391803122-4425-1-git-send-email-bigeasy@linutronix.de>
 <1391803122-4425-2-git-send-email-bigeasy@linutronix.de>
 <20140207210905.GV5002@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140207210905.GV5002@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The init task is state TASK_RUNNING and on_irq should be set to 1. It won't
be set by scheduler because the idle task is never woken up, it is always the
task we fall back to if there is no other task pending.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[bigeasy: add patch description]
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
v1..v2: add patch description

 kernel/sched/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b46131e..64f75f9 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4473,6 +4473,7 @@ void init_idle(struct task_struct *idle, int cpu)
 	rcu_read_unlock();
 
 	rq->curr = rq->idle = idle;
+	idle->on_rq = 1;
 #if defined(CONFIG_SMP)
 	idle->on_cpu = 1;
 #endif
-- 
1.9.rc1
