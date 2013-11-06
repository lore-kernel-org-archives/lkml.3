Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522Ab3KFNhN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 08:37:13 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:37155 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756235Ab3KFNhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 08:37:10 -0500
X-AuditID: cbfee61a-b7f836d0000025d7-d1-527a46044b4c
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>, linux-pm@vger.kernel.org,
        rui.zhang@intel.com, eduardo.valentin@ti.com,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, amit.daniel@samsung.com,
        Kukjin Kim <kgene.kim@samsung.com>, devicetree@vger.kernel.org,
        cpgs@samsung.com
Subject: Re: [PATCH 1/3 v6] thermal: samsung: add intclr_fall_shift bit in
 exynos_tmu_register
Date: Wed, 06 Nov 2013 14:36:59 +0100
Message-id: <12603996.SuP1Is9Gir@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <CAHfPSqAi5NdAcpiw4LXN0AHdd5t3EW1ATQq=cFsSEV+w36OnbA@mail.gmail.com>
References: <1377668719-8602-2-git-send-email-ch.naveen@samsung.com>
 <2064487.sPVcMNRS4J@amdc1032>
 <CAHfPSqAi5NdAcpiw4LXN0AHdd5t3EW1ATQq=cFsSEV+w36OnbA@mail.gmail.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsVy+t9jAV0Wt6ogg1kH1S0aroZY3H1+mNHi
	5SFNi/lHzrFarNn/k8mid8FVNovLu+awWXzuPcJoMeP8PiaLRdv+M1s8edjH5sDtsXPWXXaP
	xXteMnn0bVnF6HH8xnYmj8+b5AJYo7hsUlJzMstSi/TtErgyXq25x1ow1aDiTP90pgbG5Wpd
	jJwcEgImEisOtTND2GISF+6tZ+ti5OIQEljEKLH4eQM7hNPCJHF45SOwKjYBK4mJ7asYQWwR
	ASOJmQ8WMoIUMQvcYJK4+O0tG0hCWCBBYsKcN2A2i4CqxJnWVhYQm1dAS2Lu7VOsILaogKfE
	ju0rwWo4BYIlHt1cwwKxbTWjxJytE1khGgQlfky+B9bMLCAvsW//VFYIW0dif+s0tgmMArOQ
	lM1CUjYLSdkCRuZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMHx8ExqB+PKBotDjAIcjEo8
	vAnylUFCrIllxZW5hxglOJiVRHitDKqChHhTEiurUovy44tKc1KLDzFKc7AoifMeaLUOFBJI
	TyxJzU5NLUgtgskycXBKNTDqrfnJUtB6us2hnXNt9SWuu09Ntk3ofHz9krv04cro5x/Yvrsr
	2iTt/n+enafp5c8Vr579OlqbxyzZ3inLXz/VYHbZ9E+bsj7ek3H/9Xyq7evjjJsXVH3r0370
	xWFi29ul8zrzWe58Knf/c01eMObA85uh/69w9S3TPPP1ZMmZ4EyTlZkLZ2kKKbEUZyQaajEX
	FScCANLCVBiDAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Wednesday, November 06, 2013 06:47:56 PM Naveen Krishna Ch wrote:
