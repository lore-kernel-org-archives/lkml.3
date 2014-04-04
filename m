Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771AbaDDGmN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 02:42:13 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:36551 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732AbaDDGmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 02:42:04 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, fweisbec@gmail.com,
        linaro-networking@linaro.org, Arvind.Chauhan@arm.com,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 23/36] hrtimer: create for_each_active_base()
Date: Fri,  4 Apr 2014 12:06:06 +0530
Message-Id: <170b73764b62e2af7cfcdd2fdea1dd203ab5173a.1396592516.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are many places where we need to iterate over all the currently active
clock bases for a particular cpu_base. Create for_each_active_base() to simplify
code at those places.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/hrtimer.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 379d21a..ceadfa5 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -113,6 +113,19 @@ static inline bool base_on_this_cpu(struct hrtimer_clock_base *base)
 }
 
 /*
+ * for_each_active_base: iterate over all active clock bases
+ * @_index: 'int' variable for internal purpose
+ * @_base: holds pointer to a active clock base
+ * @_cpu_base: cpu base to iterate on
+ * @_active_bases: 'unsigned int' variable for internal purpose
+ */
+#define for_each_active_base(_index, _base, _cpu_base, _active_bases)	\
+	for ((_active_bases) = (_cpu_base)->active_bases;		\
+		(_index) = ffs(_active_bases),				\
+		(_base) = (_cpu_base)->clock_base + (_index) - 1, (_index); \
+		(_active_bases) &= ~(1 << ((_index) - 1)))
+
+/*
  * Get the coarse grained time at the softirq based on xtime and
  * wall_to_monotonic.
  */
-- 
1.7.12.rc2.18.g61b472e

