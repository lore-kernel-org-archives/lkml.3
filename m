Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757140Ab3DWVu1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 17:50:27 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:39103 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756778Ab3DWVuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 17:50:24 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <rui.zhang@intel.com>
CC: <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCHv2 4/9] thermal: use EXPORT_SYMBOL_GPL
Date: Tue, 23 Apr 2013 17:48:15 -0400
Message-ID: <1366753700-1412-5-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
In-Reply-To: <1366753700-1412-1-git-send-email-eduardo.valentin@ti.com>
References: <1366753700-1412-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Restrict usage of GPL modules.

Acked-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/thermal/thermal_core.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index b54f916..3f39672 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -432,7 +432,7 @@ void thermal_zone_device_update(struct thermal_zone_device *tz)
 	for (count = 0; count < tz->trips; count++)
 		handle_thermal_trip(tz, count);
 }
-EXPORT_SYMBOL(thermal_zone_device_update);
+EXPORT_SYMBOL_GPL(thermal_zone_device_update);
 
 static void thermal_zone_device_check(struct work_struct *work)
 {
@@ -1195,7 +1195,7 @@ free_mem:
 	kfree(dev);
 	return result;
 }
-EXPORT_SYMBOL(thermal_zone_bind_cooling_device);
+EXPORT_SYMBOL_GPL(thermal_zone_bind_cooling_device);
 
 /**
  * thermal_zone_unbind_cooling_device - unbind a cooling device from a thermal zone
@@ -1235,7 +1235,7 @@ unbind:
 	kfree(pos);
 	return 0;
 }
-EXPORT_SYMBOL(thermal_zone_unbind_cooling_device);
+EXPORT_SYMBOL_GPL(thermal_zone_unbind_cooling_device);
 
 static void thermal_release(struct device *dev)
 {
@@ -1332,7 +1332,7 @@ unregister:
 	device_unregister(&cdev->device);
 	return ERR_PTR(result);
 }
-EXPORT_SYMBOL(thermal_cooling_device_register);
+EXPORT_SYMBOL_GPL(thermal_cooling_device_register);
 
 /**
  * thermal_cooling_device_unregister - removes the registered thermal cooling device
@@ -1392,7 +1392,7 @@ void thermal_cooling_device_unregister(struct thermal_cooling_device *cdev)
 	device_unregister(&cdev->device);
 	return;
 }
-EXPORT_SYMBOL(thermal_cooling_device_unregister);
+EXPORT_SYMBOL_GPL(thermal_cooling_device_unregister);
 
 void thermal_cdev_update(struct thermal_cooling_device *cdev)
 {
@@ -1433,7 +1433,7 @@ void thermal_notify_framework(struct thermal_zone_device *tz, int trip)
 {
 	handle_thermal_trip(tz, trip);
 }
-EXPORT_SYMBOL(thermal_notify_framework);
+EXPORT_SYMBOL_GPL(thermal_notify_framework);
 
 /**
  * create_trip_attrs - create attributes for trip points
@@ -1685,7 +1685,7 @@ unregister:
 	device_unregister(&tz->device);
 	return ERR_PTR(result);
 }
-EXPORT_SYMBOL(thermal_zone_device_register);
+EXPORT_SYMBOL_GPL(thermal_zone_device_register);
 
 /**
  * thermal_device_unregister - removes the registered thermal zone device
@@ -1752,7 +1752,7 @@ void thermal_zone_device_unregister(struct thermal_zone_device *tz)
 	device_unregister(&tz->device);
 	return;
 }
-EXPORT_SYMBOL(thermal_zone_device_unregister);
+EXPORT_SYMBOL_GPL(thermal_zone_device_unregister);
 
 #ifdef CONFIG_NET
 static struct genl_family thermal_event_genl_family = {
@@ -1830,7 +1830,7 @@ int thermal_generate_netlink_event(struct thermal_zone_device *tz,
 
 	return result;
 }
-EXPORT_SYMBOL(thermal_generate_netlink_event);
+EXPORT_SYMBOL_GPL(thermal_generate_netlink_event);
 
 static int genetlink_init(void)
 {
-- 
1.8.2.1.342.gfa7285d

