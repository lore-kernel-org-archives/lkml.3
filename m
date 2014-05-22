Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890AbaEVMKx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 08:10:53 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:52230 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754653AbaEVMKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 08:10:51 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-db-537de948acee
Message-id: <537DE946.9090303@samsung.com>
Date: Thu, 22 May 2014 14:10:46 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Tushar Behera <tushar.behera@linaro.org>
Cc: Tomasz Figa <t.figa@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Mark Brown <broonie@kernel.org>, Tomasz Figa <tomasz.figa@gmail.com>
Subject: Re: [PATCH 3/4] clk: samsung: Add driver to control CLKOUT line on
 Exynos SoCs
References: <1400604211-9447-1-git-send-email-t.figa@samsung.com>
 <1400604211-9447-4-git-send-email-t.figa@samsung.com>
 <537D8788.8030904@linaro.org> <537DD2C0.4060802@samsung.com>
 <CAHbNUh2gkpV-rt6S+-bUmFvYAuK_HNoXfyOStwYe29sZMJonUw@mail.gmail.com>
In-reply-to: <CAHbNUh2gkpV-rt6S+-bUmFvYAuK_HNoXfyOStwYe29sZMJonUw@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsVy+t/xq7oeL2uDDTa+4LOY+vAJm8X8I+dY
	LXoXXGWz2PT4GqvF5V1z2CxmnN/HZLH2yF12i6XXLzJZPJ1wkc1i0dYv7BZTFh1mtWjde4Td
	Yv2M1ywWq3b9YbRo/7uXzYHfY828NYweO2fdZffYtKqTzePOtT1sHpuX1Hv0bVnF6PF5k1wA
	exSXTUpqTmZZapG+XQJXxrrDN1gLTopWXO7/ztjAeFagi5GTQ0LARGLD3D/sELaYxIV769m6
	GLk4hASWMkrcnHUPyvnEKLF4yRMmkCpeAS2JGUfesoDYLAKqEkfeNIDF2QQMJXqP9jF2MXJw
	iApESDy+IARRLijxY/I9sHIRAR2JB4v2gtnMAo9YJOa8igWxhQUiJW5dfM4Cses/o8Seyb1g
	RZwCwRK7phxghWhQl5g0bxEzhC0vsXnNW+YJjAKzkOyYhaRsFpKyBYzMqxhFU0uTC4qT0nMN
	9YoTc4tL89L1kvNzNzFCIunLDsbFx6wOMQpwMCrx8ApcrQ4WYk0sK67MPcQowcGsJMLr+KQ2
	WIg3JbGyKrUoP76oNCe1+BAjEwenVAPjfLGifyGa70+XTY99MNHrwNV26WU1k6QuXaufaN91
	RPuatJ0NY+86YxHvzd8kBSIj9UKXiYqaaa0+byE6x7xlRrKvyLbGjP077YpVFGOrD5Q+Vzkr
	0R8/Ndt7+p71TI2e9Yc4HKtS9dftnbOB3zQiaL/C7EOsBk8cdz712nNEQGfbF98un3dKLMUZ
	iYZazEXFiQCCn3IYggIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/05/14 13:44, Tushar Behera wrote:
> On 22 May 2014 16:04, Tomasz Figa <t.figa@samsung.com> wrote:
>> On 22.05.2014 07:13, Tushar Behera wrote:
>>> On 05/20/2014 10:13 PM, Tomasz Figa wrote:
>>>> This patch introduces a driver that handles configuration of CLKOUT pin
>>>> of Exynos SoCs that can be used to output certain clocks from inside of
>>>> the SoC to a dedicated output pin.
>>>>
>>>> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
>>>> ---
>>>>  .../devicetree/bindings/arm/samsung/pmu.txt        |  30 ++++
>>>>  drivers/clk/samsung/Makefile                       |   1 +
>>>>  drivers/clk/samsung/clk-exynos-clkout.c            | 153 +++++++++++++++++++++
>>>>  3 files changed, 184 insertions(+)
>>>>  create mode 100644 drivers/clk/samsung/clk-exynos-clkout.c
>>>>
>>>
>>> [ ... ]
>>>
>>>> +    clkout->clk_table[0] = clk_register_composite(NULL, "clkout",
>>>> +                            parent_names, parent_count, &clkout->mux.hw,
>>>> +                            &clk_mux_ops, NULL, NULL, &clkout->gate.hw,
>>>> +                            &clk_gate_ops, CLK_SET_RATE_PARENT
>>>> +                            | CLK_SET_RATE_NO_REPARENT);
>>>
>>> Would you please remove CLK_SET_RATE_NO_REPARENT flag from here? Let me
>>> know if you have reservations against this.
>>
>> The problem with clock reparenting is that there are certain parent
>> clocks of CLKOUT, rate of which changes at runtime, e.g. clocks derived
>> from APLL or bus clocks, which can be reconfigured by cpufreq or devfreq.
>>
> 
> +CC: Sylwester Nawrocki
> 
> Okay. But in cases where there is only 1 valid parent clock provided
> through DT (at the moment for Exynos5250/Exynos5420), would it be safe
> to set that clock as the parent of CLKOUT? Otherwise, this clock is
> not usable ATM.

I'd prefer to not allow re-parenting here, as it will not work in all system
configurations and seems not reliable in general.

>>> With RFC patches, I am able to do a clk_set_rate() on this clock to
>>> get a 24MHz output to the codec clock. With this flag set, I again have
>>> to rely on the default value set to this register in bootloader.
>>>
>>
>> This problem should be handled by initializing clocks from DT. I'm not
>> sure why it hasn't been implemented yet...
> 
> I would be happy to get it done that way. I can see a patch from
> Sylwester regarding this, but there hasn't been a conclusion as of
> yet.
> 
> https://lkml.org/lkml/2014/4/9/173

I posted a next version recently [1], any feedback on that is welcome.
I used these patches for the camera on Trats2 and the audio on Odroid U3
clocks configuration.

[1] http://www.spinics.net/lists/devicetree/msg34718.html

--
Thanks,
Sylwester
