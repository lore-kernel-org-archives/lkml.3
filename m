Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872AbaKAHep (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 03:34:45 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:39619 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbaKAHen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 03:34:43 -0400
MIME-Version: 1.0
In-Reply-To: <CAGTfZH1kK3z0NL1F0WFQ4Qad0z3xin6Qdrh4ymCgPY9Rz+7zaA@mail.gmail.com>
References: <1414759083-4555-1-git-send-email-a.kesavan@samsung.com>
	<545384D3.5050000@samsung.com>
	<CAM4voamJhveLN-=wS2vF+x9e3kWMSR_2X1QsHLpB3w4DwgkgyQ@mail.gmail.com>
	<CAGTfZH2fpv3tR3Ah6sHCWAUGS6PhNiQkKEz_ab22ux55-KdRPQ@mail.gmail.com>
	<CAM4voamU-kd_GXHSfg87pT2cGoNVwnqeOEFcyLN1Of00LfeHWQ@mail.gmail.com>
	<CAGTfZH1kK3z0NL1F0WFQ4Qad0z3xin6Qdrh4ymCgPY9Rz+7zaA@mail.gmail.com>
Date: Sat, 1 Nov 2014 13:04:42 +0530
Message-ID: <CAM4voa=a+TyVmT91WgvxG1p-FeOv3qB=-VZsKY45KYcXktsGcA@mail.gmail.com>
Subject: Re: [PATCH] iio: adc: exynos_adc: Add support for ADCv3 on exynos7
From: Abhilash Kesavan <kesavan.abhilash@gmail.com>
To: =?UTF-8?B?7LWc7LCs7Jqw?= <cw00.choi@samsung.com>
Cc: linux-iio@vger.kernel.org, jic23@kernel.org,
        Naveen Krishna <naveenkrishna.ch@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo,

On Sat, Nov 1, 2014 at 11:57 AM, Chanwoo Choi <cwchoi00@gmail.com> wrote:
> Hi Abhilash,
>
> On Sat, Nov 1, 2014 at 1:00 PM, Abhilash Kesavan
> <kesavan.abhilash@gmail.com> wrote:
>> Hi Chanwoo,
>>
>> On Fri, Oct 31, 2014 at 9:44 PM, Chanwoo Choi <cwchoi00@gmail.com> wrote:
>>> Hi Abhilash,
>>>
>>> On Fri, Oct 31, 2014 at 11:01 PM, Abhilash Kesavan
>>> <kesavan.abhilash@gmail.com> wrote:
>>>> Hi Chanwoo,
>>>>
>>>> Thanks for the quick response.
>>>>
>>>> On Fri, Oct 31, 2014 at 6:17 PM, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>>>>> Hi Abhilash,
>>>>>
>>>>> On 10/31/2014 09:38 PM, Abhilash Kesavan wrote:
>>>>>> The ADC on exynos7 is quite similar to ADCv2. The differences are as
>>>>>> follows:
>>>>>>       - v3 has 8 input channels (10 in v2).
>>>>>>       - v3 does not include an ADC PHY control register.
>>>>>>       - Some ADC_CON2 register bits being used in v2 are listed as
>>>>>>         reserved in v3. This results in a different init_hw function
>>>>>>         for v3.
>>>>>>
>>>>>> Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
>>>>>> ---
>>>>>> - Based on Naveen's "iio: exynos-adc: use syscon instead of ioremap" patchset
>>>>>> http://comments.gmane.org/gmane.linux.kernel.iio/13943
>>>>>>
>>>>>>  .../devicetree/bindings/arm/samsung/exynos-adc.txt |    2 ++
>>>>>>  drivers/iio/adc/exynos_adc.c                       |   32 ++++++++++++++++++++
>>>>>>  2 files changed, 34 insertions(+)
>>>>>>
>>>>>> diff --git a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
>>>>>> index c368210..a11e32c 100644
>>>>>> --- a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
>>>>>> +++ b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
>>>>>> @@ -14,6 +14,8 @@ Required properties:
>>>>>>                               for exynos4412/5250 and s5pv210 controllers.
>>>>>>                       Must be "samsung,exynos-adc-v2" for
>>>>>>                               future controllers.
>>>>>> +                     Must be "samsung,exynos-adc-v3" for
>>>>>> +                             the ADC in Exynos7 and compatibles
>>>>>
>>>>> I prefer to use 'exynos7-adc' instead of 'exynos-adc-v3'.
>>>>> Exynos7 has little different from existing ADCv2.
>>>>
>>>> Sure, I'll change it. The reason for my choosing v3 was that reading
>>>> the version register (0x20 offset) showed a value of 0x80000009 in
>>>> Exynos7 as against 0x80000008 in both 5420 and 3250.
>>>>>
>>>>> Also, If you want to use 'exynos-adc-v3' compatible,
>>>>> Exynos7's TRM have to include the correct version(v3) infromation.
>>>>
>>>> I could not see any mention of the ADC controller version in the
>>>> Exynos7 UM other than the version register. Does that mean it is v2 ?
>>>
>>> So am I. I don't see any version number of ADC in Exynos TRM.
>> OK, considering the small differences between ADCv2 and this
>> controller, I will change the compatible to exynos7-adc.
>> Patch will be posted in a bit.
>>>
>>> Additionally,
>>> I have a question about Exynos7. If you possible,
>>> did you tell me about full name of Exynos7 SoC (e.g., Exynos5433, Exynos52..)?
>> The soc name is Exynos7 and it has 4 A57 cores.
>
> I wondered what is Exynos7. Thanks for your reply.

Exynos7 is a System-On-Chip that is based on 64-bit ARMv8 RISC
processor. As mentioned earlier, it has a Cortex-A57 quad core
configuration targeted towards high-performance applications.

I have posted v2 with your suggested modifications
(https://lkml.org/lkml/2014/11/1/2), kindly review.

Regards,
Abhilash

>
> Best Regards,
> Chanwoo Choi
>
>>>
>>> Best Regards,
>>> Chanwoo Choi
>>>
>>>>
>>>> Regards,
>>>> Abhilash
>>>>>
>>>>> Thanks,
>>>>> Chanwoo Choi
>>>>>
>>>>>
>>>>>
>>>>>>                       Must be "samsung,exynos3250-adc" for
>>>>>>                               controllers compatible with ADC of Exynos3250.
>>>>>>                       Must be "samsung,s3c2410-adc" for
>>>>>> diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
>>>>>> index fe03177..74d0a9d 100644
>>>>>> --- a/drivers/iio/adc/exynos_adc.c
>>>>>> +++ b/drivers/iio/adc/exynos_adc.c
>>>>>> @@ -390,6 +390,35 @@ static const struct exynos_adc_data exynos3250_adc_data = {
>>>>>>       .start_conv     = exynos_adc_v2_start_conv,
>>>>>>  };
>>>>>>
>>>>>> +static void exynos_adc_v3_init_hw(struct exynos_adc *info)
>>>>>> +{
>>>>>> +     u32 con1, con2;
>>>>>> +
>>>>>> +     if (info->data->needs_adc_phy)
>>>>>> +             regmap_write(info->pmu_map, info->data->phy_offset, 1);
>>>>>> +
>>>>>> +     con1 = ADC_V2_CON1_SOFT_RESET;
>>>>>> +     writel(con1, ADC_V2_CON1(info->regs));
>>>>>> +
>>>>>> +     con2 = readl(ADC_V2_CON2(info->regs));
>>>>>> +     con2 &= ~ADC_V2_CON2_C_TIME(7);
>>>>>> +     con2 |= ADC_V2_CON2_C_TIME(0);
>>>>>> +     writel(con2, ADC_V2_CON2(info->regs));
>>>>>> +
>>>>>> +     /* Enable interrupts */
>>>>>> +     writel(1, ADC_V2_INT_EN(info->regs));
>>>>>> +}
>>>>>> +
>>>>>> +static const struct exynos_adc_data exynos_adc_v3_data = {
>>>>>> +     .num_channels   = MAX_ADC_V1_CHANNELS,
>>>>>> +     .mask           = ADC_DATX_MASK, /* 12 bit ADC resolution */
>>>>>> +
>>>>>> +     .init_hw        = exynos_adc_v3_init_hw,
>>>>>> +     .exit_hw        = exynos_adc_v2_exit_hw,
>>>>>> +     .clear_irq      = exynos_adc_v2_clear_irq,
>>>>>> +     .start_conv     = exynos_adc_v2_start_conv,
>>>>>> +};
>>>>>> +
>>>>>>  static const struct of_device_id exynos_adc_match[] = {
>>>>>>       {
>>>>>>               .compatible = "samsung,s3c2410-adc",
>>>>>> @@ -413,6 +442,9 @@ static const struct of_device_id exynos_adc_match[] = {
>>>>>>               .compatible = "samsung,exynos-adc-v2",
>>>>>>               .data = &exynos_adc_v2_data,
>>>>>>       }, {
>>>>>> +             .compatible = "samsung,exynos-adc-v3",
>>>>>> +             .data = &exynos_adc_v3_data,
>>>>>> +     }, {
>>>>>>               .compatible = "samsung,exynos3250-adc",
>>>>>>               .data = &exynos3250_adc_data,
>>>>>>       },
>>>>>>
>>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
