Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946AbaCZLYd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 07:24:33 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:53781 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754577AbaCZLWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 07:22:36 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, linaro-networking@linaro.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 08/14] hrtimer: remove dummy definition of hrtimer_force_reprogram()
Date: Wed, 26 Mar 2014 16:51:14 +0530
Message-Id: <3525e4ce8a596302d1d6772e26d13d36eb13f0bd.1395832156.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1395832156.git.viresh.kumar@linaro.org>
References: <cover.1395832156.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1395832156.git.viresh.kumar@linaro.org>
References: <cover.1395832156.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hrtimer_force_reprogram() is only called from parts of kernel which are defined
within #ifdef CONFIG_HIGH_RES_TIMERS and so its empty definition is never used.
Remove it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/hrtimer.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index cb485b9..5b3b212 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -728,8 +728,6 @@ void clock_was_set_delayed(void)
 static inline int hrtimer_hres_active(void) { return 0; }
 static inline int hrtimer_is_hres_enabled(void) { return 0; }
 static inline int hrtimer_switch_to_hres(void) { return 0; }
-static inline void
-hrtimer_force_reprogram(struct hrtimer_cpu_base *base, int skip_equal) { }
 static inline int hrtimer_enqueue_reprogram(struct hrtimer *timer,
 					    struct hrtimer_clock_base *base)
 {
-- 
1.7.12.rc2.18.g61b472e

