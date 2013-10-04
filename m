Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab3JDKEe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 06:04:34 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:60729 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660Ab3JDKEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 06:04:31 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-7e-524e92977a26
Date: Fri, 04 Oct 2013 12:04:00 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH 2/6] thermal: exynos: Provide separate TMU data for
 Exynos4412
Message-id: <20131004120400.397019e4@amdc308.digital.local>
In-reply-to: <524DE944.8030603@ti.com>
References: <1380010102-25817-1-git-send-email-l.majewski@samsung.com>
 <1380010102-25817-3-git-send-email-l.majewski@samsung.com>
 <524DE944.8030603@ti.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupikeLIzCtJLcpLzFFi42I5/e+xgO6MSX5BBtf7mSwaroZYbJyxntVi
	/pFzrBZr9v9ksug8+4TZ4s0jbovLu+awWXzuPcJoMeP8PiaL240r2Cz6F/YyWTx52MdmsX7G
	axYHXo/Fe14yeayb9pbZo2/LKkaPR4tbGD2O39jO5PF5k1wAWxSXTUpqTmZZapG+XQJXxvlp
	P5gKzhhXfPr6nqmB8almFyMnh4SAicSVm9NZIWwxiQv31rN1MXJxCAksYpQ4v7WTFcJpZ5J4
	9m8HM0gVi4CqxPV971hAbDYBPYnPd58ygdgiQPaNF0/AbGaBN8wSq1d4gdjCAiESu/ongm3g
	FbCWODqxB6yXU0BNYsaqqYwQC+YzSqxYcABsAb+ApET7vx/MECfZSZz7tIEdollQ4sfkeywQ
	C7QkNm9rYoWw5SU2r3nLPIFRcBaSsllIymYhKVvAyLyKUTS1ILmgOCk910ivODG3uDQvXS85
	P3cTIziGnknvYFzVYHGIUYCDUYmHd0Oxb5AQa2JZcWXuIUYJDmYlEd493X5BQrwpiZVVqUX5
	8UWlOanFhxilOViUxHkPtloHCgmkJ5akZqemFqQWwWSZODilGhg5zya/Zu+7vPLn1Oj9GaHC
	bj/M8r4yT3jIrt/2vU9xV+2lR10S0VYx8TN2fLl15OVKl98yzAwTbUw3TDi4dp+5hdH3kwq8
	k/llvl5ayXtx/1OFr0mftt+8rX77yLFD1v9qeZ88v70urT+u9Wum2TTH7J3rTQ2vSK5W53mX
	cPvUhGurf19Yunn9NiWW4oxEQy3mouJEALPbAECdAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eduardo,

> Lukasz,
> 
> Just minor comments.
> 
> On 24-09-2013 04:08, Lukasz Majewski wrote:
> > Up till now Exynos5250 and Exynos4412 had the same definitions for
> > TMU data. Following commit changes that, by introducing separate
> > exynos4412_default_tmu_data structure.
> > 
> > Since Exynos4412 was chronologically first, the corresponding name
> > for TMU registers and default data was renamed.
> > 
> > Additionally, new SOC_ARCH_EXYNOS4412 type has been defined.
> 
> It is not clear the objective of the patch itself. Was it just to make
> the code more readable or are you fixing something?

I'm fixing thermal on EXYNOS4412 device (trats2). The problem here is
to do it properly, since on the current code EXYNOS4412 and EXYNOS5250
uses the same configuration data.

To fix this problem, I had to split them. Also chronologically the
THERMAL IP first appeared on EXYNOS4412, not EXYNOS5250.

