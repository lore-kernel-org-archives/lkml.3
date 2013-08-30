Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028Ab3H3JUm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 05:20:42 -0400
Received: from mga03.intel.com ([143.182.124.21]:63088 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694Ab3H3JUj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 05:20:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,989,1367996400"; 
   d="scan'208";a="353779991"
From: "R, Durgadoss" <durgadoss.r@intel.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
CC: "Zhang, Rui" <rui.zhang@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hongbo.zhang@linaro.org" <hongbo.zhang@linaro.org>,
        "wni@nvidia.com" <wni@nvidia.com>
Subject: RE: [PATCHv3 0/8] Thermal Framework Enhancements
Thread-Topic: [PATCHv3 0/8] Thermal Framework Enhancements
Thread-Index: AQHOpO9fn2+fS6U/+ka5UqqQQPExz5mtTpLA
Date: Fri, 30 Aug 2013 09:20:29 +0000
Message-ID: <4D68720C2E767A4AA6A8796D42C8EB59D4D3F8@BGSMSX101.gar.corp.intel.com>
References: <1360061183-14137-1-git-send-email-durgadoss.r@intel.com>
 <521FA335.2060309@ti.com>
In-Reply-To: <521FA335.2060309@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eduardo,

> -----Original Message-----
> From: Eduardo Valentin [mailto:eduardo.valentin@ti.com]
> Sent: Friday, August 30, 2013 1:08 AM
> To: R, Durgadoss
> Cc: Zhang, Rui; linux-pm@vger.kernel.org; linux-kernel@vger.kernel.org;
> eduardo.valentin@ti.com; hongbo.zhang@linaro.org; wni@nvidia.com
> Subject: Re: [PATCHv3 0/8] Thermal Framework Enhancements
> 
> Durga,
> 
> On 05-02-2013 06:46, Durgadoss R wrote:
> > This patch set is a v3 of the previous versions submitted here:
> > [v2]: http://lwn.net/Articles/531720/
> > [v1]: https://lkml.org/lkml/2012/12/18/108
> > [RFC]:https://patchwork.kernel.org/patch/1758921/
> >
> 
> Long time this work is not moving forward. While writing the device tree

I am trying my best to get to this,
Will try to refresh in a couple of weeks.

> parser, I thought of using your work as baseline to see how the multiple
> sensor per zone would look like (also in DT).
> 
> But while checking your code again, I realized that you are actually
> creating a new API, that is probably why you named it sysfs-api2. While
> I understand the motivation (they are pretty different), I believe this
> is not a good thing to do. I would suggest making so that we have a
> single API.

As in the sensor APIs ? or the zone level APIs ?
The sensor level APIs are anyway new; the zone level ones
we have to work out a way for them.

Is this what you are referring to ? Could you confirm/explain a bit more ?

Thanks,
Durga

> 
> > This patch set is based on Rui's -next tree, and is
> > tested on a Core-i5 and an Atom netbook.
> >
> > Changes since v2:
> >  * Reworked the map sysfs attributes in patch [5/8]
> >  * Dropped configuration for maximum sensors and
> >    cooling devices, through Kconfig.
> >  * Added __remove_trip_attr method
> >  * Renamed __clean_map_entry to __remove_map_entry
> >    for consistency in naming.
> > Changes Since v1:
> >  * Removed kobject creation for thermal_trip and thermal_map
> >    nodes as per Greg-KH's comments.
> >  * Added ABI Documentation under 'testing'.
> >  * Modified the GET_INDEX macro to be more linux-like, thanks
> >    to Joe Perches.
> >  * Added get_[sensor/cdev]_by_name APIs to thermal.h
> >
> > This series contains 8 patches:
> > Patch 1/8: Creates new sensor level APIs
> > Patch 2/8: Creates new zone level APIs. The existing tzd structure is
> >            kept as such for clarity and compatibility purposes.
> > Patch 3/8: Creates functions to add/remove a cdev to/from a zone. The
> >            existing tcd structure need not be modified.
> > Patch 4/8: Adds sensorX_trip_[active/passive/hot/critical] sysfs nodes,
> > 	   under /sys/class/thermal/zoneY/. This exposes various trip
> >            points for sensorX present in zoneY.
> > Patch 5/8: Adds mapY_* sysfs node. These attributes represent
> >            the binding relationship between a sensor and a cdev,
> >            within a zone.
> > Patch 6/8: Creates Documentation for the new APIs. A new file is
> >            created for clarity. Final goal is to merge with the existing
> >            file or refactor the files, as whatever seems appropriate.
> > Patch 7/8: Add ABI documentation for sysfs interfaces introduced in this patch.
> > Patch 8/8: A dummy driver that can be used for testing. This is not for merge.
> >
> > Durgadoss R (8):
> >   Thermal: Create sensor level APIs
> >   Thermal: Create zone level APIs
> >   Thermal: Add APIs to bind cdev to new zone structure
> >   Thermal: Add trip point sysfs nodes for sensor
> >   Thermal: Create Thermal map sysfs attributes for a zone
> >   Thermal: Add Documentation to new APIs
> >   Thermal: Add ABI Documentation for sysfs interfaces
> >   Thermal: Dummy driver used for testing
> >
> >  Documentation/ABI/testing/sysfs-class-thermal |  137 ++++
> >  Documentation/thermal/sysfs-api2.txt          |  247 ++++++
> >  drivers/thermal/Kconfig                       |    5 +
> >  drivers/thermal/Makefile                      |    2 +
> >  drivers/thermal/thermal_sys.c                 |  994 +++++++++++++++++++++++++
> >  drivers/thermal/thermal_test.c                |  324 ++++++++
> >  include/linux/thermal.h                       |  123 ++-
> >  7 files changed, 1831 insertions(+), 1 deletion(-)
> >  create mode 100644 Documentation/ABI/testing/sysfs-class-thermal
> >  create mode 100644 Documentation/thermal/sysfs-api2.txt
> >  create mode 100644 drivers/thermal/thermal_test.c
> >
> 
> 
> --
> You have got to be excited about what you are doing. (L. Lamport)
> 
> Eduardo Valentin

