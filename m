Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910Ab3EJCMo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 22:12:44 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:39746 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887Ab3EJCMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 22:12:42 -0400
MIME-Version: 1.0
In-Reply-To: <518BAA18.901@ti.com>
References: <1367931671-3906-1-git-send-email-amit.daniel@samsung.com>
	<1367931671-3906-7-git-send-email-amit.daniel@samsung.com>
	<518BAA18.901@ti.com>
Date: Fri, 10 May 2013 07:42:41 +0530
X-Google-Sender-Auth: YNNx5X5QVjZDRyxXloVKi54wLeo
Message-ID: <CADGdYn57vgX=Bk1GoFu0c=Bn5f3r2W7oQQrbcpvaXkqk09Q0Og@mail.gmail.com>
Subject: Re: [PATCH V3 06/21] thermal: exynos: Add missing definations and
 code cleanup
From: amit daniel kachhap <amit.daniel@samsung.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: linux-pm@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, May 9, 2013 at 7:22 PM, Eduardo Valentin
<eduardo.valentin@ti.com> wrote:
> Amit,
>
> On 07-05-2013 09:00, Amit Daniel Kachhap wrote:
>> This patch adds some extra register bitfield definations and cleans
>> up the code to prepare for moving register macros and definations inside
>> the TMU data section.
>>
>> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
>> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
>> ---
>>  drivers/thermal/samsung/exynos_tmu.c |   62 +++++++++++++++++++++++++---------
>>  1 files changed, 46 insertions(+), 16 deletions(-)
>>
>> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
>> index 05b5068..a43afc4 100644
>> --- a/drivers/thermal/samsung/exynos_tmu.c
>> +++ b/drivers/thermal/samsung/exynos_tmu.c
>> @@ -47,9 +47,12 @@
>>
>>  #define EXYNOS_TMU_TRIM_TEMP_MASK    0xff
>>  #define EXYNOS_TMU_GAIN_SHIFT                8
>> +#define EXYNOS_TMU_GAIN_MASK         0xf
>>  #define EXYNOS_TMU_REF_VOLTAGE_SHIFT 24
>> -#define EXYNOS_TMU_CORE_ON           3
>> -#define EXYNOS_TMU_CORE_OFF          2
>> +#define EXYNOS_TMU_REF_VOLTAGE_MASK  0x1f
>> +#define EXYNOS_TMU_BUF_SLOPE_SEL_MASK        0xf
>> +#define EXYNOS_TMU_BUF_SLOPE_SEL_SHIFT       8
>> +#define EXYNOS_TMU_CORE_EN_SHIFT     0
>>  #define EXYNOS_TMU_DEF_CODE_TO_TEMP_OFFSET   50
>>
>>  /* Exynos4210 specific registers */
>> @@ -67,6 +70,7 @@
>>  #define EXYNOS4210_TMU_TRIG_LEVEL1_MASK      0x10
>>  #define EXYNOS4210_TMU_TRIG_LEVEL2_MASK      0x100
>>  #define EXYNOS4210_TMU_TRIG_LEVEL3_MASK      0x1000
>> +#define EXYNOS4210_TMU_TRIG_LEVEL_MASK       0x1111
>>  #define EXYNOS4210_TMU_INTCLEAR_VAL  0x1111
>>
>>  /* Exynos5250 and Exynos4412 specific registers */
>> @@ -76,17 +80,30 @@
>>  #define EXYNOS_EMUL_CON              0x80
>>
>>  #define EXYNOS_TRIMINFO_RELOAD               0x1
>> +#define EXYNOS_TRIMINFO_SHIFT                0x0
>> +#define EXYNOS_TMU_RISE_INT_MASK     0x111
>> +#define EXYNOS_TMU_RISE_INT_SHIFT    0
>> +#define EXYNOS_TMU_FALL_INT_MASK     0x111
>> +#define EXYNOS_TMU_FALL_INT_SHIFT    12
>>  #define EXYNOS_TMU_CLEAR_RISE_INT    0x111
>>  #define EXYNOS_TMU_CLEAR_FALL_INT    (0x111 << 12)
>> -#define EXYNOS_MUX_ADDR_VALUE                6
>> -#define EXYNOS_MUX_ADDR_SHIFT                20
>>  #define EXYNOS_TMU_TRIP_MODE_SHIFT   13
>> +#define EXYNOS_TMU_TRIP_MODE_MASK    0x7
>> +
>> +#define EXYNOS_TMU_INTEN_RISE0_SHIFT 0
>> +#define EXYNOS_TMU_INTEN_RISE1_SHIFT 4
>> +#define EXYNOS_TMU_INTEN_RISE2_SHIFT 8
>> +#define EXYNOS_TMU_INTEN_RISE3_SHIFT 12
>> +#define EXYNOS_TMU_INTEN_FALL0_SHIFT 16
>> +#define EXYNOS_TMU_INTEN_FALL1_SHIFT 20
>> +#define EXYNOS_TMU_INTEN_FALL2_SHIFT 24
>>
>>  #define EFUSE_MIN_VALUE 40
>>  #define EFUSE_MAX_VALUE 100
>>
>>  #ifdef CONFIG_THERMAL_EMULATION
>>  #define EXYNOS_EMUL_TIME     0x57F0
>> +#define EXYNOS_EMUL_TIME_MASK        0xffff
>>  #define EXYNOS_EMUL_TIME_SHIFT       16
>>  #define EXYNOS_EMUL_DATA_SHIFT       8
>>  #define EXYNOS_EMUL_DATA_MASK        0xFF
>
>
> What is the pattern above? Sometimes you use decimal notation sometimes
> you use hex notation. On a quick look I could not see a pattern..
For mask I have used hex and for shift I have used decimal as they
help looking at data sheet easily but I am not sure if there is any
coding guidelines for this.
>
>> @@ -265,24 +282,37 @@ static void exynos_tmu_control(struct platform_device *pdev, bool on)
>>       mutex_lock(&data->lock);
>>       clk_enable(data->clk);
>>
>> -     con = pdata->reference_voltage << EXYNOS_TMU_REF_VOLTAGE_SHIFT |
>> -             pdata->gain << EXYNOS_TMU_GAIN_SHIFT;
>> +     con = readl(data->base + EXYNOS_TMU_REG_CONTROL);
>>
>
> You have a important change here. Before you would just apply a value
> based on your local configuration. Now you are considering what is
> present in your ctrl register. Is this really a code cleanup required
> for moving the register definitions?
My intention of doing it like this way is to use the default value
from the controller if no data value is passed. In case any data value
just use it.
>
>> -     if (data->soc == SOC_ARCH_EXYNOS) {
>> -             con |= pdata->noise_cancel_mode << EXYNOS_TMU_TRIP_MODE_SHIFT;
>> -             con |= (EXYNOS_MUX_ADDR_VALUE << EXYNOS_MUX_ADDR_SHIFT);
>> +     if (pdata->reference_voltage) {
>> +             con &= ~(EXYNOS_TMU_REF_VOLTAGE_MASK <<
>> +                             EXYNOS_TMU_REF_VOLTAGE_SHIFT);
>> +             con |= pdata->reference_voltage << EXYNOS_TMU_REF_VOLTAGE_SHIFT;
>> +     }
>> +
>> +     if (pdata->gain) {
>> +             con &= ~(EXYNOS_TMU_GAIN_MASK << EXYNOS_TMU_GAIN_SHIFT);
>> +             con |= (pdata->gain << EXYNOS_TMU_GAIN_SHIFT);
>> +     }
>> +
>> +     if (pdata->noise_cancel_mode) {
>> +             con &= ~(EXYNOS_TMU_TRIP_MODE_MASK <<
>> +                                     EXYNOS_TMU_TRIP_MODE_SHIFT);
>> +             con |= (pdata->noise_cancel_mode << EXYNOS_TMU_TRIP_MODE_SHIFT);
>
> For all the above ifs: Dont you want to clear those bits in case the
> pdata config says those flags are not set? For instance, if pdata->gain
> == 0, do you need to con &= ~(EXYNOS_TMU_GAIN_MASK <<
> EXYNOS_TMU_GAIN_SHIFT); ??
if data value is not passed I want to retain the default value and not clear it.

Thanks,
Amit Daniel
>
>>       }
>>
>>       if (on) {
>> -             con |= EXYNOS_TMU_CORE_ON;
>> -             interrupt_en = pdata->trigger_level3_en << 12 |
>> -                     pdata->trigger_level2_en << 8 |
>> -                     pdata->trigger_level1_en << 4 |
>> -                     pdata->trigger_level0_en;
>> +             con |= (1 << EXYNOS_TMU_CORE_EN_SHIFT);
>> +             interrupt_en =
>> +             pdata->trigger_level3_en << EXYNOS_TMU_INTEN_RISE3_SHIFT |
>> +             pdata->trigger_level2_en << EXYNOS_TMU_INTEN_RISE2_SHIFT |
>> +             pdata->trigger_level1_en << EXYNOS_TMU_INTEN_RISE1_SHIFT |
>> +             pdata->trigger_level0_en << EXYNOS_TMU_INTEN_RISE0_SHIFT;
>>               if (pdata->threshold_falling)
>> -                     interrupt_en |= interrupt_en << 16;
>> +                     interrupt_en |=
>> +                             interrupt_en << EXYNOS_TMU_INTEN_FALL0_SHIFT;
>>       } else {
>> -             con |= EXYNOS_TMU_CORE_OFF;
>> +             con &= ~(1 << EXYNOS_TMU_CORE_EN_SHIFT);
>>               interrupt_en = 0; /* Disable all interrupts */
>>       }
>>       writel(interrupt_en, data->base + EXYNOS_TMU_REG_INTEN);
>>
>
>
