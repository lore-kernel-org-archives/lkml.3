Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985Ab3BEKwV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 05:52:21 -0500
Received: from mga14.intel.com ([143.182.124.37]:42620 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754921Ab3BEKwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 05:52:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,602,1355126400"; 
   d="scan'208";a="252768385"
From: Durgadoss R <durgadoss.r@intel.com>
To: rui.zhang@intel.com, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, eduardo.valentin@ti.com,
        hongbo.zhang@linaro.org, wni@nvidia.com,
        Durgadoss R <durgadoss.r@intel.com>
Subject: [PATCH 7/8] Thermal: Add ABI Documentation for sysfs interfaces
Date: Tue,  5 Feb 2013 16:16:22 +0530
Message-Id: <1360061183-14137-8-git-send-email-durgadoss.r@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360061183-14137-1-git-send-email-durgadoss.r@intel.com>
References: <1360061183-14137-1-git-send-email-durgadoss.r@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds Documentation for ABI's introduced
for thermal subsystem (under /sys/class/thermal/).

Signed-off-by: Durgadoss R <durgadoss.r@intel.com>
---
 Documentation/ABI/testing/sysfs-class-thermal |  137 +++++++++++++++++++++++++
 1 file changed, 137 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-class-thermal

diff --git a/Documentation/ABI/testing/sysfs-class-thermal b/Documentation/ABI/testing/sysfs-class-thermal
new file mode 100644
index 0000000..00f033a
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-class-thermal
@@ -0,0 +1,137 @@
+What:		/sys/class/thermal/sensorX/temp
+Date:		February 2013
+KernelVersion:	3.8
+Contact:	Linux PM Mailing list <linux-pm@vger.kernel.org>
+Description:
+		Exposes 'temperature' of a thermal sensor in mC
+Users:		Kernel/User space thermal governors
+
+What:		/sys/class/thermal/sensorX/name
+Date:		February 2013
+KernelVersion:	3.8
+Contact:	Linux PM Mailing list <linux-pm@vger.kernel.org>
+Description:
+		Name of the thermal sensor
+Users:		Kernel/User space thermal governors
+
+What:		/sys/class/thermal/sensorX/thresholdY
+Date:		February 2013
+KernelVersion:	3.8
+Contact:	Linux PM Mailing list <linux-pm@vger.kernel.org>
+Description:
+		Programmable threshold (in terms of mC). On reaching
+		this, the thermal governors may take action to control
+		temperature.
+Users:		Kernel/User space thermal governors
+
+What:		/sys/class/thermal/zoneX/name
+Date:		February 2013
+KernelVersion:	3.8
+Contact:	Linux PM Mailing list <linux-pm@vger.kernel.org>
+Description:
+		Name of the thermal zone.
+Users:		Kernel/User space thermal governors
+
+What:		/sys/class/thermal/zoneX/sensorY
+Date:		February 2013
+KernelVersion:	3.8
+Contact:	Linux PM Mailing list <linux-pm@vger.kernel.org>
+Description:
+		Symlink to a sensor associated with this zone.
+Users:		User space thermal governors or applications
+
+What:		/sys/class/thermal/zoneX/cooling_deviceY
+Date:		February 2013
+KernelVersion:	3.8
+Contact:	Linux PM Mailing list <linux-pm@vger.kernel.org>
+Description:
+		Symlink to a cooling device associated with this zone.
+Users:		User space thermal governors or applications
+
+What:		/sys/class/thermal/zoneX/sensorY_trip_active
+Date:		February 2013
+KernelVersion:	3.8
+Contact:	Linux PM Mailing list <linux-pm@vger.kernel.org>
+Description:
+		Space separated list of active trip points for 'sensorY'
+		in 'zoneX' (in mC).
+Users:		Kernel/User space thermal governors
+
+What:		/sys/class/thermal/zoneX/sensorY_trip_passive
+Date:		February 2013
+KernelVersion:	3.8
+Contact:	Linux PM Mailing list <linux-pm@vger.kernel.org>
+Description:
+		Space separated list of passive trip points for 'sensorY'
+		in 'zoneX' (in mC).
+Users:		Kernel/User space thermal governors
+
+What:		/sys/class/thermal/zoneX/sensorY_trip_hot
+Date:		February 2013
+KernelVersion:	3.8
+Contact:	Linux PM Mailing list <linux-pm@vger.kernel.org>
+Description:
+		Hot trip point for 'sensorY' in 'zoneX' (in mC).
+Users:		Kernel/User space thermal governors
+
+What:		/sys/class/thermal/zoneX/sensorY_trip_critical
+Date:		February 2013
+KernelVersion:	3.8
+Contact:	Linux PM Mailing list <linux-pm@vger.kernel.org>
+Description:
+		Critical trip point for 'sensorY' in 'zoneX' (in mC).
+Users:		Kernel/User space thermal governors
+
+What:		/sys/class/thermal/zoneX/mapY_trip_type
+Date:		February 2013
+KernelVersion:	3.8
+Contact:	Linux PM Mailing list <linux-pm@vger.kernel.org>
+Description:
+		Mapping information between a sensor and a cooling device
+		in 'zoneX'. This interface provides the trip_type for a
+		particular map(Y).
+Users:		Kernel/User space thermal governors
+
+What:		/sys/class/thermal/zoneX/mapY_sensor_name
+Date:		February 2013
+KernelVersion:	3.8
+Contact:	Linux PM Mailing list <linux-pm@vger.kernel.org>
+Description:
+		Mapping information between a sensor and a cooling device
+		in 'zoneX'. This interface provides the name of the sensor
+		used in this map(Y).
+Users:		Kernel/User space thermal governors
+
+What:		/sys/class/thermal/zoneX/mapY_cdev_name
+Date:		February 2013
+KernelVersion:	3.8
+Contact:	Linux PM Mailing list <linux-pm@vger.kernel.org>
+Description:
+		Mapping information between a sensor and a cooling device
+		in 'zoneX'. This interface provides the name of the cooling
+		device used in this map(Y).
+Users:		Kernel/User space thermal governors
+
+What:		/sys/class/thermal/zoneX/mapY_trip_mask
+Date:		February 2013
+KernelVersion:	3.8
+Contact:	Linux PM Mailing list <linux-pm@vger.kernel.org>
+Description:
+		Mapping information between a sensor and a cooling device
+		in 'zoneX'. This interface provides the trip point mask,
+		which defines whether or not to throttle a particular
+		cooling device. See Documentation/thermal/sysfs-api2.txt
+		for more information on this interface.
+Users:		Kernel/User space thermal governors
+
+What:		/sys/class/thermal/zoneX/mapY_weights
+Date:		February 2013
+KernelVersion:	3.8
+Contact:	Linux PM Mailing list <linux-pm@vger.kernel.org>
+Description:
+		Mapping information between a sensor and a cooling device
+		in 'zoneX'. This interface provides the weights that can
+		be used to throttle a cooling device, on thermal violations.
+		See Documentation/thermal/sysfs-api2.txt for more details on
+		this interface.
+Users:		Kernel/User space thermal governors
-- 
1.7.9.5

