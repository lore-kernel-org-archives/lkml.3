Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760143Ab3DZKmG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 06:42:06 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:36339 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760059Ab3DZKjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 06:39:05 -0400
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-pm@vger.kernel.org
Cc: Zhang Rui <rui.zhang@intel.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, amit.kachhap@gmail.com,
        Kukjin Kim <kgene.kim@samsung.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH V2 13/20] thermal: exynos: Return success even if no cooling data supplied
Date: Fri, 26 Apr 2013 16:07:44 +0530
Message-Id: <1366972671-9227-14-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1366972671-9227-1-git-send-email-amit.daniel@samsung.com>
References: <1366972671-9227-1-git-send-email-amit.daniel@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the error return in the bind/unbind routine
as the platform may not register any cpufreq cooling data.

Acked-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 drivers/thermal/samsung/exynos_thermal_common.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_thermal_common.c b/drivers/thermal/samsung/exynos_thermal_common.c
index c0e4bdb..b7ca8a4 100644
--- a/drivers/thermal/samsung/exynos_thermal_common.c
+++ b/drivers/thermal/samsung/exynos_thermal_common.c
@@ -136,7 +136,7 @@ static int exynos_bind(struct thermal_zone_device *thermal,
 	tab_size = data->cooling_data.freq_clip_count;
 
 	if (tab_ptr == NULL || tab_size == 0)
-		return -EINVAL;
+		return 0;
 
 	/* find the cooling device registered*/
 	for (i = 0; i < th_zone->cool_dev_size; i++)
@@ -185,7 +185,7 @@ static int exynos_unbind(struct thermal_zone_device *thermal,
 	tab_size = data->cooling_data.freq_clip_count;
 
 	if (tab_size == 0)
-		return -EINVAL;
+		return 0;
 
 	/* find the cooling device registered*/
 	for (i = 0; i < th_zone->cool_dev_size; i++)
-- 
1.7.1