> Hello Bartlomiej,
> 
> My reply is very long delayed sorry.
> 
> On 17 October 2013 15:33, Bartlomiej Zolnierkiewicz
> <b.zolnierkie@samsung.com> wrote:
> >
> > Hi Naveen,
> >
> > On Thursday, October 17, 2013 08:41:13 AM Naveen Krishna Chatradhi wrote:
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
> >> This patch introduces a new bit field intclr_fall_shift to handle the
> >> offset for exyns5250 and exynos5440
> >>
> >> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> >> ---
> >> Changes since v1:
> >> Changes since v2:
> >> Changes since v3:
> >>   None
> >> Changes since v4:
> >>  Correct the CLEAR_FALL_INT_SHIFT for Exynos5250/Exynos5440
> >> Changes since v5:
> >>  Modify the commit message
> >
> > Thank you but v5 had more issues which are not fixed yet. Please see below.
> >
> >>  drivers/thermal/samsung/exynos_tmu.c      |    2 +-
> >>  drivers/thermal/samsung/exynos_tmu.h      |    2 ++
> >>  drivers/thermal/samsung/exynos_tmu_data.c |    2 ++
> >>  drivers/thermal/samsung/exynos_tmu_data.h |    4 +++-
> >>  4 files changed, 8 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
> >> index 32f38b9..b2202fa 100644
> >> --- a/drivers/thermal/samsung/exynos_tmu.c
> >> +++ b/drivers/thermal/samsung/exynos_tmu.c
> >> @@ -265,7 +265,7 @@ skip_calib_data:
> >>                               data->base + reg->threshold_th1);
> >>
> >>               writel((reg->inten_rise_mask << reg->inten_rise_shift) |
> >> -                     (reg->inten_fall_mask << reg->inten_fall_shift),
> >> +                     (reg->inten_fall_mask << reg->intclr_fall_shift),
> >>                               data->base + reg->tmu_intclear);
> >>
> >>               /* if last threshold limit is also present */
> >> diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
> >> index 3fb6554..5f4fe6c 100644
> >> --- a/drivers/thermal/samsung/exynos_tmu.h
> >> +++ b/drivers/thermal/samsung/exynos_tmu.h
> >> @@ -136,6 +136,7 @@ enum soc_type {
> >>   * @inten_fall3_shift: shift bits of falling 3 interrupt bits.
> >>   * @tmu_intstat: Register containing the interrupt status values.
> >>   * @tmu_intclear: Register for clearing the raised interrupt status.
> >> + * @intclr_fall_shift: shift bits for interrupt clear fall 0
> >>   * @emul_con: TMU emulation controller register.
> >>   * @emul_temp_shift: shift bits of emulation temperature.
> >>   * @emul_time_shift: shift bits of emulation time.
> >> @@ -207,6 +208,7 @@ struct exynos_tmu_registers {
> >>       u32     tmu_intstat;
> >>
> >>       u32     tmu_intclear;
> >> +     u32     intclr_fall_shift;
> >>
> >>       u32     emul_con;
> >>       u32     emul_temp_shift;
> >> diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
> >> index 073c292..09a8a27 100644
> >> --- a/drivers/thermal/samsung/exynos_tmu_data.c
> >> +++ b/drivers/thermal/samsung/exynos_tmu_data.c
> >> @@ -123,6 +123,7 @@ static const struct exynos_tmu_registers exynos4412_tmu_registers = {
> >>       .inten_fall0_shift = EXYNOS_TMU_INTEN_FALL0_SHIFT,
> >>       .tmu_intstat = EXYNOS_TMU_REG_INTSTAT,
> >>       .tmu_intclear = EXYNOS_TMU_REG_INTCLEAR,
> >> +     .intclr_fall_shift = EXYNOS5250_TMU_CLEAR_FALL_INT_SHIFT,
> >>       .emul_con = EXYNOS_EMUL_CON,
> >>       .emul_temp_shift = EXYNOS_EMUL_DATA_SHIFT,
> >>       .emul_time_shift = EXYNOS_EMUL_TIME_SHIFT,
> >> @@ -228,6 +229,7 @@ static const struct exynos_tmu_registers exynos5440_tmu_registers = {
> >>       .inten_fall0_shift = EXYNOS5440_TMU_INTEN_FALL0_SHIFT,
> >>       .tmu_intstat = EXYNOS5440_TMU_S0_7_IRQ,
> >>       .tmu_intclear = EXYNOS5440_TMU_S0_7_IRQ,
> >> +     .intclr_fall_shift = EXYNOS5440_TMU_CLEAR_FALL_INT_SHIFT,
> >>       .tmu_irqstatus = EXYNOS5440_TMU_IRQ_STATUS,
> >>       .emul_con = EXYNOS5440_TMU_S0_7_DEBUG,
> >>       .emul_temp_shift = EXYNOS_EMUL_DATA_SHIFT,
> >> diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/thermal/samsung/exynos_tmu_data.h
> >> index a1ea19d..9c1e2c8 100644
> >> --- a/drivers/thermal/samsung/exynos_tmu_data.h
> >> +++ b/drivers/thermal/samsung/exynos_tmu_data.h
> >> @@ -69,9 +69,11 @@
> >>  #define EXYNOS_TMU_RISE_INT_MASK     0x111
> >>  #define EXYNOS_TMU_RISE_INT_SHIFT    0
> >>  #define EXYNOS_TMU_FALL_INT_MASK     0x111
> >> -#define EXYNOS_TMU_FALL_INT_SHIFT    12
> >> +#define EXYNOS_TMU_FALL_INT_SHIFT    16
> >>  #define EXYNOS_TMU_CLEAR_RISE_INT    0x111
> >>  #define EXYNOS_TMU_CLEAR_FALL_INT    (0x111 << 12)
> >> +#define EXYNOS5250_TMU_CLEAR_FALL_INT_SHIFT  12
> >
> > The better name would be EXYNOS_TMU_CLEAR_FALL_INT_SHIFT because it is
> > also used on EXYNOS4412.
> Okey will do that,
> >
> > Also in patch #3 you should define EXYNOS5420_TMU_CLEAR_FALL_INT_SHIFT
> > instead of re-using EXYNOS_TMU_FALL_INT_SHIFT.
> Exynos5440 has so will make for exynos5420 aswell
> >
> > Finally please remove no longer used inten_fall_shift field and related
> inten_fall_shift is not used will remove
> > defines (EXYNOS_TMU_FALL_INT_MASK and EXYNOS5440_TMU_FALL_INT_MASK).
> These macros are used for inten_fall_shift which is used at
> drivers/thermal/samsung/exynos_tmu.c:273:
> (reg->inten_fall_mask << reg->intclr_fall_shift),

I meant EXYNOS_TMU_FALL_INT_SHIFT and EXYNOS5440_TMU_FALL_INT_SHIFT macros,
sorry about the confusion.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

