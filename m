Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425AbaESFrb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 01:47:31 -0400
Received: from mail-yh0-f45.google.com ([209.85.213.45]:41092 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbaESFr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 01:47:29 -0400
MIME-Version: 1.0
In-Reply-To: <2098888.ybkVo6Z2Xi@amdc1032>
References: <1399288539-1793-1-git-send-email-b.zolnierkie@samsung.com>
	<1399288539-1793-6-git-send-email-b.zolnierkie@samsung.com>
	<20140515144739.GA27690@developer>
	<2098888.ybkVo6Z2Xi@amdc1032>
Date: Mon, 19 May 2014 11:17:28 +0530
Message-ID: <CADGdYn43aKJRhT9OdA+tDi7UXTaEN8qk_WBV4NrnSrMxqteK9Q@mail.gmail.com>
Subject: Re: [PATCH 05/10] thermal: exynos: remove redundant pdata checks from exynos_tmu_initialize()
From: Amit Kachhap <amit.kachhap@gmail.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Eduardo Valentin <edubezval@gmail.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        Zhang Rui <rui.zhang@intel.com>, Tomasz Figa <t.figa@samsung.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/15/14, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com> wrote:
> On Thursday, May 15, 2014 10:47:40 AM Eduardo Valentin wrote:
>> Hello Bartlomiej,
>
> Hi,
>
>> On Mon, May 05, 2014 at 01:15:34PM +0200, Bartlomiej Zolnierkiewicz
>> wrote:
>> > Remove runtime checks for pdata sanity from exynos_tmu_initialize().
>> > The current values hardcoded in pdata will never trigger the checks
>> > and for the new code potential mistakes should be caught during
>> > development/review phases.
>> >
>> > There should be no functional changes caused by this patch.
>> >
>> > Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
>> > ---
>> >  drivers/thermal/samsung/exynos_thermal_common.h |  1 -
>> >  drivers/thermal/samsung/exynos_tmu.c            | 13 -------------
>> >  2 files changed, 14 deletions(-)
>> >
>> > diff --git a/drivers/thermal/samsung/exynos_thermal_common.h
>> > b/drivers/thermal/samsung/exynos_thermal_common.h
>> > index 3eb2ed9..cd44719 100644
>> > --- a/drivers/thermal/samsung/exynos_thermal_common.h
>> > +++ b/drivers/thermal/samsung/exynos_thermal_common.h
>> > @@ -27,7 +27,6 @@
>> >  #define SENSOR_NAME_LEN	16
>> >  #define MAX_TRIP_COUNT	8
>> >  #define MAX_COOLING_DEVICE 4
>> > -#define MAX_THRESHOLD_LEVS 5
>> >
>> >  #define ACTIVE_INTERVAL 500
>> >  #define IDLE_INTERVAL 10000
>> > diff --git a/drivers/thermal/samsung/exynos_tmu.c
>> > b/drivers/thermal/samsung/exynos_tmu.c
>> > index 903566f..789d745 100644
>> > --- a/drivers/thermal/samsung/exynos_tmu.c
>> > +++ b/drivers/thermal/samsung/exynos_tmu.c
>> > @@ -158,23 +158,10 @@ static int exynos_tmu_initialize(struct
>> > platform_device *pdev)
>> >  	    data->temp_error > pdata->max_efuse_value)
>> >  		data->temp_error = pdata->efuse_value & EXYNOS_TMU_TEMP_MASK;
>> >
>> > -	if (pdata->max_trigger_level > MAX_THRESHOLD_LEVS) {
>> > -		dev_err(&pdev->dev, "Invalid max trigger level\n");
>> > -		ret = -EINVAL;
>> > -		goto out;
>> > -	}
>> > -
>> >  	for (i = 0; i < pdata->max_trigger_level; i++) {
>> >  		if (!pdata->trigger_levels[i])
>> >  			continue;
>> >
>> > -		if ((pdata->trigger_type[i] == HW_TRIP) &&
>> > -		(!pdata->trigger_levels[pdata->max_trigger_level - 1])) {
>> > -			dev_err(&pdev->dev, "Invalid hw trigger level\n");
>> > -			ret = -EINVAL;
>> > -			goto out;
>> > -		}
>> > -
>>
>> Does it mean no new pdata are going to be written? i.e., no new soc is
>> going to be supported by this driver that needs proper pdata checking?
>
> This is not a proper checking.  The checks in question are done at runtime
> in a production code for data that is hardcoded inside driver during
> development time and later it doesn't change.  Such data should be verified
> during development and review time (i.e. by a script parsing relevant data
> from exynos_tmu_data.c, one can also argue that verification to be done is
> so simple that the review by a maintainer should be enough).
Agreed to your arguments. These changes looks fine.
>
>> >  		/* Count trigger levels except the HW trip*/
>> >  		if (!(pdata->trigger_type[i] == HW_TRIP))
>> >  			trigger_levs++;
>
> Best regards,
> --
> Bartlomiej Zolnierkiewicz
> Samsung R&D Institute Poland
> Samsung Electronics
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