> 
> > 
> > Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> > Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> > Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> > ---
> >  drivers/thermal/samsung/exynos_tmu.c      |    7 ++++---
> >  drivers/thermal/samsung/exynos_tmu.h      |    1 +
> >  drivers/thermal/samsung/exynos_tmu_data.c |   26
> > ++++++++++++++++++++------
> > drivers/thermal/samsung/exynos_tmu_data.h |    9 ++++++++- 4 files
> > changed, 33 insertions(+), 10 deletions(-)
> > 
> > diff --git a/drivers/thermal/samsung/exynos_tmu.c
> > b/drivers/thermal/samsung/exynos_tmu.c index b43afda..a858cc4 100644
> > --- a/drivers/thermal/samsung/exynos_tmu.c
> > +++ b/drivers/thermal/samsung/exynos_tmu.c
> > @@ -488,7 +488,7 @@ static const struct of_device_id
> > exynos_tmu_match[] = { },
> >  	{
> >  		.compatible = "samsung,exynos4412-tmu",
> > -		.data = (void *)EXYNOS5250_TMU_DRV_DATA,
> > +		.data = (void *)EXYNOS4412_TMU_DRV_DATA,
> >  	},
> >  	{
> >  		.compatible = "samsung,exynos5250-tmu",
> > @@ -630,8 +630,9 @@ static int exynos_tmu_probe(struct
> > platform_device *pdev) return ret;
> >  
> >  	if (pdata->type == SOC_ARCH_EXYNOS ||
> > -		pdata->type == SOC_ARCH_EXYNOS4210 ||
> > -				pdata->type == SOC_ARCH_EXYNOS5440)
> > +	    pdata->type == SOC_ARCH_EXYNOS4210 ||
> > +	    pdata->type == SOC_ARCH_EXYNOS4412 ||
> > +	    pdata->type == SOC_ARCH_EXYNOS5440)
> >  		data->soc = pdata->type;
> >  	else {
> >  		ret = -EINVAL;
> > diff --git a/drivers/thermal/samsung/exynos_tmu.h
> > b/drivers/thermal/samsung/exynos_tmu.h index b364c9e..db37df0 100644
> > --- a/drivers/thermal/samsung/exynos_tmu.h
> > +++ b/drivers/thermal/samsung/exynos_tmu.h
> > @@ -41,6 +41,7 @@ enum calibration_mode {
> >  
> >  enum soc_type {
> >  	SOC_ARCH_EXYNOS4210 = 1,
> > +	SOC_ARCH_EXYNOS4412,
> >  	SOC_ARCH_EXYNOS,
> >  	SOC_ARCH_EXYNOS5440,
> >  };
> 
> I believe the above enum needs some documentation. SOC_ARCH_EXYNOS
> seams to be a bit confusing.

This is fixed at patch 4/6 of the series.

> 
> > diff --git a/drivers/thermal/samsung/exynos_tmu_data.c
> > b/drivers/thermal/samsung/exynos_tmu_data.c index 9002499..bd08093
> > 100644 --- a/drivers/thermal/samsung/exynos_tmu_data.c
> > +++ b/drivers/thermal/samsung/exynos_tmu_data.c
> > @@ -90,8 +90,8 @@ struct exynos_tmu_init_data const
> > exynos4210_default_tmu_data = { };
> >  #endif
> >  
> > -#if defined(CONFIG_SOC_EXYNOS5250) ||
> > defined(CONFIG_SOC_EXYNOS4412) -static const struct
> > exynos_tmu_registers exynos5250_tmu_registers = { +#if
> > defined(CONFIG_SOC_EXYNOS4412) || defined(CONFIG_SOC_EXYNOS5250)
> > +static const struct exynos_tmu_registers exynos4412_tmu_registers
> > = { .triminfo_data = EXYNOS_TMU_REG_TRIMINFO, .triminfo_25_shift =
> > EXYNOS_TRIMINFO_25_SHIFT, .triminfo_85_shift =
> > EXYNOS_TRIMINFO_85_SHIFT, @@ -128,7 +128,7 @@ static const struct
> > exynos_tmu_registers exynos5250_tmu_registers = { .emul_time_mask =
> > EXYNOS_EMUL_TIME_MASK, };
> >  
> > -#define EXYNOS5250_TMU_DATA \
> > +#define EXYNOS4412_TMU_DATA \
> >  	.threshold_falling = 10, \
> >  	.trigger_levels[0] = 85, \
> >  	.trigger_levels[1] = 103, \
> > @@ -162,15 +162,29 @@ static const struct exynos_tmu_registers
> > exynos5250_tmu_registers = { .temp_level = 103, \
> >  	}, \
> >  	.freq_tab_count = 2, \
> > -	.type = SOC_ARCH_EXYNOS, \
> > -	.registers = &exynos5250_tmu_registers, \
> > +	.registers = &exynos4412_tmu_registers, \
> >  	.features = (TMU_SUPPORT_EMULATION |
> > TMU_SUPPORT_TRIM_RELOAD | \ TMU_SUPPORT_FALLING_TRIP |
> > TMU_SUPPORT_READY_STATUS | \ TMU_SUPPORT_EMUL_TIME)
> > +#endif
> >  
> > +#if defined(CONFIG_SOC_EXYNOS4412)
> > +struct exynos_tmu_init_data const exynos4412_default_tmu_data = {
> > +	.tmu_data = {
> > +		{ EXYNOS4412_TMU_DATA,
> > +		.type = SOC_ARCH_EXYNOS4412,
> > +		},
> > +	},
> > +	.tmu_count = 1,
> > +};
> > +#endif
> > +
> > +#if defined(CONFIG_SOC_EXYNOS5250)
> >  struct exynos_tmu_init_data const exynos5250_default_tmu_data = {
> >  	.tmu_data = {
> > -		{ EXYNOS5250_TMU_DATA },
> > +		{ EXYNOS4412_TMU_DATA,
> > +		.type = SOC_ARCH_EXYNOS,
> > +		},
> 
> Please add a comment on this initialization, specially because we
> start to mix macros with inline initialization. Starts to be hard to
> follow.
> 
> Besides, I believe
> +		{
> +			EXYNOS4412_TMU_DATA,
> +			.type = SOC_ARCH_EXYNOS,
> +		},
> 
> is a much more common style.

Ok.

> 
> 
> >  	},
> >  	.tmu_count = 1,
> >  };
> > diff --git a/drivers/thermal/samsung/exynos_tmu_data.h
> > b/drivers/thermal/samsung/exynos_tmu_data.h index dc7feb5..b130b1e
> > 100644 --- a/drivers/thermal/samsung/exynos_tmu_data.h
> > +++ b/drivers/thermal/samsung/exynos_tmu_data.h
> > @@ -138,7 +138,14 @@ extern struct exynos_tmu_init_data const
> > exynos4210_default_tmu_data; #define EXYNOS4210_TMU_DRV_DATA (NULL)
> >  #endif
> >  
> > -#if (defined(CONFIG_SOC_EXYNOS5250) ||
> > defined(CONFIG_SOC_EXYNOS4412)) +#if defined(CONFIG_SOC_EXYNOS4412)
> > +extern struct exynos_tmu_init_data const
> > exynos4412_default_tmu_data; +#define EXYNOS4412_TMU_DRV_DATA
> > (&exynos4412_default_tmu_data) +#else
> > +#define EXYNOS4412_TMU_DRV_DATA (NULL)
> > +#endif
> > +
> > +#if defined(CONFIG_SOC_EXYNOS5250)
> >  extern struct exynos_tmu_init_data const
> > exynos5250_default_tmu_data; #define EXYNOS5250_TMU_DRV_DATA
> > (&exynos5250_default_tmu_data) #else
> > 
> 
> 



-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
