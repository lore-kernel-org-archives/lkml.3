Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221Ab3AXUpL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:45:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35020 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755539Ab3AXUpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:45:04 -0500
Date: Thu, 24 Jan 2013 12:44:47 -0800
From: tip-bot for Viresh Kumar <viresh.kumar@linaro.org>
Message-ID: <tip-16c8f1c72ece3871a6c93003cd888fc2d003a7eb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        viresh.kumar@linaro.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        viresh.kumar@linaro.org, tglx@linutronix.de
In-Reply-To: <ae59db1945518d6f6250920d46eb1f1a9cc0024e.1352361704.git.viresh.kumar@linaro.org>
References: <ae59db1945518d6f6250920d46eb1f1a9cc0024e.1352361704.git.viresh.kumar@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/fair: Set se->
 vruntime directly in place_entity()
Git-Commit-ID: 16c8f1c72ece3871a6c93003cd888fc2d003a7eb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 24 Jan 2013 12:44:52 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  16c8f1c72ece3871a6c93003cd888fc2d003a7eb
Gitweb:     http://git.kernel.org/tip/16c8f1c72ece3871a6c93003cd888fc2d003a7eb
Author:     Viresh Kumar <viresh.kumar@linaro.org>
AuthorDate: Thu, 8 Nov 2012 13:33:46 +0530
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 24 Jan 2013 18:06:11 +0100

sched/fair: Set se->vruntime directly in place_entity()

We are first storing the new vruntime in a variable and then
storing it in se->vruntime. Simply update se->vruntime directly.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-dev@lists.linaro.org
Cc: patches@linaro.org
Cc: peterz@infradead.org
Link: http://lkml.kernel.org/r/ae59db1945518d6f6250920d46eb1f1a9cc0024e.1352361704.git.viresh.kumar@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index a7a19ff..8dbee9f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1680,9 +1680,7 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 	}
 
 	/* ensure we never gain time by being placed backwards. */
-	vruntime = max_vruntime(se->vruntime, vruntime);
-
-	se->vruntime = vruntime;
+	se->vruntime = max_vruntime(se->vruntime, vruntime);
 }
 
 static void check_enqueue_throttle(struct cfs_rq *cfs_rq);
