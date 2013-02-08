Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946076Ab3BHI1A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 03:27:00 -0500
Received: from mga11.intel.com ([192.55.52.93]:61912 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759790Ab3BHI06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 03:26:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,628,1355126400"; 
   d="scan'208";a="288205732"
From: "R, Durgadoss" <durgadoss.r@intel.com>
To: "Zhang, Rui" <rui.zhang@intel.com>
CC: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "eduardo.valentin@ti.com" <eduardo.valentin@ti.com>,
        "hongbo.zhang@linaro.org" <hongbo.zhang@linaro.org>,
        "wni@nvidia.com" <wni@nvidia.com>
Subject: RE: [PATCH 1/8] Thermal: Create sensor level APIs
Thread-Topic: [PATCH 1/8] Thermal: Create sensor level APIs
Thread-Index: AQHOA47fUTh8eaYnjUCCH+SxflpMBJhvP4yAgABfOAA=
Date: Fri, 8 Feb 2013 08:26:53 +0000
Message-ID: <4D68720C2E767A4AA6A8796D42C8EB5927AA18@BGSMSX101.gar.corp.intel.com>
References: <1360061183-14137-1-git-send-email-durgadoss.r@intel.com>
	 <1360061183-14137-2-git-send-email-durgadoss.r@intel.com>
 <1360310031.2242.24.camel@rzhang1-mobl4>
In-Reply-To: <1360310031.2242.24.camel@rzhang1-mobl4>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r188R25s002406

Hi Rui,

> -----Original Message-----
> From: Zhang, Rui
> Sent: Friday, February 08, 2013 1:24 PM
> To: R, Durgadoss
> Cc: linux-pm@vger.kernel.org; linux-kernel@vger.kernel.org;
> eduardo.valentin@ti.com; hongbo.zhang@linaro.org; wni@nvidia.com
> Subject: Re: [PATCH 1/8] Thermal: Create sensor level APIs
> 
> On Tue, 2013-02-05 at 16:16 +0530, Durgadoss R wrote:
> > This patch creates sensor level APIs, in the
> > generic thermal framework.

[snip.]

> > +
> >  static ssize_t
> >  type_show(struct device *dev, struct device_attribute *attr, char *buf)
> >  {
> > @@ -707,6 +807,10 @@ static DEVICE_ATTR(mode, 0644, mode_show,
> mode_store);
> >  static DEVICE_ATTR(passive, S_IRUGO | S_IWUSR, passive_show,
> passive_store);
> >  static DEVICE_ATTR(policy, S_IRUGO | S_IWUSR, policy_show,
> policy_store);
> >
> > +/* Thermal sensor attributes */
> > +static DEVICE_ATTR(sensor_name, 0444, sensor_name_show, NULL);
> > +static DEVICE_ATTR(temp_input, 0444, sensor_temp_show, NULL);
> > +
> >  /* sys I/F for cooling device */
> >  #define to_cooling_device(_dev)	\
> >  	container_of(_dev, struct thermal_cooling_device, device)
> > @@ -1493,6 +1597,182 @@ static void remove_trip_attrs(struct
> thermal_zone_device *tz)
> >  }
> >
> >  /**
> > + * enable_sensor_thresholds - create sysfs nodes for thresholdX
> 
> this is a little confusing.
> I'd prefer
> thermal_sensor_sysfs_add() and create sensor_name and temp_input
> attribute in this function as well, and thermal_sensor_sysfs_remove()
> to remove the sysfs I/F.
> And further more, we can do this for thermal zones and cooling devices.

I agree, and we will change this.
Since this involves change for all standard APIs, I think it is better to submit
a separate patch to do this. What do you think ?

> 
> others look okay to me.

Thank you :-)

> 
> thanks,
> rui

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
