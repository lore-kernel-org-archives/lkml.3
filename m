Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751756AbaAPS2h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 13:28:37 -0500
Received: from mga14.intel.com ([143.182.124.37]:23616 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333AbaAPS2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 13:28:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,668,1384329600"; 
   d="scan'208";a="404034805"
From: Durgadoss R <durgadoss.r@intel.com>
To: rui.zhang@intel.com, eduardo.valentin@ti.com, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hongbo.zhang@freescale.com, wni@nvidia.com,
        Durgadoss R <durgadoss.r@intel.com>
Subject: [PATCHv5 00/10] Thermal Framework Enhancements
Date: Fri, 17 Jan 2014 05:26:17 +0530
Message-Id: <1389916587-2541-1-git-send-email-durgadoss.r@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set is a v5 of the previous versions submitted here:
[v4]: http://lwn.net/Articles/568988/
[v3]: https://lkml.org/lkml/2013/2/5/228 
[v2]: http://lwn.net/Articles/531720/
[v1]: https://lkml.org/lkml/2012/12/18/108 
[RFC]:https://patchwork.kernel.org/patch/1758921/

This patch set is based on Rui's -next tree, on top
of commit 'c698a4492f01127ca90fc28cd5157f3d616fe4ff'
This is tested on a Core-i5 running ubuntu 12.04.

Changes since v4:
 * Cleaned up the thermal_release function; Now all
   kfree's are done in _unregister functions.
 * Kconfig option to selectively enable and use this
   new version of thermal_core.c
 * According to a previous comment from Rui, moved all
   new API's into a file named thermal_core_new.c
Changes since v3:
 * Added a patch to conditionally do kfree(cdev) in
   thermal_release function.
 * Reworked all sysfs attributes to have one value per file
   This includes sensor_trip_* and map_weight* attributes.
 * Added 'lock' variable in thermal_zone structure to
   protect its members.
 * Added Documentation to all functions in thermal_core.c
 * Changes all strcpy() to strlcpy()
 * Used devm_kzalloc() in places where applicable
 * Address some buffer overflow conditions and contentions
   in tz->sensors[] and tz->cdevs[].
Changes since v2:
 * Reworked the map sysfs attributes in patch [5/8]
 * Dropped configuration for maximum sensors and
   cooling devices, through Kconfig.
 * Added __remove_trip_attr method
 * Renamed __clean_map_entry to __remove_map_entry
   for consistency in naming.
Changes Since v1:
 * Removed kobject creation for thermal_trip and thermal_map
   nodes as per Greg-KH's comments.
 * Added ABI Documentation under 'testing'.
 * Modified the GET_INDEX macro to be more linux-like, thanks
   to Joe Perches.
 * Added get_[sensor/cdev]_by_name APIs to thermal.h

This series contains 10 patches:
Patch 1/10: Remove code from thermal_release function. 
            Do kfree in _unregister functions.
Patch 2/10: Creates new sensor level APIs
Patch 3/10: Adds new cooling device APIs
Patch 4/10: Creates new zone level APIs. The existing tzd structure is
            kept as such for clarity and compatibility purposes.
Patch 5/10: Creates functions to add/remove a cdev to/from a zone. The
            existing tcd structure need not be modified.
Patch 6/10: Adds sensorX_trip_[active/passive/hot/critical] sysfs nodes,
  	    under /sys/class/thermal/zoneY/. This exposes various trip
            points for sensorX present in zoneY.
Patch 7/10: Adds mapY_* sysfs node. These attributes represent the
	    relationship between various sensors and cooling
	    devices in a thermal zone.
Patch 8/10: Creates Documentation for the new APIs. A new file is
            created for clarity. Final goal is to merge with the existing
            file or refactor the files, as whatever seems appropriate.
Patch 9/10: Add ABI documentation for sysfs interfaces introduced in this patch.
Patch 10/10: A dummy driver that can be used for testing. This is not for merge.

Thanks to Rui for helping me in resolving some
Kconfig issues, related to this series.

Durgadoss R (10):
  Thermal: Do kfree in _unregister functions
  Thermal: Create sensor level APIs
  Thermal: Add cooling device APIs
  Thermal: Create zone level APIs
  Thermal: Add APIs to bind cdev to new zone structure
  Thermal: Add trip point sysfs nodes for sensor
  Thermal: Create Thermal map sysfs attributes for a zone
  Thermal: Add Documentation to new APIs
  Thermal: Add ABI Documentation for sysfs interfaces
  Thermal: Dummy driver used for testing

 Documentation/ABI/testing/sysfs-class-thermal |  137 +++
 Documentation/thermal/sysfs-api2.txt          |  240 ++++
 drivers/thermal/Kconfig                       |    9 +
 drivers/thermal/Makefile                      |    4 +
 drivers/thermal/thermal_core.c                |   19 +-
 drivers/thermal/thermal_core.h                |    1 +
 drivers/thermal/thermal_core_new.c            | 1585 +++++++++++++++++++++++++
 drivers/thermal/thermal_test.c                |  322 +++++
 include/linux/thermal.h                       |  144 ++-
 9 files changed, 2447 insertions(+), 14 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-thermal
 create mode 100644 Documentation/thermal/sysfs-api2.txt
 create mode 100644 drivers/thermal/thermal_core_new.c
 create mode 100644 drivers/thermal/thermal_test.c

-- 
1.7.9.5

