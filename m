Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156Ab3ENKAf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 06:00:35 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:39472 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932111Ab3ENKA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 06:00:29 -0400
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-pm@vger.kernel.org
Cc: Zhang Rui <rui.zhang@intel.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, amit.kachhap@gmail.com,
        Kukjin Kim <kgene.kim@samsung.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH V4 14/30] thermal: exynos: Modify private_data to appropriate name driver_data
Date: Tue, 14 May 2013 15:28:44 +0530
Message-Id: <1368525540-15034-15-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1368525540-15034-1-git-send-email-amit.daniel@samsung.com>
References: <1368525540-15034-1-git-send-email-amit.daniel@samsung.com>
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
index 2af1e3b..7064eb7 100644
--- a/drivers/thermal/samsung/exynos_thermal_common.c
+++ b/drivers/thermal/samsung/exynos_thermal_common.c
@@ -221,7 +221,7 @@ static int exynos_get_temp(struct thermal_zone_device *thermal,
 		pr_info("Temperature sensor not initialised\n");
 		return -EINVAL;
 	}
-	data = th_zone->sensor_conf->private_data;
+	data = th_zone->sensor_conf->driver_data;
 	*temp = th_zone->sensor_conf->read_temperature(data);
 	/* convert the temperature into millicelsius */
 	*temp = *temp * MCELSIUS;
@@ -240,7 +240,7 @@ static int exynos_set_emul_temp(struct thermal_zone_device *thermal,
 		pr_info("Temperature sensor not initialised\n");
 		return -EINVAL;
 	}
-	data = th_zone->sensor_conf->private_data;
+	data = th_zone->sensor_conf->driver_data;
 	if (th_zone->sensor_conf->write_emul_temp)
 		ret = th_zone->sensor_conf->write_emul_temp(data, temp);
 	return ret;
diff --git a/drivers/thermal/samsung/exynos_thermal_common.h b/drivers/thermal/samsung/exynos_thermal_common.h
index 89ae078..59138ae 100644
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
index a1dc402..3855515 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -479,7 +479,7 @@ static int exynos_tmu_probe(struct platform_device *pdev)
 	exynos_tmu_control(pdev, true);
 
 	/* Register the sensor with thermal management interface */
-	(&exynos_sensor_conf)->private_data = data;
+	(&exynos_sensor_conf)->driver_data = data;
 	exynos_sensor_conf.trip_data.trip_count = pdata->trigger_enable[0] +
 			pdata->trigger_enable[1] + pdata->trigger_enable[2]+
 			pdata->trigger_enable[3];
-- 
1.7.1

