Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792AbaIDQcl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 12:32:41 -0400
Received: from forward-corp1e.mail.yandex.net ([77.88.60.199]:35888 "EHLO
	forward-corp1e.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754458AbaIDQbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 12:31:20 -0400
X-Yandex-Uniq: 0c1235df-bd33-447b-8d98-28238335c70b
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: klamm@yandex-team.ru
To: peterz@infradead.org, mingo@redhat.com, linux-kernel@vger.kernel.org
Cc: stfomichev@yandex-team.ru, Roman Gushchin <klamm@yandex-team.ru>
Subject: [PATCH 15/19] smart: decrease default rt_period/rt_runtime values
Date: Thu,  4 Sep 2014 20:31:01 +0400
Message-Id: <1409848265-17150-15-git-send-email-klamm@yandex-team.ru>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409848265-17150-1-git-send-email-klamm@yandex-team.ru>
References: <77161409833206@webcorp01h.yandex-team.ru>
 <1409848265-17150-1-git-send-email-klamm@yandex-team.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roman Gushchin <klamm@yandex-team.ru>

By default, rt_period is 1s and rt_runtime is 0.95s. These values
are to high to achieve acceptable system responsibility under high
rt load. Decrease it to 100ms and 99ms respectively.

Signed-off-by: Roman Gushchin <klamm@yandex-team.ru>
---
 kernel/sched/core.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 0f25fe0..a1b116e 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -282,19 +282,26 @@ const_debug unsigned int sysctl_sched_nr_migrate = 32;
  */
 const_debug unsigned int sysctl_sched_time_avg = MSEC_PER_SEC;
 
+#ifdef CONFIG_SMART
+#define DEFAULT_SCHED_RT_PERIOD 100000
+#define DEFAULT_SCHED_RT_RUNTIME 99000
+
+#else
+#define DEFAULT_SCHED_RT_PERIOD 1000000
+#define DEFAULT_SCHED_RT_RUNTIME 950000
+#endif
+
 /*
  * period over which we measure -rt task cpu usage in us.
- * default: 1s
  */
-unsigned int sysctl_sched_rt_period = 1000000;
+unsigned int sysctl_sched_rt_period = DEFAULT_SCHED_RT_PERIOD;
 
 __read_mostly int scheduler_running;
 
 /*
  * part of the period that we allow rt tasks to run in us.
- * default: 0.95s
  */
-int sysctl_sched_rt_runtime = 950000;
+int sysctl_sched_rt_runtime = DEFAULT_SCHED_RT_RUNTIME;
 
 
 
-- 
1.9.3

