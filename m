Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751611Ab3LLJwV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 04:52:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45826 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120Ab3LLJwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 04:52:16 -0500
Date: Thu, 12 Dec 2013 01:51:32 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-l8ng2m9uml6fhibln8wqpom7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, peterz@infradead.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched:
  Initialize power_orig for overlapping groups
Git-Commit-ID: 8e8339a3a1069141985daaa2521ba304509ddecd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 12 Dec 2013 01:51:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8e8339a3a1069141985daaa2521ba304509ddecd
Gitweb:     http://git.kernel.org/tip/8e8339a3a1069141985daaa2521ba304509ddecd
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 11 Dec 2013 11:09:53 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 11 Dec 2013 15:47:59 +0100

sched: Initialize power_orig for overlapping groups

Yinghai reported that he saw a /0 in sg_capacity on his EX parts.
Make sure to always initialize power_orig now that we actually use it.

Ideally build_sched_domains() -> init_sched_groups_power() would also
initialize this; but for some yet unexplained reason some setups seem
to miss updates there.

Reported-by: Yinghai Lu <yinghai@kernel.org>
Tested-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-l8ng2m9uml6fhibln8wqpom7@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index e85cda2..19af58f 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5112,6 +5112,7 @@ build_overlap_sched_groups(struct sched_domain *sd, int cpu)
 		 * die on a /0 trap.
 		 */
 		sg->sgp->power = SCHED_POWER_SCALE * cpumask_weight(sg_span);
+		sg->sgp->power_orig = sg->sgp->power;
 
 		/*
 		 * Make sure the first group of this domain contains the
