Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760074Ab3DZKjI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 06:39:08 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:57876 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760054Ab3DZKjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 06:39:03 -0400
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-pm@vger.kernel.org
Cc: Zhang Rui <rui.zhang@intel.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, amit.kachhap@gmail.com,
        Kukjin Kim <kgene.kim@samsung.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH V2 12/20] thermal: exynos: Modify private_data to appropriate name driver_data
Date: Fri, 26 Apr 2013 16:07:43 +0530
Message-Id: <1366972671-9227-13-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1366972671-9227-1-git-send-email-amit.daniel@samsung.com>
References: <1366972671-9227-1-git-send-email-amit.daniel@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch renames member private_data to driver_data of the thermal
zone registration structure as this item stores the driver related
data and uses it to call the driver related callbacks.

Acked-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 drivers/thermal/samsung/exynos_thermal_common.c |    4 ++--
 drivers/thermal/samsung/exynos_thermal_common.h |    2 +-
 drivers/thermal/samsung/exynos_tmu.c            |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_thermal_common.c b/drivers/thermal/samsung/exynos_thermal_common.c
index d4cd5ec..c0e4bdb 100644
--- a/drivers/thermal/samsung/exynos_thermal_common.c
+++ b/drivers/thermal/samsung/exynos_thermal_common.c
@@ -226,7 +226,7 @@ static int exynos_get_temp(struct thermal_zone_device *thermal,
 		pr_info("Temperature sensor not initialised\n");
 		return -EINVAL;
 	}
-	data = th_zone->sensor_conf->private_data;
+	data = th_zone->sensor_conf->driver_data;
 	*temp = th_zone->sensor_conf->read_temperature(data);
 	/* convert the temperature into millicelsius */
 	*temp = *temp * MCELSIUS;
@@ -245,7 +245,7 @@ static int exynos_set_emul_temp(struct thermal_zone_device *thermal,
 		pr_info("Temperature sensor not initialised\n");
 		return -EINVAL;
 	}
-	data = th_zone->sensor_conf->private_data;
+	data = th_zone->sensor_conf->driver_data;
 	if (th_zone->sensor_conf->write_emul_temp)
 		ret = th_zone->sensor_conf->write_emul_temp(data, temp);
 	return ret;
diff --git a/drivers/thermal/samsung/exynos_thermal_common.h b/drivers/thermal/samsung/exynos_thermal_common.h
index 26fdf8d..878120b 100644
--- a/drivers/thermal/samsung/exynos_thermal_common.h
+++ b/drivers/thermal/samsung/exynos_thermal_common.h
@@ -76,7 +76,7 @@ struct thermal_sensor_conf {
 	int (*write_emul_temp)(void *drv_data, unsigned long temp);
 	struct thermal_trip_point_conf trip_data;
 	struct thermal_cooling_conf cooling_data;
-	void *private_data;
+	void *driver_data;
 	void *pzone_data;
 };
 
diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index 133d3f5..bdf40ef 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -482,7 +482,7 @@ static int exynos_tmu_probe(struct platform_device *pdev)
 	exynos_tmu_control(pdev, true);
 
 	/* Register the sensor with thermal management interface */
-	(&exynos_sensor_conf)->private_data = data;
+	(&exynos_sensor_conf)->driver_data = data;
 	exynos_sensor_conf.trip_data.trip_count = pdata->trigger_enable[0] +
 			pdata->trigger_enable[1] + pdata->trigger_enable[2]+
 			pdata->trigger_enable[3];
-- 
1.7.1

