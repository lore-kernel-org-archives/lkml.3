Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab3LCJHI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 04:07:08 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:40040 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149Ab3LCJGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 04:06:52 -0500
From: Alex Shi <alex.shi@linaro.org>
To: mingo@redhat.com, peterz@infradead.org, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, daniel.lezcano@linaro.org,
        fweisbec@gmail.com, linux@arm.linux.org.uk, tony.luck@intel.com,
        fenghua.yu@intel.com, tglx@linutronix.de, akpm@linux-foundation.org,
        arjan@linux.intel.com, pjt@google.com, fengguang.wu@intel.com
Cc: james.hogan@imgtec.com, alex.shi@linaro.org, jason.low2@hp.com,
        gregkh@linuxfoundation.org, hanjun.guo@linaro.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] sched: shortcut to remove load_idx
Date: Tue,  3 Dec 2013 17:05:53 +0800
Message-Id: <1386061556-28233-2-git-send-email-alex.shi@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1386061556-28233-1-git-send-email-alex.shi@linaro.org>
References: <1386061556-28233-1-git-send-email-alex.shi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shortcut to remove rq->cpu_load[load_idx] effect in scheduler.
In five load idx, only busy_idx, idle_idx are not zero.
Newidle_idx, wake_idx and fork_idx are all zero in all archs.

So, change the idx to zero here can fully remove load_idx effect.

Signed-off-by: Alex Shi <alex.shi@linaro.org>
---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index e8b652e..ce683aa 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5633,7 +5633,7 @@ static inline void update_sd_lb_stats(struct lb_env *env, struct sd_lb_stats *sd
 	if (child && child->flags & SD_PREFER_SIBLING)
 		prefer_sibling = 1;
 
-	load_idx = get_sd_load_idx(env->sd, env->idle);
+	load_idx = 0;
 
 	do {
 		struct sg_lb_stats *sgs = &tmp_sgs;
-- 
1.8.1.2

