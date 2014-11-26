Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751483AbaKZIkL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 03:40:11 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:14005 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbaKZIkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 03:40:09 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-3d-547591e6b6ef
Date: Wed, 26 Nov 2014 09:39:43 +0100
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
Subject: Re: [PATCH v2 3/4] thermal: of: Extend of-thermal to export table of
 trip points
Message-id: <20141126093943.362a084a@amdc2363>
In-reply-to: <20141125203845.GB14292@developer>
References: <1412872737-624-1-git-send-email-l.majewski@samsung.com>
 <1416500488-7232-1-git-send-email-l.majewski@samsung.com>
 <1416500488-7232-4-git-send-email-l.majewski@samsung.com>
 <20141125203845.GB14292@developer>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsVy+t9jAd1nE0tDDL6f1rZ4vGYxk8XGGetZ
	Lb587mOzmH/lGqvFmr9KFm8ecVtc3jWHzeJz7xFGiycLzzBZPLg6jc3iyUOgqlcH21gsfu6a
	x+LA67Fz1l12j8V7XjJ5rJv2ltmjt/kdm8ffWftZPHZ+b2D36NuyitHj8yY5j41zQwM4o7hs
	UlJzMstSi/TtErgydh58z1bwU73i9RWzBsYl8l2MnBwSAiYSbW8nsEHYYhIX7q0Hs4UEFjFK
	nJrr1cXIBWT/YpRo27mRGSTBIqAqMfPPYVYQm01AT+Lz3adMILaIgJbEiUvbwWxmgT/MEjdX
	gNnCAtESbQfXsoDYvED1V17eBLM5BfQlzq3qYYRY8JBR4syFNkaQBL+ApET7vx/MEBfZSZz7
	tIEdollQ4sfkeywQC7QkNm9rYoWw5SU2r3nLPIFRcBaSsllIymYhKVvAyLyKUTS1ILmgOCk9
	10ivODG3uDQvXS85P3cTIzi2nknvYFzVYHGIUYCDUYmHN0KqNESINbGsuDL3EKMEB7OSCK9J
	HVCINyWxsiq1KD++qDQntfgQozQHi5I4742buSFCAumJJanZqakFqUUwWSYOTqkGRv3V1+af
	+KB26nWA08Tyy0VfSj1Ock5pXlEwoWhJpLiRyqoVs6Q2BegekVt99dXnZfVzX+8vObHostJ7
	iZNT1x381zRnQcu03ItLRPgFF311y6m5HuHvH1L1MuWdEp+w3e1NXZt67X/X65iyHlkYWvT4
	wEXhog1yTk/adOJ63epLFKc6CnPvfKrEUpyRaKjFXFScCAAqXBugqQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eduardo,

> On Thu, Nov 20, 2014 at 05:21:27PM +0100, Lukasz Majewski wrote:
> > This patch extends the of-thermal.c to export copy of trip points
> > for a given thermal zone.
> > 
> > Thermal drivers should use of_thermal_get_trip_points() method to
> > get pointer to table of thermal trip points.
> > 
> > Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> > ---
> > Changes for v2:
> > - New patch - as suggested by Eduardo Valentin
> > ---
> >  drivers/thermal/of-thermal.c   | 33
> > +++++++++++++++++++++++++++++++++ drivers/thermal/thermal_core.h |
> > 7 +++++++ include/linux/thermal.h        | 14 ++++++++++++++
> >  3 files changed, 54 insertions(+)
> > 
> > diff --git a/drivers/thermal/of-thermal.c
> > b/drivers/thermal/of-thermal.c index 336af7f..33921c5 100644
> > --- a/drivers/thermal/of-thermal.c
> > +++ b/drivers/thermal/of-thermal.c
> > @@ -89,6 +89,7 @@ struct __thermal_zone {
> >  	/* trip data */
> >  	int ntrips;
> >  	struct __thermal_trip *trips;
> > +	struct thermal_trip *gtrips;
> >  
> >  	/* cooling binding data */
> >  	int num_tbps;
> > @@ -152,6 +153,27 @@ bool of_thermal_is_trip_en(struct
> > thermal_zone_device *tz, int trip) return true;
> >  }
> >  
> > +/**
> > + * of_thermal_get_trip_points - function to get access to a
> > globally exported
> > + *				trip points
> > + *
> > + * @tz:	pointer to a thermal zone
> > + *
> > + * This function provides a pointer to the copy of trip points
> > table
> > + *
> > + * Return: pointer to trip points table, NULL otherwise
> > + */
> > +const struct thermal_trip * const
> > +of_thermal_get_trip_points(struct thermal_zone_device *tz)
> 
> Another thing, can you please check why scripts/kernel-doc does not
> like this prototype? It throws an warn:
> Warning(drivers/thermal/of-thermal.c:168): cannot understand function
> prototype: 'const struct thermal_trip * const
> of_thermal_get_trip_points(struct thermal_zone_device *tz) '
> 

