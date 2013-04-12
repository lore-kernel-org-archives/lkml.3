Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391Ab3DLLSs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 07:18:48 -0400
Received: from mail-ia0-f173.google.com ([209.85.210.173]:65113 "EHLO
	mail-ia0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819Ab3DLLSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 07:18:46 -0400
MIME-Version: 1.0
In-Reply-To: <51672304.2060600@ti.com>
References: <1364297642-2746-7-git-send-email-amit.daniel@samsung.com>
	<51672304.2060600@ti.com>
Date: Fri, 12 Apr 2013 16:48:45 +0530
X-Google-Sender-Auth: Qe55QtlckUBWXqKqllJOVQt7bLg
Message-ID: <CADGdYn7TzwYu4HAOLTSkpcj_fyGFNV5W_=-eGP6GWemTmM1D8w@mail.gmail.com>
Subject: Re: [6/9] thermal: exynos: small cleanups to prepare for adding
 exynos5440 driver
From: amit daniel kachhap <amit.daniel@samsung.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: linux-pm@vger.kernel.org, Thomas Abraham <thomas.abraham@linaro.org>,
        Zhang Rui <rui.zhang@intel.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eduardo,


On Fri, Apr 12, 2013 at 2:24 AM, Eduardo Valentin
<eduardo.valentin@ti.com> wrote:
> Amit,
>
>
> On 26-03-2013 07:33, Amit Daniel Kachhap wrote:
>>
>> Add calib mode, trigger types and trigger_enable array. This is needed
>> for adding exynos5440 TMU driver.
>>
>
> I dont think the above are small cleanups. I d rather split this patch into
> three, one per change and describe them properly.
Yes Right.
>
>
>> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
>>
>> ---
>> drivers/thermal/samsung/exynos4210_thermal.c |   30
>> ++++++++++++------------
>>   include/linux/platform_data/exynos_thermal.h |   32
>> +++++++++++++-------------
>>   2 files changed, 31 insertions(+), 31 deletions(-)
>>
>> diff --git a/drivers/thermal/samsung/exynos4210_thermal.c
>> b/drivers/thermal/samsung/exynos4210_thermal.c
>> index 09ea8c8..58d16ac 100644
>> --- a/drivers/thermal/samsung/exynos4210_thermal.c
>> +++ b/drivers/thermal/samsung/exynos4210_thermal.c
>> @@ -276,10 +276,10 @@ static void exynos_tmu_control(struct
>> platform_device *pdev, bool on)
>>
>>         if (on) {
>>                 con |= EXYNOS_TMU_CORE_ON;
>> -               interrupt_en = pdata->trigger_level3_en << 12 |
>> -                       pdata->trigger_level2_en << 8 |
>> -                       pdata->trigger_level1_en << 4 |
>> -                       pdata->trigger_level0_en;
>> +               interrupt_en = pdata->trigger_enable[3] << 12 |
>> +                       pdata->trigger_enable[2] << 8 |
>> +                       pdata->trigger_enable[1] << 4 |
>> +                       pdata->trigger_enable[0];
>>                 if (pdata->threshold_falling)
>>                         interrupt_en |= interrupt_en << 16;
>>         } else {
>> @@ -394,10 +394,10 @@ static struct exynos_tmu_platform_data const
>> exynos4210_default_tmu_data = {
>>         .trigger_levels[0] = 5,
>>         .trigger_levels[1] = 20,
>>         .trigger_levels[2] = 30,
>> -       .trigger_level0_en = 1,
>> -       .trigger_level1_en = 1,
>> -       .trigger_level2_en = 1,
>> -       .trigger_level3_en = 0,
>> +       .trigger_enable[0] = 1,
>> +       .trigger_enable[1] = 1,
>> +       .trigger_enable[2] = 1,
>> +       .trigger_enable[3] = 0,
>>         .gain = 15,
>>         .reference_voltage = 7,
>>         .cal_type = TYPE_ONE_POINT_TRIMMING,
>> @@ -423,10 +423,10 @@ static struct exynos_tmu_platform_data const
>> exynos_default_tmu_data = {
>>         .trigger_levels[0] = 85,
>>         .trigger_levels[1] = 103,
>>         .trigger_levels[2] = 110,
>> -       .trigger_level0_en = 1,
>> -       .trigger_level1_en = 1,
>> -       .trigger_level2_en = 1,
>> -       .trigger_level3_en = 0,
>> +       .trigger_enable[0] = 1,
>> +       .trigger_enable[1] = 1,
>> +       .trigger_enable[2] = 1,
>> +       .trigger_enable[3] = 0,
>>         .gain = 8,
>>         .reference_voltage = 16,
>>         .noise_cancel_mode = 4,
>> @@ -566,9 +566,9 @@ static int exynos_tmu_probe(struct platform_device
>> *pdev)
>>
>>         /* Register the sensor with thermal management interface */
>>         (&exynos_sensor_conf)->driver_data = data;
>> -       exynos_sensor_conf.trip_data.trip_count = pdata->trigger_level0_en
>> +
>> -                       pdata->trigger_level1_en +
>> pdata->trigger_level2_en +
>> -                       pdata->trigger_level3_en;
>> +       exynos_sensor_conf.trip_data.trip_count = pdata->trigger_enable[0]
>> +
>> +                       pdata->trigger_enable[1] +
>> pdata->trigger_enable[2] +
>> +                       pdata->trigger_enable[3];
>>
>>         for (i = 0; i < exynos_sensor_conf.trip_data.trip_count; i++)
>>                 exynos_sensor_conf.trip_data.trip_val[i] =
>> diff --git a/include/linux/platform_data/exynos_thermal.h
>> b/include/linux/platform_data/exynos_thermal.h
>> index 893b758..1090f48 100644
>> --- a/include/linux/platform_data/exynos_thermal.h
>> +++ b/include/linux/platform_data/exynos_thermal.h
>> @@ -31,6 +31,17 @@ enum calibration_type {
>>         TYPE_NONE,
>>   };
>>
>> +enum calibration_mode {
>> +       SW_MODE,
>> +       HW_MODE,
>> +};
>> +
>> +enum trigger_type {
>> +       ACTIVE,
>> +       CRITICAL,
>> +       HW_TRIP,
>> +};
>> +
>>   enum soc_type {
>>         SOC_ARCH_EXYNOS4210 = 1,
>>         SOC_ARCH_EXYNOS,
>> @@ -71,18 +82,9 @@ struct freq_clip_table {
>>    *    3: temperature for trigger_level3 interrupt
>>    *       condition for trigger_level3 interrupt:
>>    *            current temperature > threshold + trigger_levels[3]
>> - * @trigger_level0_en:
>> + * @trigger_enable[]: array to denote which trigger levels are enabled.
>>    *    1 = enable trigger_level0 interrupt,
>>    *    0 = disable trigger_level0 interrupt
>> - * @trigger_level1_en:
>> - *     1 = enable trigger_level1 interrupt,
>> - *     0 = disable trigger_level1 interrupt
>> - * @trigger_level2_en:
>> - *     1 = enable trigger_level2 interrupt,
>> - *     0 = disable trigger_level2 interrupt
>> - * @trigger_level3_en:
>> - *     1 = enable trigger_level3 interrupt,
>> - *     0 = disable trigger_level3 interrupt
>>    * @gain: gain of amplifier in the positive-TC generator block
>>    *    0 <= gain <= 15
>>    * @reference_voltage: reference voltage of amplifier
>> @@ -93,6 +95,7 @@ struct freq_clip_table {
>>    * @type: determines the type of SOC
>>    * @efuse_value: platform defined fuse value
>>    * @cal_type: calibration type for temperature
>> + * @cal_mode: calibration mode for temperature
>
>
> How about trigger_type?
will add. Thanks for the detailed review.
>
>>    * @freq_clip_table: Table representing frequency reduction percentage.
>>    * @freq_tab_count: Count of the above table as frequency reduction may
>>    *    applicable to only some of the trigger levels.
>> @@ -103,18 +106,15 @@ struct exynos_tmu_platform_data {
>>         u8 threshold;
>>         u8 threshold_falling;
>>         u8 trigger_levels[MAX_TRIP];
>> -       bool trigger_level0_en;
>> -       bool trigger_level1_en;
>> -       bool trigger_level2_en;
>> -       bool trigger_level3_en;
>> -       bool trigger_level4_en;
>> -
>> +       enum trigger_type trigger_type[MAX_TRIP];
>> +       bool trigger_enable[MAX_TRIP];
>>         u8 gain;
>>         u8 reference_voltage;
>>         u8 noise_cancel_mode;
>>         u32 efuse_value;
>>
>>         enum calibration_type cal_type;
>> +       enum calibration_mode cal_mode;
>>         enum soc_type type;
>>         struct freq_clip_table freq_tab[MAX_TRIP];
>>         unsigned int freq_tab_count;
>>
>
