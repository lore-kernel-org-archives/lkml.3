Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423092Ab3CVVCf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 17:02:35 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:34525 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423027Ab3CVVCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 17:02:34 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: Zhang Rui <rui.zhang@intel.com>
CC: <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 03/11] thermal: rename notify_thermal_framework to thermal_notify_framework
Date: Fri, 22 Mar 2013 17:00:46 -0400
Message-ID: <1363986054-24637-4-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1363986054-24637-1-git-send-email-eduardo.valentin@ti.com>
References: <1363986054-24637-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To follow the prefix names used by the thermal exported functions,
this patch renames notify_thermal_framework to thermal_notify_framework.

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 Documentation/thermal/sysfs-api.txt |    2 +-
 drivers/thermal/thermal_sys.c       |    6 +++---
 include/linux/thermal.h             |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/thermal/sysfs-api.txt b/Documentation/thermal/sysfs-api.txt
index 6859661..4b23190 100644
--- a/Documentation/thermal/sysfs-api.txt
+++ b/Documentation/thermal/sysfs-api.txt
@@ -363,7 +363,7 @@ This function returns the thermal_instance corresponding to a given
 {thermal_zone, cooling_device, trip_point} combination. Returns NULL
 if such an instance does not exist.
 
-5.3:notify_thermal_framework:
+5.3:thermal_notify_framework:
 This function handles the trip events from sensor drivers. It starts
 throttling the cooling devices according to the policy configured.
 For CRITICAL and HOT trip points, this notifies the respective drivers,
diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index 9542600..ffaf6d3 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -1420,7 +1420,7 @@ void thermal_cdev_update(struct thermal_cooling_device *cdev)
 EXPORT_SYMBOL(thermal_cdev_update);
 
 /**
- * notify_thermal_framework - Sensor drivers use this API to notify framework
+ * thermal_notify_framework - Sensor drivers use this API to notify framework
  * @tz:		thermal zone device
  * @trip:	indicates which trip point has been crossed
  *
@@ -1431,11 +1431,11 @@ EXPORT_SYMBOL(thermal_cdev_update);
  * The throttling policy is based on the configured platform data; if no
  * platform data is provided, this uses the step_wise throttling policy.
  */
-void notify_thermal_framework(struct thermal_zone_device *tz, int trip)
+void thermal_notify_framework(struct thermal_zone_device *tz, int trip)
 {
 	handle_thermal_trip(tz, trip);
 }
-EXPORT_SYMBOL(notify_thermal_framework);
+EXPORT_SYMBOL(thermal_notify_framework);
 
 /**
  * create_trip_attrs - create attributes for trip points
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index f0bd7f9..e8ec9d8 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -242,7 +242,7 @@ int get_tz_trend(struct thermal_zone_device *, int);
 struct thermal_instance *get_thermal_instance(struct thermal_zone_device *,
 		struct thermal_cooling_device *, int);
 void thermal_cdev_update(struct thermal_cooling_device *);
-void notify_thermal_framework(struct thermal_zone_device *, int);
+void thermal_notify_framework(struct thermal_zone_device *, int);
 
 int thermal_register_governor(struct thermal_governor *);
 void thermal_unregister_governor(struct thermal_governor *);
-- 
1.7.7.1.488.ge8e1c

