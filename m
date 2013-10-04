Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713Ab3JDKUm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 06:20:42 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:19477 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438Ab3JDKUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 06:20:39 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-b9-524e96761e24
Date: Fri, 04 Oct 2013 12:20:31 +0200
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
Subject: Re: [PATCH 3/6] thermal: exynos: Provide initial setting for TMU's
 test MUX address at Exynos4412
Message-id: <20131004122031.379450f3@amdc308.digital.local>
In-reply-to: <524DEA1D.4010100@ti.com>
References: <1380010102-25817-1-git-send-email-l.majewski@samsung.com>
 <1380010102-25817-4-git-send-email-l.majewski@samsung.com>
 <524DEA1D.4010100@ti.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkkeLIzCtJLcpLzFFi42I5/e+xoG7ZNL8gg2/blC0aroZYbJyxntVi
	/pFzrBZr9v9ksug8+4TZ4s0jbovLu+awWXzuPcJoMeP8PiaL240r2Cz6F/YyWTx52MdmsX7G
	axYHXo/Fe14yeayb9pbZo2/LKkaPR4tbGD2O39jO5PF5k1wAWxSXTUpqTmZZapG+XQJXRtP0
	yywF7yUqNl/dwtzAOFOki5GTQ0LAROLrlfcsELaYxIV769m6GLk4hASmM0rsXvKHEcJpZ5Lo
	nXiVGaSKRUBV4tKkf4wgNpuAnsTnu0+ZQGwRIPvGiydgNrPAG2aJ1Su8QGxhgRyJZ/u/APVy
	cPAKWEtcaVcDCXMKqEk8vPSfBWL+fEaJr3ufg83nF5CUaP/3gxniIjuJc582sIPYvAKCEj8m
	32OBmK8lsXlbEyuELS+xec1b5gmMgrOQlM1CUjYLSdkCRuZVjKKpBckFxUnpuUZ6xYm5xaV5
	6XrJ+bmbGMER9Ex6B+OqBotDjAIcjEo8vBuKfYOEWBPLiitzDzFKcDArifAen+QXJMSbklhZ
	lVqUH19UmpNafIhRmoNFSZz3YKt1oJBAemJJanZqakFqEUyWiYNTqoFx6tyJDTEurzknNG9t
	t1aRXnlZvnsDR92HA/W3v09MexjO8+uj2M47k/R/OVQpqqb92dxq/+q6tMerg4X+GxODTzsp
	MbnG+gpkHkqxD15wWyPFbeb2h7/vf9T71fIrKn/vYU3GMI19OVX7Dgq4hEsl6L1prO18k739
	aPwaSQ/h+0IL2DfnBBQpsRRnJBpqMRcVJwIA1+08oJwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eduardo,

> On 24-09-2013 04:08, Lukasz Majewski wrote:
> > The commit d0a0ce3e77c795258d47f9163e92d5031d0c5221 ("thermal:
> > exynos: Add missing definations and code cleanup") has removed
> > setting of test MUX address value at TMU configuration setting.
> > 
> > This field is not present on Exynos4210 and Exynos5 SoCs. However
> > on Exynos4412 SoC it is required to set this field after reset
> > because without it TMU shows maximal available temperature, which
> > causes immediate platform shutdown.
> > 
> > Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> > Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> > Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> > ---
> >  drivers/thermal/samsung/exynos_tmu.c      |    3 +++
> >  drivers/thermal/samsung/exynos_tmu_data.h |    4 ++++
> >  2 files changed, 7 insertions(+)
> > 
> > diff --git a/drivers/thermal/samsung/exynos_tmu.c
> > b/drivers/thermal/samsung/exynos_tmu.c index a858cc4..21b89e4 100644
> > --- a/drivers/thermal/samsung/exynos_tmu.c
> > +++ b/drivers/thermal/samsung/exynos_tmu.c
> > @@ -317,6 +317,9 @@ static void exynos_tmu_control(struct
> > platform_device *pdev, bool on) 
> >  	con = readl(data->base + reg->tmu_ctrl);
> >  
> > +	if (pdata->type == SOC_ARCH_EXYNOS4412)
> > +		con |= (EXYNOS4412_MUX_ADDR_VALUE <<
> > EXYNOS4412_MUX_ADDR_SHIFT);
> 
> Amit has introduced a way to describe features instead of checking
> features per type. It would be interesting to have a reasoning why not
> to use it. 

Problem with Exynos4412 and Exynos4212 is that _only_ those SoCs export
this MUX_ADDR field at TMU_CONTROL register. Also I _must_ setup it
correctly after reset (reset value causes board emergency shutdown).

The Exynos5250 defines it as a "reserved".

> Think what if new Exynos TMU versions come, are you guys
> going to steadily increase the above check for type?

As the alternative I can define the TMU_SUPPORT_MUX_ADDR at .features
field for EXYNOS4412_TMU_DATA.

Then I can test for this feature at exynos_tmu_control function.
Proper shift and mask can be defined at struct exynos_tmu_registers.

Eduardo, Amit, will we manage to review/pull those patches with new
approach before -rcX ends?

> 
> > +
> >  	if (pdata->reference_voltage) {
> >  		con &= ~(reg->buf_vref_sel_mask <<
> > reg->buf_vref_sel_shift); con |= pdata->reference_voltage <<
> > reg->buf_vref_sel_shift; diff --git
> > a/drivers/thermal/samsung/exynos_tmu_data.h
> > b/drivers/thermal/samsung/exynos_tmu_data.h index b130b1e..a1ea19d
> > 100644 --- a/drivers/thermal/samsung/exynos_tmu_data.h +++
> > b/drivers/thermal/samsung/exynos_tmu_data.h @@ -95,6 +95,10 @@
> >  
> >  #define EXYNOS_MAX_TRIGGER_PER_REG	4
> >  
> > +/* Exynos4412 specific */
> > +#define EXYNOS4412_MUX_ADDR_VALUE          6
> > +#define EXYNOS4412_MUX_ADDR_SHIFT          20
> > +
> >  /*exynos5440 specific registers*/
> >  #define EXYNOS5440_TMU_S0_7_TRIM		0x000
> >  #define EXYNOS5440_TMU_S0_7_CTRL		0x020
> > 
> 
> 



-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
