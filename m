Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296AbaCZLWJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 07:22:09 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:41163 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879AbaCZLWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 07:22:07 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, linaro-networking@linaro.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 03/14] hrtimer: call hrtimer_set_expires_range() from hrtimer_set_expires_range_ns()
Date: Wed, 26 Mar 2014 16:51:09 +0530
Message-Id: <52fac3f430d3c0da7b218264d7423997b469b8d0.1395832156.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1395832156.git.viresh.kumar@linaro.org>
References: <cover.1395832156.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1395832156.git.viresh.kumar@linaro.org>
References: <cover.1395832156.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hrtimer_set_expires_range() and hrtimer_set_expires_range_ns() have almost same
implementations and so we can call hrtimer_set_expires_range() from
hrtimer_set_expires_range_ns() internally, instead of duplicating code.

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

