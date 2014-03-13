Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304AbaCMGDF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 02:03:05 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:55693 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbaCMGDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 02:03:04 -0400
From: Alex Shi <alex.shi@linaro.org>
To: mingo@redhat.com, peterz@infradead.org, morten.rasmussen@arm.com
Cc: vincent.guittot@linaro.org, daniel.lezcano@linaro.org, fweisbec@gmail.com,
        linux@arm.linux.org.uk, tony.luck@intel.com, fenghua.yu@intel.com,
        james.hogan@imgtec.com, alex.shi@linaro.org, jason.low2@hp.com,
        viresh.kumar@linaro.org, hanjun.guo@linaro.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, pjt@google.com,
        fengguang.wu@intel.com, linaro-kernel@lists.linaro.org,
        wangyun@linux.vnet.ibm.com, mgorman@suse.de
Subject: [PATCH 4/8] sched: remove LB_BIAS
Date: Thu, 13 Mar 2014 13:57:25 +0800
Message-Id: <1394690249-14130-5-git-send-email-alex.shi@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1394690249-14130-1-git-send-email-alex.shi@linaro.org>
References: <1394690249-14130-1-git-send-email-alex.shi@linaro.org>
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
1.8.1.2

