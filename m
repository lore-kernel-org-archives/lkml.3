Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573Ab3JAGzP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 02:55:15 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:42516 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267Ab3JAGzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 02:55:12 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-70-524a71ce4a03
Date: Tue, 01 Oct 2013 08:55:02 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: amit daniel kachhap <amit.daniel@samsung.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, devicetree@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH 3/6] thermal: exynos: Provide initial setting for TMU's
 test MUX address at Exynos4412
Message-id: <20131001085502.187f54ab@amdc308.digital.local>
In-reply-to: <CADGdYn6a1jSR17v0N6kVFZFsn71FUbXJHjeSya-xy_wX9GtYpg@mail.gmail.com>
References: <1380010102-25817-1-git-send-email-l.majewski@samsung.com>
 <1380010102-25817-4-git-send-email-l.majewski@samsung.com>
 <CADGdYn6a1jSR17v0N6kVFZFsn71FUbXJHjeSya-xy_wX9GtYpg@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkkeLIzCtJLcpLzFFi42I5/e+xgO65Qq8gg9kHOC0aroZYbJyxntVi
	/pFzrBZr9v9ksug8+4TZ4s0jbovLu+awWXzuPcJoMeP8PiaL240r2Cz6F/YyWTx52MdmsX7G
	axYHXo/Fe14yeayb9pbZo2/LKkaPR4tbGD2O39jO5PF5k1wAWxSXTUpqTmZZapG+XQJXxq5J
	z9gK5hpXHJl3j72B8YVGFyMnh4SAicSWqXtZIGwxiQv31rN1MXJxCAksYpTYeP8ZlNPOJLFu
	dxcrSBWLgKpEc/97ZhCbTUBP4vPdp0xdjBwcIgKGErO+i4PUMwtMZJHY+XIHWI2wQI7Es/1f
	wGxeAWuJl5d3soPUcwoES0y9FwMx/xSjxKv9u8Dm8wtISrT/+8EMcZGdxLlPG9ghegUlfky+
	B3Yps4CWxOZtTawQtrzE5jVvmScwCs5CUjYLSdksJGULGJlXMYqmFiQXFCel5xrqFSfmFpfm
	pesl5+duYgRH0DOpHYwrGywOMQpwMCrx8BrUewYJsSaWFVfmHmKU4GBWEuFlivMKEuJNSays
	Si3Kjy8qzUktPsQozcGiJM57oNU6UEggPbEkNTs1tSC1CCbLxMEp1cC4IOPu1g/dcW9uqxV+
	2hX+7Ghe0ceXQvc2dzGnnX33/+uRI0deOFUUvF9xRpjNc1XlO8Ha/94JD/8v9jlatIrv5ZKt
	unG1K1fwC9avuDlRqMwvZ3H1CTuJvg9z+Ze9vKvtsDi47zFHsteFQB29D1xqWit32T/nyA7q
	rkvgfPClRH3r4wlSs5KvK7EUZyQaajEXFScCAFf+UPmcAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Amit,

