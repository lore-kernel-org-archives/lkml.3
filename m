Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751276AbaKZIbp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 03:31:45 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:24662 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbaKZIbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 03:31:43 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-fb-54758fe2b0f8
Date: Wed, 26 Nov 2014 09:31:09 +0100
From: Lukasz Majewski <l.majewski@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>, Linux PM list <linux-pm@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        Caesar Wang <caesar.wang@rock-chips.com>
Subject: Re: [PATCH v2 2/4] thermal: of: Extend of-thermal.c to provide check
 if trip point is enabled
Message-id: <20141126093109.0588c2c2@amdc2363>
In-reply-to: <20141125082524.GA13924@developer>
References: <1412872737-624-1-git-send-email-l.majewski@samsung.com>
 <1416500488-7232-1-git-send-email-l.majewski@samsung.com>
 <1416500488-7232-3-git-send-email-l.majewski@samsung.com>
 <20141125082524.GA13924@developer>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOIsWRmVeSWpSXmKPExsVy+t9jQd1H/aUhBndbzSwer1nMZLFxxnpW
	iy+f+9gs5l+5xmqx5q+SxZtH3BaXd81hs/jce4TR4snCM0wWD65OY7N48hCo6tXBNhaLn7vm
	sTjweuycdZfdY/Gel0we66a9ZfbobX7H5vF31n4Wj53fG9g9+rasYvT4vEnOY+Pc0ADOKC6b
	lNSczLLUIn27BK6MiUe/sBRckamYPfMOcwPjTrEuRk4OCQETiVm3u5ghbDGJC/fWs3UxcnEI
	CUxnlLi2ZS0jhPOLUWLp/CesIFUsAqoS83bPZAOx2QT0JD7ffcoEYosIaEmcuLQdzGYW+MMs
	cXMFkM3BISyQIXHhawRImBeo/NDyK2AlnAL6Er1nQBaDzH/IKLH52DawK/gFJCXa//2AushO
	4tynDewQzYISPybfY4GYryWxeVsTK4QtL7F5zVvmCYyCs5CUzUJSNgtJ2QJG5lWMoqkFyQXF
	Sem5RnrFibnFpXnpesn5uZsYwdH1THoH46oGi0OMAhyMSjy8EVKlIUKsiWXFlbmHGCU4mJVE
	eE3qgEK8KYmVValF+fFFpTmpxYcYpTlYlMR5b9zMDRESSE8sSc1OTS1ILYLJMnFwSjUw8vze
	8GWq/JwLF/bmFh2SquMO709Q9VzP27RQXaZZoeZZa+O09w57ne/N7vJsOCuh+2vTQdnLBZN3
	vGbkSWKKP5dtozx/t/OGtL31V8Qji+a6OpTOqpfLqPzZPP/k0wc7nlhs8t13lSsmeI/G81kX
	bs38u+/im+5zk4pY56Zr7fj6+PIy5/UpHUosxRmJhlrMRcWJAAJkeQCqAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eduardo,

> 
> Lukasz,
> 
> Same stuff here.
> 
> On Thu, Nov 20, 2014 at 05:21:26PM +0100, Lukasz Majewski wrote:
> > This patch extends the of-thermal.c to provide check if trip point
> > is enabled.
> > 
> > Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> > ---
> > Changes for v2:
> > - Replace int with bool
> > - Replace 1/0 with true/false
> > - Add check if data pointer is not NULL
> > - Add missing doxygen style comment for the function
> > ---
> >  drivers/thermal/of-thermal.c   | 20 ++++++++++++++++++++
> >  drivers/thermal/thermal_core.h |  5 +++++
> >  2 files changed, 25 insertions(+)
> > 
> > diff --git a/drivers/thermal/of-thermal.c
> > b/drivers/thermal/of-thermal.c index 7170822..336af7f 100644
> > --- a/drivers/thermal/of-thermal.c
> > +++ b/drivers/thermal/of-thermal.c
> > @@ -132,6 +132,26 @@ int of_thermal_get_ntrips(struct
> > thermal_zone_device *tz) return data->ntrips;
> >  }
> >  
> > +/**
> > + * of_thermal_is_trip_en - function to check if trip point is
> > enabled
> > + *
> > + * @tz:	pointer to a thermal zone
> > + * @trip:	trip point to evaluate
> > + *
> > + * This function is responsible for checking if passed trip point
> > is enabled
> > + *
> > + * Return: true if trip point is enabled, false otherwise
> > + */
> > +bool of_thermal_is_trip_en(struct thermal_zone_device *tz, int
> > trip)
> 
> This one looks more like "is this trip point valid?" than "is this
> trip point enabled?", isn't it?
> 
> By having such a function to check if a trip is enabled, one would
> expect to have functions to enable / disable trips points.
> 
> What do you think of naming it:
> of_thermal_is_trip_valid()
> ?
> 

Good point. I think that of_thermal_is_trip_valid() is a better name.

> > +{
> > +	struct __thermal_zone *data = tz->devdata;
> > +
> > +	if (!data || trip >= data->ntrips || trip < 0)
> 
> Even your check is about looking if the trip value is within a range,
> telling the caller if the trip is valid or not, right?

Yes. Correct. it justifies function rename to of_thermal_is_trip_valid()

> 
> > +		return false;
> > +
> > +	return true;
> > +}
> > +
> 
> Missing:
> EXPORT_SYMBOL_GPL(of_thermal_is_trip_en);
> 
> or
> 
> EXPORT_SYMBOL_GPL(of_thermal_is_trip_valid);

I will add that, no problem.

> 
> >  static int of_thermal_get_trend(struct thermal_zone_device *tz,
> > int trip, enum thermal_trend *trend)
> >  {
> > diff --git a/drivers/thermal/thermal_core.h
> > b/drivers/thermal/thermal_core.h index c3c7b82..466208c 100644
> > --- a/drivers/thermal/thermal_core.h
> > +++ b/drivers/thermal/thermal_core.h
> > @@ -90,6 +90,7 @@ static inline void
> > thermal_gov_user_space_unregister(void) {} int
> > of_parse_thermal_zones(void); void of_thermal_destroy_zones(void);
> >  int of_thermal_get_ntrips(struct thermal_zone_device *);
> > +bool of_thermal_is_trip_en(struct thermal_zone_device *, int);
> >  #else
> >  static inline int of_parse_thermal_zones(void) { return 0; }
> >  static inline void of_thermal_destroy_zones(void) { }
> > @@ -97,6 +98,10 @@ static inline int of_thermal_get_ntrips(struct
> > thermal_zone_device *) {
> >  	return 0;
> >  }
> > +static inline bool of_thermal_is_trip_en(struct
> > thermal_zone_device *, int)
> 
> Same as in patch 01, this produces compilation error. Please, name
> your parameters.

Ok.

> 
> > +{
> > +	return 0;
> > +}
> >  #endif
> >  
> >  #endif /* __THERMAL_CORE_H__ */
> > -- 
> > 2.0.0.rc2
> > 



-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
