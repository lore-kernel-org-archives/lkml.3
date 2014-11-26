Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751208AbaKZI2o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 03:28:44 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:50877 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbaKZI2m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 03:28:42 -0500
X-AuditID: cbfee61a-f79c06d000004e71-0a-54758f38a7be
Date: Wed, 26 Nov 2014 09:28:29 +0100
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
Subject: Re: [PATCH v2 1/4] thermal: of: Extend of-thermal.c to provide number
 of trip points
Message-id: <20141126092829.41127e8b@amdc2363>
In-reply-to: <20141125060421.GA13591@developer>
References: <1412872737-624-1-git-send-email-l.majewski@samsung.com>
 <1416500488-7232-1-git-send-email-l.majewski@samsung.com>
 <1416500488-7232-2-git-send-email-l.majewski@samsung.com>
 <20141125060421.GA13591@developer>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCIsWRmVeSWpSXmKPExsVy+t9jQV2L/tIQg8NrJC0er1nMZLFxxnpW
	iy+f+9gs5l+5xmqx5q+SxZtH3BaXd81hs/jce4TR4snCM0wWD65OY7N48hCo6tXBNhaLn7vm
	sTjweuycdZfdY/Gel0we66a9ZfbobX7H5vF31n4Wj53fG9g9+rasYvT4vEnOY+Pc0ADOKC6b
	lNSczLLUIn27BK6MSw8a2Qs2SVbMmcbWwLhXpIuRk0NCwERiwreFTBC2mMSFe+vZuhi5OIQE
	pjNK/Px1mAXC+cUo0X7zHytIFYuAqsTkk33sIDabgJ7E57tPwbpFBLQkTlzaDmYzC/xhlri5
	Asjm4BAWiJe49DofxOQFKt/0sRrE5BTQl2j8rgEx/SGjxLRHZ1lAOvkFJCXa//1ghrjHTuLc
	pw1gm3gFBCV+TL7HAjFdXWLSvEXMELa2xJN3F1gnMArOQlI2C0nZLCRlCxiZVzGKphYkFxQn
	peca6hUn5haX5qXrJefnbmIEx9UzqR2MKxssDjEKcDAq8fBGSJWGCLEmlhVX5h5ilOBgVhLh
	NakDCvGmJFZWpRblxxeV5qQWH2KU5mBREue9cTM3REggPbEkNTs1tSC1CCbLxMEp1cC46PmO
	Cy+/10kpx31d96d2uvWThYzbo5arnNfacLCnZNWW47ceFHCyHL/D87a69PqFvF/Tju89GDT3
	Zf0KvUVLPT4Lbeue6XP0Htv7XXHrpv3dmTCBfa1OeLfZkeVTF/cr6VsWayXwXs5I9HPfN9u0
	puVIb3Y+q65/0+PtBVwXrjha8KRFKU5vUGIpzkg01GIuKk4EAJ5N8L2nAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eduardo,

> 
> Lukasz,
> 
> On Thu, Nov 20, 2014 at 05:21:25PM +0100, Lukasz Majewski wrote:
> > This patch extends the of-thermal.c to provide information about
> > number of available trip points.
> > 
> > Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> > ---
> > Changes for v2:
> > - Provide detailed (doxygen like) description of the
> > of_thermal_get_ntrips() method
> > - Check for data pointer not being NULL
> > ---
> >  drivers/thermal/of-thermal.c   | 20 ++++++++++++++++++++
> >  drivers/thermal/thermal_core.h |  5 +++++
> >  2 files changed, 25 insertions(+)
> > 
> > diff --git a/drivers/thermal/of-thermal.c
> > b/drivers/thermal/of-thermal.c index b7982f0..7170822 100644
> > --- a/drivers/thermal/of-thermal.c
> > +++ b/drivers/thermal/of-thermal.c
> > @@ -112,6 +112,26 @@ static int of_thermal_get_temp(struct
> > thermal_zone_device *tz, return
> > data->ops->get_temp(data->sensor_data, temp); }
> >  
> > +/**
> > + * of_thermal_get_ntrips - function to export number of available
> > trip
> > + *			   points.
> > + * @tz: pointer to a thermal zone
> > + *
> > + * This function is a globally visible wrapper to get number of
> > trip points
> > + * stored in the local struct __thermal_zone
> > + *
> > + * Return: number of available trip points, -ENODEV when data not
> > available
> > + */
> > +int of_thermal_get_ntrips(struct thermal_zone_device *tz)
> > +{
> > +	struct __thermal_zone *data = tz->devdata;
> > +
> > +	if (!data || IS_ERR(data))
> > +		return -ENODEV;
> > +
> > +	return data->ntrips;
> > +}
> > +
> 
> Missing
> EXPORT_SYMBOL_GPL(of_thermal_get_ntrips);

OK

> 
> >  static int of_thermal_get_trend(struct thermal_zone_device *tz,
> > int trip, enum thermal_trend *trend)
> >  {
> > diff --git a/drivers/thermal/thermal_core.h
> > b/drivers/thermal/thermal_core.h index d15d243..c3c7b82 100644
> > --- a/drivers/thermal/thermal_core.h
> > +++ b/drivers/thermal/thermal_core.h
> > @@ -89,9 +89,14 @@ static inline void
> > thermal_gov_user_space_unregister(void) {} #ifdef CONFIG_THERMAL_OF
> >  int of_parse_thermal_zones(void);
> >  void of_thermal_destroy_zones(void);
> > +int of_thermal_get_ntrips(struct thermal_zone_device *);
> >  #else
> >  static inline int of_parse_thermal_zones(void) { return 0; }
> >  static inline void of_thermal_destroy_zones(void) { }
> > +static inline int of_thermal_get_ntrips(struct thermal_zone_device
> > *)
> 
> You need to declare the parameter name with a name
> ---------------^ .
> 
> > +{
> 
> This produces a compilation error if CONFIG_THERMAL_OF is not set:
> In file included from drivers/thermal/step_wise.c:28:0:
> drivers/thermal/thermal_core.h: In function ‘of_thermal_get_ntrips’:
> drivers/thermal/thermal_core.h:96:48: error: parameter name omitted
>  static inline int of_thermal_get_ntrips(struct thermal_zone_device *)
> 

Good point. Thanks for check.

> 
> 
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
