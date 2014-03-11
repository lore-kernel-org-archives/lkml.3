Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575AbaCKMkt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 08:40:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35740 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755238AbaCKMkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 08:40:46 -0400
Date: Tue, 11 Mar 2014 05:40:02 -0700
From: tip-bot for Kirill Tkhai <tipbot@zytor.com>
Message-ID: <tip-35805ff8f4fc535ac85330170d3c56829c87c677@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, ktkhai@parallels.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, ktkhai@parallels.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1394118975.19290.104.camel@tkhai>
References: <1394118975.19290.104.camel@tkhai>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/fair: Fix endless loop in idle_balance()
Git-Commit-ID: 35805ff8f4fc535ac85330170d3c56829c87c677
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

Commit-ID:  35805ff8f4fc535ac85330170d3c56829c87c677
Gitweb:     http://git.kernel.org/tip/35805ff8f4fc535ac85330170d3c56829c87c677
Author:     Kirill Tkhai <ktkhai@parallels.com>
AuthorDate: Thu, 6 Mar 2014 19:16:15 +0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 11 Mar 2014 12:05:41 +0100

sched/fair: Fix endless loop in idle_balance()

Check for fair tasks number to decide, that we've pulled a task.
rq's nr_running may contain throttled RT tasks.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1394118975.19290.104.camel@tkhai
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 10db4a8..f1eedae 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6710,7 +6710,7 @@ static int idle_balance(struct rq *this_rq)
 	 * While browsing the domains, we released the rq lock.
 	 * A task could have be enqueued in the meantime
 	 */
-	if (this_rq->nr_running && !pulled_task) {
+	if (this_rq->cfs.h_nr_running && !pulled_task) {
 		pulled_task = 1;
 		goto out;
 	}
