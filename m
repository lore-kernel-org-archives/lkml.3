Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738Ab3F0JDl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 05:03:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46101 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753672Ab3F0JDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 05:03:37 -0400
Date: Thu, 27 Jun 2013 02:03:08 -0700
From: tip-bot for Alex Shi <tipbot@zytor.com>
Message-ID: <tip-a9dc5d0e33c677619e4b97a38c23db1a42857905@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, alex.shi@intel.com, vincent.guittot@linaro.org,
        tglx@linutronix.de, fengguang.wu@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, alex.shi@intel.com, vincent.guittot@linaro.org,
        tglx@linutronix.de, fengguang.wu@intel.com
In-Reply-To: <1371694737-29336-14-git-send-email-alex.shi@intel.com>
References: <1371694737-29336-14-git-send-email-alex.shi@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Change get_rq_runnable_load()
  to static and inline
Git-Commit-ID: a9dc5d0e33c677619e4b97a38c23db1a42857905
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 27 Jun 2013 02:03:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a9dc5d0e33c677619e4b97a38c23db1a42857905
Gitweb:     http://git.kernel.org/tip/a9dc5d0e33c677619e4b97a38c23db1a42857905
Author:     Alex Shi <alex.shi@intel.com>
AuthorDate: Thu, 20 Jun 2013 10:18:57 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 27 Jun 2013 10:07:44 +0200

sched: Change get_rq_runnable_load() to static and inline

Based-on-patch-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Alex Shi <alex.shi@intel.com>
Tested-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1371694737-29336-14-git-send-email-alex.shi@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/proc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/proc.c b/kernel/sched/proc.c
index ce5cd48..16f5a30 100644
--- a/kernel/sched/proc.c
+++ b/kernel/sched/proc.c
@@ -502,12 +502,12 @@ static void __update_cpu_load(struct rq *this_rq, unsigned long this_load,
 }
 
 #ifdef CONFIG_SMP
-unsigned long get_rq_runnable_load(struct rq *rq)
+static inline unsigned long get_rq_runnable_load(struct rq *rq)
 {
 	return rq->cfs.runnable_load_avg;
 }
 #else
-unsigned long get_rq_runnable_load(struct rq *rq)
+static inline unsigned long get_rq_runnable_load(struct rq *rq)
 {
 	return rq->load.weight;
 }
