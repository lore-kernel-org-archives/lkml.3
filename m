Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932795Ab3BSMeb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 07:34:31 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:35915 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932711Ab3BSMe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 07:34:28 -0500
MIME-Version: 1.0
In-Reply-To: <000501ce0e8a$91ef7c30$b5ce7490$%jun@samsung.com>
References: <1361210793-5710-1-git-send-email-tobetter@gmail.com>
	<000501ce0e8a$91ef7c30$b5ce7490$%jun@samsung.com>
Date: Tue, 19 Feb 2013 21:34:27 +0900
Message-ID: <CADoNuNc2cjOU-PjWgwtB2wo9USMABGdwP=udCBHBYO9jgiLnvw@mail.gmail.com>
Subject: Re: [PATCH v3] mmc: dw_mmc: Add MSHC compatible for Exynos4412
From: Dongjin Kim <tobetter@gmail.com>
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: "'unlisted-recipients:'"@samsung.com,
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

Hello Seungwon,

Thank you for reviewing and I understand what you mean.

I agree that Exynos5250 and Exynos4412 are not same, no idea how much
they are different because no Exynos5250 spec on my hand. But at least
I assumed that the capabilities below are supported by Exynos4412 in
terms of its datasheet and it does work on my end as expected. :) Also
I assumed it will be separated if one of both become different to add
more capabilities.

        MMC_CAP_UHS_DDR50 | MMC_CAP_1_8V_DDR |
               MMC_CAP_8_BIT_DATA | MMC_CAP_CMD23,

Maybe my understanding or approach is wrong since I do not have the
information of Exynos5250.
And suggestion do you have?

Regards,
Dongjin.

On Tue, Feb 19, 2013 at 7:19 PM, Seungwon Jeon <tgih.jun@samsung.com> wrote:
> On Tuesday, February 19, 2013, Dongjin Kim wrote:
>> This patch adds the compatible string for MSHC controller of Exynos4412, and
>> share the controller specific properties with Exynos5250 since they have same
>> features. Its driver data name is changed to exynos_drv_data instead SoC
>> specific name.
>
> It's not actually same.
> Exynos4412 doesn't have forward compatibilities for Exynos5250.
> I agree that functionality of exynos_drv_data is common.
> These functions have been implemented for existing Exynos*.
> But in case of caps, it can't applied completely.
> I'm concerning about this.
>
> Thanks,
> Seungwon Jeon
>>
>> Cc: Jaehoon Chung <jh80.chung@samsung.com>
>> Cc: Sachin Kamat <sachin.kamat@linaro.org>
>> Signed-off-by: Dongjin Kim <tobetter@gmail.com>
>> ---
>>  drivers/mmc/host/dw_mmc-exynos.c |   12 +++++++-----
>>  1 file changed, 7 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/mmc/host/dw_mmc-exynos.c b/drivers/mmc/host/dw_mmc-exynos.c
>> index 4d50da6..38cd03c 100644
>> --- a/drivers/mmc/host/dw_mmc-exynos.c
>> +++ b/drivers/mmc/host/dw_mmc-exynos.c
>> @@ -199,8 +199,8 @@ static int dw_mci_exynos_setup_bus(struct dw_mci *host,
>>       return 0;
>>  }
>>
>> -/* Exynos5250 controller specific capabilities */
>> -static unsigned long exynos5250_dwmmc_caps[4] = {
>> +/* Exynos4412/Exynos5250 controller specific capabilities */
>> +static unsigned long exynos_dwmmc_caps[4] = {
>>       MMC_CAP_UHS_DDR50 | MMC_CAP_1_8V_DDR |
>>               MMC_CAP_8_BIT_DATA | MMC_CAP_CMD23,
>>       MMC_CAP_CMD23,
>> @@ -208,8 +208,8 @@ static unsigned long exynos5250_dwmmc_caps[4] = {
>>       MMC_CAP_CMD23,
>>  };
>>
>> -static const struct dw_mci_drv_data exynos5250_drv_data = {
>> -     .caps                   = exynos5250_dwmmc_caps,
>> +static const struct dw_mci_drv_data exynos_drv_data = {
>> +     .caps                   = exynos_dwmmc_caps,
>>       .init                   = dw_mci_exynos_priv_init,
>>       .setup_clock            = dw_mci_exynos_setup_clock,
>>       .prepare_command        = dw_mci_exynos_prepare_command,
>> @@ -219,8 +219,10 @@ static const struct dw_mci_drv_data exynos5250_drv_data = {
>>  };
>>
>>  static const struct of_device_id dw_mci_exynos_match[] = {
>> +     { .compatible = "samsung,exynos4412-dw-mshc",
>> +                     .data = &exynos_drv_data, },
>>       { .compatible = "samsung,exynos5250-dw-mshc",
>> -                     .data = &exynos5250_drv_data, },
>> +                     .data = &exynos_drv_data, },
>>       {},
>>  };
>>  MODULE_DEVICE_TABLE(of, dw_mci_exynos_match);
>> --
>> 1.7.10.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
