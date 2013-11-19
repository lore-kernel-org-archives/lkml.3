Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024Ab3KSN2N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 08:28:13 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:35823 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002Ab3KSN2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 08:28:11 -0500
From: Jonghwan Choi <jhbird.choi@gmail.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>
Cc: linux-kernel@vger.kernel.org, Jonghwan Choi <jhbird.choi@samsung.com>
Subject: [PATCH 1/4] cpufreq: s5pv210: Consider hibernation in pm notifier
Date: Tue, 19 Nov 2013 22:28:01 +0900
Message-Id: <1384867681-15163-1-git-send-email-jhbird.choi@samsung.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frequency lock should be considered in suspend/hibernation.

Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 drivers/cpufreq/s5pv210-cpufreq.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/cpufreq/s5pv210-cpufreq.c b/drivers/cpufreq/s5pv210-cpufreq.c
index e3973da..bfbb09e 100644
--- a/drivers/cpufreq/s5pv210-cpufreq.c
+++ b/drivers/cpufreq/s5pv210-cpufreq.c
@@ -526,6 +526,7 @@ static int s5pv210_cpufreq_notifier_event(struct notifier_block *this,
 	int ret;
 
 	switch (event) {
+	case PM_HIBERNATION_PREPARE:
 	case PM_SUSPEND_PREPARE:
 		ret = cpufreq_driver_target(cpufreq_cpu_get(0), SLEEP_FREQ, 0);
 		if (ret < 0)
@@ -534,6 +535,7 @@ static int s5pv210_cpufreq_notifier_event(struct notifier_block *this,
 		/* Disable updation of cpu frequency */
 		no_cpufreq_access = true;
 		return NOTIFY_OK;
+	case PM_POST_HIBERNATION:
 	case PM_POST_RESTORE:
 	case PM_POST_SUSPEND:
 		/* Enable updation of cpu frequency */
-- 
1.8.1.2

