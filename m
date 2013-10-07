Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234Ab3JGKJJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 06:09:09 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:36421 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796Ab3JGKJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 06:09:07 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-22-525288419c1d
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Zhang Rui <rui.zhang@intel.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 2/2] thermal: TI: always register sensor driver with core
 thermal framework
Date: Mon, 07 Oct 2013 12:08:55 +0200
Message-id: <5589711.ayvx0g0Djy@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-52-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <524F0802.3070004@ti.com>
References: <1466554.jrelSVKzU4@amdc1032> <524F0802.3070004@ti.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsVy+t9jQV2njqAgg74/zBZr9v9ksjjb9Ibd
	4vKuOWwWn3uPMFo8edjH5sDqsXjPSyaPvi2rGD2O39jO5PF5k1wASxSXTUpqTmZZapG+XQJX
	xp+bz5gL5qtWTOnYxtTAuF2ui5GTQ0LAROLGzF9MELaYxIV769m6GLk4hASmM0qsmboOymlh
	kvj9bQ07SBWbgJXExPZVjCC2iICexI0XT5hAipgFOhgl7q3fxAqSEBZIlGiaehTMZhFQldj0
	cjMbiM0roCkxafszsLiogKfEp0lLmUFsTgE1icnbX4CdISTgLDFlSwMLRL2gxI/J98BsZgF5
	iX37p7JC2DoS+1unsU1gFJiFpGwWkrJZSMoWMDKvYhRNLUguKE5KzzXSK07MLS7NS9dLzs/d
	xAgO5WfSOxhXNVgcYhTgYFTi4d1xPzBIiDWxrLgy9xCjBAezkghvT2tQkBBvSmJlVWpRfnxR
	aU5q8SFGaQ4WJXHeg63WgUIC6YklqdmpqQWpRTBZJg5OqQbGLb+X61U8nJZl6GUho+qs9Vbw
	9DHb4sdZ0U932R91ijuz3Edqv2jKO/kj8o7+S4QN86O0jaeevdMssEhvdoTB3i33X1YmLOT2
	XtfpmLil+yQjo9P3ba9/sL+cqCgtXT+Ra8Yph4KySF3WX13z/6g8S64P2/SHa9+1PyqS9V5O
	a/nnup7m/8KsxFKckWioxVxUnAgAAk9LrmECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 04, 2013 02:25:06 PM Eduardo Valentin wrote:
> On 04-10-2013 08:40, Bartlomiej Zolnierkiewicz wrote:
> > There is little sense in having separate config option for
> > registering the sensor driver with the core thermal framework.
> > Fix it by integrating TI_THERMAL config option with TI_SOC_THERMAL
> > one.
> 
> I am a bit confused of what is exactly wrong or needs fixing. The code
> organization is so that the file ti-bandgap.c adds the support for TI
> Bandgap IP. It is not aware of thermal framework. And the
> ti-thermal-common.c file is expected to talk to thermal framework. Can
> you please elaborate a bit more why this split is hurting you?

The split seems artificial since both options have dependency on THERMAL.

Could you please tell me what is an advantage of having separate core
TI bandgap IP support without registration to thermal framework?

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

> > Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> >  drivers/thermal/ti-soc-thermal/Kconfig      | 15 +++-----------
> >  drivers/thermal/ti-soc-thermal/Makefile     |  2 +-
> >  drivers/thermal/ti-soc-thermal/ti-thermal.h | 31 -----------------------------
> >  3 files changed, 4 insertions(+), 44 deletions(-)
> > 
> > diff --git a/drivers/thermal/ti-soc-thermal/Kconfig b/drivers/thermal/ti-soc-thermal/Kconfig
> > index bf5d6e4..c64e78b 100644
> > --- a/drivers/thermal/ti-soc-thermal/Kconfig
> > +++ b/drivers/thermal/ti-soc-thermal/Kconfig
> > @@ -7,18 +7,9 @@ config TI_SOC_THERMAL
> >  	  OMAP4460+ on die bandgap temperature sensor support. The register
> >  	  set is part of system control module.
> >  
> > -	  This includes alert interrupts generation and also the TSHUT
> > -	  support.
> > -
> > -config TI_THERMAL
> > -	bool "Texas Instruments SoCs thermal framework support"
> > -	depends on TI_SOC_THERMAL
> > -	help
> > -	  If you say yes here you want to get support for generic thermal
> > -	  framework for the Texas Instruments on die bandgap temperature sensor.
> > -
> > -	  This includes trip points definitions, extrapolation rules and
> > -	  CPU cooling device bindings.
> > +	  This includes alert interrupts generation, the TSHUT support,
> > +	  trip points definitions, extrapolation rules and CPU cooling
> > +	  device bindings.
> >  
> >  config OMAP4_THERMAL
> >  	bool "Texas Instruments OMAP4 thermal support"
> > diff --git a/drivers/thermal/ti-soc-thermal/Makefile b/drivers/thermal/ti-soc-thermal/Makefile
> > index 1226b24..c75cc91 100644
> > --- a/drivers/thermal/ti-soc-thermal/Makefile
> > +++ b/drivers/thermal/ti-soc-thermal/Makefile
> > @@ -1,6 +1,6 @@
> >  obj-$(CONFIG_TI_SOC_THERMAL)		+= ti-soc-thermal.o
> >  ti-soc-thermal-y			:= ti-bandgap.o
> > -ti-soc-thermal-$(CONFIG_TI_THERMAL)	+= ti-thermal-common.o
> > +ti-soc-thermal-y			+= ti-thermal-common.o
> >  ti-soc-thermal-$(CONFIG_DRA752_THERMAL)	+= dra752-thermal-data.o
> >  ti-soc-thermal-$(CONFIG_OMAP4_THERMAL)	+= omap4-thermal-data.o
> >  ti-soc-thermal-$(CONFIG_OMAP5_THERMAL)	+= omap5-thermal-data.o
> > diff --git a/drivers/thermal/ti-soc-thermal/ti-thermal.h b/drivers/thermal/ti-soc-thermal/ti-thermal.h
> > index f8b7ffe..5fb427c 100644
> > --- a/drivers/thermal/ti-soc-thermal/ti-thermal.h
> > +++ b/drivers/thermal/ti-soc-thermal/ti-thermal.h
> > @@ -83,41 +83,10 @@
> >  #define ti_thermal_is_valid_trip(trip)				\
> >  	((trip) >= 0 && (trip) < OMAP_TRIP_NUMBER)
> >  
> > -#ifdef CONFIG_TI_THERMAL
> >  int ti_thermal_expose_sensor(struct ti_bandgap *bgp, int id, char *domain);
> >  int ti_thermal_remove_sensor(struct ti_bandgap *bgp, int id);
> >  int ti_thermal_report_sensor_temperature(struct ti_bandgap *bgp, int id);
> >  int ti_thermal_register_cpu_cooling(struct ti_bandgap *bgp, int id);
> >  int ti_thermal_unregister_cpu_cooling(struct ti_bandgap *bgp, int id);
> > -#else
> > -static inline
> > -int ti_thermal_expose_sensor(struct ti_bandgap *bgp, int id, char *domain)
> > -{
> > -	return 0;
> > -}
> >  
> > -static inline
> > -int ti_thermal_remove_sensor(struct ti_bandgap *bgp, int id)
> > -{
> > -	return 0;
> > -}
> > -
> > -static inline
> > -int ti_thermal_report_sensor_temperature(struct ti_bandgap *bgp, int id)
> > -{
> > -	return 0;
> > -}
> > -
> > -static inline
> > -int ti_thermal_register_cpu_cooling(struct ti_bandgap *bgp, int id)
> > -{
> > -	return 0;
> > -}
> > -
> > -static inline
> > -int ti_thermal_unregister_cpu_cooling(struct ti_bandgap *bgp, int id)
> > -{
> > -	return 0;
> > -}
> > -#endif
> >  #endif

