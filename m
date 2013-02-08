Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760064Ab3BHJyR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 04:54:17 -0500
Received: from mga14.intel.com ([143.182.124.37]:18244 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760030Ab3BHJyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 04:54:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,628,1355126400"; 
   d="scan'208";a="200044771"
Message-ID: <1360317247.2242.80.camel@rzhang1-mobl4>
Subject: RE: [PATCH 2/8] Thermal: Create zone level APIs
From: Zhang Rui <rui.zhang@intel.com>
To: "R, Durgadoss" <durgadoss.r@intel.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "eduardo.valentin@ti.com" <eduardo.valentin@ti.com>,
        "hongbo.zhang@linaro.org" <hongbo.zhang@linaro.org>,
        "wni@nvidia.com" <wni@nvidia.com>
Date: Fri, 08 Feb 2013 17:54:07 +0800
In-Reply-To: <4D68720C2E767A4AA6A8796D42C8EB5927AAB1@BGSMSX101.gar.corp.intel.com>
References: <1360061183-14137-1-git-send-email-durgadoss.r@intel.com>
	 <1360061183-14137-3-git-send-email-durgadoss.r@intel.com>
	 <1360311092.2242.28.camel@rzhang1-mobl4>
	 <4D68720C2E767A4AA6A8796D42C8EB5927AAB1@BGSMSX101.gar.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-02-08 at 01:54 -0700, R, Durgadoss wrote:
> Hi Rui,
> 
> > -----Original Message-----
> > From: Zhang, Rui
> > Sent: Friday, February 08, 2013 1:42 PM
> > To: R, Durgadoss
> > Cc: linux-pm@vger.kernel.org; linux-kernel@vger.kernel.org;
> > eduardo.valentin@ti.com; hongbo.zhang@linaro.org; wni@nvidia.com
> > Subject: Re: [PATCH 2/8] Thermal: Create zone level APIs
> > 
> > On Tue, 2013-02-05 at 16:16 +0530, Durgadoss R wrote:
> > > This patch adds a new thermal_zone structure to
> > > thermal.h. Also, adds zone level APIs to the thermal
> > > framework.
> > >
> 
> [snip.]
> 
> > > +
> > > +struct thermal_sensor *get_sensor_by_name(const char *name)
> > > +{
> > > +	struct thermal_sensor *pos;
> > > +	struct thermal_sensor *ts = NULL;
> > > +
> > > +	mutex_lock(&sensor_list_lock);
> > > +	for_each_thermal_sensor(pos) {
> > > +		if (!strnicmp(pos->name, name, THERMAL_NAME_LENGTH))
> > {
> > > +			ts = pos;
> > > +			break;
> > 
> > this function depends on the assumption that all the sensor names are
> > unique.
> > thus I prefer to go through all the list and return -EINVAL if duplicate
> > names found, because in this case, the pointer returned may be not the
> > sensor we want to get.
> 
> Yes, I agree with you. But I prefer having this check in the register API
> itself, which then will not allow duplicates.
> 
No, I do not think so.

Unique cdev/sensor name is not a hard rule for generic thermal layer,
and will not be.
Because any cooling device driver does not have the technology that if
its name is platform unique or not.

Say, your platform thermal driver wants to use FAN cooling device, what
if another FAN cooling device has been registered before the FAN your
platform thermal driver wants to use get registered?
If the platform thermal driver wants to use get_cdev/sensor_by_name(),
it has already made the assumption that all the cooling devices have
unique names. Thus duplicate names are a big issue, we should abort the
platform thermal driver, rather than aborting the cooling device driver
with duplicate names.

> The reason being, we use this get* API (comparatively) a lot more than
> the register APIs.

why?
why can not invoke get_sensor/cdev_by_name once and cache the pointer in
the platform thermal driver?

thanks,
rui

