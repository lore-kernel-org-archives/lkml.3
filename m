Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423114Ab3CVVCz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 17:02:55 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:34542 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423072Ab3CVVCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 17:02:54 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: Zhang Rui <rui.zhang@intel.com>
CC: <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 04/11] thermal: rename get_thermal_instance to thermal_instance_get
Date: Fri, 22 Mar 2013 17:00:47 -0400
Message-ID: <1363986054-24637-5-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1363986054-24637-1-git-send-email-eduardo.valentin@ti.com>
References: <1363986054-24637-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To follow the prefix names used by the thermal exported functions,
this patch renames get_thermal_instance to thermal_instance_get.

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 Documentation/thermal/sysfs-api.txt |    2 +-
 drivers/thermal/fair_share.c        |    2 +-
 drivers/thermal/thermal_sys.c       |    4 ++--
 include/linux/thermal.h             |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/thermal/sysfs-api.txt b/Documentation/thermal/sysfs-api.txt
index 4b23190..059b3bf 100644
--- a/Documentation/thermal/sysfs-api.txt
+++ b/Documentation/thermal/sysfs-api.txt
@@ -358,7 +358,7 @@ are supposed to implement the callback. If they don't, the thermal
 framework calculated the trend by comparing the previous and the current
 temperature values.
 
-5.2:get_thermal_instance:
+5.2:thermal_instance_get:
 This function returns the thermal_instance corresponding to a given
 {thermal_zone, cooling_device, trip_point} combination. Returns NULL
 if such an instance does not exist.
diff --git a/drivers/thermal/fair_share.c b/drivers/thermal/fair_share.c
index 792479f..f629446 100644
--- a/drivers/thermal/fair_share.c
+++ b/drivers/thermal/fair_share.c
@@ -95,7 +95,7 @@ static int fair_share_throttle(struct thermal_zone_device *tz, int trip)
 			continue;
 
 		cdev = tzp->tbp[i].cdev;
-		instance = get_thermal_instance(tz, cdev, trip);
+		instance = thermal_instance_get(tz, cdev, trip);
 		if (!instance)
 			continue;
 
diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index ffaf6d3..44e89c0 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -170,7 +170,7 @@ int get_tz_trend(struct thermal_zone_device *tz, int trip)
 }
 EXPORT_SYMBOL(get_tz_trend);
 
-struct thermal_instance *get_thermal_instance(struct thermal_zone_device *tz,
+struct thermal_instance *thermal_instance_get(struct thermal_zone_device *tz,
 			struct thermal_cooling_device *cdev, int trip)
 {
 	struct thermal_instance *pos = NULL;
@@ -191,7 +191,7 @@ struct thermal_instance *get_thermal_instance(struct thermal_zone_device *tz,
 
 	return target_instance;
 }
-EXPORT_SYMBOL(get_thermal_instance);
+EXPORT_SYMBOL(thermal_instance_get);
 
 static void print_bind_err_msg(struct thermal_zone_device *tz,
 			struct thermal_cooling_device *cdev, int ret)
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index e8ec9d8..e2a49e1 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -239,7 +239,7 @@ struct thermal_cooling_device *thermal_cooling_device_register(char *, void *,
 void thermal_cooling_device_unregister(struct thermal_cooling_device *);
 
 int get_tz_trend(struct thermal_zone_device *, int);
-struct thermal_instance *get_thermal_instance(struct thermal_zone_device *,
+struct thermal_instance *thermal_instance_get(struct thermal_zone_device *,
 		struct thermal_cooling_device *, int);
 void thermal_cdev_update(struct thermal_cooling_device *);
 void thermal_notify_framework(struct thermal_zone_device *, int);
-- 
1.7.7.1.488.ge8e1c

