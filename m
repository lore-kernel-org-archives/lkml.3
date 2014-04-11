Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755622AbaDKK4b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 06:56:31 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:51333 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbaDKK4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 06:56:25 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-cf-5347ca56f3cb
Message-id: <5347CA51.8020003@samsung.com>
Date: Fri, 11 Apr 2014 12:56:17 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: jic23@kernel.org, ch.naveen@samsung.com, kgene.kim@samsung.com,
        linux-iio@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] iio: adc: exynos_adc: Control special clock of ADC to
 support Exynos3250 ADC
References: <1397181640-18513-1-git-send-email-cw00.choi@samsung.com>
 <18632148.yOYlTYattA@amdc1032>
In-reply-to: <18632148.yOYlTYattA@amdc1032>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrALMWRmVeSWpSXmKPExsVy+t/xa7php9yDDRY2GltsnLGe1eLu88OM
	Fte/PGe1eNC0ismid8FVNouzTW/YLTY9vsZqMe/IOxaLy7vmsFnMOL+PyYHLY9OqTjaPzUvq
	Pfq2rGL0+LxJLoAlissmJTUnsyy1SN8ugSvj/cW3LAUvBSsOTjvM2sC4ha+LkZNDQsBEYv+h
	DUwQtpjEhXvr2boYuTiEBJYySkx5tJoZwvnMKHH8zXYgh4ODV0BL4thWfRCTRUBV4v2ESpBe
	NgE1ic8Nj9hAbH6gijVN11lAbFGBCIl7jYdZQWxeAUGJH5PvgcVFBBIkNm0/DLaLWeAro8ST
	78vAxgsLJEusvSAAUiMkkCZx834DE0iYU0Bb4uWMapAws4C1xMpJ2xghbHmJzWveMk9gFJyF
	ZMMsJGWzkJQtYGRexSiaWppcUJyUnmukV5yYW1yal66XnJ+7iRESC193MC49ZnWIUYCDUYmH
	98Alt2Ah1sSy4srcQ4wSHMxKIrzme92DhXhTEiurUovy44tKc1KLDzEycXBKNTCK75W127yr
	4OHyBa0JnvKuHidP/D+ybrMum/PVcJ5uo6rCw82b+rcotcmpxATofjJpaAu+anBU/FP9kzMJ
	Xq5ZZyauzwtlE86TmHH+oauBw27d9SsYlJ1XvVAp3PBk64o5bglf5k/l437Kv2HxKk3O/s4p
	kRvPyvxcOfPMS5frv3LjT/DJTbBXYinOSDTUYi4qTgQAPm9FnWMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 11.04.2014 11:41, Bartlomiej Zolnierkiewicz wrote:
>
> Hi,
>
> On Friday, April 11, 2014 11:00:40 AM Chanwoo Choi wrote:
>> This patch control special clock for ADC in Exynos series's FSYS block.
>
> s/control/controls/
>
>> If special clock of ADC is registerd on clock list of common clk framework,
>> Exynos ADC drvier have to control this clock.
>
> s/drvier/driver/
>
>> Exynos3250/Exynos4/Exynos5 has 'adc' clock as following:
>> - 'adc' clock: bus clock for ADC
>>
>> Exynos3250 has additional 'sclk_tsadc' clock as following:
>> - 'sclk_tsadc' clock: special clock for ADC which provide clock to internal ADC
>>
>> Exynos 4210/4212/4412 and Exynos5250/5420 has not included 'sclk_tsadc' clock
>> in FSYS_BLK. But, Exynos3250 based on Cortex-A7 has only included 'sclk_tsadc'
>> clock in FSYS_BLK.
>>
>> Cc: Jonathan Cameron <jic23@kernel.org>
>> Cc: Kukjin Kim <kgene.kim@samsung.com>
>> Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
>> Cc: linux-iio@vger.kernel.org
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>   drivers/iio/adc/exynos_adc.c | 13 +++++++++++++
>>   1 file changed, 13 insertions(+)

This change alters DT bindings for Exynos ADC, so documentation must be 
modified appropriately.

>>
>> diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
>> index d25b262..4cd1975 100644
>> --- a/drivers/iio/adc/exynos_adc.c
>> +++ b/drivers/iio/adc/exynos_adc.c
>> @@ -88,6 +88,7 @@ struct exynos_adc {
>>   	void __iomem		*regs;
>>   	void __iomem		*enable_reg;
>>   	struct clk		*clk;
>> +	struct clk		*sclk;
>>   	unsigned int		irq;
>>   	struct regulator	*vdd;
>>
>> @@ -308,6 +309,13 @@ static int exynos_adc_probe(struct platform_device *pdev)
>>   		goto err_irq;
>>   	}
>>
>> +	info->sclk = devm_clk_get(&pdev->dev, "sclk_tsadc");
>> +	if (IS_ERR(info->sclk)) {
>> +		dev_warn(&pdev->dev, "failed getting sclk clock, err = %ld\n",
>> +							PTR_ERR(info->sclk));
>> +		info->sclk = NULL;
>> +	}
>> +

Is there any reason why we should have a warning on SoCs which don't 
have this clock? I think this clock should be acquired only for affected 
SoCs.

Best regards,
Tomasz
