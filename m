Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401AbaDDGlE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 02:41:04 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:57322 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112AbaDDGkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 02:40:23 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, fweisbec@gmail.com,
        linaro-networking@linaro.org, Arvind.Chauhan@arm.com,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 06/36] hrtimer: remove dummy definition of hrtimer_force_reprogram()
Date: Fri,  4 Apr 2014 12:05:49 +0530
Message-Id: <3f26ec61bb598af832c0d6b2ba6f14a0610cad4a.1396592516.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hrtimer_force_reprogram() is only called from parts of kernel which are defined
between #ifdef CONFIG_HIGH_RES_TIMERS and so its empty definition is never used.
Remove it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/hrtimer.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 4843238..f6b1968 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -730,8 +730,6 @@ void clock_was_set_delayed(void)
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

