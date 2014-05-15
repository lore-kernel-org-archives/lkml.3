Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922AbaEOQYb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 12:24:31 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:49655 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbaEOQYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 12:24:30 -0400
X-AuditID: cbfee61b-b7f766d00000646c-e8-5374ea3bc79a
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Eduardo Valentin <eduardo.valentin@ti.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/10] thermal: exynos: remove redundant pdata checks from
 exynos_tmu_initialize()
Date: Thu, 15 May 2014 18:24:14 +0200
Message-id: <2098888.ybkVo6Z2Xi@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <20140515144739.GA27690@developer>
References: <1399288539-1793-1-git-send-email-b.zolnierkie@samsung.com>
 <1399288539-1793-6-git-send-email-b.zolnierkie@samsung.com>
 <20140515144739.GA27690@developer>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsVy+t9jQV3rVyXBBjuWmVg0XA2xWLP/J5PF
	/CvXWC3ONr1ht7i8aw6bxefeI4wWM87vY7I4c/oSq8WTh31sFutnvGZx4PLYOesuu8fiPS+Z
	PLZcbWfx6NuyitHj+I3tTB6fN8kFsEVx2aSk5mSWpRbp2yVwZWxfd46l4Kt4xbpTT5gbGBcI
	dzFyckgImEgc23iVBcIWk7hwbz1bFyMXh5DAdEaJzo7v7CAJIYEWJonvf2JAbDYBK4mJ7asY
	QWwRAS2JE5e2M4E0MAvcZJI4/OsH0CQODmGBDIm1jYYgNSwCqhLdSw6D1fMKaEqcXLsWzBYV
	8JTYsX0lG4jNKaAvMefBMVaIxasYJXrW/GWCaBCU+DH5Hth1zALyEvv2T2WFsLUk1u88zjSB
	UWAWkrJZSMpmISlbwMi8ilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4Gp5J72Bc1WBxiFGA
	g1GJh5dhcnGwEGtiWXFl7iFGCQ5mJRFe8+clwUK8KYmVValF+fFFpTmpxYcYpTlYlMR5D7Za
	BwoJpCeWpGanphakFsFkmTg4pRoYt/Kdf7AvVHHRqvYFnD/87ae9SFnju2OTZZ7DhpNLlnzu
	tHn+wUOOpUKb7+rzc7WvE7S+GQvJ+6dsecZt6sC3UzvrGKvM2sKJ7475Xk8TdneIfGFfNJf/
	bEHZK5fVdmJ7JjGZT9wrnq91xWnpygg277C/E0zP1Es0Bzbc0LgsV5d9yofFaCWrEktxRqKh
	FnNRcSIAPsno8IICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 15, 2014 10:47:40 AM Eduardo Valentin wrote:
> Hello Bartlomiej,

Hi,

> On Mon, May 05, 2014 at 01:15:34PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > Remove runtime checks for pdata sanity from exynos_tmu_initialize().
> > The current values hardcoded in pdata will never trigger the checks
> > and for the new code potential mistakes should be caught during
> > development/review phases.
> > 
> > There should be no functional changes caused by this patch.
> > 
> > Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> > ---
> >  drivers/thermal/samsung/exynos_thermal_common.h |  1 -
> >  drivers/thermal/samsung/exynos_tmu.c            | 13 -------------
> >  2 files changed, 14 deletions(-)
> > 
> > diff --git a/drivers/thermal/samsung/exynos_thermal_common.h b/drivers/thermal/samsung/exynos_thermal_common.h
> > index 3eb2ed9..cd44719 100644
> > --- a/drivers/thermal/samsung/exynos_thermal_common.h
> > +++ b/drivers/thermal/samsung/exynos_thermal_common.h
> > @@ -27,7 +27,6 @@
> >  #define SENSOR_NAME_LEN	16
> >  #define MAX_TRIP_COUNT	8
> >  #define MAX_COOLING_DEVICE 4
> > -#define MAX_THRESHOLD_LEVS 5
> >  
> >  #define ACTIVE_INTERVAL 500
> >  #define IDLE_INTERVAL 10000
> > diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
> > index 903566f..789d745 100644
> > --- a/drivers/thermal/samsung/exynos_tmu.c
> > +++ b/drivers/thermal/samsung/exynos_tmu.c
> > @@ -158,23 +158,10 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
> >  	    data->temp_error > pdata->max_efuse_value)
> >  		data->temp_error = pdata->efuse_value & EXYNOS_TMU_TEMP_MASK;
> >  
> > -	if (pdata->max_trigger_level > MAX_THRESHOLD_LEVS) {
> > -		dev_err(&pdev->dev, "Invalid max trigger level\n");
> > -		ret = -EINVAL;
> > -		goto out;
> > -	}
> > -
> >  	for (i = 0; i < pdata->max_trigger_level; i++) {
> >  		if (!pdata->trigger_levels[i])
> >  			continue;
> >  
> > -		if ((pdata->trigger_type[i] == HW_TRIP) &&
> > -		(!pdata->trigger_levels[pdata->max_trigger_level - 1])) {
> > -			dev_err(&pdev->dev, "Invalid hw trigger level\n");
> > -			ret = -EINVAL;
> > -			goto out;
> > -		}
> > -
> 
> Does it mean no new pdata are going to be written? i.e., no new soc is
> going to be supported by this driver that needs proper pdata checking?

This is not a proper checking.  The checks in question are done at runtime
in a production code for data that is hardcoded inside driver during
development time and later it doesn't change.  Such data should be verified
during development and review time (i.e. by a script parsing relevant data
from exynos_tmu_data.c, one can also argue that verification to be done is
so simple that the review by a maintainer should be enough).

> >  		/* Count trigger levels except the HW trip*/
> >  		if (!(pdata->trigger_type[i] == HW_TRIP))
> >  			trigger_levs++;

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