I will check that. However the warning looks a bit strange.

> 
> > +{
> > +	struct __thermal_zone *data = tz->devdata;
> > +
> > +	if (!data)
> > +		return NULL;
> > +
> > +	return data->gtrips;
> > +}
> > +
> >  static int of_thermal_get_trend(struct thermal_zone_device *tz,
> > int trip, enum thermal_trend *trend)
> >  {
> > @@ -767,6 +789,16 @@ thermal_of_build_thermal_zone(struct
> > device_node *np) goto free_tbps;
> >  	}
> >  
> > +	tz->gtrips = kcalloc(tz->ntrips, sizeof(*tz->gtrips),
> > GFP_KERNEL);
> > +	if (!tz->gtrips) {
> > +		ret = -ENOMEM;
> > +		goto free_tbps;
> > +	}
> > +
> > +	for (i = 0; i < tz->ntrips; i++)
> > +		memcpy(&(tz->gtrips[i]),
> > &(tz->trips[i].temperature),
> > +		       sizeof(*tz->gtrips));
> > +
> >  finish:
> >  	of_node_put(child);
> >  	tz->mode = THERMAL_DEVICE_DISABLED;
> > @@ -793,6 +825,7 @@ static inline void of_thermal_free_zone(struct
> > __thermal_zone *tz) {
> >  	int i;
> >  
> > +	kfree(tz->gtrips);
> >  	for (i = 0; i < tz->num_tbps; i++)
> >  		of_node_put(tz->tbps[i].cooling_device);
> >  	kfree(tz->tbps);
> > diff --git a/drivers/thermal/thermal_core.h
> > b/drivers/thermal/thermal_core.h index 466208c..a9580ca 100644
> > --- a/drivers/thermal/thermal_core.h
> > +++ b/drivers/thermal/thermal_core.h
> > @@ -91,6 +91,8 @@ int of_parse_thermal_zones(void);
> >  void of_thermal_destroy_zones(void);
> >  int of_thermal_get_ntrips(struct thermal_zone_device *);
> >  bool of_thermal_is_trip_en(struct thermal_zone_device *, int);
> > +const struct thermal_trip * const
> > +of_thermal_get_trip_points(struct thermal_zone_device *);
> >  #else
> >  static inline int of_parse_thermal_zones(void) { return 0; }
> >  static inline void of_thermal_destroy_zones(void) { }
> > @@ -102,6 +104,11 @@ static inline bool
> > of_thermal_is_trip_en(struct thermal_zone_device *, int) {
> >  	return 0;
> >  }
> > +static inline const struct thermal_trip * const
> > +of_thermal_get_trip_points(struct thermal_zone_device *)
> > +{
> > +	return NULL;
> > +}
> >  #endif
> >  
> >  #endif /* __THERMAL_CORE_H__ */
> > diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> > index 5bc28a7..88d7249 100644
> > --- a/include/linux/thermal.h
> > +++ b/include/linux/thermal.h
> > @@ -303,6 +303,20 @@ struct thermal_zone_of_device_ops {
> >  	int (*get_trend)(void *, long *);
> >  };
> >  
> > +/**
> > + * struct thermal_trip - Structure representing themal trip points
> > exported from
> > + *                       of-thermal
> > + *
> > + * @temperature:	trip point temperature
> > + * @hysteresis:		trip point hysteresis
> > + * @type:		trip point type
> > + */
> > +struct thermal_trip {
> > +	unsigned long int temperature;
> > +	unsigned long int hysteresis;
> > +	enum thermal_trip_type type;
> > +};
> > +
> >  /* Function declarations */
> >  #ifdef CONFIG_THERMAL_OF
> >  struct thermal_zone_device *
> > -- 
> > 2.0.0.rc2
> > 



-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
