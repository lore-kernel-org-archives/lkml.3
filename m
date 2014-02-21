Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982AbaBUUc0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 15:32:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58532 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbaBUUcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 15:32:23 -0500
Date: Fri, 21 Feb 2014 12:31:52 -0800
From: tip-bot for Juri Lelli <tipbot@zytor.com>
Message-ID: <tip-e9e7cb38c21c80c82af4b16608bb4c8c5ec6a28e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de,
        juri.lelli@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de,
        juri.lelli@gmail.com
In-Reply-To: <1392107067-19907-2-git-send-email-juri.lelli@gmail.com>
References: <1392107067-19907-2-git-send-email-juri.lelli@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched/core: Fix sched_rt_global_validate
Git-Commit-ID: e9e7cb38c21c80c82af4b16608bb4c8c5ec6a28e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e9e7cb38c21c80c82af4b16608bb4c8c5ec6a28e
Gitweb:     http://git.kernel.org/tip/e9e7cb38c21c80c82af4b16608bb4c8c5ec6a28e
Author:     Juri Lelli <juri.lelli@gmail.com>
AuthorDate: Tue, 11 Feb 2014 09:24:26 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 21 Feb 2014 21:27:10 +0100

sched/core: Fix sched_rt_global_validate

Don't compare sysctl_sched_rt_runtime against sysctl_sched_rt_period if
the former is equal to RUNTIME_INF, otherwise disabling -rt bandwidth
management (with CONFIG_RT_GROUP_SCHED=n) fails.

Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1392107067-19907-2-git-send-email-juri.lelli@gmail.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 2491448..98d33c1 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7475,7 +7475,8 @@ static int sched_rt_global_validate(void)
 	if (sysctl_sched_rt_period <= 0)
 		return -EINVAL;
 
-	if (sysctl_sched_rt_runtime > sysctl_sched_rt_period)
+	if ((sysctl_sched_rt_runtime != RUNTIME_INF) &&
+		(sysctl_sched_rt_runtime > sysctl_sched_rt_period))
 		return -EINVAL;
 
 	return 0;
