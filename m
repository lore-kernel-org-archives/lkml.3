Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996Ab3L3No6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 08:44:58 -0500
Received: from mail-we0-f170.google.com ([74.125.82.170]:56031 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755604Ab3L3No5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 08:44:57 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: mingo@redhat.com, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: [PATCH 0/7] sched: cleanup trigger_load_balance
Date: Mon, 30 Dec 2013 14:44:46 +0100
Message-Id: <1388411093-3413-1-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset does a cleanup on the parameters passed from the function
'trigger_load_balance' to the underneath functions.

The cpu is passed as parameter to the different functions as well as the struct
rq but this one contains already the cpu information. Moreover, in the call
stack for these functions, we have the struct rq retrieved from the cpu, and then
the cpu retrieve from the struct rq, etc ...

The patchset unifies all these functions to have a struct rq parameter and
removes the pointless parameters.

-static inline int find_new_ilb(int call_cpu)
+static inline int find_new_ilb(void)

-static void nohz_balancer_kick(int cpu)
+static void nohz_balancer_kick(void)

-static void rebalance_domains(int cpu, enum cpu_idle_type idle)
+static void rebalance_domains(struct rq *rq, enum cpu_idle_type idle)

-static void nohz_idle_balance(int this_cpu, enum cpu_idle_type idle)
+static void nohz_idle_balance(struct rq *this_rq, enum cpu_idle_type idle)

-static inline int nohz_kick_needed(struct rq *rq, int cpu)
+static inline int nohz_kick_needed(struct rq *rq)

-static inline int on_null_domain(int cpu)
+static inline int on_null_domain(struct rq *rq)

Daniel Lezcano (7):
  sched: reduce nohz_kick_needed parameters
  sched: pass struct rq to on_null_domain function
  sched: remove unused parameter for find_new_ilb
  sched: remove unused parameter in nohz_balancer_kick function
  sched: pass struct rq to rebalance_domains function
  sched: pass struct rq to nohz_idle_balance function
  sched: factor out on_null_domain check in trigger_load_balance
    function

 kernel/sched/fair.c |   45 ++++++++++++++++++++++-----------------------
 1 file changed, 22 insertions(+), 23 deletions(-)

-- 
1.7.9.5

