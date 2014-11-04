Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997AbaKDQNJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 11:13:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59562 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742AbaKDQNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 11:13:05 -0500
Date: Tue, 4 Nov 2014 08:12:12 -0800
From: tip-bot for Wanpeng Li <tipbot@zytor.com>
Message-ID: <tip-cad3bb32e181c286c46ec12b2deb1f26a6f9835d@git.kernel.org>
Cc: tglx@linutronix.de, wanpeng.li@linux.intel.com,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        peterz@infradead.org, mingo@kernel.org, ktkhai@parallels.com,
        juri.lelli@arm.com, hpa@zytor.com
Reply-To: torvalds@linux-foundation.org, tglx@linutronix.de,
        wanpeng.li@linux.intel.com, peterz@infradead.org,
        linux-kernel@vger.kernel.org, ktkhai@parallels.com, mingo@kernel.org,
        juri.lelli@arm.com, hpa@zytor.com
In-Reply-To: <1414708776-124078-6-git-send-email-wanpeng.li@linux.intel.com>
References: <1414708776-124078-6-git-send-email-wanpeng.li@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/deadline: Don'
 t check CONFIG_SMP in switched_from_dl()
Git-Commit-ID: cad3bb32e181c286c46ec12b2deb1f26a6f9835d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cad3bb32e181c286c46ec12b2deb1f26a6f9835d
Gitweb:     http://git.kernel.org/tip/cad3bb32e181c286c46ec12b2deb1f26a6f9835d
Author:     Wanpeng Li <wanpeng.li@linux.intel.com>
AuthorDate: Fri, 31 Oct 2014 06:39:36 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 4 Nov 2014 07:17:56 +0100

sched/deadline: Don't check CONFIG_SMP in switched_from_dl()

There are both UP and SMP version of pull_dl_task(), so don't need
to check CONFIG_SMP in switched_from_dl();

Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@arm.com>
Cc: Kirill Tkhai <ktkhai@parallels.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1414708776-124078-6-git-send-email-wanpeng.li@linux.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/deadline.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 362ab1f..f3d7776 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1637,7 +1637,6 @@ static void switched_from_dl(struct rq *rq, struct task_struct *p)
 
 	__dl_clear_params(p);
 
-#ifdef CONFIG_SMP
 	/*
 	 * Since this might be the only -deadline task on the rq,
 	 * this is the right place to try to pull some other one
@@ -1648,7 +1647,6 @@ static void switched_from_dl(struct rq *rq, struct task_struct *p)
 
 	if (pull_dl_task(rq))
 		resched_curr(rq);
-#endif
 }
 
 /*
