Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934325Ab3FSIvk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 04:51:40 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:46043 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934057Ab3FSIvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 04:51:36 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 2/2] cpufreq: make __cpufreq_notify_transition() static
Date: Wed, 19 Jun 2013 14:19:34 +0530
Message-Id: <77a7487c0518f8a56d9d6927b2f2380e66ca836e.1371631432.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <9625ea15bf036549ac323d7d4ae3b87ada007e7a.1371631432.git.viresh.kumar@linaro.org>
References: <9625ea15bf036549ac323d7d4ae3b87ada007e7a.1371631432.git.viresh.kumar@linaro.org>
In-Reply-To: <9625ea15bf036549ac323d7d4ae3b87ada007e7a.1371631432.git.viresh.kumar@linaro.org>
References: <9625ea15bf036549ac323d7d4ae3b87ada007e7a.1371631432.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__cpufreq_notify_transition() is used only in cpufreq.c, make it static.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 7c38842..8a9a23a 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -248,7 +248,7 @@ static inline void adjust_jiffies(unsigned long val, struct cpufreq_freqs *ci)
 }
 #endif
 
-void __cpufreq_notify_transition(struct cpufreq_policy *policy,
+static void __cpufreq_notify_transition(struct cpufreq_policy *policy,
 		struct cpufreq_freqs *freqs, unsigned int state)
 {
 	BUG_ON(irqs_disabled());
-- 
1.7.12.rc2.18.g61b472e

