Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796Ab3JNOxI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 10:53:08 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:13237 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756615Ab3JNOxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 10:53:05 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-61-525c054e3ef8
Date: Mon, 14 Oct 2013 16:52:49 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Zhang Rui <rui.zhang@intel.com>, kgene.kim@samsung.com,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, devicetree@vger.kernel.org,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH v2 2/5] thermal: exynos: Provide separate TMU data for
 Exynos4412
Message-id: <20131014165249.7b8b2f9e@amdc308.digital.local>
In-reply-to: <525BFDC5.4000109@ti.com>
References: <1380010102-25817-1-git-send-email-l.majewski@samsung.com>
 <1381300194-13134-1-git-send-email-l.majewski@samsung.com>
 <1381300194-13134-3-git-send-email-l.majewski@samsung.com>
 <525BFDC5.4000109@ti.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplkeLIzCtJLcpLzFFi42I5/e+xoK4/a0yQwZRfLBYNV0MsNs5Yz2ox
	/8g5Vos1+38yWXSefcJs0bvgKpvFm0fcFpd3zWGz+Nx7hNFixvl9TBa3G1ewWZw5fYnV4snD
	PjaL9TNeszjweSze85LJY920t8weW662s3j0bVnF6HH8xnYmj8+b5ALYorhsUlJzMstSi/Tt
	Ergyri1OL9hlVNF29T9bA2OzZhcjJ4eEgInEx30TmSBsMYkL99azgdhCAtMZJX5MY+5i5AKy
	25kkru04xwKSYBFQlTj9djEjiM0moCfx+e5TsGYRIPvGiydMIA3MAt0sEjfXbmMHSQgLhEtc
	er0XrIhXwFpi/pzFQHEODk4BNYlXa+wgFtxhlHi+dRFYDb+ApET7vx/MEBfZSZz7tIEdoldQ
	4sfke2BHMAtoSWze1sQKYctLbF7zlnkCo+AsJGWzkJTNQlK2gJF5FaNoakFyQXFSeq6hXnFi
	bnFpXrpecn7uJkZwJD2T2sG4ssHiEKMAB6MSD6+AU3SQEGtiWXFl7iFGCQ5mJRHe3LdAId6U
	xMqq1KL8+KLSnNTiQ4zSHCxK4rwHWq0DhQTSE0tSs1NTC1KLYLJMHJxSDYyLi7IklmTPPCe5
	dc5tUfcrUpezlix79la3yyHDkUXE2oPXq6RnuR93moLk1/v1M7qVJR51vr/wSo3hyP9DNwpa
	9x7ZFK3z5U7ErPuuza0nVvHHpj9RXO+wtTDgzen4TQf3PDhbuKbE31i1WHFT6omKCW7swTcu
	zap+kcw7a8stboUYCYME9klKLMUZiYZazEXFiQBPMk1joAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eduardo,

> On 09-10-2013 02:29, Lukasz Majewski wrote:
> > Up till now Exynos5250 and Exynos4412 had the same definitions for
> > TMU data. Following commit changes that, by introducing separate
> > exynos4412_default_tmu_data structure.
> > 
> > Since Exynos4412 was chronologically first, the corresponding name
> > for TMU registers and default data was renamed.
> > 
> > Additionally, new SOC_ARCH_EXYNOS4412 type has been defined.
> > 
> > Moreover, the SOC_ARCH_EXYNOS name has been changed to
> > SOC_ARCH_EXYNOS5250.
> > 
> > Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> > Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> > Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> > 
> > ---
> > Changes for v2:
> > - Replace SOC_ARCH_EXYNOS with SOC_ARCH_EXYNOS5250
> > - Fix coding style for tmu_data elements definition
> > 
> >  drivers/thermal/samsung/exynos_tmu.c      |    9 +++++----
> >  drivers/thermal/samsung/exynos_tmu.h      |    3 ++-
> >  drivers/thermal/samsung/exynos_tmu_data.c |   28
> > ++++++++++++++++++++++------
> > drivers/thermal/samsung/exynos_tmu_data.h |    9 ++++++++- 4 files
> > changed, 37 insertions(+), 12 deletions(-)
> > 
> > diff --git a/drivers/thermal/samsung/exynos_tmu.c
> > b/drivers/thermal/samsung/exynos_tmu.c index b43afda..1312b34 100644
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
> > @@ -629,9 +629,10 @@ static int exynos_tmu_probe(struct
> > platform_device *pdev) if (ret)
> >  		return ret;
> >  
> > -	if (pdata->type == SOC_ARCH_EXYNOS ||
> > -		pdata->type == SOC_ARCH_EXYNOS4210 ||
> > -				pdata->type == SOC_ARCH_EXYNOS5440)
> > +	if (pdata->type == SOC_ARCH_EXYNOS4210 ||
> > +	    pdata->type == SOC_ARCH_EXYNOS4412 ||
> > +	    pdata->type == SOC_ARCH_EXYNOS5250 ||
> > +	    pdata->type == SOC_ARCH_EXYNOS5440)
> >  		data->soc = pdata->type;
> >  	else {
> >  		ret = -EINVAL;
> > diff --git a/drivers/thermal/samsung/exynos_tmu.h
> > b/drivers/thermal/samsung/exynos_tmu.h index b364c9e..b42ece4 100644
> > --- a/drivers/thermal/samsung/exynos_tmu.h
> > +++ b/drivers/thermal/samsung/exynos_tmu.h
> > @@ -41,7 +41,8 @@ enum calibration_mode {
> >  
> >  enum soc_type {
> >  	SOC_ARCH_EXYNOS4210 = 1,
> > -	SOC_ARCH_EXYNOS,
> > +	SOC_ARCH_EXYNOS4412,
> > +	SOC_ARCH_EXYNOS5250,
> >  	SOC_ARCH_EXYNOS5440,
> >  };
> >  
> > diff --git a/drivers/thermal/samsung/exynos_tmu_data.c
> > b/drivers/thermal/samsung/exynos_tmu_data.c index 9002499..d8de5c1
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
> 
> Below will be only 4412 definitions,right? Why should we test for
> 5250? 
   ^^^^^^^^ [1]

Below are registers definitions for Exynos4412, which appeared first.

However, the Exynos5250 is reusing those registers. 

The exact separation between Exynos4412 and Exynos5250 is done when we
assign value to .tmu_data at exynos4412_default_tmu_data and
exynos5250_default_tmu_data.

The test [1] is correct here.

> 
> > +static const struct exynos_tmu_registers exynos4412_tmu_registers
> > = { .triminfo_data = EXYNOS_TMU_REG_TRIMINFO,
> >  	.triminfo_25_shift = EXYNOS_TRIMINFO_25_SHIFT,
> >  	.triminfo_85_shift = EXYNOS_TRIMINFO_85_SHIFT,
> > @@ -128,7 +128,7 @@ static const struct exynos_tmu_registers
> > exynos5250_tmu_registers = { .emul_time_mask =
> > EXYNOS_EMUL_TIME_MASK, };
> >  
> > -#define EXYNOS5250_TMU_DATA \
> > +#define EXYNOS4412_TMU_DATA \
> >  	.threshold_falling = 10, \
> >  	.trigger_levels[0] = 85, \
> >  	.trigger_levels[1] = 103, \
> > @@ -162,15 +162,31 @@ static const struct exynos_tmu_registers
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
> > +		{
> > +			EXYNOS4412_TMU_DATA,
> > +			.type = SOC_ARCH_EXYNOS4412,
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
> > +		{
> > +			EXYNOS4412_TMU_DATA,
> > +			.type = SOC_ARCH_EXYNOS5250,
> > +		},
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
