Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589AbaEILrh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 07:47:37 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:39813 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755884AbaEILrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 07:47:35 -0400
Message-ID: <536CC052.3080806@linaro.org>
Date: Fri, 09 May 2014 17:17:30 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: rui.zhang@intel.com, eduardo.valentin@ti.com
CC: Amit Kachhap <amit.kachhap@gmail.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH] thermal: samsung: Only update available threshold limits
References: <1397453895-6688-1-git-send-email-tushar.behera@linaro.org> <CADGdYn719UzdPd3fVWrPi=mTnKvKy3O5bPHZcn8xCFjrAWp7yA@mail.gmail.com>
In-Reply-To: <CADGdYn719UzdPd3fVWrPi=mTnKvKy3O5bPHZcn8xCFjrAWp7yA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2014 11:48 AM, Amit Kachhap wrote:
> On 4/14/14, Tushar Behera <tushar.behera@linaro.org> wrote:
>> Currently the threshold limits are updated in 2 stages, once for all
>> software trigger levels and again for hardware trip point.
> I guess the first stage is bootloader as could not find this in this file.
> Anyways the changes looks fine to me.
> 
> Acked-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
> 

Can this the patch be merged now?

>>
>> While updating the software trigger levels, it overwrites the threshold
>> limit for hardware trip point thereby forcing the Exynos core to issue
>> an emergency shutdown.
>>
>> Updating only the required fields in threshold register fixes this issue.
>>
>> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
>> ---
>> Based on v3.15-rc1.
>>
>>  drivers/thermal/samsung/exynos_tmu.c |    4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/drivers/thermal/samsung/exynos_tmu.c
>> b/drivers/thermal/samsung/exynos_tmu.c
>> index 0d96a51..ffccc89 100644
>> --- a/drivers/thermal/samsung/exynos_tmu.c
>> +++ b/drivers/thermal/samsung/exynos_tmu.c
>> @@ -225,6 +225,8 @@ skip_calib_data:
>>  			trigger_levs++;
>>  	}
>>
>> +	rising_threshold = readl(data->base + reg->threshold_th0);
>> +
>>  	if (data->soc == SOC_ARCH_EXYNOS4210) {
>>  		/* Write temperature code for threshold */
>>  		threshold_code = temp_to_code(data, pdata->threshold);
>> @@ -249,6 +251,7 @@ skip_calib_data:
>>  				ret = threshold_code;
>>  				goto out;
>>  			}
>> +			rising_threshold &= ~(0xff << 8 * i);
>>  			rising_threshold |= threshold_code << 8 * i;
>>  			if (pdata->threshold_falling) {
>>  				threshold_code = temp_to_code(data,
>> @@ -281,6 +284,7 @@ skip_calib_data:
>>  			}
>>  			if (i == EXYNOS_MAX_TRIGGER_PER_REG - 1) {
>>  				/* 1-4 level to be assigned in th0 reg */
>> +				rising_threshold &= ~(0xff << 8 * i);
>>  				rising_threshold |= threshold_code << 8 * i;
>>  				writel(rising_threshold,
>>  					data->base + reg->threshold_th0);
>> --
>> 1.7.9.5
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc"
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>


-- 
Tushar Behera
