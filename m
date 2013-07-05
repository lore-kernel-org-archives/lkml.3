Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab3GEGoI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 02:44:08 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:44912 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab3GEGoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 02:44:06 -0400
X-AuditID: cbfee61a-b7f3b6d000006edd-04-51d66b33c840
Date: Fri, 05 Jul 2013 08:43:16 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: "R, Durgadoss" <durgadoss.r@intel.com>
Cc: Lukasz Majewski <l.majewski@majess.pl>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, "Zhang, Rui" <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH v5 5/7] thermal:boost: Automatic enable/disable of BOOST
 feature
Message-id: <20130705084316.3f84aeb8@amdc308.digital.local>
In-reply-to: <4D68720C2E767A4AA6A8796D42C8EB59CCF66C@BGSMSX101.gar.corp.intel.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1372927830-2949-1-git-send-email-l.majewski@samsung.com>
 <1372927830-2949-6-git-send-email-l.majewski@samsung.com>
 <4D68720C2E767A4AA6A8796D42C8EB59CCF152@BGSMSX101.gar.corp.intel.com>
 <20130704225806.6d08b0a9@jawa>
 <4D68720C2E767A4AA6A8796D42C8EB59CCF66C@BGSMSX101.gar.corp.intel.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIIsWRmVeSWpSXmKPExsVy+t9jAV3j7GuBBkvPclr8ebuc1eJp0w92
	i3mfZS36fl5htliz/yeTRefZJ8wWvQuuslm8ecRtcXnXHDaLz71HGC1uN65gs+hf2Mtk8eRh
	H5vFxq8eDnwei/e8ZPK4c20Pm8e6aW+ZPfq2rGL0eLS4hdHj+I3tTB6fN8kFsEdx2aSk5mSW
	pRbp2yVwZTw5t5W5YL9SxZOW2awNjL8luxg5OCQETCSuHKvvYuQEMsUkLtxbzwZiCwksYpRY
	/UWii5ELyG5nkpjZcJ4ZpJ5FQFXiTz8nSA2bgJ7E57tPmUBsEQEtifYdOxlB6pkFNrFItLye
	BZYQFgiTWLWjG8zmFbCW2LljNdgCToEQiVenV7NCLHgHtGDmcrAEv4CkRPu/H8wQF9lJnPu0
	gR2iWVDix+R7LCA2M9C2zduaWCFseYnNa94yT2AUnIWkbBaSsllIyhYwMq9iFE0tSC4oTkrP
	NdQrTswtLs1L10vOz93ECI6oZ1I7GFc2WBxiFOBgVOLhtWi6GijEmlhWXJl7iFGCg1lJhNc+
	4VqgEG9KYmVValF+fFFpTmrxIUZpDhYlcd4DrdaBQgLpiSWp2ampBalFMFkmDk6pBsZAtY+G
	FeeP1htu5qnpWm7mZ/H696n5qaejjgR+ZxM9s+j2vzNKDW/T/rU8l2CtLfOOv/X2ceHaSVZc
	1g6vQnKlKiv/fzcrUdkTZXGc77wNxzsxr3kcpged13x2TYo5NWW25SP16HTeQKX/oiEbDOJs
	OW137ev6Ia93yKeA5f/BNLX4XyaiX5RYijMSDbWYi4oTAbJPrlOkAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 05 Jul 2013 05:31:42 +0000, R, Durgadoss wrote:
Hi Durga,

