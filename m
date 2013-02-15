Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759969Ab3BOJrO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 04:47:14 -0500
Received: from mga09.intel.com ([134.134.136.24]:10534 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755253Ab3BOJrL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 04:47:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,672,1355126400"; 
   d="scan'208";a="286172076"
From: "Zhang, Rui" <rui.zhang@intel.com>
To: Andreas Mohr <andi@lisas.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "R, Durgadoss" <durgadoss.r@intel.com>, "peter@piie.net" <peter@piie.net>,
        "lenb@kernel.org" <lenb@kernel.org>
Subject: RE: thermal governor: does it actually work??
Thread-Topic: thermal governor: does it actually work??
Thread-Index: AQHOCsiS9m4z/gHQmUWPsLihfR+t2Zh6pmhw
Date: Fri, 15 Feb 2013 09:47:07 +0000
Message-ID: <744357E9AAD1214791ACBA4B0B90926329ED72@SHSMSX101.ccr.corp.intel.com>
References: <20130214153255.GA5033@rhlx01.hs-esslingen.de>
In-Reply-To: <20130214153255.GA5033@rhlx01.hs-esslingen.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Andreas Mohr [mailto:andi@lisas.de]
> Sent: Thursday, February 14, 2013 11:33 PM
> To: linux-kernel@vger.kernel.org
> Cc: R, Durgadoss; Zhang, Rui; peter@piie.net
> Subject: thermal governor: does it actually work??
> Importance: High
> 
> For me after having loaded acerhdf the fan never stops (with kernelmode
> active), despite staying safely below trip point
> (acerhdf_set_cur_state() actually never gets called).

Please attach the output of
"grep . /sys/class/thermal/thermal_zone*/cdev*/*"?

> And AFAIR in a 3.2.0 kernel acerhdf fan operation seemed to just work
> (i.e., no fan for low temps, from the beginning).
> Needless to say 3.2.0 didn't even feature all the modern thermal
> governor crapyard yet ;) (ok, well, it's more complex but it's also a
> very nice environment capability)
> 
> 3.8-rc7:
> CONFIG_ACPI_THERMAL=m
> CONFIG_THERMAL=m
> CONFIG_THERMAL_HWMON=y
> CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
> # CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set #
> CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set CONFIG_FAIR_SHARE=y
> CONFIG_STEP_WISE=y # CONFIG_USER_SPACE is not set # CONFIG_CPU_THERMAL
> is not set
> 
> 
> 
> Terminology in this area seems to be quite a bit off, too, at several
> docs places, at least according to my understanding:
> 
> e.g. drivers/thermal/step_wise.c has the following comment:
> 
> /**
>  * step_wise_throttle - throttles devices associated with the given
> zone
>  * @tz - thermal_zone_device
>  * @trip - the trip point
>  * @trip_type - type of the trip point
>  *
>  * Throttling Logic: This uses the trend of the thermal zone to
>  * throttle.
>  * If the thermal zone is 'heating up' this throttles all the cooling
>  * devices associated with the zone and its particular trip point, by
>  * one
>  * step. If the zone is 'cooling down' it brings back the performance
> of
>  * the devices by one step.
> 
> 
> 
> if ... heating up ... throttles ...
> Sorry, but at least for P4 clockmod stuff (or some such), throttle
> states (P1...P8 IIRC) meant that the CPU operation was *reduced*, i.e.
> with pause intervals.

For processors, surely you are right.

> And the translation of throttle clearly says that it does go that way
> and not the other way...
> (yes, you managed to confuse me that much that I even had to look up
> things to verify)
> 

The question is that if we can also call it "throttle" when reducing the device performance to generate less heat.

I do not have a clear answer for this as I'm not a native English speaker.
And what you're saying here may be right.
Surely I can generate a patch to rename it if throttle can't be used in that way.

Len,
What's your idea on this?

Thanks,
rui
> ... cooling down ... brings back ...
> This should certainly be worded "reduces" or some such.
> 
> So, any idea why I'm missing callbacks in acerhdf (if that is what I'm
> supposed to expect to happen)?
> Kernel bug, .config mistake, missing/wrong user-side setup?
> 
> Needless to say if kernel bug this ought to be fixed pre-3.8 ideally.
> 
> Thanks,
> 
> Andreas Mohr
