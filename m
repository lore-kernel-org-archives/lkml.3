Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760589Ab3B1VeA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 16:34:00 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:39816 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758894Ab3B1Vd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 16:33:57 -0500
Message-ID: <512FCD3C.1020504@ti.com>
Date: Thu, 28 Feb 2013 17:33:48 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Durgadoss R <durgadoss.r@intel.com>
CC: <rui.zhang@intel.com>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <hongbo.zhang@linaro.org>,
        <wni@nvidia.com>
Subject: Re: [PATCHv3 0/8] Thermal Framework Enhancements
References: <1360061183-14137-1-git-send-email-durgadoss.r@intel.com>
In-Reply-To: <1360061183-14137-1-git-send-email-durgadoss.r@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Durga,



On 05-02-2013 06:46, Durgadoss R wrote:
> This patch set is a v3 of the previous versions submitted here:
> [v2]: http://lwn.net/Articles/531720/
> [v1]: https://lkml.org/lkml/2012/12/18/108
> [RFC]:https://patchwork.kernel.org/patch/1758921/

On this version I have some implementation details which applies mostly 
for the series. So, I am replying to patch 0 to summarize:

- Consider using linked list
- You may have contention on your indexes and arrays
- overflow on your buffer (carefully check your implementation)
- zone removal condition. can we remove zones with sensors/cdevs/maps 
registered?
- Minors on strlcpy, snprintf, devm_ helpers
- documentation in the code for these helper functions and also better 
naming..


>
> This patch set is based on Rui's -next tree, and is
> tested on a Core-i5 and an Atom netbook.
>
> Changes since v2:
>   * Reworked the map sysfs attributes in patch [5/8]
>   * Dropped configuration for maximum sensors and
>     cooling devices, through Kconfig.
>   * Added __remove_trip_attr method
>   * Renamed __clean_map_entry to __remove_map_entry
>     for consistency in naming.
> Changes Since v1:
>   * Removed kobject creation for thermal_trip and thermal_map
>     nodes as per Greg-KH's comments.
>   * Added ABI Documentation under 'testing'.
>   * Modified the GET_INDEX macro to be more linux-like, thanks
>     to Joe Perches.
>   * Added get_[sensor/cdev]_by_name APIs to thermal.h
>
> This series contains 8 patches:
> Patch 1/8: Creates new sensor level APIs
> Patch 2/8: Creates new zone level APIs. The existing tzd structure is
>             kept as such for clarity and compatibility purposes.
> Patch 3/8: Creates functions to add/remove a cdev to/from a zone. The
>             existing tcd structure need not be modified.
> Patch 4/8: Adds sensorX_trip_[active/passive/hot/critical] sysfs nodes,
> 	   under /sys/class/thermal/zoneY/. This exposes various trip
>             points for sensorX present in zoneY.
> Patch 5/8: Adds mapY_* sysfs node. These attributes represent
>             the binding relationship between a sensor and a cdev,
>             within a zone.
> Patch 6/8: Creates Documentation for the new APIs. A new file is
>             created for clarity. Final goal is to merge with the existing
>             file or refactor the files, as whatever seems appropriate.
> Patch 7/8: Add ABI documentation for sysfs interfaces introduced in this patch.
> Patch 8/8: A dummy driver that can be used for testing. This is not for merge.
>
> Durgadoss R (8):
>    Thermal: Create sensor level APIs
>    Thermal: Create zone level APIs
>    Thermal: Add APIs to bind cdev to new zone structure
>    Thermal: Add trip point sysfs nodes for sensor
>    Thermal: Create Thermal map sysfs attributes for a zone
>    Thermal: Add Documentation to new APIs
>    Thermal: Add ABI Documentation for sysfs interfaces
>    Thermal: Dummy driver used for testing
>
>   Documentation/ABI/testing/sysfs-class-thermal |  137 ++++
>   Documentation/thermal/sysfs-api2.txt          |  247 ++++++
>   drivers/thermal/Kconfig                       |    5 +
>   drivers/thermal/Makefile                      |    2 +
>   drivers/thermal/thermal_sys.c                 |  994 +++++++++++++++++++++++++
>   drivers/thermal/thermal_test.c                |  324 ++++++++
>   include/linux/thermal.h                       |  123 ++-
>   7 files changed, 1831 insertions(+), 1 deletion(-)
>   create mode 100644 Documentation/ABI/testing/sysfs-class-thermal
>   create mode 100644 Documentation/thermal/sysfs-api2.txt
>   create mode 100644 drivers/thermal/thermal_test.c
>

