Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933800AbaKMPPb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 10:15:31 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:41857 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932730AbaKMPP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 10:15:26 -0500
X-AuditID: cbfee61a-f79c06d000004e71-7c-5464cb092e2e
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] thermal: exynos: use correct offset for TMU_CONTROL
 register on Exynos5260
Date: Thu, 13 Nov 2014 16:15:18 +0100
Message-id: <10653155.va3UnGOxba@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-70-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <20141107185949.GA27266@developer>
References: <1594947.1Ri7fFnV5h@amdc1032> <17456984.pRSEMqiSfL@amdc1032>
 <20141107185949.GA27266@developer>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsVy+t9jQV3O0ykhBqs+m1g0XA2xmH/lGqvF
	2aY37BZvHm5mtLi8aw6bxefeI4wWM87vY7J48rCPzYHDY+esu+wei/e8ZPLo27KK0ePzJrkA
	ligum5TUnMyy1CJ9uwSujE+PZrIVrJWuWL3pHFMD4xGxLkZODgkBE4m+DXuYIWwxiQv31rN1
	MXJxCAlMZ5TY9fs4I4TTwiTxb+YqFpAqNgEriYntqxhBbBEBLYkTl7YzgRQxC3QwSbS+3sAE
	khAWSJR4eq6BDcRmEVCV2LJ0OSuIzQvUcH7+bbAaUQFPiZ3TD4AN4hTQl7i0aT3YAiGBXIkH
	b5ewQNQLSvyYfA/MZhaQl9i3fyorhK0jsb91GtsERoFZSMpmISmbhaRsASPzKkbR1ILkguKk
	9FxDveLE3OLSvHS95PzcTYzgMH8mtYNxZYPFIUYBDkYlHt4XLCkhQqyJZcWVuYcYJTiYlUR4
	vQ8DhXhTEiurUovy44tKc1KLDzFKc7AoifMeaLUOFBJITyxJzU5NLUgtgskycXBKNTBm56n+
	nxs48XC2W260/cKPWwN+PwubKXAr08fsjeZFpoOiumoeL72kby+fzhPxT6ZAzyF07Yqdnkek
	um/LtCspPVKftvqCu+7li/PZy0sS5xU96r9zaPbC6sJlbIVWKw4LPZg32+++bqLiKaHE5167
	zmo4lb3a1rUjvbXQLaWUkXGaQ7abKI8SS3FGoqEWc1FxIgD8ph0TbwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Friday, November 07, 2014 02:59:51 PM Eduardo Valentin wrote:
> Hi Bartlomiej,
> 
> On Mon, Oct 20, 2014 at 02:41:07PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > 
> > Hi,
> > 
> > Eduardo, could you please merge this patch?
> > 
> 
> I queued this in my -fixes branch. It should appear also in linux-next.

Thanks!

> Can you please refresh your patch series
> https://lkml.org/lkml/2014/9/18/305
> 
> based on my tree? Looks like something may be missing, as could not get
> all patches applied cleanly.

Done:

  http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg38717.html

Sorry for the delay.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

> Thanks
> 
> > Best regards,
> > --
> > Bartlomiej Zolnierkiewicz
> > Samsung R&D Institute Poland
> > Samsung Electronics
> > 
> > On Thursday, September 11, 2014 03:00:49 PM Bartlomiej Zolnierkiewicz wrote:
> > > In exynos5260_tmu_registers tmu_ctrl entry is erroneously
> > > assigned twice.  The second assignment (to EXYNOS_TMU_REG_CONTROL1
> > > define which represents 0x24 value) overrides the first one
> > > (to EXYNOS_TMU_REG_CONTROL define which represents 0x20 value)
> > > which results in the wrong (according to the Exynos5260 SoC
> > > documentation that I have) offset being used for TMU_CONTROL
> > > register.  Fix it by removing the wrong assignment and then
> > > remove no longer used EXYNOS_TMU_REG_CONTROL1 define.
> > > 
> > > Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> > > Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
> > > Cc: Lukasz Majewski <l.majewski@samsung.com>
> > > Cc: Eduardo Valentin <edubezval@gmail.com>
> > > Cc: Zhang Rui <rui.zhang@intel.com>
> > > Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> > > Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> > > ---
> > >  drivers/thermal/samsung/exynos_tmu_data.c |    1 -
> > >  drivers/thermal/samsung/exynos_tmu_data.h |    1 -
> > >  2 files changed, 2 deletions(-)
> > > 
> > > Index: b/drivers/thermal/samsung/exynos_tmu_data.c
> > > ===================================================================
> > > --- a/drivers/thermal/samsung/exynos_tmu_data.c	2014-09-11 14:41:12.567347442 +0200
> > > +++ b/drivers/thermal/samsung/exynos_tmu_data.c	2014-09-11 14:43:00.211350284 +0200
> > > @@ -273,7 +273,6 @@ struct exynos_tmu_init_data const exynos
> > >  static const struct exynos_tmu_registers exynos5260_tmu_registers = {
> > >  	.triminfo_data = EXYNOS_TMU_REG_TRIMINFO,
> > >  	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
> > > -	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL1,
> > >  	.therm_trip_mode_shift = EXYNOS_TMU_TRIP_MODE_SHIFT,
> > >  	.therm_trip_mode_mask = EXYNOS_TMU_TRIP_MODE_MASK,
> > >  	.therm_trip_en_shift = EXYNOS_TMU_THERM_TRIP_EN_SHIFT,
> > > Index: b/drivers/thermal/samsung/exynos_tmu_data.h
> > > ===================================================================
> > > --- a/drivers/thermal/samsung/exynos_tmu_data.h	2014-09-11 14:41:12.243347433 +0200
> > > +++ b/drivers/thermal/samsung/exynos_tmu_data.h	2014-09-11 14:43:36.167351233 +0200
> > > @@ -83,7 +83,6 @@
> > >  #define EXYNOS_MAX_TRIGGER_PER_REG	4
> > >  
> > >  /* Exynos5260 specific */
> > > -#define EXYNOS_TMU_REG_CONTROL1			0x24
> > >  #define EXYNOS5260_TMU_REG_INTEN		0xC0
> > >  #define EXYNOS5260_TMU_REG_INTSTAT		0xC4
> > >  #define EXYNOS5260_TMU_REG_INTCLEAR		0xC8