> Hi,
> 
> On Tue, Sep 24, 2013 at 1:38 PM, Lukasz Majewski
> <l.majewski@samsung.com> wrote:
> > The commit d0a0ce3e77c795258d47f9163e92d5031d0c5221 ("thermal:
> > exynos: Add missing definations and code cleanup") has removed
> > setting of test MUX address value at TMU configuration setting.
> >
> > This field is not present on Exynos4210 and Exynos5 SoCs. However
> > on Exynos4412 SoC it is required to set this field after reset
> > because without it TMU shows maximal available temperature, which
> > causes immediate platform shutdown.
> Right In 5250 this field is not defined so didn't catch this. The
> changes looks fine but I have a minor comment that if this field is
> defined in 4412 in detail then you can add a field entry in
> exynos_tmu_registers with proper name and populate this field. 

It seems, that only at Exynos4412 (and Exynos4212) this field is valid.
When I extent exynos_tmu_registers structure, then all other Samsung
SoCs will be aware of it.
Define with explicit EXYNOS4412 seems more readable. 


Also at exynos_tmu_control() function we use constructs like:
data->base + EXYNOS_TMU_REG_CONTROL, not data->base + regs->tmu_ctrl.

> The
> good thing is that in 5250 also this field is reserved and the default
> value is 0x6 so same TMU_DATA can be used for 5250 and 4412.

I'm not keen to this kind of hacks. This field is only valid on
Exynos4x12. And for Exynos5250 is reserved, which means that we shall
not touch it.

> The main
> idea of this suggestion is to reduce the soc checks in the driver.

Correct me if I'm wrong, but this MUX_ADDR initialization is performed
at exynos_tmu_control() which is called at probe and thermal power
management functions. Therefore, it seems that checking if SoC ==
Exynos4412 there is not an overkill.

If you don't mind I would leave those patches as they are and kindly
ask thermal maintainers for pulling them to v3.12.

> 
> Thanks,
> Amit Daniel
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
> >
> >         con = readl(data->base + reg->tmu_ctrl);
> >
> > +       if (pdata->type == SOC_ARCH_EXYNOS4412)
> > +               con |= (EXYNOS4412_MUX_ADDR_VALUE <<
> > EXYNOS4412_MUX_ADDR_SHIFT); +
> >         if (pdata->reference_voltage) {
> >                 con &= ~(reg->buf_vref_sel_mask <<
> > reg->buf_vref_sel_shift); con |= pdata->reference_voltage <<
> > reg->buf_vref_sel_shift; diff --git
> > a/drivers/thermal/samsung/exynos_tmu_data.h
> > b/drivers/thermal/samsung/exynos_tmu_data.h index b130b1e..a1ea19d
> > 100644 --- a/drivers/thermal/samsung/exynos_tmu_data.h +++
> > b/drivers/thermal/samsung/exynos_tmu_data.h @@ -95,6 +95,10 @@
> >
> >  #define EXYNOS_MAX_TRIGGER_PER_REG     4
> >
> > +/* Exynos4412 specific */
> > +#define EXYNOS4412_MUX_ADDR_VALUE          6
> > +#define EXYNOS4412_MUX_ADDR_SHIFT          20
> > +
> >  /*exynos5440 specific registers*/
> >  #define EXYNOS5440_TMU_S0_7_TRIM               0x000
> >  #define EXYNOS5440_TMU_S0_7_CTRL               0x020
> > --
> > 1.7.10.4
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-pm"
> > in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> On Tue, Sep 24, 2013 at 1:38 PM, Lukasz Majewski
> <l.majewski@samsung.com> wrote:
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
> >
> >         con = readl(data->base + reg->tmu_ctrl);
> >
> > +       if (pdata->type == SOC_ARCH_EXYNOS4412)
> > +               con |= (EXYNOS4412_MUX_ADDR_VALUE <<
> > EXYNOS4412_MUX_ADDR_SHIFT); +
> >         if (pdata->reference_voltage) {
> >                 con &= ~(reg->buf_vref_sel_mask <<
> > reg->buf_vref_sel_shift); con |= pdata->reference_voltage <<
> > reg->buf_vref_sel_shift; diff --git
> > a/drivers/thermal/samsung/exynos_tmu_data.h
> > b/drivers/thermal/samsung/exynos_tmu_data.h index b130b1e..a1ea19d
> > 100644 --- a/drivers/thermal/samsung/exynos_tmu_data.h +++
> > b/drivers/thermal/samsung/exynos_tmu_data.h @@ -95,6 +95,10 @@
> >
> >  #define EXYNOS_MAX_TRIGGER_PER_REG     4
> >
> > +/* Exynos4412 specific */
> > +#define EXYNOS4412_MUX_ADDR_VALUE          6
> > +#define EXYNOS4412_MUX_ADDR_SHIFT          20
> > +
> >  /*exynos5440 specific registers*/
> >  #define EXYNOS5440_TMU_S0_7_TRIM               0x000
> >  #define EXYNOS5440_TMU_S0_7_CTRL               0x020
> > --
> > 1.7.10.4
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-pm"
> > in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
