Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756992Ab3DWVuK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 17:50:10 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:34509 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755647Ab3DWVuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 17:50:04 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <rui.zhang@intel.com>
CC: <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCHv2 3/9] thermal: rename notify_thermal_framework to thermal_notify_framework
Date: Tue, 23 Apr 2013 17:48:14 -0400
Message-ID: <1366753700-1412-4-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
In-Reply-To: <1366753700-1412-1-git-send-email-eduardo.valentin@ti.com>
References: <1366753700-1412-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To follow the prefix names used by the thermal functions,
this patch renames notify_thermal_framework to thermal_notify_framework.

Acked-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 Documentation/thermal/sysfs-api.txt | 2 +-
 drivers/thermal/thermal_core.c      | 6 +++---
 include/linux/thermal.h             | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/thermal/sysfs-api.txt b/Documentation/thermal/sysfs-api.txt
index b2ffe98..bb42266 100644
--- a/Documentation/thermal/sysfs-api.txt
+++ b/Documentation/thermal/sysfs-api.txt
@@ -367,7 +367,7 @@ This function returns the thermal_instance corresponding to a given
 {thermal_zone, cooling_device, trip_point} combination. Returns NULL
 if such an instance does not exist.
 
-5.3:notify_thermal_framework:
+5.3:thermal_notify_framework:
 This function handles the trip events from sensor drivers. It starts
 throttling the cooling devices according to the policy configured.
 For CRITICAL and HOT trip points, this notifies the respective drivers,
diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index a999b22..b54f916 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -1418,7 +1418,7 @@ void thermal_cdev_update(struct thermal_cooling_device *cdev)
 EXPORT_SYMBOL(thermal_cdev_update);
 
 /**
- * notify_thermal_framework - Sensor drivers use this API to notify framework
+ * thermal_notify_framework - Sensor drivers use this API to notify framework
  * @tz:		thermal zone device
  * @trip:	indicates which trip point has been crossed
  *
@@ -1429,11 +1429,11 @@ EXPORT_SYMBOL(thermal_cdev_update);
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
index 45c3917..8a1a5a4 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -244,7 +244,7 @@ int get_tz_trend(struct thermal_zone_device *, int);
 struct thermal_instance *get_thermal_instance(struct thermal_zone_device *,
 		struct thermal_cooling_device *, int);
 void thermal_cdev_update(struct thermal_cooling_device *);
-void notify_thermal_framework(struct thermal_zone_device *, int);
+void thermal_notify_framework(struct thermal_zone_device *, int);
 
 #ifdef CONFIG_NET
 extern int thermal_generate_netlink_event(struct thermal_zone_device *tz,
-- 
1.8.2.1.342.gfa7285d

