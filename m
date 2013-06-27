Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab3F0JCS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 05:02:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46006 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458Ab3F0JCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 05:02:15 -0400
Date: Thu, 27 Jun 2013 02:01:39 -0700
From: tip-bot for Alex Shi <tipbot@zytor.com>
Message-ID: <tip-fa6bddeb14d59d701f846b174b59c9982e926e66@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, alex.shi@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, alex.shi@intel.com
In-Reply-To: <1371694737-29336-3-git-send-email-alex.shi@intel.com>
References: <1371694737-29336-3-git-send-email-alex.shi@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Move a few runnable tg variables into CONFIG_SMP
Git-Commit-ID: fa6bddeb14d59d701f846b174b59c9982e926e66
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 27 Jun 2013 02:01:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fa6bddeb14d59d701f846b174b59c9982e926e66
Gitweb:     http://git.kernel.org/tip/fa6bddeb14d59d701f846b174b59c9982e926e66
Author:     Alex Shi <alex.shi@intel.com>
AuthorDate: Thu, 20 Jun 2013 10:18:46 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 27 Jun 2013 10:07:29 +0200

sched: Move a few runnable tg variables into CONFIG_SMP

The following 2 variables are only used under CONFIG_SMP, so its
better to move their definiation into CONFIG_SMP too.

        atomic64_t load_avg;
        atomic_t runnable_avg;

Signed-off-by: Alex Shi <alex.shi@intel.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1371694737-29336-3-git-send-email-alex.shi@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/sched.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 77ce668..31d25f8 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -149,9 +149,11 @@ struct task_group {
 	unsigned long shares;
 
 	atomic_t load_weight;
+#ifdef	CONFIG_SMP
 	atomic64_t load_avg;
 	atomic_t runnable_avg;
 #endif
+#endif
 
 #ifdef CONFIG_RT_GROUP_SCHED
 	struct sched_rt_entity **rt_se;
