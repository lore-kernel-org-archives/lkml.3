Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072Ab3KGPMV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 10:12:21 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:50337 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010Ab3KGPMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 10:12:18 -0500
MIME-Version: 1.0
In-Reply-To: <1695605.pk9l7dqkqm@amdc1227>
References: <1383828154-428-1-git-send-email-ch.naveen@samsung.com> <1695605.pk9l7dqkqm@amdc1227>
From: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Date: Thu, 7 Nov 2013 20:41:57 +0530
Message-ID: <CAHfPSqDrkn5nPfP17bMRQUQTHSc48nGXu4_+XVBBixfx+Wvj5g@mail.gmail.com>
Subject: Re: [PATCH] thermal: exynos: handle gate clock for misplaced TRIMINFO register
To: Tomasz Figa <t.figa@samsung.com>
Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>, linux-pm@vger.kernel.org,
        rui.zhang@intel.com, eduardo.valentin@ti.com,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, amit.daniel@samsung.com,
        Kukjin Kim <kgene.kim@samsung.com>, devicetree@vger.kernel.org,
        b.zolnierkie@samsung.com, cpgs@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 November 2013 19:48, Tomasz Figa <t.figa@samsung.com> wrote:
> Hi Naveen,
>
> On Thursday 07 of November 2013 18:12:34 Naveen Krishna Chatradhi wrote:
>> On Exynos5420 the TMU(4) for GPU has a seperate clock enable bit from
>> the other TMU channels(0 ~ 3). Hence, accessing TRIMINFO for base_second
>> should be acompanied by enabling the respective clock.
>>
>> This patch which allow for a "clk_sec" clock to be specified in the
>> device-tree which will be ungated when accessing the TRIMINFO register.
>>
>> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
>> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
>> ---
>>  drivers/thermal/samsung/exynos_tmu.c |   24 +++++++++++++++++++++++-
>>  1 file changed, 23 insertions(+), 1 deletion(-)
>
> This patch modifies the device binding, but fails to mention anything
> about the modification in respective documentation. Please do not do that.
Will make a note to update Documentation from now on.

>
> In addition, since the series adding support for Exynos 5420 has not been
> merged yet, I would rather make this patch a part of that series.
Will merge and upload the whole set, first thing tomorrow.
>
> Also please see my comment below.
>
>> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
>> index b54825a..33edd1a 100644
>> --- a/drivers/thermal/samsung/exynos_tmu.c
>> +++ b/drivers/thermal/samsung/exynos_tmu.c
> [snip]
>> @@ -641,6 +650,15 @@ static int exynos_tmu_probe(struct platform_device *pdev)
>>       if (ret)
>>               return ret;
>>
>> +     data->clk_sec = devm_clk_get(&pdev->dev, "tmu_apbif_sec");
>> +     if (!IS_ERR(data->clk_sec)) {
>
> This code does not check if the clock was specified for TMU channels that
> require it, i.e. the driver will not fail if you don't specify this clock.
I thought of making it mandatory, And TMU on Exynos5440 may not need
second clock for accessing the second base. I Will confirm with the Exynso5440
specs and update accordingly.
>
> Instead, it would be better create a separate compatible value for such
> channels, like "samsung,exynos5420-tmu-broken-triminfo", for which this
> clock would be mandatory and for which, if this clock is not specified,
> the driver would fail.
Right

Sure Tomasz,
Creating a new compatible makes handling this case really simple

Thanks for reviewing.
>
> Best regards,
> Tomasz
>



-- 
Shine bright,
(: Nav :)