> Hi Lukasz,
> 
> > -----Original Message-----
> > From: Lukasz Majewski [mailto:l.majewski@majess.pl]
> > Sent: Friday, July 05, 2013 2:28 AM
> > To: R, Durgadoss
> > Cc: Lukasz Majewski; Viresh Kumar; Rafael J. Wysocki; Zhang, Rui;
> > Eduardo Valentin; cpufreq@vger.kernel.org; Linux PM list; Jonghwa
> > Lee; linux-kernel; Andre Przywara; Daniel Lezcano; Kukjin Kim;
> > Myungjoo Ham Subject: Re: [PATCH v5 5/7] thermal:boost: Automatic
> > enable/disable of BOOST feature
> > 
> > On Thu, 4 Jul 2013 17:19:04 +0000
> > "R, Durgadoss" <durgadoss.r@intel.com> wrote:
> > Hi,
> > 
> 
> [Cut.]
> 
> > > > @@ -326,6 +327,15 @@ static void monitor_thermal_zone(struct
> > > > thermal_zone_device *tz)
> > > >  static void handle_non_critical_trips(struct
> > > > thermal_zone_device *tz, int trip, enum thermal_trip_type
> > > > trip_type) {
> > > > +	if (cpufreq_boost_supported()) {
> > > > +		tz->overheated = true;
> > > > +		cpufreq_boost_trigger_state(0);
> > > > +		if (!tz->polling_delay) {
> > > > +			tz->boost_polling = true;
> > > > +			tz->polling_delay = 1000;
> > > > +		}
> > > > +	}
> > > > +
> > > >  	if (tz->governor)
> > > >  		tz->governor->throttle(tz, trip);
> > > >  }
> > > > @@ -453,6 +463,27 @@ static void
> > > > thermal_zone_device_check(struct work_struct *work)
> > > >  	struct thermal_zone_device *tz = container_of(work,
> > > > struct thermal_zone_device,
> > > >  						      poll_queue.work);
> > > > +	long trip_temp;
> > > > +
> > > > +	if (cpufreq_boost_supported() && tz->overheated) {
> > >
> > > Not all thermal drivers support trip points. So, we first need a
> > > if (tz->ops->get_trip_temp) check here.
> > 
> > Ok, thanks for tip. Bluntly speaking, I thought, that all SoCs
> > supported by thermal set trip points.
> 
> We would wish to get there. But not the reality today ;)

Ok, I see :-).

> 
> > 
> > >
> > > > +		tz->ops->get_trip_temp(tz, 0, &trip_temp);
> > > > +		/*
> > > > +		 * Enable boost again only when current
> > > > temperature is less
> > > > +		 * than 75% of trip_temp[0]
> > > > +		 */
> > > > +		if ((tz->temperature + (trip_temp >> 2)) <
> > > > trip_temp) {
> > >
> > > Another way would be to use the get_trend APIs for this thermal
> > > zone. If the trend is cooling we can re-enable boost otherwise
> > > not.
> > 
> > Trend evaluation seems like a good complementary idea.
> > 
> > However, I would also like to have the relative temperature drop
> > measurement (if possible) like above (to 75% of the first trip
> > point).
> > 
> > Then I would be more confident, that everything cooled down and
> > that I can start boost again.
> > 
> > >
> > > > +			tz->overheated = false;
> > > > +			if (tz->boost_polling) {
> > > > +				tz->boost_polling = false;
> > > > +				tz->polling_delay = 0;
> > > > +				monitor_thermal_zone(tz);
> > > > +			}
> > >
> > > Overall, I believe this will work well only if the thermal zone is
> > > CPU.
> > 
> > My assumption:
> > 
> > When I enable boost at CPU, then I also shall cool down the CPU. And
> > the CPU zone seemed a natural choice.
> > 
> > However I might be missing something, so hints are welcome.
> > 
> > >
> > > Another suggestion is: We tried hard to remove all throttling
> > > logic from thermal_core.c.
> > 
> > By throttling logic you mean:
> > if ((tz->temperature + (trip_temp >> 2)) and other conditions (like
> > trend measurement)?
> 
> Yes. That is correct.

Ok.

> 
> > 
> > > May be we should include this kind of logic in
> > > step_wise.c ?
> > 
> > It sounds interesting (since ->throttle at thermal_core.c is called
> > always when needed), but I'm afraid of a code duplication when one
> > use Boost with fair_share or other thermal governor.
> 
> right. So, for the time being, (as part of this patch series)
> I am Okay to have this code in thermal_core.c. From the thermal
> subsystem perspective, we will (need to) work out a better/
> cleaner/easier approach for this later.

Thanks for understanding. I'm going to embed the trend checking in the
next version of this patch (to be more confident that I can reenable
boost).

> 
> Thanks,
> Durga
> 


-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
