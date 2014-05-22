Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631AbaEVMaO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 08:30:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51379 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194AbaEVMaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 08:30:10 -0400
Date: Thu, 22 May 2014 05:28:48 -0700
From: "tip-bot for xiaofeng.yan" <tipbot@zytor.com>
Message-ID: <tip-4027d080854d1be96ef134a1c3024d5276114db6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, xiaofeng.yan@huawei.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, xiaofeng.yan@huawei.com
In-Reply-To: <1399605687-18094-1-git-send-email-xiaofeng.yan@huawei.com>
References: <1399605687-18094-1-git-send-email-xiaofeng.yan@huawei.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/rt: Fix 'struct sched_dl_entity'
  and dl_task_time() comments, to match the current upstream code
Git-Commit-ID: 4027d080854d1be96ef134a1c3024d5276114db6
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

Commit-ID:  4027d080854d1be96ef134a1c3024d5276114db6
Gitweb:     http://git.kernel.org/tip/4027d080854d1be96ef134a1c3024d5276114db6
Author:     xiaofeng.yan <xiaofeng.yan@huawei.com>
AuthorDate: Fri, 9 May 2014 03:21:27 +0000
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 22 May 2014 11:16:37 +0200

sched/rt: Fix 'struct sched_dl_entity' and dl_task_time() comments, to match the current upstream code

Signed-off-by: xiaofeng.yan <xiaofeng.yan@huawei.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1399605687-18094-1-git-send-email-xiaofeng.yan@huawei.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched.h   | 4 ++--
 kernel/sched/deadline.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 725eef1..0f91d00 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1175,8 +1175,8 @@ struct sched_dl_entity {
 
 	/*
 	 * Original scheduling parameters. Copied here from sched_attr
-	 * during sched_setscheduler2(), they will remain the same until
-	 * the next sched_setscheduler2().
+	 * during sched_setattr(), they will remain the same until
+	 * the next sched_setattr().
 	 */
 	u64 dl_runtime;		/* maximum runtime for each instance	*/
 	u64 dl_deadline;	/* relative deadline of each instance	*/
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index e0a04ae..f9ca7d1 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -520,7 +520,7 @@ static enum hrtimer_restart dl_task_timer(struct hrtimer *timer)
 	 * We need to take care of a possible races here. In fact, the
 	 * task might have changed its scheduling policy to something
 	 * different from SCHED_DEADLINE or changed its reservation
-	 * parameters (through sched_setscheduler()).
+	 * parameters (through sched_setattr()).
 	 */
 	if (!dl_task(p) || dl_se->dl_new)
 		goto unlock;
