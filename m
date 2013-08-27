Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab3H0MVb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 08:21:31 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:16249 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069Ab3H0MV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 08:21:29 -0400
MIME-version: 1.0
Content-type: text/plain; charset=windows-1252; format=flowed
X-AuditID: cbfec7f5-b7ef66d00000795a-14-521c99c64ac7
Content-transfer-encoding: 8BIT
Message-id: <521C99C5.3080401@partner.samsung.com>
Date: Tue, 27 Aug 2013 14:21:25 +0200
From: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803
 Thunderbird/17.0.8
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linus.walleij@linaro.org, t.figa@samsung.com, thomas.abraham@linaro.org,
        kgene.kim@samsung.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH 1/4] pinctrl: Add s5pv210 support to pinctrl-exynos
References: <1377595171-31116-1-git-send-email-m.krawczuk@partner.samsung.com>
 <521C71A1.4070609@samsung.com>
In-reply-to: <521C71A1.4070609@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFLMWRmVeSWpSXmKPExsVy+t/xq7rHZsoEGTybZmrRu+Aqm8WUP8uZ
	LDY9vsZqcXnXHDaLGef3MVkcftPOarF+xmsWi2MzljA6cHjcubaHzWPzknqPvi2rGD0+b5IL
	YInisklJzcksSy3St0vgyni+Yx9TwWKeihkXfzM1MC7i6mLk5JAQMJHYPOkrO4QtJnHh3nq2
	LkYuDiGBpYwSLzu7WEESvAKCEj8m32PpYuTgYBaQlzhyKRskzCxgK7Hg/ToWiPqPjBI3jpxk
	gag3kpj1/wAjiM0ioCoxf/1PMJtNwFxi4rNNYDWiAhESK5c8AJsvIqAvsWTVRbDFzAJnGSVe
	re8AWyYs4C5x6mMtSI2QQL7EgpYN7CBhTgFtiaOz4icwCsxCct0shOtmIbluASPzKkbR1NLk
	guKk9FwjveLE3OLSvHS95PzcTYyQ8P66g3HpMatDjAIcjEo8vA9bpIOEWBPLiitzDzFKcDAr
	ifBObZYJEuJNSaysSi3Kjy8qzUktPsTIxMEp1cDYcPsFM49EmM7loBPP9Venyr68xFBYEM2p
	V7vOVkLKqn6iYit3ofqeRVs3VxUp2OYpTeuZLb91XcxRRq4HWmz3L8bs+nJivxHPSbsLbX1m
	N3dF+Adve39X9+8Dvx3M879dvHKlveKC7XabHHXhY3c+PxcM7fo8bduEeY+nr3q/dvKyqjpp
	/oMXlFiKMxINtZiLihMBKsDcm00CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2013 11:30 AM, Sylwester Nawrocki wrote:
> Hi,
>
> Just a few nits...
>
> On 08/27/2013 11:19 AM, Mateusz Krawczuk wrote:
>> This patch implements pinctrl for s5pv210 and adds required device tree bindings.
> Would be good to wrap this to not exceed 80 columns.
>
>> Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
>> ---
> [...]
>> diff --git a/drivers/pinctrl/pinctrl-exynos.c b/drivers/pinctrl/pinctrl-exynos.c
>> index a74b3cb..fc3e1d7 100644
>> --- a/drivers/pinctrl/pinctrl-exynos.c
>> +++ b/drivers/pinctrl/pinctrl-exynos.c
>> @@ -660,6 +660,64 @@ static void exynos_pinctrl_resume(struct samsung_pinctrl_drv_data *drvdata)
>>   			exynos_pinctrl_resume_bank(drvdata, bank);
>>   }
>>   
>> +/* pin banks of s5pv210 pin-controller */
>> +static struct samsung_pin_bank s5pv210_pin_banks0[] = {
> Couldn't it be 'static const' ?
Using static const cause warning: initialization discards ‘const’ 
qualifier from pointer target type
>
>> +	EXYNOS_PIN_BANK_EINTG(8, 0x000, "gpa0", 0x00),
>> +	EXYNOS_PIN_BANK_EINTG(6, 0x020, "gpa1", 0x04),
>> +	EXYNOS_PIN_BANK_EINTG(8, 0x040, "gpb", 0x08),
>> +	EXYNOS_PIN_BANK_EINTG(5, 0x060, "gpc0", 0x0c),
>> +	EXYNOS_PIN_BANK_EINTG(5, 0x080, "gpc1", 0x10),
>> +	EXYNOS_PIN_BANK_EINTG(4, 0x0A0, "gpd0", 0x14),
>> +	EXYNOS_PIN_BANK_EINTG(4, 0x0C0, "gpd1", 0x18),
>> +	EXYNOS_PIN_BANK_EINTG(5, 0x0E0, "gpe0", 0x1c),
> How about consistently using lower case for the hex numbers ?
Thanks, I will use lower case.
>
> --
> Thanks,
> Sylwester
>
Best regards,
Mateusz
