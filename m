Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443AbaJMLOD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 07:14:03 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:40934 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204AbaJMLOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 07:14:00 -0400
Message-ID: <543BB3CD.7040001@ti.com>
Date: Mon, 13 Oct 2014 14:13:17 +0300
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Kevin Hilman <khilman@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kevin Hilman <khilman@linaro.org>
CC: Geert Uytterhoeven <geert+renesas@glider.be>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, <grant.likely@secretlab.ca>,
        <ulf.hansson@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v1 2/4] ARM: keystone: pm: switch to use generic pm domains
References: <1412001499-19369-1-git-send-email-grygorii.strashko@ti.com>	<1412001499-19369-3-git-send-email-grygorii.strashko@ti.com> <CAMAWPa-sKGu_o0CDLCk_uKofxwOjXiiFBedjEP=OhQFmo+ehCA@mail.gmail.com>
In-Reply-To: <CAMAWPa-sKGu_o0CDLCk_uKofxwOjXiiFBedjEP=OhQFmo+ehCA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2014 03:56 PM, Kevin Hilman wrote:
> Hi Grygorii,
>
> On 9/29/14 7:38 AM, Grygorii Strashko wrote:
>> This patch switches Keystone 2 PM code to use Generic PM domains
>> instead of PM clock domains because of the lack of DT support
>> for the last.
>>
>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>
> IMO, this approach is much better.
>
> One minor nit below...
>
>> diff --git a/arch/arm/mach-keystone/pm_domain.c b/arch/arm/mach-keystone/pm_domain.c
>> index ca79dda..3eb5257 100644
>> --- a/arch/arm/mach-keystone/pm_domain.c
>> +++ b/arch/arm/mach-keystone/pm_domain.c
>> @@ -12,69 +12,110 @@
>>    * version 2, as published by the Free Software Foundation.
>>    */
>>
>> +#include <linux/clk.h>
>>   #include <linux/init.h>
>> -#include <linux/pm_runtime.h>
>>   #include <linux/pm_clock.h>
>> +#include <linux/pm_domain.h>
>>   #include <linux/platform_device.h>
>> -#include <linux/clk-provider.h>
>>   #include <linux/of.h>
>>
>> -#ifdef CONFIG_PM_RUNTIME
>> -static int keystone_pm_runtime_suspend(struct device *dev)
>> +#ifdef CONFIG_PM_GENERIC_DOMAINS
>> +
>> +struct keystone_domain {
>> + struct generic_pm_domain base;
>> + struct device *dev;
>> +};
>
> I think the name 'base' for this field leads to confusion later in the
> code, since base usually means something else in drivers.  How about
> 'genpd'?

Agree. I'll change it.

Thanks for your comments.

Regards,
-grygorii
