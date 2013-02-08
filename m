Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946149Ab3BHIyS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 03:54:18 -0500
Received: from mga02.intel.com ([134.134.136.20]:28123 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946115Ab3BHIyR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 03:54:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,628,1355126400"; 
   d="scan'208";a="259519746"
From: "R, Durgadoss" <durgadoss.r@intel.com>
To: "Zhang, Rui" <rui.zhang@intel.com>
CC: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "eduardo.valentin@ti.com" <eduardo.valentin@ti.com>,
        "hongbo.zhang@linaro.org" <hongbo.zhang@linaro.org>,
        "wni@nvidia.com" <wni@nvidia.com>
Subject: RE: [PATCH 2/8] Thermal: Create zone level APIs
Thread-Topic: [PATCH 2/8] Thermal: Create zone level APIs
Thread-Index: AQHOA47ffF4wEFgFDEewd+yx4aZWdJhvRH0AgABm+vA=
Date: Fri, 8 Feb 2013 08:54:12 +0000
Message-ID: <4D68720C2E767A4AA6A8796D42C8EB5927AAB1@BGSMSX101.gar.corp.intel.com>
References: <1360061183-14137-1-git-send-email-durgadoss.r@intel.com>
	 <1360061183-14137-3-git-send-email-durgadoss.r@intel.com>
 <1360311092.2242.28.camel@rzhang1-mobl4>
In-Reply-To: <1360311092.2242.28.camel@rzhang1-mobl4>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r188sIhP002527

Hi Rui,

> -----Original Message-----
> From: Zhang, Rui
> Sent: Friday, February 08, 2013 1:42 PM
> To: R, Durgadoss
> Cc: linux-pm@vger.kernel.org; linux-kernel@vger.kernel.org;
> eduardo.valentin@ti.com; hongbo.zhang@linaro.org; wni@nvidia.com
> Subject: Re: [PATCH 2/8] Thermal: Create zone level APIs
> 
> On Tue, 2013-02-05 at 16:16 +0530, Durgadoss R wrote:
> > This patch adds a new thermal_zone structure to
> > thermal.h. Also, adds zone level APIs to the thermal
> > framework.
> >

[snip.]

> > +
> > +struct thermal_sensor *get_sensor_by_name(const char *name)
> > +{
> > +	struct thermal_sensor *pos;
> > +	struct thermal_sensor *ts = NULL;
> > +
> > +	mutex_lock(&sensor_list_lock);
> > +	for_each_thermal_sensor(pos) {
> > +		if (!strnicmp(pos->name, name, THERMAL_NAME_LENGTH))
> {
> > +			ts = pos;
> > +			break;
> 
> this function depends on the assumption that all the sensor names are
> unique.
> thus I prefer to go through all the list and return -EINVAL if duplicate
> names found, because in this case, the pointer returned may be not the
> sensor we want to get.

Yes, I agree with you. But I prefer having this check in the register API
itself, which then will not allow duplicates.

The reason being, we use this get* API (comparatively) a lot more than
the register APIs. And putting this check in the register APIs means doing
this check only once. Let me know what you think.

And the same for cooling devices too.

Thanks,
Durga
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
