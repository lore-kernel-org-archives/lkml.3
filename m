Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693AbaK0JnQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 04:43:16 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:51972 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328AbaK0JnK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 04:43:10 -0500
X-AuditID: cbfee61a-f79c06d000004e71-ad-5476f22ccbd9
Date: Thu, 27 Nov 2014 10:42:59 +0100
From: Lukasz Majewski <l.majewski@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: navneet kumar <navneetk@nvidia.com>, Zhang Rui <rui.zhang@intel.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Guenter Roeck <linux@roeck-us.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Caesar Wang <caesar.wang@rock-chips.com>,
        Lukasz Majewski <l.majewski@majess.pl>
Subject: Re: [PATCH v2 3/4] thermal: of: Extend of-thermal to export table of
 trip points
Message-id: <20141127104259.1b01eb0a@amdc2363>
In-reply-to: <20141126230922.GA2612@developer>
References: <1412872737-624-1-git-send-email-l.majewski@samsung.com>
 <1416500488-7232-1-git-send-email-l.majewski@samsung.com>
 <1416500488-7232-4-git-send-email-l.majewski@samsung.com>
 <20141125203629.GA14292@developer> <20141126093510.4233ff7f@amdc2363>
 <20141126151828.GC3925@developer> <54763B66.90208@nvidia.com>
 <20141126230922.GA2612@developer>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLIsWRmVeSWpSXmKPExsVy+t9jAV2dT2UhBk/fG1o8XrOYyWLjjPWs
	Fl8+97FZzL9yjdVizV8lizePuC0u75rDZvG59wijxZOFZ5gsHlydxmaxb81SJosnD4FKXx1s
	Y7H4uWseiwOfx85Zd9k9Fu95yeSxbtpbZo/e5ndsHn9n7Wfx2Pm9gd2jb8sqRo/Pm+Q8Ns4N
	DeCM4rJJSc3JLEst0rdL4Mo4fn8mU8Gv3Iqj8y6xNjBeCu1i5OSQEDCRuN86mQnCFpO4cG89
	WxcjF4eQwCJGiaO770E5vxglrs88yg5SxSKgKrHz/0wwm01AT+Lz3adg3SICWhInLm1nAmlg
	FvjAItG6t4cFJCEsEC3RdnAtmM0L1NC95ytzFyMHByeQ3fLSCGLBCyaJ9hm/wGr4BSQl2v/9
	YIY4yU7i3KcN7BC9ghI/Jt8Dq2EWUJeYNG8RM4StLfHk3QXWCYyCs5CUzUJSNgtJ2QJG5lWM
	oqkFyQXFSem5hnrFibnFpXnpesn5uZsYwZH2TGoH48oGi0OMAhyMSjy8FgfKQoRYE8uKK3MP
	MUpwMCuJ8EotAgrxpiRWVqUW5ccXleakFh9ilOZgURLnvXEzN0RIID2xJDU7NbUgtQgmy8TB
	KdXAuGbaN9bL4rNXzbu3rbrhoc7lC+01K5YbfQgQ6L92YKJA3ZL9IZ13NuzWFzqTYrzmxOuL
	fI++eCXMFZh7xXtLZHzmA+9lh/UyDRVZWtqnmQnW3Nh1+vOvmVFsfydouTSlTDt+YQ6ve/Tf
	qtUm4Q132kuZS0P2MC86tGK+v6Om0YtUUdVJty4+O6nEUpyRaKjFXFScCAA5ub2YsAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eduardo,

> 
> Hello Navneet,
> 
> On Wed, Nov 26, 2014 at 12:43:18PM -0800, navneet kumar wrote:
> > 
> > Hi Eduardo, Lukasz,
> > 
> > [Combining my concerns as a single text blob here]
> > 
> > I. Firstly, with the current patch
> > 	1. is it really needed to duplicate the struct
> > thermal_trip? Why don’t we get rid of the __thermal_trip and stay
> > with the 'thermal_trip' ? it is not a big change.

The __thermal_trip seems to be somehow "private" structure (to
of-thermal) which holds not only data which could be exposed to sensors.

> > 
> > 	2. gtrips is not updated on "set_trip_temp" etc. actions
> > via sysfs. (am I missing something?).

True. This is a bug. Thanks for spotting.

> > 
> 
> Good! Comments are always welcome, that's how we make patches :-).
> 
> Both above make sense to me.
> 
> > II. The other concern is more of a design question
> > 	1. Do we intend to keep the of-thermal as a middle layer
> > between the thermal_core and the sensor device? OR, is the role of
> > of-thermal just to parse the DT and opt out ? currently of-thermal
> > is somewhat a hybrid of these as, in addition to parsing the dt, it
> > holds on to the data related to trip points etc. etc.
> > 
> 
> of-thermal has always been as your latter statement, and I intend to
> keep it as it should be, just a of parser for thermal data.

