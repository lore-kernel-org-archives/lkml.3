Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751366AbaDZDj4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 23:39:56 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:47325 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbaDZDjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 23:39:55 -0400
MIME-Version: 1.0
In-Reply-To: <535AD177.3030700@gmail.com>
References: <1396425058-4012-1-git-send-email-pankaj.dubey@samsung.com>
 <1398429166-5539-1-git-send-email-pankaj.dubey@samsung.com>
 <1398429166-5539-6-git-send-email-pankaj.dubey@samsung.com> <535AD177.3030700@gmail.com>
From: Pankaj Dubey <pankaj.dubey@samsung.com>
Date: Sat, 26 Apr 2014 12:39:33 +0900
X-Google-Sender-Auth: CnXZhTvPZHtPhOC_IVyYSNhmz3U
Message-ID: <CAGcde9GkJCRcaA9LEso6j3STQ3Qnh6Y_waq1R1fSU6ZAB+79_w@mail.gmail.com>
Subject: Re: [PATCH v2 05/10] ARM: EXYNOS: Remove regs-pmu.h header dependency
 from pm_domain
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kukjin Kim <kgene.kim@samsung.com>, linux@arm.linux.org.uk,
        Tomasz Figa <t.figa@samsung.com>, chow.kim@samsung.com,
        Young-Gun Jang <yg1004.jang@samsung.com>, vikas.sajjan@samsung.com,
        s.nawrocki@samsung.com, b.zolnierkie@samsung.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI Tomasz,


On Sat, Apr 26, 2014 at 6:19 AM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
> Hi,
>
>
> On 25.04.2014 14:32, Pankaj Dubey wrote:
>>
>> From: Young-Gun Jang <yg1004.jang@samsung.com>
>>
>> Current "pm_domain.c" file uses "S5P_INT_LOCAL_PWR_EN" definition from
>> "regs-pmu.h" and hence needs to include this header file. As there is
>> no other user of "S5P_INT_LOCAL_PWR_EN" definition other than pm_domain,
>> to remove "regs-pmu.h" header file dependency from "pm_domain.c"  it's
>> better we define this definition in "pm_domain.c" file itself and thus it
>> will help in removing header file inclusion from "pm_domain.c".
>>
>> Signed-off-by: Young-Gun Jang <yg1004.jang@samsung.com>
>> ---
>>   arch/arm/mach-exynos/pm_domains.c |    2 +-
>>   arch/arm/mach-exynos/regs-pmu.h   |    1 -
>>   2 files changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/arch/arm/mach-exynos/pm_domains.c
>> b/arch/arm/mach-exynos/pm_domains.c
>> index fe6570e..f676b0a 100644
>> --- a/arch/arm/mach-exynos/pm_domains.c
>> +++ b/arch/arm/mach-exynos/pm_domains.c
>> @@ -22,7 +22,7 @@
>>   #include <linux/of_platform.h>
>>   #include <linux/sched.h>
>>
>> -#include "regs-pmu.h"
>> +#define S5P_INT_LOCAL_PWR_EN 0x7
>
>
> nit: You could indent the value a bit more in case of adding any new macros
> in future. While at it, you could probably also drop the S5P_ prefix.
>

Thanks for review.
Will take care of both suggestions.

Thanks,
Pankaj Dubey

> With these fixed, feel free to add my
>
> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
>
> Best regards,
> Tomasz
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
