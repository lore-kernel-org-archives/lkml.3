Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900Ab3IKKRZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 06:17:25 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:41201 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727Ab3IKKRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 06:17:20 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 3/5] cpufreq: rewrite cpufreq_driver->flags using shift operator
Date: Wed, 11 Sep 2013 15:43:09 +0530
Message-Id: <0f41597e75e01964046009df288555cc16506fa5.1378893296.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1378893296.git.viresh.kumar@linaro.org>
References: <cover.1378893296.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1378893296.git.viresh.kumar@linaro.org>
References: <cover.1378893296.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently cpufreq_driver's flags are defined directly using 0x1, 0x2, 0x4, 0x8,
etc.. As the list grows it doesn't stays much readable..

Lets use bitwise shift operator << to generate these numbers for respective
positions.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 include/linux/cpufreq.h | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index fcabc42..c71dc0f 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -211,13 +211,14 @@ struct cpufreq_driver {
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
 
 int cpufreq_register_driver(struct cpufreq_driver *driver_data);
 int cpufreq_unregister_driver(struct cpufreq_driver *driver_data);
-- 
1.7.12.rc2.18.g61b472e

