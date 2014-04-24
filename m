Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757100AbaDXN0v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 09:26:51 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:60592 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446AbaDXN0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 09:26:47 -0400
MIME-Version: 1.0
In-Reply-To: <53590A3D.1020308@samsung.com>
References: <1396425778-4379-1-git-send-email-pankaj.dubey@samsung.com>
	<1396425778-4379-2-git-send-email-pankaj.dubey@samsung.com>
	<CAGm_ybjfxprtLUX6Vs8QVvXoMOaHez4-Og8a9n3UevibvmzbZA@mail.gmail.com>
	<53590A3D.1020308@samsung.com>
Date: Thu, 24 Apr 2014 18:56:47 +0530
Message-ID: <CAGm_ybi+QiC95-aJtzbpY8CCv9f6+NDC4HHrC8RuCmkUHDGB5A@mail.gmail.com>
Subject: Re: [PATCH 1/3] ARM: dts: Add PMU reg node to exynos4210
From: Vikas Sajjan <sajjan.linux@gmail.com>
To: Pankaj Dubey <pankaj.dubey@samsung.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        devicetree@vger.kernel.org, mark.rutland@arm.com,
        Kukjin Kim <kgene.kim@samsung.com>, linux@arm.linux.org.uk,
        pawel.moll@arm.com, ijc+devicetree@hellion.org.uk,
        Rob Herring <robh+dt@kernel.org>, galak@codeaurora.org,
        chow.kim@samsung.com, Tomasz Figa <t.figa@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, sunil joshi <joshi@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pankaj,

On Thu, Apr 24, 2014 at 6:27 PM, Pankaj Dubey <pankaj.dubey@samsung.com> wrote:
> Hi Vikas,
>
>
> On 04/24/2014 08:59 PM, Vikas Sajjan wrote:
>>
>> +Tomasz
>>
>>
>> On Wed, Apr 2, 2014 at 1:32 PM, Pankaj Dubey <pankaj.dubey@samsung.com>
>> wrote:
>>>
>>> This patch adds pmu regnode to exynos4210 dtsi to handle
>>> PMU register access via DT.
>>>
>>> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
>>> ---
>>>   arch/arm/boot/dts/exynos4210.dtsi |    5 +++++
>>>   1 file changed, 5 insertions(+)
>>>
>>> diff --git a/arch/arm/boot/dts/exynos4210.dtsi
>>> b/arch/arm/boot/dts/exynos4210.dtsi
>>> index cacf614..0a2c0fe 100644
>>> --- a/arch/arm/boot/dts/exynos4210.dtsi
>>> +++ b/arch/arm/boot/dts/exynos4210.dtsi
>>> @@ -81,6 +81,11 @@
>>>                  interrupts = <2 2>, <3 2>;
>>>          };
>>>
>>> +       pmu_system_controller: system-controller@10020000 {
>>> +               compatible = "samsung,exynos4210-pmu", "syscon";
>>> +               reg = <0x10020000 0x5000>;
>>
>> Can we have 2 strings as "compatible" and these 2 strings are used by
>> 2 different driver?
>>
>> Because once syscon driver gets probed, exynos-pmu.c [1] driver will
>> never be probed.
>>
>> The new PMU driver [1] completely relies on this. With just
>> exynos_defconfig, you will not notice this issue, since syscon is NOT
>> enabled by exynos_defconfig. When I enabled "System Controller
>> Register R/W Based on Regmap" in menuconfig, I could see PMU driver
>> [1] is NEVER probed.
>>
>> Let me know, if I am missing something.
>>
>>   [1] http://www.spinics.net/lists/arm-kernel/msg319750.html
>
>
> You are correct. We also missed this because "SYSCON" option was
> not enabled in exynos_defconfig.
> I noticed this during preparation of V2 when I planned to use
> "early_syscon_init" [1] as suggested by Sylwester here [2].
>
OK.

> In V2 I will take care of this. I hope soon I will be able to post second

So in your V2, will you be adding new DT node altogether for PMU?
Because with existing DT node "pmu_system_controller"  (which is
already present in mailine for exynos 5250) and SYSCON driver enable,
exynos PMU driver will NEVER probed.

> version of this series, just waiting for testing and internal code review.
>
> [1] https://lkml.org/lkml/2014/4/8/239
> [2] https://lkml.org/lkml/2014/4/2/171
>
>>
>>
>>> +       };
>>> +
>>>          pinctrl_0: pinctrl@11400000 {
>>>                  compatible = "samsung,exynos4210-pinctrl";
>>>                  reg = <0x11400000 0x1000>;
>>> --
>>> 1.7.10.4
>>>
>>>
>>> _______________________________________________
>>> linux-arm-kernel mailing list
>>> linux-arm-kernel@lists.infradead.org
>>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>
>
>
> --
> Best Regards,
> Pankaj Dubey
>
