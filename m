Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354AbaDPCpX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 22:45:23 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:51743 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbaDPCoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 22:44:30 -0400
From: Alex Shi <alex.shi@linaro.org>
To: mingo@redhat.com, peterz@infradead.org, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, daniel.lezcano@linaro.org, efault@gmx.de
Cc: wangyun@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, mgorman@suse.de
Subject: [PATCH V5 4/8] sched: remove LB_BIAS
Date: Wed, 16 Apr 2014 10:43:25 +0800
Message-Id: <1397616209-27275-5-git-send-email-alex.shi@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397616209-27275-1-git-send-email-alex.shi@linaro.org>
References: <1397616209-27275-1-git-send-email-alex.shi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't need LB_BIAS now. so remove it.

Signed-off-by: Alex Shi <alex.shi@linaro.org>
---
 Documentation/timers/NO_HZ.txt | 2 --
 kernel/sched/features.h        | 1 -
 2 files changed, 3 deletions(-)

diff --git a/Documentation/timers/NO_HZ.txt b/Documentation/timers/NO_HZ.txt
index cca122f..84dd71d 100644
--- a/Documentation/timers/NO_HZ.txt
+++ b/Documentation/timers/NO_HZ.txt
@@ -177,8 +177,6 @@ not come for free:
 	slightly differently than those for non-adaptive-tick CPUs.
 	This might in turn perturb load-balancing of real-time tasks.
 
-6.	The LB_BIAS scheduler feature is disabled by adaptive ticks.
-
 Although improvements are expected over time, adaptive ticks is quite
 useful for many types of real-time and compute-intensive applications.
 However, the drawbacks listed above mean that adaptive ticks should not
diff --git a/kernel/sched/features.h b/kernel/sched/features.h
index 5716929..fe3c1cb 100644
--- a/kernel/sched/features.h
+++ b/kernel/sched/features.h
@@ -43,7 +43,6 @@ SCHED_FEAT(ARCH_POWER, true)
 
 SCHED_FEAT(HRTICK, false)
 SCHED_FEAT(DOUBLE_TICK, false)
-SCHED_FEAT(LB_BIAS, true)
 
 /*
  * Decrement CPU power based on time not spent running tasks
-- 
1.8.3.2

