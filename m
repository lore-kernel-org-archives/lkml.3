Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423118Ab3CVVDR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 17:03:17 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36163 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423063Ab3CVVDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 17:03:15 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: Zhang Rui <rui.zhang@intel.com>
CC: <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 05/11] thermal: rename get_tz_trend to thermal_zone_trend_get
Date: Fri, 22 Mar 2013 17:00:48 -0400
Message-ID: <1363986054-24637-6-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1363986054-24637-1-git-send-email-eduardo.valentin@ti.com>
References: <1363986054-24637-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To follow the prefix names used by the thermal exported functions,
this patch renames get_tz_trend to thermal_zone_trend_get.

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 Documentation/thermal/sysfs-api.txt |    2 +-
 drivers/thermal/step_wise.c         |    2 +-
 drivers/thermal/thermal_sys.c       |    4 ++--
 include/linux/thermal.h             |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/thermal/sysfs-api.txt b/Documentation/thermal/sysfs-api.txt
index 059b3bf..a9abb84 100644
--- a/Documentation/thermal/sysfs-api.txt
+++ b/Documentation/thermal/sysfs-api.txt
@@ -351,7 +351,7 @@ crosses any of the configured thresholds.
 
 5. Export Symbol APIs:
 
-5.1: get_tz_trend:
+5.1: thermal_zone_trend_get:
 This function returns the trend of a thermal zone, i.e the rate of change
 of temperature of the thermal zone. Ideally, the thermal sensor drivers
 are supposed to implement the callback. If they don't, the thermal
diff --git a/drivers/thermal/step_wise.c b/drivers/thermal/step_wise.c
index 407cde3..a640e2b 100644
--- a/drivers/thermal/step_wise.c
+++ b/drivers/thermal/step_wise.c
@@ -116,7 +116,7 @@ static void thermal_zone_trip_update(struct thermal_zone_device *tz, int trip)
 		tz->ops->get_trip_type(tz, trip, &trip_type);
 	}
 
-	trend = get_tz_trend(tz, trip);
+	trend = thermal_zone_trend_get(tz, trip);
 
 	if (tz->temperature >= trip_temp)
 		throttle = true;
diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index 44e89c0..242c82a 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -153,7 +153,7 @@ static void release_idr(struct idr *idr, struct mutex *lock, int id)
 		mutex_unlock(lock);
 }
 
-int get_tz_trend(struct thermal_zone_device *tz, int trip)
+int thermal_zone_trend_get(struct thermal_zone_device *tz, int trip)
 {
 	enum thermal_trend trend;
 
@@ -168,7 +168,7 @@ int get_tz_trend(struct thermal_zone_device *tz, int trip)
 
 	return trend;
 }
-EXPORT_SYMBOL(get_tz_trend);
+EXPORT_SYMBOL(thermal_zone_trend_get);
 
 struct thermal_instance *thermal_instance_get(struct thermal_zone_device *tz,
 			struct thermal_cooling_device *cdev, int trip)
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index e2a49e1..542a39c 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -238,7 +238,7 @@ struct thermal_cooling_device *thermal_cooling_device_register(char *, void *,
 		const struct thermal_cooling_device_ops *);
 void thermal_cooling_device_unregister(struct thermal_cooling_device *);
 
-int get_tz_trend(struct thermal_zone_device *, int);
+int thermal_zone_trend_get(struct thermal_zone_device *, int);
 struct thermal_instance *thermal_instance_get(struct thermal_zone_device *,
 		struct thermal_cooling_device *, int);
 void thermal_cdev_update(struct thermal_cooling_device *);
-- 
1.7.7.1.488.ge8e1c