It seems to me that now of-thermal is doing more than parsing
thermal data. 

For example it is an abstraction layer for
calling .get_temp(), .get_trend().

It has its own set of "private" trip points which aren't exposed to
sensors.

Also, it registers thermal_zone_device.

A lot of stuff is done by the of-thermal. Frankly, I don't
mind, since this is a common code for many sensors.

For example with of-thermal.c usage, we are able to cut down LOC number
by half for Exynos TMU when moving to OF.

> 
> > 	2. assuming latter is true (OF is just a dt parser helper):
> > we should not be adding more intelligence and dependencies linked
> > to the OF.
> > 
> 
> Yes this is right. We should never be adding intelligence to it,

But a lot of stuff is already added and to be worse it is well adopted
API by sensors.

> except for parsing the thermal data out of device tree and adding the
> proper structures inside the kernel.

In my understanding the of-thermal code to expose the above features
need to:
- parse device tree
- export trip points in a table to sensors
- export cpu frequencies (OPPs?) with information about corresponding
  temperature

And that is all. The sensor is then responsible for initializing HW and
register the thermal zone with thermal_core.


> 
> > 	3. assuming former is true (OF is a well-defined middle
> > layer): All is good till the point OF maintains the trip points
> > (which is a good thing since, OF caches on to the data); BUT, if we
> > expose this information to the sensor device too (as this patch is
> > doing),
> > 
> 
> the former is not true.
> 
> > 		3a. we violate the layering principle :-)
> > 

Are we? of-thermal.c is parsing DT and it exposes read only information
about trip points. Also it gives you information about e.g. number of
available trip points.

> 
> well, even if it was, I disagree here. :-) The split between data
> coming from DT and the driver is still in place. Besides, there is
> other layers that expose some of their data, and that doesn't violate
> their layering principles. CPUfreq, for one closer example, exposes
> its freq table.
> 
> It would be different if by exposing this data, the users would be
> affecting the behavior of the layer. And that is not the intention of
> cpufreq table. In the same way, that is not the intention of this
> patch.
> 
> > 		3b. more importantly, this is all just excessive
> > logic that we put in which *could be useful* only if we intend to
> > extend the role of OF as a trip point management layer that does
> > more than just holding on to the data. This may include -
> > 
> > 			-> The sensor devices to know nothing about
> > the trip_points, instead the sensor devices would work on
> > 			"temperature thresholds" and OF would map
> > sensor thresholds to the actual trip points as needed
> > 			(configured from DT); while the sensor
> > devices stick to using "thresholds".
> > 
> > 			-> Queuing from above, sensors, most of the
> > time, only need to know a high and a low temp threshold; which
> > 			essentially is a subset of the
> > active/passive etc. trip points. Calculation of that based on the
> > current temp, as of today is replicated across all the sensor
> > drivers and can be hoisted up to the of-thermal.
> > 
> 
> There is no intention to add such logic to of thermal. The main reason
> is of-thermal should never be competing with thermal core. Any
> extension in of-thermal needs to be supported by thermal core.
> 
> I believe all the above is left currently to thermal zone device
> drivers. The problem with of-thermal is that it had to be born as a
> thermal zone device driver. And that is because..
> 
> > Seems like this is the opportune time to make a call about the role
> > of of-thermal?
> > 
> 
> .. the point one may be missing here is the fact that with current
> thermal subsystem implementation, handling thermal devices is somewhat
> different from other devices within the kernel.
> 
> The real design issue (or not an issue) we have is the fact that
> thermal drivers adds both the driver and the device. Changing that is
> somewhat disruptive. Not impossible, but requires considering the
> existing driver's code.
> 
> If we had a better split from who adds the device and who provides the
> driver, then of-thermal would never be a "glue layer" or born as
> thermal zone device driver. It would simply, parse DT, add the
> devices, done.
> 
> Then, drivers would register themselves as handlers for specific
> thermal devices. That is the correct design, based on common design
> found in other parts of the kernel. Another little missing end would
> be the "compatible" string for thermal zone devices in DT. But as I
> said, it should not be a blocker.
> 
> So, given the current situation, we have essentially two options: (a)
> stick to the same design we have for now, having of-thermal as dummy
> as possible, and grow in small steps towards the correct design; or
> (b) redesign thermal core to have a better split between devices and
> drivers, then adjust of-thermal.
> 
> 
> For now, the path we are taking is (a). In fact, to fit the needs of
> coming drivers, specially considering they are based on DT booting
> platforms, it is always tempting to add intelligence to of-thermal.
> But, as I mentioned, I want to avoid growing intelligence in it, for
> obvious reasons.

