Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517Ab3EaMpB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 08:45:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57912 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756128Ab3EaMoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 08:44:55 -0400
Date: Fri, 31 May 2013 05:44:41 -0700
From: tip-bot for Kamalesh Babulal <tipbot@zytor.com>
Message-ID: <tip-0de358f1c2642710d41190b73fbc295e675c4ab8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fweisbec@gmail.com, kamalesh@linux.vnet.ibm.com, pjt@google.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        kamalesh@linux.vnet.ibm.com, fweisbec@gmail.com, pjt@google.com,
        tglx@linutronix.de
In-Reply-To: <1369904660-14169-1-git-send-email-kamalesh@linux.vnet.ibm.com>
References: <1369904660-14169-1-git-send-email-kamalesh@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/fair:
  Remove unused variable from expire_cfs_rq_runtime()
Git-Commit-ID: 0de358f1c2642710d41190b73fbc295e675c4ab8
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

Commit-ID:  0de358f1c2642710d41190b73fbc295e675c4ab8
Gitweb:     http://git.kernel.org/tip/0de358f1c2642710d41190b73fbc295e675c4ab8
Author:     Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
AuthorDate: Thu, 30 May 2013 14:34:20 +0530
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 31 May 2013 13:02:29 +0200

sched/fair: Remove unused variable from expire_cfs_rq_runtime()

Commit 78becc2709 ("sched: Use an accessor to read the rq clock")
introduces rq_clock(), which obsoletes the use of the "rq" variable
in expire_cfs_rq_runtime() and triggers this build warning:

  kernel/sched/fair.c: In function 'expire_cfs_rq_runtime':
  kernel/sched/fair.c:2159:13: warning: unused variable 'rq' [-Wunused-variable]

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Paul Turner <pjt@google.com>
Cc: peterz@infradead.org
Link: http://lkml.kernel.org/r/1369904660-14169-1-git-send-email-kamalesh@linux.vnet.ibm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 3ee1c2e..143dcdb 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2156,7 +2156,6 @@ static int assign_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 static void expire_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 {
 	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(cfs_rq->tg);
-	struct rq *rq = rq_of(cfs_rq);
 
 	/* if the deadline is ahead of our clock, nothing to do */
 	if (likely((s64)(rq_clock(rq_of(cfs_rq)) - cfs_rq->runtime_expires) < 0))
