Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932649Ab3AYOSH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 09:18:07 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:53781 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757136Ab3AYOPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 09:15:00 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@list.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Peter Boonstoppel <pboonstoppel@nvidia.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 05/19] sched: warnings in kernel/sched/fair.c
Date: Fri, 25 Jan 2013 14:14:22 +0000
Message-Id: <1359123276-15833-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1359123276-15833-1-git-send-email-arnd@arndb.de>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:WI+Uc0GI6SeJwwmPgieYlJJV5v1+bZtcPNYKN6LBOvj
 j0f6lr/at+YKpqyzzklVN+w5KHT8nb1bAMoJEV72mrlOhT9yF7
 5esf9iOFu4l9Er6MalLfLjgaxOjjwuFDzO1R4DOyaJ7M46jfqf
 1Sp27ckPmk+o9rKnqc0alhdC0eIg9WPQYpM+orABri7LhVcFiN
 q2TiuvUyv+EvKOzOyMxs7DeGG/8PTO3YcwQ/Stg/EsuAU+H2eD
 PsfxLv+/iQark7G+jJdkr6GfEpwnJaQx4jCualj9RYfiLxb+ed
 +N+FVz/4J0wiwdoqbpI+BZ/ZVFZRiMgo35u+8rlqClnlZNXxZL
 Er1wXUL1mLV5zCwSZnv8fkfShC5riz9Na8Eq1Ue15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

a4c96ae319 "sched: Unthrottle rt runqueues in __disable_runtime()"
turned the unthrottle_offline_cfs_rqs function into a static symbol,
which now triggers a warning about it being potentially unused:

kernel/sched/fair.c:2055:13: warning: 'unthrottle_offline_cfs_rqs' defined but not used [-Wunused-function]

Marking it __maybe_unused shuts up the gcc warning and lets the
compiler safely drop the function body when it's not being used.

To reproduce, build the ARM bcm2835_defconfig.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Peter Boonstoppel <pboonstoppel@nvidia.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Turner <pjt@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 5eea870..81fa536 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2663,7 +2663,7 @@ static void destroy_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
 	hrtimer_cancel(&cfs_b->slack_timer);
 }
 
-static void unthrottle_offline_cfs_rqs(struct rq *rq)
+static void __maybe_unused unthrottle_offline_cfs_rqs(struct rq *rq)
 {
 	struct cfs_rq *cfs_rq;
 
-- 
1.8.0