Eventually, it is your call if we make __thermal_trip [1] exported to
sensors (with or without struct device_node *np)
 or if we have new structure (e.g. struct thermal_trip) which is a read
only reference to relevant fields of [1]?

> 
> > On 11/26/2014 07:18 AM, Eduardo Valentin wrote:
> > > * PGP Signed by an unknown key
> > > 
> > > Hello,
> > > 
> > > On Wed, Nov 26, 2014 at 09:35:10AM +0100, Lukasz Majewski wrote:
> > >> Hi Eduardo,
> > >>
> > >>> Hello Lukasz,
> > >>>
> > >>> On Thu, Nov 20, 2014 at 05:21:27PM +0100, Lukasz Majewski wrote:
> > >>>> This patch extends the of-thermal.c to export copy of trip
> > >>>> points for a given thermal zone.
> > >>>>
> > >>>> Thermal drivers should use of_thermal_get_trip_points() method
> > >>>> to get pointer to table of thermal trip points.
> > >>>>
> > >>>> Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> > >>>> ---
> > >>>> Changes for v2:
> > >>>> - New patch - as suggested by Eduardo Valentin
> > >>>> ---
> > >>>>  drivers/thermal/of-thermal.c   | 33
> > >>>> +++++++++++++++++++++++++++++++++
> > >>>> drivers/thermal/thermal_core.h | 7 +++++++
> > >>>> include/linux/thermal.h        | 14 ++++++++++++++ 3 files
> > >>>> changed, 54 insertions(+)
> > >>>>
> > >>>> diff --git a/drivers/thermal/of-thermal.c
> > >>>> b/drivers/thermal/of-thermal.c index 336af7f..33921c5 100644
> > >>>> --- a/drivers/thermal/of-thermal.c
> > >>>> +++ b/drivers/thermal/of-thermal.c
> > >>>> @@ -89,6 +89,7 @@ struct __thermal_zone {
> > >>>>  	/* trip data */
> > >>>>  	int ntrips;
> > >>>>  	struct __thermal_trip *trips;
> > >>>> +	struct thermal_trip *gtrips;
> > Do we really need this duplication ?
> > >>>>  
> > >>>>  	/* cooling binding data */
> > >>>>  	int num_tbps;
> > >>>> @@ -152,6 +153,27 @@ bool of_thermal_is_trip_en(struct
> > >>>> thermal_zone_device *tz, int trip) return true;
> > >>>>  }
> > >>>>  
> > >>>> +/**
> > >>>> + * of_thermal_get_trip_points - function to get access to a
> > >>>> globally exported
> > >>>> + *				trip points
> > >>>> + *
> > >>>> + * @tz:	pointer to a thermal zone
> > >>>> + *
> > >>>> + * This function provides a pointer to the copy of trip points
> > >>>> table
> > >>>> + *
> > >>>> + * Return: pointer to trip points table, NULL otherwise
> > >>>> + */
> > >>>> +const struct thermal_trip * const
> > >>>> +of_thermal_get_trip_points(struct thermal_zone_device *tz)
> > >>>> +{
> > >>>> +	struct __thermal_zone *data = tz->devdata;
> > >>>> +
> > >>>> +	if (!data)
> > >>>> +		return NULL;
> > >>>> +
> > >>>> +	return data->gtrips;
> > >>>> +}
> > >>>> +
> > >>>
> > >>> EXPORT_SYMBOL_GPL(of_thermal_get_trip_points);
> > >>
> > >> Ok.
> > >>
> > >>>
> > >>>>  static int of_thermal_get_trend(struct thermal_zone_device
> > >>>> *tz, int trip, enum thermal_trend *trend)
> > >>>>  {
> > >>>> @@ -767,6 +789,16 @@ thermal_of_build_thermal_zone(struct
> > >>>> device_node *np) goto free_tbps;
> > >>>>  	}
> > >>>>  
> > >>>> +	tz->gtrips = kcalloc(tz->ntrips, sizeof(*tz->gtrips),
> > >>>> GFP_KERNEL);
> > >>>> +	if (!tz->gtrips) {
> > >>>> +		ret = -ENOMEM;
> > >>>> +		goto free_tbps;
> > >>>> +	}
> > >>>> +
> > >>>> +	for (i = 0; i < tz->ntrips; i++)
> > >>>> +		memcpy(&(tz->gtrips[i]),
> > >>>> &(tz->trips[i].temperature),
> > >>>> +		       sizeof(*tz->gtrips));
> > >>>> +
> > >>>>  finish:
> > >>>>  	of_node_put(child);
> > >>>>  	tz->mode = THERMAL_DEVICE_DISABLED;
> > >>>> @@ -793,6 +825,7 @@ static inline void
> > >>>> of_thermal_free_zone(struct __thermal_zone *tz) {
> > >>>>  	int i;
> > >>>>  
> > >>>> +	kfree(tz->gtrips);
> > >>>>  	for (i = 0; i < tz->num_tbps; i++)
> > >>>>  		of_node_put(tz->tbps[i].cooling_device);
> > >>>>  	kfree(tz->tbps);
> > Couldn't find the code that updates *gtrips as a result of
> > set_trip_temp via sysfs.
> > 
> > >>>> diff --git a/drivers/thermal/thermal_core.h
> > >>>> b/drivers/thermal/thermal_core.h index 466208c..a9580ca 100644
> > >>>> --- a/drivers/thermal/thermal_core.h
> > >>>> +++ b/drivers/thermal/thermal_core.h
> > >>>> @@ -91,6 +91,8 @@ int of_parse_thermal_zones(void);
> > >>>>  void of_thermal_destroy_zones(void);
> > >>>>  int of_thermal_get_ntrips(struct thermal_zone_device *);
> > >>>>  bool of_thermal_is_trip_en(struct thermal_zone_device *, int);
> > >>>> +const struct thermal_trip * const
> > >>>> +of_thermal_get_trip_points(struct thermal_zone_device *);
> > >>>>  #else
> > >>>>  static inline int of_parse_thermal_zones(void) { return 0; }
> > >>>>  static inline void of_thermal_destroy_zones(void) { }
> > >>>> @@ -102,6 +104,11 @@ static inline bool
> > >>>> of_thermal_is_trip_en(struct thermal_zone_device *, int) {
> > >>>
> > >>> This produces compilation error when CONFIG_THERMAL_OF is not
> > >>> set. Name the parameters to fix.
> > >>
> > >> As all the other cases, I will fix that.
> > >>
> > >>>
> > >>>>  	return 0;
> > >>>>  }
> > >>>> +static inline const struct thermal_trip * const
> > >>>> +of_thermal_get_trip_points(struct thermal_zone_device *)
> > >>>> +{
> > >>>> +	return NULL;
> > >>>> +}
> > >>>>  #endif
> > >>>>  
> > >>>>  #endif /* __THERMAL_CORE_H__ */
> > >>>> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> > >>>> index 5bc28a7..88d7249 100644
> > >>>> --- a/include/linux/thermal.h
> > >>>> +++ b/include/linux/thermal.h
> > >>>> @@ -303,6 +303,20 @@ struct thermal_zone_of_device_ops {
> > >>>>  	int (*get_trend)(void *, long *);
> > >>>>  };
> > >>>>  
> > >>>> +/**
> > >>>> + * struct thermal_trip - Structure representing themal trip
> > >>>> points exported from
> > >>>> + *                       of-thermal
> > >>>> + *
> > >>>
> > >>> The only problem I have with this name is that would look like
> > >>> it is in use in all thermal framework, which is not really the
> > >>> case. But I do think having a type here is a good thing. So,
> > >>> not sure :-)
> > >>
> > >> It can stay to be struct thermal_trip or we can rename it to
> > >> struct of_thermal_trip.
> > >>
> > >> I'm fine with both names.
> > > 
> > > Leave it as 'thermal_trip'.
> > > 
> > >>
> > >>>
> > >>>> + * @temperature:	trip point temperature
> > >>>> + * @hysteresis:		trip point hysteresis
> > >>>> + * @type:		trip point type
> > >>>> + */
> > >>>> +struct thermal_trip {
> > >>>> +	unsigned long int temperature;
> > >>>> +	unsigned long int hysteresis;
> > >>>> +	enum thermal_trip_type type;
> > >>>> +};
> > >>>> +
> > >>>>  /* Function declarations */
> > >>>>  #ifdef CONFIG_THERMAL_OF
> > >>>>  struct thermal_zone_device *
> > >>>> -- 
> > >>>> 2.0.0.rc2
> > >>>>
> > >>
> > >>
> > >>
> > >> -- 
> > >> Best regards,
> > >>
> > >> Lukasz Majewski
> > >>
> > >> Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
> > > 
> > > * Unknown Key
> > > * 0x7DA4E256
> > > 



-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
