Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361AbaDNL7P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 07:59:15 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:62523 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755171AbaDNL7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 07:59:10 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-1e-534bcd8a5bf3
Message-id: <534BCD88.4020108@samsung.com>
Date: Mon, 14 Apr 2014 15:59:04 +0400
From: Tarek Dakhran <t.dakhran@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Heiko Stuebner <heiko@sntech.de>, linux-doc@vger.kernel.org,
        Tomasz Figa <t.figa@samsung.com>,
        Chander Kashyap <chander.kashyap@linaro.org>,
        Romain Naour <romain.naour@openwide.fr>,
        Tarek Dakhran <t.dakhran@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Abraham <thomas.abraham@linaro.org>, devicetree@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-samsung-soc@vger.kernel.org,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>,
        Ben Dooks <ben-linux@fluff.org>,
        Mike Turquette <mturquette@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Rob Landley <rob@landley.net>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH v8 1/3] ARM: EXYNOS: Add support for EXYNOS5410 SoC
References: <1397459860-21869-1-git-send-email-t.dakhran@samsung.com>
 <1397459860-21869-2-git-send-email-t.dakhran@samsung.com>
 <5617478.sn2TYu7iO3@wuerfel>
In-reply-to: <5617478.sn2TYu7iO3@wuerfel>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAIsWRmVeSWpSXmKPExsVy+t/xa7pdZ72DDfa3mlj8nXSM3WLSugNM
	Fg/X32SxmH/kHKtF/5uFrBb/H71mtTj3aiWjRe+Cq2wWZ5vesFtsenyN1WJh2xIWi8u75rBZ
	zDi/j8ni9mVei6XXLzJZPJ1wkc1iwvS1LBbrXk5nsWjde4TdYsvPDkaL3z2fmC3Wz3jNYnFs
	xhJGi6kzfrA7SHismbeG0aOluYfN4/evSYwel/t6mTz+rnrB7LFz1l12j5XLv7B5bFrVyebx
	avVMVo871/aweWxeUu/x6hqLR9+WVYwe26/NY/b4vEkugD+KyyYlNSezLLVI3y6BK6Nn9wW2
	gh72iter/jE3MH5k6WLk5JAQMJGYu3IhK4QtJnHh3nq2LkYuDiGBpYwSnxdvhnI+Mkpcb5rP
	BFLFK6AlsWnHFTCbRUBV4tiEJUCTODjYBLQltuzwAgmLCkRI3Gs8zApRLijxY/I9sGUiAu4S
	66bPA4szC+xlk/h2sQykVRgofmCZDsSqBYwST6Z/YgWJcwpoSvzZqwxRbi2xctI2RghbXmLz
	mrfMExgFZiHZMAtJ2SwkZQsYmVcxiqaWJhcUJ6XnGuoVJ+YWl+al6yXn525ihMT6lx2Mi49Z
	HWIU4GBU4uHtnOMdLMSaWFZcmXuIUYKDWUmE13UrUIg3JbGyKrUoP76oNCe1+BAjEwenVANj
	WcGD+pakO++CeiNub51z4+a93Kn5rIt+LLZbnz9hiXXCrCLLlx+dv0r9llfO0OULST+59t38
	0xtkNH51OZnvDdZeIX1UvEZHLjVYYPVshe63WmZax8XvTZvO7ZHpsGjh1oWeomcen8+/YOu8
	Zs8fu6sNa2RuTjnSuHC7M+ef9yaZ/sFJrdGzlViKMxINtZiLihMBerMQf9MCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2014 03:03 PM, Arnd Bergmann wrote:
> On Monday 14 April 2014 11:17:38 Tarek Dakhran wrote:
>> --- a/arch/arm/mach-exynos/exynos.c
>> +++ b/arch/arm/mach-exynos/exynos.c
>> @@ -159,6 +159,15 @@ static struct map_desc exynos5250_iodesc[] __initdata = {
>>          },
>>   };
>>   
>> +static struct map_desc exynos5410_iodesc[] __initdata = {
>> +       {
>> +               .virtual        = (unsigned long)S5P_VA_SYSRAM_NS,
>> +               .pfn            = __phys_to_pfn(EXYNOS5410_PA_SYSRAM_NS),
>> +               .length         = SZ_4K,
>> +               .type           = MT_DEVICE,
>> +       },
>> +};
>> +
>>   static struct map_desc exynos5_iodesc[] __initdata = {
> NAK
>
> Why does this keep coming up?
>
> 	Arnd
>
We need this memory region because boot address for exynos5410 located 
here, same as for 5250.

-- 
Best regards,
     Tarek Dakhran

