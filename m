Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932425Ab3FQGsQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 02:48:16 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:35280 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932359Ab3FQGsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 02:48:12 -0400
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-pm@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit.kachhap@gmail.com, Kukjin Kim <kgene.kim@samsung.com>,
        jonghwa3.lee@samsung.com
Subject: [PATCH V6 15/30] thermal: exynos: Return success even if no cooling data supplied
Date: Mon, 17 Jun 2013 12:16:24 +0530
Message-Id: <1371451599-31035-16-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1371451599-31035-1-git-send-email-amit.daniel@samsung.com>
References: <1371451599-31035-1-git-send-email-amit.daniel@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the error return in the bind/unbind routine
as the platform may not register any cpufreq cooling data.

Acked-by: Kukjin Kim <kgene.kim@samsung.com>
Acked-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 drivers/thermal/samsung/exynos_thermal_common.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_thermal_common.c b/drivers/thermal/samsung/exynos_thermal_common.c
index 7064eb7..86d39aa 100644
--- a/drivers/thermal/samsung/exynos_thermal_common.c
+++ b/drivers/thermal/samsung/exynos_thermal_common.c
@@ -131,7 +131,7 @@ static int exynos_bind(struct thermal_zone_device *thermal,
 	tab_size = data->cooling_data.freq_clip_count;
 
 	if (tab_ptr == NULL || tab_size == 0)
-		return -EINVAL;
+		return 0;
 
 	/* find the cooling device registered*/
 	for (i = 0; i < th_zone->cool_dev_size; i++)
@@ -180,7 +180,7 @@ static int exynos_unbind(struct thermal_zone_device *thermal,
 	tab_size = data->cooling_data.freq_clip_count;
 
 	if (tab_size == 0)
-		return -EINVAL;
+		return 0;
 
 	/* find the cooling device registered*/
 	for (i = 0; i < th_zone->cool_dev_size; i++)
-- 
1.7.1

