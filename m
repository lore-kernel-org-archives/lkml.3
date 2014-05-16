Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751741AbaEPEBl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 00:01:41 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:44019 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbaEPEBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 00:01:40 -0400
MIME-Version: 1.0
In-Reply-To: <5375311B.2010202@gmail.com>
References: <ANuQgHGSPJ45tbrVppAVpOqF0OfHacPWfX=S5mOVxTPr66f7vg@mail.gmail.com>
	<1400054637-21505-1-git-send-email-chander.kashyap@linaro.org>
	<1400054637-21505-6-git-send-email-chander.kashyap@linaro.org>
	<5375311B.2010202@gmail.com>
Date: Fri, 16 May 2014 09:31:38 +0530
Message-ID: <CANuQgHGSA+R__raSa_tzrgpceqLD2SZw+s0XQUHGF4wscgh6Kg@mail.gmail.com>
Subject: Re: [PATCH v5 5/6] exynos: cpuidle: do not allow cpuidle registration
 for Exynos5420
From: Chander Kashyap <chander.kashyap@linaro.org>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Chander Kashyap <k.chander@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

On 16 May 2014 02:56, Tomasz Figa <tomasz.figa@gmail.com> wrote:
> Hi Chander,
>
> On 14.05.2014 10:03, Chander Kashyap wrote:
>> Exynos5420 is big.Little Soc. It uses cpuidle-big-litle generic cpuidle driver.
>> Hence do not allow exynos cpuidle driver registration for Exynos5420.
>>
>> Signed-off-by: Chander Kashyap <chander.kashyap@linaro.org>
>> Signed-off-by: Chander Kashyap <k.chander@samsung.com>
>> Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
>> ---
>>  arch/arm/mach-exynos/cpuidle.c |    3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/arch/arm/mach-exynos/cpuidle.c b/arch/arm/mach-exynos/cpuidle.c
>> index 3dd385e..807a386 100644
>> --- a/arch/arm/mach-exynos/cpuidle.c
>> +++ b/arch/arm/mach-exynos/cpuidle.c
>> @@ -218,6 +218,9 @@ static int exynos_cpuidle_probe(struct platform_device *pdev)
>>       int cpu_id, ret;
>>       struct cpuidle_device *device;
>>
>> +     if (soc_is_exynos5420())
>> +             return -ENODEV;
>> +
>>       if (soc_is_exynos5250())
>>               exynos5_core_down_clk();
>>
>>
>
> Why not put this in exynos.c in exynos_dt_machine_init(), so
> exynos_cpuidle_init() is called only if not running on Exynos5420?
>

That makes more sense.
I will update this

Thanks
> Best regards,
> Tomasz



-- 
with warm regards,
Chander Kashyap
