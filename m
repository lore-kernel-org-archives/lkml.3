Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377Ab3AYWtA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 17:49:00 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:53554 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204Ab3AYWpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 17:45:54 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Peter Boonstoppel <pboonstoppel@nvidia.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 05/19] sched: warnings in kernel/sched/fair.c
Date: Fri, 25 Jan 2013 22:44:04 +0000
Message-Id: <1359153858-31992-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1359153858-31992-1-git-send-email-arnd@arndb.de>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de>
 <1359153858-31992-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:go0GOMwo9b3fFYpXb4A8LCCFCpr0TkNwYvvcAlzjzqM
 AGzEVqb1Gts3QuTbqdmedknmRn36BXSCf6pYI95wDwyf8JnXdm
 YB+vX/pekA4rS6NnbM/ArjPSJfFFKl1vx2IIjKbg8h8hogfUVL
 5tcHeYoKFu/r/KVHgemF0sMGFP9JmMwk/okP6t/wJ9sUCs3ty2
 DfwF+wwiuxaUGSow45khWbFN/1LrWc1b7AHrmetwetOr5dq1yd
 MGXoJJoBD8ytVrbxX8u5w+lAHgGibCwC8J/iRFIbZCmiOfHc/g
 IedaQpnlDgOaZ+4tOAFbXYxwZi92EWsEpEowo9jvrx95WcvbPs
 80ihRFfh934tNW3y/Gak4URqnc4tN/SljyJW53vp1
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

