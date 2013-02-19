Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758524Ab3BSPfc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 10:35:32 -0500
Received: from mga11.intel.com ([192.55.52.93]:52000 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758393Ab3BSPfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 10:35:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,696,1355126400"; 
   d="scan'208";a="289093530"
Message-ID: <1361288123.2323.29.camel@rzhang1-mobl4>
Subject: Re: thermal governor: does it actually work??
From: Zhang Rui <rui.zhang@intel.com>
To: Andreas Mohr <andi@lisas.de>
Cc: linux-kernel@vger.kernel.org, Durgadoss R <durgadoss.r@intel.com>,
        peter@piie.net
Date: Tue, 19 Feb 2013 23:35:23 +0800
In-Reply-To: <20130214153255.GA5033@rhlx01.hs-esslingen.de>
References: <20130214153255.GA5033@rhlx01.hs-esslingen.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-14 at 16:32 +0100, Andreas Mohr wrote:
> For me after having loaded acerhdf the fan never stops (with kernelmode
> active), despite staying safely below trip point
> (acerhdf_set_cur_state() actually never gets called).

BTW, could you please check if this one fixes the problem for you?
http://git.kernel.org/?p=linux/kernel/git/rzhang/linux.git;a=commit;h=b8bb6cb999858043489c1ddef08eed2127559169

thanks,
rui
> And AFAIR in a 3.2.0 kernel acerhdf fan operation seemed to just work
> (i.e., no fan for low temps, from the beginning).
> Needless to say 3.2.0 didn't even feature all the modern thermal
> governor crapyard yet ;)
> (ok, well, it's more complex but it's also a very nice environment capability)
> 
> 3.8-rc7:
> CONFIG_ACPI_THERMAL=m
> CONFIG_THERMAL=m
> CONFIG_THERMAL_HWMON=y
> CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
> # CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
> # CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
> CONFIG_FAIR_SHARE=y
> CONFIG_STEP_WISE=y
> # CONFIG_USER_SPACE is not set
> # CONFIG_CPU_THERMAL is not set
> 
> 
> 
> Terminology in this area seems to be quite a bit off, too, at several
> docs places, at least according to my understanding:
> 
> e.g. drivers/thermal/step_wise.c has the following comment:
> 
> /**
>  * step_wise_throttle - throttles devices associated with the given zone
>  * @tz - thermal_zone_device
>  * @trip - the trip point
>  * @trip_type - type of the trip point
>  *
>  * Throttling Logic: This uses the trend of the thermal zone to
>  * throttle.
>  * If the thermal zone is 'heating up' this throttles all the cooling
>  * devices associated with the zone and its particular trip point, by
>  * one
>  * step. If the zone is 'cooling down' it brings back the performance of
>  * the devices by one step.
> 
> 
> 
> if ... heating up ... throttles ...
> Sorry, but at least for P4 clockmod stuff (or some such), throttle
> states (P1...P8 IIRC) meant that the CPU operation was *reduced*,
> i.e. with pause intervals.
> And the translation of throttle clearly says that it does go that way
> and not the other way...
> (yes, you managed to confuse me that much that I even had to look up
> things to verify)
> 
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


