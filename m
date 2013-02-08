Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945924Ab3BHBNp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 20:13:45 -0500
Received: from mail-ye0-f171.google.com ([209.85.213.171]:40881 "EHLO
	mail-ye0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759578Ab3BHBN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 20:13:29 -0500
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-pm@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>
Cc: jonghwa3.lee@samsung.com, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kgene.kim@samsung.com
Subject: [PATCH V3 2/2] thermal: exynos: Use the new thermal trend type for quick cooling action.
Date: Thu,  7 Feb 2013 17:13:07 -0800
Message-Id: <1360285987-13921-2-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1360285987-13921-1-git-send-email-amit.daniel@samsung.com>
References: <1360285987-13921-1-git-send-email-amit.daniel@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses the quick thermal cooling trend type macros. This is needed
as exynos5 and other thermal sensors now supports only interrupt method for
thresold temperature check.

Acked-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---

Hi,

Submitting these patches again as they got lost somewhere and was not merged.

Changes since V2:
* Rebased against Rui Zhang next tree.
* Added Kukjin Kim acked by.

All these patches are based on thermal maintainer next branch.
git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux.git thermal

 drivers/thermal/exynos_thermal.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/thermal/exynos_thermal.c b/drivers/thermal/exynos_thermal.c
index 65f69cf..030bba3 100644
--- a/drivers/thermal/exynos_thermal.c
+++ b/drivers/thermal/exynos_thermal.c
@@ -296,7 +296,7 @@ static int exynos_bind(struct thermal_zone_device *thermal,
 		case MONITOR_ZONE:
 		case WARN_ZONE:
 			if (thermal_zone_bind_cooling_device(thermal, i, cdev,
-								level, level)) {
+								level, 0)) {
 				pr_err("error binding cdev inst %d\n", i);
 				ret = -EINVAL;
 			}
@@ -399,9 +399,9 @@ static int exynos_get_trend(struct thermal_zone_device *thermal,
 		return ret;
 
 	if (thermal->temperature >= trip_temp)
-		*trend = THERMAL_TREND_RAISING;
+		*trend = THERMAL_TREND_RAISE_FULL;
 	else
-		*trend = THERMAL_TREND_DROPPING;
+		*trend = THERMAL_TREND_DROP_FULL;
 
 	return 0;
 }
-- 
1.7.5.4

