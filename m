Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab3CKKE7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 06:04:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38256 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748Ab3CKKE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 06:04:58 -0400
Date: Mon, 11 Mar 2013 03:03:28 -0700
From: tip-bot for Li Zefan <tipbot@zytor.com>
Message-ID: <tip-b719203b846284e77f5c50fca04b458b6484aeae@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, fengguang.wu@intel.com,
        lizefan@huawei.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, fengguang.wu@intel.com,
        lizefan@huawei.com
In-Reply-To: <5137F4BA.2060101@huawei.com>
References: <5137F4BA.2060101@huawei.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix update_group_power()
  prototype placement to fix build warning when !CONFIG_SMP
Git-Commit-ID: b719203b846284e77f5c50fca04b458b6484aeae
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 11 Mar 2013 03:03:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b719203b846284e77f5c50fca04b458b6484aeae
Gitweb:     http://git.kernel.org/tip/b719203b846284e77f5c50fca04b458b6484aeae
Author:     Li Zefan <lizefan@huawei.com>
AuthorDate: Thu, 7 Mar 2013 10:00:26 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 11 Mar 2013 09:07:24 +0100

sched: Fix update_group_power() prototype placement to fix build warning when !CONFIG_SMP

All warnings:

   In file included from kernel/sched/core.c:85:0:
   kernel/sched/sched.h:1036:39: warning: 'struct sched_domain' declared inside parameter list
   kernel/sched/sched.h:1036:39: warning: its scope is only this definition or declaration, which is probably not what you want

It's because struct sched_domain is defined inside #if CONFIG_SMP,
while update_group_power() is declared unconditionally.

Fix this warning by declaring update_group_power() only if
CONFIG_SMP=n.

Build tested with CONFIG_SMP enabled and then disabled.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Li Zefan <lizefan@huawei.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/5137F4BA.2060101@huawei.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/sched.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 30bebb9..3bd15a4 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1026,6 +1026,8 @@ extern const struct sched_class idle_sched_class;
 
 #ifdef CONFIG_SMP
 
+extern void update_group_power(struct sched_domain *sd, int cpu);
+
 extern void trigger_load_balance(struct rq *rq, int cpu);
 extern void idle_balance(int this_cpu, struct rq *this_rq);
 
@@ -1040,7 +1042,6 @@ static inline void idle_balance(int cpu, struct rq *rq)
 extern void sysrq_sched_debug_show(void);
 extern void sched_init_granularity(void);
 extern void update_max_interval(void);
-extern void update_group_power(struct sched_domain *sd, int cpu);
 extern int update_runtime(struct notifier_block *nfb, unsigned long action, void *hcpu);
 extern void init_sched_rt_class(void);
 extern void init_sched_fair_class(void);
