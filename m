Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932642AbaAaQoD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 11:44:03 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:41673 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932263AbaAaQoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 11:44:01 -0500
From: Juri Lelli <juri.lelli@gmail.com>
To: peterz@infradead.org
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org,
        Juri Lelli <juri.lelli@gmail.com>
Subject: [PATCH] sched/core: fix sched_rt_global_validate
Date: Fri, 31 Jan 2014 17:43:27 +0100
Message-Id: <1391186607-11247-1-git-send-email-juri.lelli@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't compare sysctl_sched_rt_runtime against sysctl_sched_rt_period if
the former is equal to RUNTIME_INF, otherwise disabling -rt bandwidth
management always fails.

Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
---
 kernel/sched/core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 210a12a..5c0a304 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7477,7 +7477,8 @@ static int sched_rt_global_validate(void)
 	if (sysctl_sched_rt_period <= 0)
 		return -EINVAL;
 
-	if (sysctl_sched_rt_runtime > sysctl_sched_rt_period)
+	if ((sysctl_sched_rt_runtime != RUNTIME_INF) &&
+		(sysctl_sched_rt_runtime > sysctl_sched_rt_period))
 		return -EINVAL;
 
 	return 0;
-- 
1.7.9.5

