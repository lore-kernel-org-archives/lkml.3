Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687AbaAMP4i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 10:56:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60879 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbaAMP4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 10:56:32 -0500
Date: Mon, 13 Jan 2014 07:55:59 -0800
From: tip-bot for Daniel Lezcano <tipbot@zytor.com>
Message-ID: <tip-3dd0337d6df7d54c82ecebfa6485040f686bf8b1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        preeti@linux.vnet.ibm.com, peterz@infradead.org, tglx@linutronix.de,
        daniel.lezcano@linaro.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        preeti@linux.vnet.ibm.com, peterz@infradead.org, tglx@linutronix.de,
        daniel.lezcano@linaro.org
In-Reply-To: <1389008085-9069-5-git-send-email-daniel.lezcano@linaro.org>
References: <1389008085-9069-5-git-send-email-daniel.lezcano@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Remove unused parameter from find_new_ilb
 ()
Git-Commit-ID: 3dd0337d6df7d54c82ecebfa6485040f686bf8b1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 13 Jan 2014 07:56:05 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3dd0337d6df7d54c82ecebfa6485040f686bf8b1
Gitweb:     http://git.kernel.org/tip/3dd0337d6df7d54c82ecebfa6485040f686bf8b1
Author:     Daniel Lezcano <daniel.lezcano@linaro.org>
AuthorDate: Mon, 6 Jan 2014 12:34:41 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 13 Jan 2014 13:47:29 +0100

sched: Remove unused parameter from find_new_ilb()

The 'call_cpu' is never used in the function. Remove it.

Reviewed-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1389008085-9069-5-git-send-email-daniel.lezcano@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index fc0afc5..5fda3c4 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6509,7 +6509,7 @@ static struct {
 	unsigned long next_balance;     /* in jiffy units */
 } nohz ____cacheline_aligned;
 
-static inline int find_new_ilb(int call_cpu)
+static inline int find_new_ilb(void)
 {
 	int ilb = cpumask_first(nohz.idle_cpus_mask);
 
@@ -6530,7 +6530,7 @@ static void nohz_balancer_kick(int cpu)
 
 	nohz.next_balance++;
 
-	ilb_cpu = find_new_ilb(cpu);
+	ilb_cpu = find_new_ilb();
 
 	if (ilb_cpu >= nr_cpu_ids)
 		return;
