Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086Ab3KSN31 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 08:29:27 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:34047 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367Ab3KSN3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 08:29:25 -0500
From: Jonghwan Choi <jhbird.choi@gmail.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: [PATCH 2/4] cpufreq: exynos: Consider hibernation in pm notifier
Date: Tue, 19 Nov 2013 22:29:18 +0900
Message-Id: <1384867758-15276-1-git-send-email-jhbird.choi@samsung.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frequency lock should be considered in suspend/hibernation.

Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 drivers/cpufreq/exynos-cpufreq.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/cpufreq/exynos-cpufreq.c b/drivers/cpufreq/exynos-cpufreq.c
index f3c2287..cd05b0a 100644
--- a/drivers/cpufreq/exynos-cpufreq.c
+++ b/drivers/cpufreq/exynos-cpufreq.c
@@ -187,6 +187,7 @@ static int exynos_cpufreq_pm_notifier(struct notifier_block *notifier,
 	int ret;
 
 	switch (pm_event) {
+	case PM_HIBERNATION_PREPARE:
 	case PM_SUSPEND_PREPARE:
 		mutex_lock(&cpufreq_lock);
 		frequency_locked = true;
@@ -198,6 +199,8 @@ static int exynos_cpufreq_pm_notifier(struct notifier_block *notifier,
 
 		break;
 
+	case PM_POST_HIBERNATION:
+	case PM_POST_RESTORE:
 	case PM_POST_SUSPEND:
 		mutex_lock(&cpufreq_lock);
 		frequency_locked = false;
-- 
1.8.1.2

