Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758680Ab3BSQtE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 11:49:04 -0500
Received: from mail-ve0-f173.google.com ([209.85.128.173]:43738 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758479Ab3BSQtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 11:49:01 -0500
X-Greylist: delayed 467 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Feb 2013 11:49:01 EST
MIME-Version: 1.0
In-Reply-To: <CADoNuNc2cjOU-PjWgwtB2wo9USMABGdwP=udCBHBYO9jgiLnvw@mail.gmail.com>
References: <1361210793-5710-1-git-send-email-tobetter@gmail.com>
 <000501ce0e8a$91ef7c30$b5ce7490$%jun@samsung.com> <CADoNuNc2cjOU-PjWgwtB2wo9USMABGdwP=udCBHBYO9jgiLnvw@mail.gmail.com>
From: Alim Akhtar <alim.akhtar@gmail.com>
Date: Tue, 19 Feb 2013 22:10:32 +0530
Message-ID: <CAGOxZ51YtUL1yOJERLZG7uWgfQ=j88HmYue1oWiuah6Gdr32Eg@mail.gmail.com>
Subject: Re: [PATCH v3] mmc: dw_mmc: Add MSHC compatible for Exynos4412
To: Dongjin Kim <tobetter@gmail.com>
Cc: Seungwon Jeon <tgih.jun@samsung.com>, "'unlisted-recipients:'"@samsung.com,
        "'no To-header on input'"@samsung.com,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>, Chris Ball <cjb@laptop.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Will Newton <will.newton@imgtec.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Feb 19, 2013 at 6:04 PM, Dongjin Kim <tobetter@gmail.com> wrote:
> Hello Seungwon,
>
> Thank you for reviewing and I understand what you mean.
>
> I agree that Exynos5250 and Exynos4412 are not same, no idea how much
> they are different because no Exynos5250 spec on my hand. But at least
> I assumed that the capabilities below are supported by Exynos4412 in
> terms of its datasheet and it does work on my end as expected. :) Also
> I assumed it will be separated if one of both become different to add
> more capabilities.
>
>         MMC_CAP_UHS_DDR50 | MMC_CAP_1_8V_DDR |
>                MMC_CAP_8_BIT_DATA | MMC_CAP_CMD23,
>
> Maybe my understanding or approach is wrong since I do not have the
> information of Exynos5250.
> And suggestion do you have?

Recently Guennadi Liakhovetski has done some work to centralize the
mmc capabilities. See [1] and [2].
Those patches are pushed to Chris's mmc-next tree.
Is  it possible to extend [1] and [2] and add more capabilities (at
least all known one) and let these caps being passed from DT instead?

Second thought is, let the common minimum caps as a part of .caps
field in dw_mmc-exynos.c itself and pass the extra/advance controller
caps from DT and parse them via dw_mci_parse_dt() in dw_mmc.c itself.

[1] https://patchwork.kernel.org/patch/1991851/
[2] https://patchwork.kernel.org/patch/2106531/

> Regards,
> Dongjin.
>
> On Tue, Feb 19, 2013 at 7:19 PM, Seungwon Jeon <tgih.jun@samsung.com> wrote:
>> On Tuesday, February 19, 2013, Dongjin Kim wrote:
>>> This patch adds the compatible string for MSHC controller of Exynos4412, and
>>> share the controller specific properties with Exynos5250 since they have same
>>> features. Its driver data name is changed to exynos_drv_data instead SoC
>>> specific name.
>>
>> It's not actually same.
>> Exynos4412 doesn't have forward compatibilities for Exynos5250.
>> I agree that functionality of exynos_drv_data is common.
>> These functions have been implemented for existing Exynos*.
>> But in case of caps, it can't applied completely.
>> I'm concerning about this.
>>
>> Thanks,
>> Seungwon Jeon
>>>
>>> Cc: Jaehoon Chung <jh80.chung@samsung.com>
>>> Cc: Sachin Kamat <sachin.kamat@linaro.org>
>>> Signed-off-by: Dongjin Kim <tobetter@gmail.com>
>>> ---
>>>  drivers/mmc/host/dw_mmc-exynos.c |   12 +++++++-----
>>>  1 file changed, 7 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/drivers/mmc/host/dw_mmc-exynos.c b/drivers/mmc/host/dw_mmc-exynos.c
>>> index 4d50da6..38cd03c 100644
>>> --- a/drivers/mmc/host/dw_mmc-exynos.c
>>> +++ b/drivers/mmc/host/dw_mmc-exynos.c
>>> @@ -199,8 +199,8 @@ static int dw_mci_exynos_setup_bus(struct dw_mci *host,
>>>       return 0;
>>>  }
>>>
>>> -/* Exynos5250 controller specific capabilities */
>>> -static unsigned long exynos5250_dwmmc_caps[4] = {
>>> +/* Exynos4412/Exynos5250 controller specific capabilities */
>>> +static unsigned long exynos_dwmmc_caps[4] = {
>>>       MMC_CAP_UHS_DDR50 | MMC_CAP_1_8V_DDR |
>>>               MMC_CAP_8_BIT_DATA | MMC_CAP_CMD23,
>>>       MMC_CAP_CMD23,
>>> @@ -208,8 +208,8 @@ static unsigned long exynos5250_dwmmc_caps[4] = {
>>>       MMC_CAP_CMD23,
>>>  };
>>>
>>> -static const struct dw_mci_drv_data exynos5250_drv_data = {
>>> -     .caps                   = exynos5250_dwmmc_caps,
>>> +static const struct dw_mci_drv_data exynos_drv_data = {
>>> +     .caps                   = exynos_dwmmc_caps,
>>>       .init                   = dw_mci_exynos_priv_init,
>>>       .setup_clock            = dw_mci_exynos_setup_clock,
>>>       .prepare_command        = dw_mci_exynos_prepare_command,
>>> @@ -219,8 +219,10 @@ static const struct dw_mci_drv_data exynos5250_drv_data = {
>>>  };
>>>
>>>  static const struct of_device_id dw_mci_exynos_match[] = {
>>> +     { .compatible = "samsung,exynos4412-dw-mshc",
>>> +                     .data = &exynos_drv_data, },
>>>       { .compatible = "samsung,exynos5250-dw-mshc",
>>> -                     .data = &exynos5250_drv_data, },
>>> +                     .data = &exynos_drv_data, },
>>>       {},
>>>  };
>>>  MODULE_DEVICE_TABLE(of, dw_mci_exynos_match);
>>> --
>>> 1.7.10.4
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Regards,
Alim
