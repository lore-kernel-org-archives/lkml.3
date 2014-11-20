Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149AbaKTCLO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 21:11:14 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:34442 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183AbaKTCLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 21:11:13 -0500
From: Florian Fainelli <f.fainelli@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, eduardo.valentin@ti.com, rui.zhang@intel.com,
        computersforpeace@gmail.com, Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH] thermal: provide an UAPI header file
Date: Wed, 19 Nov 2014 18:11:00 -0800
Message-Id: <1416449460-6161-1-git-send-email-f.fainelli@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

include/linux/thermal.h contains definitions for the Thermal generic
netlink family, but none of the valuable information relevant to
user-space such as the Genl family name, multicast group, version or
command set and data types is exported to user-space.

Export all the relevant generic netlink information to user-space to
make this genl family usable by user-space, and while at it, export
THERMAL_NAME_LENGTH since it limits name length for thermal_hwmon
devices.

Kbuild and MAINTAINERS are also updated accordingly to reflect this new
file: include/uapi/linux/thermal.h.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 MAINTAINERS                  |  1 +
 include/linux/thermal.h      | 31 +------------------------------
 include/uapi/linux/Kbuild    |  1 +
 include/uapi/linux/thermal.h | 35 +++++++++++++++++++++++++++++++++++
 4 files changed, 38 insertions(+), 30 deletions(-)
 create mode 100644 include/uapi/linux/thermal.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 3d7782b9f90d..462cfbe3c893 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8036,6 +8036,7 @@ Q:      https://patchwork.kernel.org/project/linux-pm/list/
 S:      Supported
 F:      drivers/thermal/
 F:      include/linux/thermal.h
+F:      include/uapi/linux/thermal.h
 F:      include/linux/cpu_cooling.h
 
 THINGM BLINK(1) USB RGB LED DRIVER
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index a386a1cbb6e1..1a0773e4c557 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -28,10 +28,10 @@
 #include <linux/idr.h>
 #include <linux/device.h>
 #include <linux/workqueue.h>
+#include <uapi/linux/thermal.h>
 
 #define THERMAL_TRIPS_NONE	-1
 #define THERMAL_MAX_TRIPS	12
-#define THERMAL_NAME_LENGTH	20
 
 /* invalid cooling state */
 #define THERMAL_CSTATE_INVALID -1UL
@@ -44,11 +44,6 @@
 				((long)t-2732+5)/10 : ((long)t-2732-5)/10)
 #define CELSIUS_TO_KELVIN(t)	((t)*10+2732)
 
-/* Adding event notification support elements */
-#define THERMAL_GENL_FAMILY_NAME                "thermal_event"
-#define THERMAL_GENL_VERSION                    0x01
-#define THERMAL_GENL_MCAST_GROUP_NAME           "thermal_mc_grp"
-
 /* Default Thermal Governor */
 #if defined(CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE)
 #define DEFAULT_THERMAL_GOVERNOR       "step_wise"
@@ -81,30 +76,6 @@ enum thermal_trend {
 	THERMAL_TREND_DROP_FULL, /* apply lowest cooling action */
 };
 
-/* Events supported by Thermal Netlink */
-enum events {
-	THERMAL_AUX0,
-	THERMAL_AUX1,
-	THERMAL_CRITICAL,
-	THERMAL_DEV_FAULT,
-};
-
-/* attributes of thermal_genl_family */
-enum {
-	THERMAL_GENL_ATTR_UNSPEC,
-	THERMAL_GENL_ATTR_EVENT,
-	__THERMAL_GENL_ATTR_MAX,
-};
-#define THERMAL_GENL_ATTR_MAX (__THERMAL_GENL_ATTR_MAX - 1)
-
-/* commands supported by the thermal_genl_family */
-enum {
-	THERMAL_GENL_CMD_UNSPEC,
-	THERMAL_GENL_CMD_EVENT,
-	__THERMAL_GENL_CMD_MAX,
-};
-#define THERMAL_GENL_CMD_MAX (__THERMAL_GENL_CMD_MAX - 1)
-
 struct thermal_zone_device_ops {
 	int (*bind) (struct thermal_zone_device *,
 		     struct thermal_cooling_device *);
diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
index ab5d4992e568..95d5e69273fa 100644
--- a/include/uapi/linux/Kbuild
+++ b/include/uapi/linux/Kbuild
@@ -367,6 +367,7 @@ header-y += tcp.h
 header-y += tcp_metrics.h
 header-y += telephony.h
 header-y += termios.h
+header-y += thermal.h
 header-y += time.h
 header-y += times.h
 header-y += timex.h
diff --git a/include/uapi/linux/thermal.h b/include/uapi/linux/thermal.h
new file mode 100644
index 000000000000..ac5535855982
--- /dev/null
+++ b/include/uapi/linux/thermal.h
@@ -0,0 +1,35 @@
+#ifndef _UAPI_LINUX_THERMAL_H
+#define _UAPI_LINUX_THERMAL_H
+
+#define THERMAL_NAME_LENGTH	20
+
+/* Adding event notification support elements */
+#define THERMAL_GENL_FAMILY_NAME                "thermal_event"
+#define THERMAL_GENL_VERSION                    0x01
+#define THERMAL_GENL_MCAST_GROUP_NAME           "thermal_mc_grp"
+
+/* Events supported by Thermal Netlink */
+enum events {
+	THERMAL_AUX0,
+	THERMAL_AUX1,
+	THERMAL_CRITICAL,
+	THERMAL_DEV_FAULT,
+};
+
+/* attributes of thermal_genl_family */
+enum {
+	THERMAL_GENL_ATTR_UNSPEC,
+	THERMAL_GENL_ATTR_EVENT,
+	__THERMAL_GENL_ATTR_MAX,
+};
+#define THERMAL_GENL_ATTR_MAX (__THERMAL_GENL_ATTR_MAX - 1)
+
+/* commands supported by the thermal_genl_family */
+enum {
+	THERMAL_GENL_CMD_UNSPEC,
+	THERMAL_GENL_CMD_EVENT,
+	__THERMAL_GENL_CMD_MAX,
+};
+#define THERMAL_GENL_CMD_MAX (__THERMAL_GENL_CMD_MAX - 1)
+
+#endif /* _UAPI_LINUX_THERMAL_H */
-- 
1.9.1

