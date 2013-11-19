Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168Ab3KSNak (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 08:30:40 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:54029 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421Ab3KSNah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 08:30:37 -0500
From: Jonghwan Choi <jhbird.choi@gmail.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: [PATCH 4/4] PM / devfreq: Consider hibernation in pm notifier
Date: Tue, 19 Nov 2013 22:30:31 +0900
Message-Id: <1384867831-15383-1-git-send-email-jhbird.choi@samsung.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frequency lock should be considered in suspend/hibernation.

Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 drivers/devfreq/exynos/exynos5_bus.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/devfreq/exynos/exynos5_bus.c b/drivers/devfreq/exynos/exynos5_bus.c
index a60da3c..bd672de0 100644
--- a/drivers/devfreq/exynos/exynos5_bus.c
+++ b/drivers/devfreq/exynos/exynos5_bus.c
@@ -268,6 +268,7 @@ static int exynos5_busfreq_int_pm_notifier_event(struct notifier_block *this,
 	int err = 0;
 
 	switch (event) {
+	case PM_HIBERNATION_PREPARE:
 	case PM_SUSPEND_PREPARE:
 		/* Set Fastest and Deactivate DVFS */
 		mutex_lock(&data->lock);
@@ -300,6 +301,7 @@ unlock:
 		if (err)
 			return NOTIFY_BAD;
 		return NOTIFY_OK;
+	case PM_POST_HIBERNATION:
 	case PM_POST_RESTORE:
 	case PM_POST_SUSPEND:
 		/* Reactivate */
-- 
1.8.1.2

