Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030626AbaDJMng (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 08:43:36 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:62942 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030279AbaDJMne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 08:43:34 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-a6-534691f26866
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>,
        Zhang Rui <rui.zhang@intel.com>
Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>, linux-pm@vger.kernel.org,
        eduardo.valentin@ti.com,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, amit.daniel@samsung.com,
        Kukjin Kim <kgene.kim@samsung.com>, devicetree@vger.kernel.org,
        cpgs@samsung.com, t.figa@samsung.com
Subject: Re: [PATCH v12 1/4] thermal: samsung: replace inten_ bit fields with
 intclr_
Date: Thu, 10 Apr 2014 14:43:22 +0200
Message-id: <10587037.4L52vlzy8d@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <CAHfPSqDJL87OQXFHUzmj8X_ztpWu5igv-EQ7qDmSUKF_FSu+BA@mail.gmail.com>
References: <1384238168-24561-1-git-send-email-ch.naveen@samsung.com>
 <1388629994.3739.70.camel@rzhang1-mobl4>
 <CAHfPSqDJL87OQXFHUzmj8X_ztpWu5igv-EQ7qDmSUKF_FSu+BA@mail.gmail.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKLMWRmVeSWpSXmKPExsVy+t9jAd1PE92CDVbdVbFouBpicff5YUaL
	l4c0LeYfOcdqsWb/TyaL3gVX2Swu75rDZvG59wijxYzz+5gsFm37z2zx5GEfm8X6Ga9ZHHg8
	ds66y+6xeM9LJo++LasYPY7f2M7k8XmTXABrFJdNSmpOZllqkb5dAlfG+f/tzAXbwypmzf3B
	3MB4zrmLkZNDQsBEYsOnYywQtpjEhXvr2boYuTiEBBYxSjx/f50Rwmlhkji48gs7SBWbgJXE
	xPZVjCC2iECoxOSVPWAdzALXmSTuPL3CCpIQFgiX+PJzL5jNIqAqce3TWTYQm1dAS2Lf/Wdg
	60QFPCV2bF8JFucUCJaY/ek5O8S27YwS1w99YIZoEJT4MfkeWAOzgLzEvv1TWSFsHYn9rdPY
	JjAKzEJSNgtJ2SwkZQsYmVcxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBEfGM+kdjKsaLA4x
	CnAwKvHwHljmGizEmlhWXJl7iFGCg1lJhHdtq1uwEG9KYmVValF+fFFpTmrxIUZpDhYlcd6D
	rdaBQgLpiSWp2ampBalFMFkmDk6pBkYHMTu+uCuCf2z2uf+RO5G1/fzUj39que6e/OnIVpkx
	UdV3TlmawYptN658+lG06V9Hz9WHcpGfJjW7WzJHvJz118e4kONY+e3fIfXuiZyTZKdzLzGb
	fvuSgOXu64+eKqfERysZTfeXuDP/8e9761225VU8XBPk85lN66OG+rxmk4Y+iejH0/WVWIoz
	Eg21mIuKEwF5tBqaiAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Zhang, could you please review/merge this patchset?

[ We have been waiting for a review for over 3 months now.. ]

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

On Friday, February 07, 2014 03:03:46 PM Naveen Krishna Ch wrote:
> Hello All,
> 
> On 2 January 2014 08:03, Zhang Rui <rui.zhang@intel.com> wrote:
> > On Thu, 2013-12-19 at 11:35 +0530, Naveen Krishna Chatradhi wrote:
> >> This patch replaces the inten_rise_shift/mask and inten_fall_shift/mask
> >> with intclr_rise_shift/mask and intclr_fall_shift/mask respectively.
> >> Currently, inten_rise_shift/mask and inten_fall_shift/mask bits are only used
> >> to configure intclr related registers.
> >>
> >> Description of H/W:
> >> The offset for the bits in the CLEAR register are not consistent across TMU
> >> modules in Exynso5250, 5420 and 5440.
> >>
> >> On Exynos5250, the FALL interrupt related en, status and clear bits are
> >> available at an offset of
> >> 16 in INTEN, INTSTAT registers and at an offset of
> >> 12 in INTCLEAR register.
> >>
> >> On Exynos5420, the FALL interrupt related en, status and clear bits are
> >> available at an offset of
> >> 16 in INTEN, INTSTAT and INTCLEAR registers.
> >>
> >> On Exynos5440,
> >> the FALL_IRQEN bits are at an offset of 4
> >> and the RISE_IRQEN bits are at an offset of 0
> >>
> >> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> >> Acked-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
> >> Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> >> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> >
> > Eduardo,
> >
> > what do you think of this patch set?
> >
> > thanks,
> > rui
> >> ---
> >> Changes since v11:
> >> Added Reviewed by Tomasz
> >>
> >> Changes since v10:
> >> None
> >>
> >>  drivers/thermal/samsung/exynos_tmu.c      |    6 +++---
> >>  drivers/thermal/samsung/exynos_tmu.h      |   16 ++++++++--------
> >>  drivers/thermal/samsung/exynos_tmu_data.c |   18 +++++++++---------
> >>  drivers/thermal/samsung/exynos_tmu_data.h |    4 ++--
> >>  4 files changed, 22 insertions(+), 22 deletions(-)
> >>
> >> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
> >> index 32f38b9..c493245 100644
> >> --- a/drivers/thermal/samsung/exynos_tmu.c
> >> +++ b/drivers/thermal/samsung/exynos_tmu.c
> >> @@ -237,7 +237,7 @@ skip_calib_data:
> >>                       writeb(pdata->trigger_levels[i], data->base +
> >>                       reg->threshold_th0 + i * sizeof(reg->threshold_th0));
> >>
> >> -             writel(reg->inten_rise_mask, data->base + reg->tmu_intclear);
> >> +             writel(reg->intclr_rise_mask, data->base + reg->tmu_intclear);
> >>       } else {
> >>               /* Write temperature code for rising and falling threshold */
> >>               for (i = 0;
> >> @@ -264,8 +264,8 @@ skip_calib_data:
> >>               writel(falling_threshold,
> >>                               data->base + reg->threshold_th1);
> >>
> >> -             writel((reg->inten_rise_mask << reg->inten_rise_shift) |
> >> -                     (reg->inten_fall_mask << reg->inten_fall_shift),
> >> +             writel((reg->intclr_rise_mask << reg->intclr_rise_shift) |
> >> +                     (reg->intclr_fall_mask << reg->intclr_fall_shift),
> >>                               data->base + reg->tmu_intclear);
> >>
> >>               /* if last threshold limit is also present */
> >> diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
> >> index 3fb6554..980859a 100644
> >> --- a/drivers/thermal/samsung/exynos_tmu.h
> >> +++ b/drivers/thermal/samsung/exynos_tmu.h
> >> @@ -122,10 +122,6 @@ enum soc_type {
> >>   * @threshold_th3_l0_shift: shift bits of level0 threshold temperature.
> >>   * @tmu_inten: register containing the different threshold interrupt
> >>       enable bits.
> >> - * @inten_rise_shift: shift bits of all rising interrupt bits.
> >> - * @inten_rise_mask: mask bits of all rising interrupt bits.
> >> - * @inten_fall_shift: shift bits of all rising interrupt bits.
> >> - * @inten_fall_mask: mask bits of all rising interrupt bits.
> >>   * @inten_rise0_shift: shift bits of rising 0 interrupt bits.
> >>   * @inten_rise1_shift: shift bits of rising 1 interrupt bits.
> >>   * @inten_rise2_shift: shift bits of rising 2 interrupt bits.
> >> @@ -136,6 +132,10 @@ enum soc_type {
> >>   * @inten_fall3_shift: shift bits of falling 3 interrupt bits.
> >>   * @tmu_intstat: Register containing the interrupt status values.
> >>   * @tmu_intclear: Register for clearing the raised interrupt status.
> >> + * @intclr_fall_shift: shift bits for interrupt clear fall 0
> >> + * @intclr_rise_shift: shift bits of all rising interrupt bits.
> >> + * @intclr_rise_mask: mask bits of all rising interrupt bits.
> >> + * @intclr_fall_mask: mask bits of all rising interrupt bits.
> >>   * @emul_con: TMU emulation controller register.
> >>   * @emul_temp_shift: shift bits of emulation temperature.
> >>   * @emul_time_shift: shift bits of emulation time.
> >> @@ -191,10 +191,6 @@ struct exynos_tmu_registers {
> >>       u32     threshold_th3_l0_shift;
> >>
> >>       u32     tmu_inten;
> >> -     u32     inten_rise_shift;
> >> -     u32     inten_rise_mask;
> >> -     u32     inten_fall_shift;
> >> -     u32     inten_fall_mask;
> >>       u32     inten_rise0_shift;
> >>       u32     inten_rise1_shift;
> >>       u32     inten_rise2_shift;
> >> @@ -207,6 +203,10 @@ struct exynos_tmu_registers {
> >>       u32     tmu_intstat;
> >>
> >>       u32     tmu_intclear;
> >> +     u32     intclr_fall_shift;
> >> +     u32     intclr_rise_shift;
> >> +     u32     intclr_fall_mask;
> >> +     u32     intclr_rise_mask;
> >>
> >>       u32     emul_con;
> >>       u32     emul_temp_shift;
> >> diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
> >> index 073c292..7cdb04e 100644
> >> --- a/drivers/thermal/samsung/exynos_tmu_data.c
> >> +++ b/drivers/thermal/samsung/exynos_tmu_data.c
> >> @@ -40,13 +40,13 @@ static const struct exynos_tmu_registers exynos4210_tmu_registers = {
> >>       .threshold_temp = EXYNOS4210_TMU_REG_THRESHOLD_TEMP,
> >>       .threshold_th0 = EXYNOS4210_TMU_REG_TRIG_LEVEL0,
> >>       .tmu_inten = EXYNOS_TMU_REG_INTEN,
> >> -     .inten_rise_mask = EXYNOS4210_TMU_TRIG_LEVEL_MASK,
> >>       .inten_rise0_shift = EXYNOS_TMU_INTEN_RISE0_SHIFT,
> >>       .inten_rise1_shift = EXYNOS_TMU_INTEN_RISE1_SHIFT,
> >>       .inten_rise2_shift = EXYNOS_TMU_INTEN_RISE2_SHIFT,
> >>       .inten_rise3_shift = EXYNOS_TMU_INTEN_RISE3_SHIFT,
> >>       .tmu_intstat = EXYNOS_TMU_REG_INTSTAT,
> >>       .tmu_intclear = EXYNOS_TMU_REG_INTCLEAR,
> >> +     .intclr_rise_mask = EXYNOS4210_TMU_TRIG_LEVEL_MASK,
> >>  };
> >>
> >>  struct exynos_tmu_init_data const exynos4210_default_tmu_data = {
> >> @@ -112,10 +112,6 @@ static const struct exynos_tmu_registers exynos4412_tmu_registers = {
> >>       .threshold_th0 = EXYNOS_THD_TEMP_RISE,
> >>       .threshold_th1 = EXYNOS_THD_TEMP_FALL,
> >>       .tmu_inten = EXYNOS_TMU_REG_INTEN,
> >> -     .inten_rise_mask = EXYNOS_TMU_RISE_INT_MASK,
> >> -     .inten_rise_shift = EXYNOS_TMU_RISE_INT_SHIFT,
> >> -     .inten_fall_mask = EXYNOS_TMU_FALL_INT_MASK,
> >> -     .inten_fall_shift = EXYNOS_TMU_FALL_INT_SHIFT,
> >>       .inten_rise0_shift = EXYNOS_TMU_INTEN_RISE0_SHIFT,
> >>       .inten_rise1_shift = EXYNOS_TMU_INTEN_RISE1_SHIFT,
> >>       .inten_rise2_shift = EXYNOS_TMU_INTEN_RISE2_SHIFT,
> >> @@ -123,6 +119,10 @@ static const struct exynos_tmu_registers exynos4412_tmu_registers = {
> >>       .inten_fall0_shift = EXYNOS_TMU_INTEN_FALL0_SHIFT,
> >>       .tmu_intstat = EXYNOS_TMU_REG_INTSTAT,
> >>       .tmu_intclear = EXYNOS_TMU_REG_INTCLEAR,
> >> +     .intclr_fall_shift = EXYNOS_TMU_CLEAR_FALL_INT_SHIFT,
> >> +     .intclr_rise_shift = EXYNOS_TMU_RISE_INT_SHIFT,
> >> +     .intclr_rise_mask = EXYNOS_TMU_RISE_INT_MASK,
> >> +     .intclr_fall_mask = EXYNOS_TMU_FALL_INT_MASK,
> >>       .emul_con = EXYNOS_EMUL_CON,
> >>       .emul_temp_shift = EXYNOS_EMUL_DATA_SHIFT,
> >>       .emul_time_shift = EXYNOS_EMUL_TIME_SHIFT,
> >> @@ -217,10 +217,6 @@ static const struct exynos_tmu_registers exynos5440_tmu_registers = {
> >>       .threshold_th2 = EXYNOS5440_TMU_S0_7_TH2,
> >>       .threshold_th3_l0_shift = EXYNOS5440_TMU_TH_RISE4_SHIFT,
> >>       .tmu_inten = EXYNOS5440_TMU_S0_7_IRQEN,
> >> -     .inten_rise_mask = EXYNOS5440_TMU_RISE_INT_MASK,
> >> -     .inten_rise_shift = EXYNOS5440_TMU_RISE_INT_SHIFT,
> >> -     .inten_fall_mask = EXYNOS5440_TMU_FALL_INT_MASK,
> >> -     .inten_fall_shift = EXYNOS5440_TMU_FALL_INT_SHIFT,
> >>       .inten_rise0_shift = EXYNOS5440_TMU_INTEN_RISE0_SHIFT,
> >>       .inten_rise1_shift = EXYNOS5440_TMU_INTEN_RISE1_SHIFT,
> >>       .inten_rise2_shift = EXYNOS5440_TMU_INTEN_RISE2_SHIFT,
> >> @@ -228,6 +224,10 @@ static const struct exynos_tmu_registers exynos5440_tmu_registers = {
> >>       .inten_fall0_shift = EXYNOS5440_TMU_INTEN_FALL0_SHIFT,
> >>       .tmu_intstat = EXYNOS5440_TMU_S0_7_IRQ,
> >>       .tmu_intclear = EXYNOS5440_TMU_S0_7_IRQ,
> >> +     .intclr_fall_shift = EXYNOS5440_TMU_CLEAR_FALL_INT_SHIFT,
> >> +     .intclr_rise_shift = EXYNOS5440_TMU_RISE_INT_SHIFT,
> >> +     .intclr_rise_mask = EXYNOS5440_TMU_RISE_INT_MASK,
> >> +     .intclr_fall_mask = EXYNOS5440_TMU_FALL_INT_MASK,
> >>       .tmu_irqstatus = EXYNOS5440_TMU_IRQ_STATUS,
> >>       .emul_con = EXYNOS5440_TMU_S0_7_DEBUG,
> >>       .emul_temp_shift = EXYNOS_EMUL_DATA_SHIFT,
> >> diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/thermal/samsung/exynos_tmu_data.h
> >> index a1ea19d..d9495a4 100644
> >> --- a/drivers/thermal/samsung/exynos_tmu_data.h
> >> +++ b/drivers/thermal/samsung/exynos_tmu_data.h
> >> @@ -69,9 +69,10 @@
> >>  #define EXYNOS_TMU_RISE_INT_MASK     0x111
> >>  #define EXYNOS_TMU_RISE_INT_SHIFT    0
> >>  #define EXYNOS_TMU_FALL_INT_MASK     0x111
> >> -#define EXYNOS_TMU_FALL_INT_SHIFT    12
> >>  #define EXYNOS_TMU_CLEAR_RISE_INT    0x111
> >>  #define EXYNOS_TMU_CLEAR_FALL_INT    (0x111 << 12)
> >> +#define EXYNOS_TMU_CLEAR_FALL_INT_SHIFT      12
> >> +#define EXYNOS5440_TMU_CLEAR_FALL_INT_SHIFT  4
> >>  #define EXYNOS_TMU_TRIP_MODE_SHIFT   13
> >>  #define EXYNOS_TMU_TRIP_MODE_MASK    0x7
> >>  #define EXYNOS_TMU_THERM_TRIP_EN_SHIFT       12
> >> @@ -119,7 +120,6 @@
> >>  #define EXYNOS5440_TMU_RISE_INT_MASK         0xf
> >>  #define EXYNOS5440_TMU_RISE_INT_SHIFT                0
> >>  #define EXYNOS5440_TMU_FALL_INT_MASK         0xf
> >> -#define EXYNOS5440_TMU_FALL_INT_SHIFT                4
> >>  #define EXYNOS5440_TMU_INTEN_RISE0_SHIFT     0
> >>  #define EXYNOS5440_TMU_INTEN_RISE1_SHIFT     1
> >>  #define EXYNOS5440_TMU_INTEN_RISE2_SHIFT     2
> >
> >
> Ping.

