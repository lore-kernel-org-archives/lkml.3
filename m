Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690AbaBKIYv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 03:24:51 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:36703 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640AbaBKIYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 03:24:47 -0500
From: Juri Lelli <juri.lelli@gmail.com>
To: mingo@redhat.com, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, Juri Lelli <juri.lelli@gmail.com>
Subject: [REPOST - PATCH 1/2] sched/core: fix sched_rt_global_validate
Date: Tue, 11 Feb 2014 09:24:26 +0100
Message-Id: <1392107067-19907-2-git-send-email-juri.lelli@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392107067-19907-1-git-send-email-juri.lelli@gmail.com>
References: <1392107067-19907-1-git-send-email-juri.lelli@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't compare sysctl_sched_rt_runtime against sysctl_sched_rt_period if
the former is equal to RUNTIME_INF, otherwise disabling -rt bandwidth
management (with CONFIG_RT_GROUP_SCHED=n) fails.

Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
---
 kernel/sched/core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 104c816..604dd4e 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7465,7 +7465,8 @@ static int sched_rt_global_validate(void)
 	if (sysctl_sched_rt_period <= 0)
 		return -EINVAL;
 
-	if (sysctl_sched_rt_runtime > sysctl_sched_rt_period)
+	if ((sysctl_sched_rt_runtime != RUNTIME_INF) &&
+		(sysctl_sched_rt_runtime > sysctl_sched_rt_period))
 		return -EINVAL;
 
 	return 0;
-- 
1.7.9.5

