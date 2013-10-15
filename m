Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758826Ab3JOLkS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 07:40:18 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:64909 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088Ab3JOLkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 07:40:15 -0400
MIME-Version: 1.0
In-Reply-To: <3444817.fM2Daj9BhR@amdc1032>
References: <1378268629-2886-3-git-send-email-ch.naveen@samsung.com>
 <1615083.zyGXhBfPcS@amdc1032> <525BFD1B.5080709@ti.com> <3444817.fM2Daj9BhR@amdc1032>
From: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Date: Tue, 15 Oct 2013 17:09:54 +0530
Message-ID: <CAHfPSqDbvgtMpivfhwd4kW3NE7x2=-zyE1ugpox+e0+mxm7bmg@mail.gmail.com>
Subject: Re: [PATCH 1/3 v4] thermal: samsung: correct the fall interrupt en,
 status bit fields
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Eduardo Valentin <eduardo.valentin@ti.com>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-pm@vger.kernel.org, rui.zhang@intel.com,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, amit.daniel@samsung.com,
        Kukjin Kim <kgene.kim@samsung.com>, devicetree@vger.kernel.org,
        Lukasz Majewski <l.majewski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 October 2013 21:31, Bartlomiej Zolnierkiewicz
<b.zolnierkie@samsung.com> wrote:
> On Monday, October 14, 2013 10:18:03 AM Eduardo Valentin wrote:
>> On 11-10-2013 11:57, Bartlomiej Zolnierkiewicz wrote:
>> >
>> > Hi,
>> >
>> > On Friday, October 11, 2013 11:10:38 AM Eduardo Valentin wrote:
>> >> Hi Naveen,
>> >>
>> >> On 09-10-2013 10:03, Bartlomiej Zolnierkiewicz wrote:
>> >>>
>> >>> Hi,
>> >>>
>> >>> All patches (#1-#3) look good to me, FWIW you can add:
>> >>>
>> >>>   Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
>> >>>
>> >>> Please note that (at least) patch #3 conflicts with Lukasz's EXYNOS4412
>> >>> fixup patchset:
>> >>>
>> >>>   https://lkml.org/lkml/2013/10/9/35
>> >>>
>> >>> It is up to Eduardo to resolve this but it probably would be better to
>> >>> merge EXYNOS4412 fixes first and then add EXYNOS5420 support. This would
>> >>> require you to port patch #3 over Lukasz's patchset though.
>> >>
>> >> My question is if this fix applies also to EXYNOS4412, as it  is not
>> >> mentioned in the patch description and the change affects all supported
>> >
>> > This patch doesn't affect EXYNOS4210 as exynos4210_tmu_registers struct
>>
>> I was, at least for now, worried about 4412, as I mentioned above.
>>
>> > uses the default zero value for inten_fall_mask, inten_fall_shift and
>> > intclr_fall_shift.
>> >
>> >> chip version deliberately. Has this change been validated on all
>> >> supported chip versions?
>> >>
>> >> Amit, I saw you ack, but still, it is not clear how this change behaves
>> >> across supported hardware.
>> >
>> > For EXYNOS4412 and EXYNOS5250 this patch doesn't cause any functionality
>> > changes because while the patch changes inten_fall_shift usage to
>> > intclr_fall_shift one in exynos_tmu_initialize() it defines
>> > EXYNOS_TMU_CLEAR_FALL_INT_SHIFT to 12 (old EXYNOS_TMU_FALL_INT_SHIFT
>> > value).
>> >
>>
>> OK. Then the patch is about a symbol rename, right?
>
> Yes and while doing so it also changes the define and the value used on
> EXYNOS5440. I checked this change against the documentation today (please
> see below).
>
>> > This patch only changes driver behavior for EXYNOS5440 on which the
>> > used shift value changes from 4 to 12.
>>
>> I see.
>
> tmu_intstat and tmu_intclear refer to the same register on EXYNOS5440
> (EXYNOS5440_TMU_S0_7_IRQ defined to 0x230) and the documentation that
> I have says that the value 4 (which matches EXYNOS5440_TMU_FALL_INT_SHIFT
> before the patch) should be used for the shift value. However the patch
> doesn't define EXYNOS5440_TMU_CLEAR_FALL_INT_SHIFT and instead makes
> the code use generic EXYNOS_TMU_CLEAR_FALL_INT_SHIFT (defined to value
> 12) also on EXYNOS5440. This doesn't seem correct.

Right EXYNOS5440  User manual says TMU_S0-7_IRQEN register fields
RISE_IRQEN 3:0
FALL_IRQEN 7:4
Will make changes accordingly.

I've only tested on Exynos5250 and Exynos5420.
Depending on Amit for Exynos5440 as i don't hardware available.
>
> Naveen, this issue needs to be either fixed or explained properly (if
> the documentation is wrong) in the patch description. Please also put some
> information about hardware that you've tested your patch on in the patch
> description.
I've seen that the patches won't apply straight.
and there is a compilation warning introduced. Will fix both of them.
>
>> >
>> > PS I've only noticed it now but after this patch inten_fall_shift becomes
>> > unused and can be removed.
>> >
>>
>>
>> Then we should remove it.
>
> I completely agree.
>
> Best regards,
> --
> Bartlomiej Zolnierkiewicz
> Samsung R&D Institute Poland
> Samsung Electronics
>
>> > Best regards,
>> > --
>> > Bartlomiej Zolnierkiewicz
>> > Samsung R&D Institute Poland
>> > Samsung Electronics
>> >
>> >>>
>> >>> Best regards,
>> >>> --
>> >>> Bartlomiej Zolnierkiewicz
>> >>> Samsung R&D Institute Poland
>> >>> Samsung Electronics
>> >>>
>> >>> On Wednesday, October 09, 2013 05:38:27 PM Naveen Krishna Chatradhi wrote:
>> >>>> The FALL interrupt related en, status bits are available at an offset of
>> >>>> 16 on INTEN, INTSTAT registers and at an offset of
>> >>>> 12 on INTCLEAR register.
>> >>>>
>> >>>> This patch corrects the same for exyns5250 and exynos5440
>> >>>>
>> >>>> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
>> >>>> ---
>> >>>> Changes since v1:
>> >>>> Changes since v2:
>> >>>> Changes since v3:
>> >>>>   None
>> >>>>
>> >>>>  drivers/thermal/samsung/exynos_tmu.c      |    2 +-
>> >>>>  drivers/thermal/samsung/exynos_tmu.h      |    2 ++
>> >>>>  drivers/thermal/samsung/exynos_tmu_data.c |    2 ++
>> >>>>  drivers/thermal/samsung/exynos_tmu_data.h |    3 ++-
>> >>>>  4 files changed, 7 insertions(+), 2 deletions(-)
>> >>>>
>> >>>> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
>> >>>> index b43afda..af69209 100644
>> >>>> --- a/drivers/thermal/samsung/exynos_tmu.c
>> >>>> +++ b/drivers/thermal/samsung/exynos_tmu.c
>> >>>> @@ -265,7 +265,7 @@ skip_calib_data:
>> >>>>                                  data->base + reg->threshold_th1);
>> >>>>
>> >>>>                  writel((reg->inten_rise_mask << reg->inten_rise_shift) |
>> >>>> -                        (reg->inten_fall_mask << reg->inten_fall_shift),
>> >>>> +                        (reg->inten_fall_mask << reg->intclr_fall_shift),
>> >>>>                                  data->base + reg->tmu_intclear);
>> >>>>
>> >>>>                  /* if last threshold limit is also present */
>> >>>> diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
>> >>>> index b364c9e..7c6c34a 100644
>> >>>> --- a/drivers/thermal/samsung/exynos_tmu.h
>> >>>> +++ b/drivers/thermal/samsung/exynos_tmu.h
>> >>>> @@ -134,6 +134,7 @@ enum soc_type {
>> >>>>   * @inten_fall3_shift: shift bits of falling 3 interrupt bits.
>> >>>>   * @tmu_intstat: Register containing the interrupt status values.
>> >>>>   * @tmu_intclear: Register for clearing the raised interrupt status.
>> >>>> + * @intclr_fall_shift: shift bits for interrupt clear fall 0
>> >>>>   * @emul_con: TMU emulation controller register.
>> >>>>   * @emul_temp_shift: shift bits of emulation temperature.
>> >>>>   * @emul_time_shift: shift bits of emulation time.
>> >>>> @@ -204,6 +205,7 @@ struct exynos_tmu_registers {
>> >>>>          u32     tmu_intstat;
>> >>>>
>> >>>>          u32     tmu_intclear;
>> >>>> +        u32     intclr_fall_shift;
>> >>>>
>> >>>>          u32     emul_con;
>> >>>>          u32     emul_temp_shift;
>> >>>> diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
>> >>>> index 9002499..23fea23 100644
>> >>>> --- a/drivers/thermal/samsung/exynos_tmu_data.c
>> >>>> +++ b/drivers/thermal/samsung/exynos_tmu_data.c
>> >>>> @@ -122,6 +122,7 @@ static const struct exynos_tmu_registers exynos5250_tmu_registers = {
>> >>>>          .inten_fall0_shift = EXYNOS_TMU_INTEN_FALL0_SHIFT,
>> >>>>          .tmu_intstat = EXYNOS_TMU_REG_INTSTAT,
>> >>>>          .tmu_intclear = EXYNOS_TMU_REG_INTCLEAR,
>> >>>> +        .intclr_fall_shift = EXYNOS_TMU_CLEAR_FALL_INT_SHIFT,
>> >>>>          .emul_con = EXYNOS_EMUL_CON,
>> >>>>          .emul_temp_shift = EXYNOS_EMUL_DATA_SHIFT,
>> >>>>          .emul_time_shift = EXYNOS_EMUL_TIME_SHIFT,
>> >>>> @@ -210,6 +211,7 @@ static const struct exynos_tmu_registers exynos5440_tmu_registers = {
>> >>>>          .inten_fall0_shift = EXYNOS5440_TMU_INTEN_FALL0_SHIFT,
>> >>>>          .tmu_intstat = EXYNOS5440_TMU_S0_7_IRQ,
>> >>>>          .tmu_intclear = EXYNOS5440_TMU_S0_7_IRQ,
>> >>>> +        .intclr_fall_shift = EXYNOS_TMU_CLEAR_FALL_INT_SHIFT,
>> >>>>          .tmu_irqstatus = EXYNOS5440_TMU_IRQ_STATUS,
>> >>>>          .emul_con = EXYNOS5440_TMU_S0_7_DEBUG,
>> >>>>          .emul_temp_shift = EXYNOS_EMUL_DATA_SHIFT,
>> >>>> diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/thermal/samsung/exynos_tmu_data.h
>> >>>> index dc7feb5..8788a87 100644
>> >>>> --- a/drivers/thermal/samsung/exynos_tmu_data.h
>> >>>> +++ b/drivers/thermal/samsung/exynos_tmu_data.h
>> >>>> @@ -69,9 +69,10 @@
>> >>>>  #define EXYNOS_TMU_RISE_INT_MASK        0x111
>> >>>>  #define EXYNOS_TMU_RISE_INT_SHIFT       0
>> >>>>  #define EXYNOS_TMU_FALL_INT_MASK        0x111
>> >>>> -#define EXYNOS_TMU_FALL_INT_SHIFT       12
>> >>>> +#define EXYNOS_TMU_FALL_INT_SHIFT       16
>> >>>>  #define EXYNOS_TMU_CLEAR_RISE_INT       0x111
>> >>>>  #define EXYNOS_TMU_CLEAR_FALL_INT       (0x111 << 12)
>> >>>> +#define EXYNOS_TMU_CLEAR_FALL_INT_SHIFT 12
>> >>>>  #define EXYNOS_TMU_TRIP_MODE_SHIFT      13
>> >>>>  #define EXYNOS_TMU_TRIP_MODE_MASK       0x7
>> >>>>  #define EXYNOS_TMU_THERM_TRIP_EN_SHIFT  12
>



-- 
Shine bright,
(: Nav :)
