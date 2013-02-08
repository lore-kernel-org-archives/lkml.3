Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161078Ab3BHJfq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 04:35:46 -0500
Received: from mga01.intel.com ([192.55.52.88]:53816 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146Ab3BHJfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 04:35:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,628,1355126400"; 
   d="scan'208";a="284400043"
Message-ID: <1360316139.2242.65.camel@rzhang1-mobl4>
Subject: Re: [PATCHv3 0/8] Thermal Framework Enhancements
From: Zhang Rui <rui.zhang@intel.com>
To: Durgadoss R <durgadoss.r@intel.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        eduardo.valentin@ti.com, hongbo.zhang@linaro.org, wni@nvidia.com
Date: Fri, 08 Feb 2013 17:35:39 +0800
In-Reply-To: <1360061183-14137-1-git-send-email-durgadoss.r@intel.com>
References: <1360061183-14137-1-git-send-email-durgadoss.r@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-05 at 16:16 +0530, Durgadoss R wrote:
> This patch set is a v3 of the previous versions submitted here:
> [v2]: http://lwn.net/Articles/531720/
> [v1]: https://lkml.org/lkml/2012/12/18/108 
> [RFC]:https://patchwork.kernel.org/patch/1758921/
> 
> This patch set is based on Rui's -next tree, and is
> tested on a Core-i5 and an Atom netbook.
> 
> Changes since v2:
>  * Reworked the map sysfs attributes in patch [5/8]
>  * Dropped configuration for maximum sensors and
>    cooling devices, through Kconfig.
>  * Added __remove_trip_attr method
>  * Renamed __clean_map_entry to __remove_map_entry
>    for consistency in naming.
> Changes Since v1:
>  * Removed kobject creation for thermal_trip and thermal_map
>    nodes as per Greg-KH's comments.
>  * Added ABI Documentation under 'testing'.
>  * Modified the GET_INDEX macro to be more linux-like, thanks
>    to Joe Perches.
>  * Added get_[sensor/cdev]_by_name APIs to thermal.h
> 
> This series contains 8 patches:
> Patch 1/8: Creates new sensor level APIs
> Patch 2/8: Creates new zone level APIs. The existing tzd structure is
>            kept as such for clarity and compatibility purposes.
> Patch 3/8: Creates functions to add/remove a cdev to/from a zone. The
>            existing tcd structure need not be modified.
> Patch 4/8: Adds sensorX_trip_[active/passive/hot/critical] sysfs nodes,
> 	   under /sys/class/thermal/zoneY/. This exposes various trip
>            points for sensorX present in zoneY.
> Patch 5/8: Adds mapY_* sysfs node. These attributes represent
>            the binding relationship between a sensor and a cdev,
>            within a zone.
> Patch 6/8: Creates Documentation for the new APIs. A new file is
>            created for clarity. Final goal is to merge with the existing
>            file or refactor the files, as whatever seems appropriate.
> Patch 7/8: Add ABI documentation for sysfs interfaces introduced in this patch.
> Patch 8/8: A dummy driver that can be used for testing. This is not for merge.
> 
Generally, this patch set looks good to me.
But My suggestion would be:
1. introduce a new config option for the new framework.
2. If your patches are target for 3.9, you still need to introduce a
   wrapper so that platform thermal drivers can be redirect
   to either the new framework or the old one via the Kconfig option.
   (All the current platform thermal drivers should be zones with single
   sensor). And with this wrapper, users should be able to
   switching between the new ABI and old ABI via kernel config option,
   without touching the platform thermal driver code in 3.9 kernel.
3. in next release, make the old framework optional, and make the new
   framework set by default.
4. in next next release, remove the old framework.

thanks,
rui
> Durgadoss R (8):
>   Thermal: Create sensor level APIs
>   Thermal: Create zone level APIs
>   Thermal: Add APIs to bind cdev to new zone structure
>   Thermal: Add trip point sysfs nodes for sensor
>   Thermal: Create Thermal map sysfs attributes for a zone
>   Thermal: Add Documentation to new APIs
>   Thermal: Add ABI Documentation for sysfs interfaces
>   Thermal: Dummy driver used for testing
> 
>  Documentation/ABI/testing/sysfs-class-thermal |  137 ++++
>  Documentation/thermal/sysfs-api2.txt          |  247 ++++++
>  drivers/thermal/Kconfig                       |    5 +
>  drivers/thermal/Makefile                      |    2 +
>  drivers/thermal/thermal_sys.c                 |  994 +++++++++++++++++++++++++
>  drivers/thermal/thermal_test.c                |  324 ++++++++
>  include/linux/thermal.h                       |  123 ++-
>  7 files changed, 1831 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-class-thermal
>  create mode 100644 Documentation/thermal/sysfs-api2.txt
>  create mode 100644 drivers/thermal/thermal_test.c
> 


