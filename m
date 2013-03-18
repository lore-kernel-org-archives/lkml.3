Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824Ab3CRLAs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 07:00:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34030 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800Ab3CRLAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 07:00:45 -0400
Date: Mon, 18 Mar 2013 03:59:34 -0700
From: tip-bot for Andrei Epure <tipbot@zytor.com>
Message-ID: <tip-1bf08230f745e48fea9c18ee34a73581631fe7c9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        epure.andrei@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        epure.andrei@gmail.com, tglx@linutronix.de
In-Reply-To: <1363115544-1964-1-git-send-email-epure.andrei@gmail.com>
References: <1363115544-1964-1-git-send-email-epure.andrei@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix variable name misnomer, add comments
Git-Commit-ID: 1bf08230f745e48fea9c18ee34a73581631fe7c9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 18 Mar 2013 03:59:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1bf08230f745e48fea9c18ee34a73581631fe7c9
Gitweb:     http://git.kernel.org/tip/1bf08230f745e48fea9c18ee34a73581631fe7c9
Author:     Andrei Epure <epure.andrei@gmail.com>
AuthorDate: Tue, 12 Mar 2013 21:12:24 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 14 Mar 2013 08:22:29 +0100

sched: Fix variable name misnomer, add comments

The min_vruntime variable actually stores the maximum value.
The added comment was taken from place_entity function.

Signed-off-by: Andrei Epure <epure.andrei@gmail.com>
Cc: peterz@infradead.org
Link: http://lkml.kernel.org/r/1363115544-1964-1-git-send-email-epure.andrei@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 22bd9e6..539760e 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -431,13 +431,13 @@ void account_cfs_rq_runtime(struct cfs_rq *cfs_rq, unsigned long delta_exec);
  * Scheduling class tree data structure manipulation methods:
  */
 
-static inline u64 max_vruntime(u64 min_vruntime, u64 vruntime)
+static inline u64 max_vruntime(u64 max_vruntime, u64 vruntime)
 {
-	s64 delta = (s64)(vruntime - min_vruntime);
+	s64 delta = (s64)(vruntime - max_vruntime);
 	if (delta > 0)
-		min_vruntime = vruntime;
+		max_vruntime = vruntime;
 
-	return min_vruntime;
+	return max_vruntime;
 }
 
 static inline u64 min_vruntime(u64 min_vruntime, u64 vruntime)
@@ -473,6 +473,7 @@ static void update_min_vruntime(struct cfs_rq *cfs_rq)
 			vruntime = min_vruntime(vruntime, se->vruntime);
 	}
 
+	/* ensure we never gain time by being placed backwards. */
 	cfs_rq->min_vruntime = max_vruntime(cfs_rq->min_vruntime, vruntime);
 #ifndef CONFIG_64BIT
 	smp_wmb();
