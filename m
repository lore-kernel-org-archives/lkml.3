Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751457AbbABKUP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 05:20:15 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:21222 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbbABKUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 05:20:11 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-e5-54a670d921ba
Message-id: <54A670D6.3060100@samsung.com>
Date: Fri, 02 Jan 2015 11:20:06 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101
 Thunderbird/31.3.0
MIME-version: 1.0
To: amit daniel kachhap <amit.daniel@samsung.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Kukjin Kim <kgene@kernel.org>, Inki Dae <inki.dae@samsung.com>,
        Tobias Jakobi <Liquid.Acid@gmx.net>, Daniel Drake <drake@endlessm.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v2 2/7] ARM: Exynos: add support for sub-power domains
References: <1416814256-24288-3-git-send-email-a.hajda@samsung.com>
 <1417610024-29748-1-git-send-email-m.szyprowski@samsung.com>
 <CADGdYn5N-hw7P0+0Z4hZk33NeV30UR+h8joHfC1qSo_mRfzofg@mail.gmail.com>
In-reply-to: <CADGdYn5N-hw7P0+0Z4hZk33NeV30UR+h8joHfC1qSo_mRfzofg@mail.gmail.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLLMWRmVeSWpSXmKPExsVy+t/xK7o3C5aFGLzYzGlxa905VouGqyEW
	j+Y/ZrZ4dmsvk8Wk+xNYLPofv2a22PT4GqvF5V1z2CxmnN/HZNH18yebxaKtX9gtVu36w2hx
	fG24A6/Hou9ZHjtn3WX3WLxpP5vHplWdbB53ru1h8zh0uIPRY/OSeo++LasYPT5vkgvgjOKy
	SUnNySxLLdK3S+DKuL+bo2CbbMXyhzuYGhgPiHUxcnJICJhInN9yjhXCFpO4cG89WxcjF4eQ
	wFJGia+/37BAOJ8YJR68u8UIUsUroCXxbfccZhCbRUBV4mb/aXYQm03AUKLrbRcbiC0qECOx
	eOFqZoh6QYkfk++xgNgiAnESc3+dZQQZyizwmFni2JwusCJhAS+JRz8vsEJsO8koMbnrNliC
	UyBY4sGeVrD7mAXMJL68PAxly0tsXvOWeQKjwCwkS2YhKZuFpGwBI/MqRtHU0uSC4qT0XCO9
	4sTc4tK8dL3k/NxNjJAo+rqDcekxq0OMAhyMSjy8CteWhgixJpYVV+YeYpTgYFYS4e2TWxIi
	xJuSWFmVWpQfX1Sak1p8iJGJg1OqgfFSw1wzXfE2ltRfF24HM1dO1jxrpLv36ptjui9npXKK
	WDx5sPNccMK91NbTzLGa28Rdlp1frMtW92jKvZXL09dvaHQxlXuukiuTH35uubDIgtMnVHeH
	nHDVX+Mld/XmVq61y/782V5s+XfVd7VJ7rcuzAj6vMZtvVCZusYehgULDu3oe3DPSGq2Ektx
	RqKhFnNRcSIA1s3Be4ACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-12-04 04:45, amit daniel kachhap wrote:
> On Wed, Dec 3, 2014 at 6:03 PM, Marek Szyprowski
> <m.szyprowski@samsung.com> wrote:
>> This patch adds support for making one power domain a sub-domain of
>> other domain. This is useful for modeling power dependences for devices
>> like TV Mixer or Camera ISP, which needs to have more than one power
>> domain enabled to be operational.
>>
>> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
>> ---
>>   Documentation/devicetree/bindings/arm/exynos/power_domain.txt |  2 ++
>>   arch/arm/mach-exynos/pm_domains.c                             | 11 ++++++++++-
>>   2 files changed, 12 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/devicetree/bindings/arm/exynos/power_domain.txt b/Documentation/devicetree/bindings/arm/exynos/power_domain.txt
>> index abde1ea8a119..b884358ebb1a 100644
>> --- a/Documentation/devicetree/bindings/arm/exynos/power_domain.txt
>> +++ b/Documentation/devicetree/bindings/arm/exynos/power_domain.txt
>> @@ -22,6 +22,8 @@ Optional Properties:
>>          - pclkN, clkN: Pairs of parent of input clock and input clock to the
>>                  devices in this power domain. Maximum of 4 pairs (N = 0 to 3)
>>                  are supported currently.
>> +- samsung,power-domain: phandle to a master power domain that the given domain
>> +                      is a part of
>>
>>   Node of a device using power domains must have a samsung,power-domain property
>>   defined with a phandle to respective power domain.
>> diff --git a/arch/arm/mach-exynos/pm_domains.c b/arch/arm/mach-exynos/pm_domains.c
>> index 20f267121b3e..fa9a47ddad81 100644
>> --- a/arch/arm/mach-exynos/pm_domains.c
>> +++ b/arch/arm/mach-exynos/pm_domains.c
>> @@ -108,7 +108,7 @@ static int exynos_pd_power_off(struct generic_pm_domain *domain)
>>   static __init int exynos4_pm_init_power_domain(void)
>>   {
>>          struct platform_device *pdev;
>> -       struct device_node *np;
>> +       struct device_node *np, *master_np;
>>
>>          for_each_compatible_node(np, NULL, "samsung,exynos4210-pd") {
>>                  struct exynos_pm_domain *pd;
>> @@ -159,6 +159,15 @@ no_clk:
>>
>>                  pm_genpd_init(&pd->pd, NULL, !on);
>>                  of_genpd_add_provider_simple(np, &pd->pd);
>> +
>> +               /* make master and slave hierarchy */
>> +               master_np = of_parse_phandle(np, "samsung,power-domain", 0);
>> +               if (!master_np)
>> +                       master_np = of_parse_phandle(np, "power-domains", 0);
>> +               if (master_np) {
>> +                       pm_genpd_add_subdomain_names(master_np->name, np->name);
>> +                       of_node_put(master_np);
>> +               }
>>          }
> Hi Marek,
>
> In the my patch series posted earlier i added this feature in a
> slightly different way. (https://lkml.org/lkml/2014/11/24/320)
> Parent PD's are not added in the same loop but in the second loop.
> This will make sure that the parents PD are registered before the
> child PD's and we can get away from the assumption of child/parent
> PD's position in the Device Tree. This is a still a work in progress.
> Also posted a patch earlier regarding this,
> http://www.spinics.net/lists/linux-samsung-soc/msg39836.html.

Right, your approach seems to be more error prone. Do you plan to resend 
your
patch with the parent domain phandle renamed to generic 'power-domains' 
property,
like Geert suggested?

I would like to send Exynos4 HDMI patches based on top of your work and 
have them
finally merged (they are waiting since v3.17...)

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

