Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423284Ab3FUPVT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 11:21:19 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:41093 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423135Ab3FUPVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 11:21:17 -0400
MIME-Version: 1.0
In-Reply-To: <CADGdYn5JMNgPA3rqGS+QNXWx8hdsQ0g5g5z36W7HXGUssFHe3g@mail.gmail.com>
References: <1371451599-31035-1-git-send-email-amit.daniel@samsung.com>
	<1371451599-31035-25-git-send-email-amit.daniel@samsung.com>
	<51C26659.9050003@ti.com>
	<CADGdYn5JMNgPA3rqGS+QNXWx8hdsQ0g5g5z36W7HXGUssFHe3g@mail.gmail.com>
Date: Fri, 21 Jun 2013 20:51:16 +0530
X-Google-Sender-Auth: W4DTYh1ssN-iGW8apxGoBACjzJE
Message-ID: <CADGdYn4y4jR3X7dzUFjaSvFsh8WzdF7c5izJ10oYyaCEd+ioHQ@mail.gmail.com>
Subject: Re: [PATCH V6 24/30] thermal: exynos: Add thermal configuration data
 for exynos5440 TMU sensor
From: amit daniel kachhap <amit.daniel@samsung.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: linux-pm@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, jonghwa3.lee@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 21, 2013 at 8:49 PM, amit daniel kachhap
<amit.daniel@samsung.com> wrote:
> Hi,
>
> On Thu, Jun 20, 2013 at 7:48 AM, Eduardo Valentin
> <eduardo.valentin@ti.com> wrote:
>> On 17-06-2013 02:46, Amit Daniel Kachhap wrote:
>>> This patch adds configuration data for exynos5440 soc. Also register
>>> definations for the controller are added.
>>>
>>> Acked-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
>>> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
>>> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
>>> ---
>>>  drivers/thermal/samsung/exynos_tmu.c      |    4 ++
>>>  drivers/thermal/samsung/exynos_tmu_data.c |   71 +++++++++++++++++++++++++++++
>>>  drivers/thermal/samsung/exynos_tmu_data.h |    7 +++
>>>  3 files changed, 82 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
>>> index db4035d..a4dbc84 100644
>>> --- a/drivers/thermal/samsung/exynos_tmu.c
>>> +++ b/drivers/thermal/samsung/exynos_tmu.c
>>> @@ -455,6 +455,10 @@ static const struct of_device_id exynos_tmu_match[] = {
>>>               .compatible = "samsung,exynos5250-tmu",
>>>               .data = (void *)EXYNOS5250_TMU_DRV_DATA,
>>>       },
>>> +     {
>>> +             .compatible = "samsung,exynos5440-tmu",
>>> +             .data = (void *)EXYNOS5440_TMU_DRV_DATA,
>>> +     },
>>>       {},
>>>  };
>>>  MODULE_DEVICE_TABLE(of, exynos_tmu_match);
>>> diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
>>> index 694557e..b34e726 100644
>>> --- a/drivers/thermal/samsung/exynos_tmu_data.c
>>> +++ b/drivers/thermal/samsung/exynos_tmu_data.c
>>> @@ -175,3 +175,74 @@ struct exynos_tmu_init_data const exynos5250_default_tmu_data = {
>>>       .tmu_count = 1,
>>>  };
>>>  #endif
>>> +
>>> +#if defined(CONFIG_SOC_EXYNOS5440)
>>> +static const struct exynos_tmu_registers exynos5440_tmu_registers = {
>>> +     .triminfo_data = EXYNOS5440_TMU_S0_7_TRIM,
>>> +     .triminfo_25_shift = EXYNOS_TRIMINFO_25_SHIFT,
>>> +     .triminfo_85_shift = EXYNOS_TRIMINFO_85_SHIFT,
>>> +     .tmu_ctrl = EXYNOS5440_TMU_S0_7_CTRL,
>>> +     .buf_vref_sel_shift = EXYNOS_TMU_REF_VOLTAGE_SHIFT,
>>> +     .buf_vref_sel_mask = EXYNOS_TMU_REF_VOLTAGE_MASK,
>>> +     .therm_trip_mode_shift = EXYNOS_TMU_TRIP_MODE_SHIFT,
>>> +     .therm_trip_mode_mask = EXYNOS_TMU_TRIP_MODE_MASK,
>>> +     .therm_trip_en_shift = EXYNOS_TMU_THERM_TRIP_EN_SHIFT,
>>> +     .buf_slope_sel_shift = EXYNOS_TMU_BUF_SLOPE_SEL_SHIFT,
>>> +     .buf_slope_sel_mask = EXYNOS_TMU_BUF_SLOPE_SEL_MASK,
>>> +     .core_en_shift = EXYNOS_TMU_CORE_EN_SHIFT,
>>> +     .tmu_status = EXYNOS5440_TMU_S0_7_STATUS,
>>> +     .tmu_cur_temp = EXYNOS5440_TMU_S0_7_TEMP,
>>> +     .threshold_th0 = EXYNOS5440_TMU_S0_7_TH0,
>>> +     .threshold_th1 = EXYNOS5440_TMU_S0_7_TH1,
>>> +     .threshold_th2 = EXYNOS5440_TMU_S0_7_TH2,
>>> +     .threshold_th3_l0_shift = EXYNOS5440_TMU_TH_RISE4_SHIFT,
>>> +     .tmu_inten = EXYNOS5440_TMU_S0_7_IRQEN,
>>> +     .inten_rise_mask = EXYNOS5440_TMU_RISE_INT_MASK,
>>> +     .inten_rise_shift = EXYNOS5440_TMU_RISE_INT_SHIFT,
>>> +     .inten_fall_mask = EXYNOS5440_TMU_FALL_INT_MASK,
>>> +     .inten_fall_shift = EXYNOS5440_TMU_FALL_INT_SHIFT,
>>> +     .inten_rise0_shift = EXYNOS5440_TMU_INTEN_RISE0_SHIFT,
>>> +     .inten_rise1_shift = EXYNOS5440_TMU_INTEN_RISE1_SHIFT,
>>> +     .inten_rise2_shift = EXYNOS5440_TMU_INTEN_RISE2_SHIFT,
>>> +     .inten_rise3_shift = EXYNOS5440_TMU_INTEN_RISE3_SHIFT,
>>> +     .inten_fall0_shift = EXYNOS5440_TMU_INTEN_FALL0_SHIFT,
>>> +     .tmu_intstat = EXYNOS5440_TMU_S0_7_IRQ,
>>> +     .tmu_intclear = EXYNOS5440_TMU_S0_7_IRQ,
>>> +     .tmu_irqstatus = EXYNOS5440_TMU_IRQ_STATUS,
>>> +     .emul_con = EXYNOS5440_TMU_S0_7_DEBUG,
>>> +     .emul_temp_shift = EXYNOS_EMUL_DATA_SHIFT,
>>> +     .tmu_pmin = EXYNOS5440_TMU_PMIN,
>>> +};
>>> +
>>> +#define EXYNOS5440_TMU_DATA \
>>> +     .trigger_levels[0] = 100, \
>>> +     .trigger_levels[4] = 105, \
>>> +     .trigger_enable[0] = 1, \
>>> +     .trigger_type[0] = SW_TRIP, \
>>> +     .trigger_type[4] = HW_TRIP, \
>>
>> No active / passive cooling?
>>
>>> +     .max_trigger_level = 5, \
>>> +     .gain = 5, \
>>> +     .reference_voltage = 16, \
>>> +     .noise_cancel_mode = 4, \
>>> +     .cal_type = TYPE_ONE_POINT_TRIMMING, \
>>> +     .cal_mode = 0, \
>>> +     .efuse_value = 0x5b2d, \
>>> +     .min_efuse_value = 16, \
>>> +     .max_efuse_value = 76, \
>>> +     .first_point_trim = 25, \
>>> +     .second_point_trim = 70, \
>>> +     .default_temp_offset = 25, \
>>> +     .type = SOC_ARCH_EXYNOS5440, \
>>> +     .registers = &exynos5440_tmu_registers, \
>>> +     .features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_FALLING_TRIP | \
>>> +                     TMU_SUPPORT_MULTI_INST | TMU_SUPPORT_SHARED_MEMORY),
>>
>> No freq table on 5440? hmm.. So no cpufreq_cooling then? Any reason why
>> not? I suppose one of these 3 sensors are on your CPU domain, right?
> In 5440 no cpufreq cooling is needed. Only sw trip and hw trip is sufficient.
Infact all sensors are cpu related at some positions.
>
> Thanks,
> Amit Daniel
>>
>>> +
>>> +struct exynos_tmu_init_data const exynos5440_default_tmu_data = {
>>> +     .tmu_data = {
>>> +             { EXYNOS5440_TMU_DATA } ,
>>> +             { EXYNOS5440_TMU_DATA } ,
>>> +             { EXYNOS5440_TMU_DATA } ,
>>> +     },
>>> +     .tmu_count = 3,
>>> +};
>>> +#endif
>>> diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/thermal/samsung/exynos_tmu_data.h
>>> index ad263e9..43ce5fb 100644
>>> --- a/drivers/thermal/samsung/exynos_tmu_data.h
>>> +++ b/drivers/thermal/samsung/exynos_tmu_data.h
>>> @@ -143,4 +143,11 @@ extern struct exynos_tmu_init_data const exynos5250_default_tmu_data;
>>>  #define EXYNOS5250_TMU_DRV_DATA (NULL)
>>>  #endif
>>>
>>> +#if defined(CONFIG_SOC_EXYNOS5440)
>>> +extern struct exynos_tmu_init_data const exynos5440_default_tmu_data;
>>> +#define EXYNOS5440_TMU_DRV_DATA (&exynos5440_default_tmu_data)
>>> +#else
>>> +#define EXYNOS5440_TMU_DRV_DATA (NULL)
>>> +#endif
>>> +
>>>  #endif /*_EXYNOS_TMU_DATA_H*/
>>>
>>
>>
>> --
>> You have got to be excited about what you are doing. (L. Lamport)
>>
>> Eduardo Valentin
>>
