Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892Ab3IMNDt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:03:49 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:63268 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756849Ab3IMNDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:03:43 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 006/228] cpufreq: rewrite cpufreq_driver->flags using shift operator
Date: Fri, 13 Sep 2013 18:29:12 +0530
Message-Id: <b5bba6d36ec319dd26517a1c7fedf9bf1abf8077.1379063063.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently cpufreq_driver's flags are defined directly using 0x1, 0x2, 0x4, 0x8,
etc.. As the list grows it doesn't stays much readable..

Lets use bitwise shift operator << to generate these numbers for respective
positions.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 include/linux/cpufreq.h | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 10ab22d..0eda235 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -212,19 +212,20 @@ struct cpufreq_driver {
 };
 
 /* flags */
-#define CPUFREQ_STICKY		0x01	/* the driver isn't removed even if
-					 * all ->init() calls failed */
-#define CPUFREQ_CONST_LOOPS	0x02	/* loops_per_jiffy or other kernel
-					 * "constants" aren't affected by
-					 * frequency transitions */
-#define CPUFREQ_PM_NO_WARN	0x04	/* don't warn on suspend/resume speed
-					 * mismatches */
+#define CPUFREQ_STICKY		(1 << 0)	/* driver isn't removed even if
+						   all ->init() calls failed */
+#define CPUFREQ_CONST_LOOPS	(1 << 1)	/* loops_per_jiffy or other
+						   kernel "constants" aren't
+						   affected by frequency
+						   transitions */
+#define CPUFREQ_PM_NO_WARN	(1 << 2)	/* don't warn on suspend/resume
+						   speed mismatches */
 /*
  * Driver will do POSTCHANGE notifications from outside of their ->target()
  * routine and so must set cpufreq_driver->flags with this flag, so that core
  * can handle them specially.
  */
-#define CPUFREQ_ASYNC_NOTIFICATION 0x08
+#define CPUFREQ_ASYNC_NOTIFICATION	(1 << 3)
 
 int cpufreq_register_driver(struct cpufreq_driver *driver_data);
 int cpufreq_unregister_driver(struct cpufreq_driver *driver_data);
-- 
1.7.12.rc2.18.g61b472e

