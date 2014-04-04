Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519AbaDDGlR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 02:41:17 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:54833 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606AbaDDGkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 02:40:41 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, fweisbec@gmail.com,
        linaro-networking@linaro.org, Arvind.Chauhan@arm.com,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 09/36] hrtimer: call hrtimer_set_expires_range() from hrtimer_set_expires_range_ns()
Date: Fri,  4 Apr 2014 12:05:52 +0530
Message-Id: <8cc3da5f4fa3ccacf0b47fb0386d14bd80cb5459.1396592516.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hrtimer_set_expires_range() and hrtimer_set_expires_range_ns() have almost same
implementations and so we can actually call hrtimer_set_expires_range() from
hrtimer_set_expires_range_ns() internally instead of duplicating code.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 include/linux/hrtimer.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index e7a8d3f..17c08ca 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -207,8 +207,7 @@ static inline void hrtimer_set_expires_range(struct hrtimer *timer, ktime_t time
 
 static inline void hrtimer_set_expires_range_ns(struct hrtimer *timer, ktime_t time, unsigned long delta)
 {
-	timer->_softexpires = time;
-	timer->node.expires = ktime_add_safe(time, ns_to_ktime(delta));
+	hrtimer_set_expires_range(timer, time, ns_to_ktime(delta));
 }
 
 static inline void hrtimer_set_expires_tv64(struct hrtimer *timer, s64 tv64)
-- 
1.7.12.rc2.18.g61b472e

