Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600Ab3IWMAn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 08:00:43 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:43369 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988Ab3IWMAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 08:00:42 -0400
MIME-Version: 1.0
In-Reply-To: <2060959.cLD86Prq58@amdc1227>
References: <1379309482-19779-1-git-send-email-chander.kashyap@linaro.org>
	<2060959.cLD86Prq58@amdc1227>
Date: Mon, 23 Sep 2013 17:30:37 +0530
Message-ID: <CANuQgHErO4VmjNfM4dB-zMq7=6kUxAUgUcsTXeD0sG4K9S0qhg@mail.gmail.com>
Subject: Re: [PATCH] irqchip: exynos-combiner: remove hard-coded irq_base value
From: Chander Kashyap <chander.kashyap@linaro.org>
To: Tomasz Figa <t.figa@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>, tglx@linutronix.de,
        "thomas.ab@samsung.com" <thomas.ab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 September 2013 18:07, Tomasz Figa <t.figa@samsung.com> wrote:
> Hi Chander,
>
> On Monday 16 of September 2013 11:01:22 Chander Kashyap wrote:
>> Pass '0' in place of hardcoded "irq_base" value as "first_irq" parameter
>> to "irq_domain_add_simple" in order to use linear irq domain.
>>
>> Signed-off-by: Chander Kashyap <chander.kashyap@linaro.org>
>> ---
>>  drivers/irqchip/exynos-combiner.c |   15 +++------------
>>  1 file changed, 3 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/irqchip/exynos-combiner.c
>> b/drivers/irqchip/exynos-combiner.c index 4c68265..b4ed356 100644
>> --- a/drivers/irqchip/exynos-combiner.c
>> +++ b/drivers/irqchip/exynos-combiner.c
>> @@ -206,8 +206,7 @@ static unsigned int combiner_lookup_irq(int group)
>>
>>  static void __init combiner_init(void __iomem *combiner_base,
>>                                struct device_node *np,
>> -                              unsigned int max_nr,
>> -                              int irq_base)
>> +                              unsigned int max_nr)
>>  {
>>       int i, irq;
>>       unsigned int nr_irq;
>> @@ -221,7 +220,7 @@ static void __init combiner_init(void __iomem
>> *combiner_base, return;
>>       }
>>
>> -     combiner_irq_domain = irq_domain_add_simple(np, nr_irq, irq_base,
>> +     combiner_irq_domain = irq_domain_add_simple(np, nr_irq, 0,
>>                               &combiner_irq_domain_ops, combiner_data);
>
> I believe you can safely go with calling irq_domain_add_linear() directly
> here.

Yes, I will replace the call and resend the patch.

thanks
>
> Otherwise the patch looks good.
>
> Best regards,
> Tomasz
>



-- 
with warm regards,
Chander Kashyap
