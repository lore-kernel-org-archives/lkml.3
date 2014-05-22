Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906AbaEVMBh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 08:01:37 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:59654 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754431AbaEVMBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 08:01:34 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-bd-537de717e4ec
Message-id: <537DE714.1090407@samsung.com>
Date: Thu, 22 May 2014 14:01:24 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Tushar Behera <tushar.behera@linaro.org>
Cc: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
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
        Mark Brown <broonie@kernel.org>, Tomasz Figa <tomasz.figa@gmail.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH 3/4] clk: samsung: Add driver to control CLKOUT line on
 Exynos SoCs
References: <1400604211-9447-1-git-send-email-t.figa@samsung.com>
 <1400604211-9447-4-git-send-email-t.figa@samsung.com>
 <537D8788.8030904@linaro.org> <537DD2C0.4060802@samsung.com>
 <CAHbNUh2gkpV-rt6S+-bUmFvYAuK_HNoXfyOStwYe29sZMJonUw@mail.gmail.com>
In-reply-to: <CAHbNUh2gkpV-rt6S+-bUmFvYAuK_HNoXfyOStwYe29sZMJonUw@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNLMWRmVeSWpSXmKPExsVy+t/xK7riz2uDDdbuYLaY+vAJm8X8I+dY
	LXoXXGWz2PT4GqvF5V1z2CxmnN/HZLH2yF12i6XXLzJZPJ1wkc1i0dYv7BZTFh1mtWjde4Td
	4vCbdlaLVbv+MFq0/93L5sDvsWbeGkaPnbPusntsWtXJ5nHn2h42j81L6j36tqxi9Pi8SS6A
	PYrLJiU1J7MstUjfLoEr4+iPNqaCheIVtxYlNTB+EOxi5OSQEDCR6Ps9iwXCFpO4cG89Wxcj
	F4eQwFJGidlXNzNDOJ8ZJf78WMkEUsUroCVxt6UTzGYRUJWYu+85WDebgJrE54ZHbCA2P1DN
	mqbrQHEODlGBCInHF4QgWgUlfky+B1YuIqAj8WDRXhaQ+cwCb1kk1j37BtYrLBApcevicxaI
	xf8ZJfZM7gXr4BQIltg15QAriM0soC4xad4iZghbXmLzmrfMExgFZyFZMgtJ2SwkZQsYmVcx
	iqaWJhcUJ6XnGuoVJ+YWl+al6yXn525ihETYlx2Mi49ZHWIU4GBU4uEVuFodLMSaWFZcmXuI
	UYKDWUmE1/FJbbAQb0piZVVqUX58UWlOavEhRiYOTqkGRon9pec15obWbJ11PnabqecbxSXf
	O6VSn0Xd/rjK/0DKnDfSZhrt6sw71+k8v2I3SSo7ft2/znOKO+zrVr7/8zlSejsTG8dUqfc2
	4ocu39E6eTxT+3aS2fHLmvUP3Ix7Z4TGZJQ+1YhKuVVi6l3O5ZAzMch1neC0+DUTTN9NX+/m
	L9EqI3D0lxJLcUaioRZzUXEiAPu5OjaOAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.05.2014 13:44, Tushar Behera wrote:
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
> to set that clock as the parent of CLKOUT?

This is not something to rely on. I have simply omitted remaining CLKOUT
parents on Exynos 5 SoCs, as I don't have any board with them on which I
could test this. Eventually they will be added.

> Otherwise, this clock is
> not usable ATM.

On many boards it is already configured properly by the bootloader.
Although I don't see any reason why you couldn't reparent it in
(board-specific) sound card driver right now.

> 
>>>
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

Have you mentioned your use case there? It might indicate that this is
indeed an important problem and that too much bikeshedding doesn't
really make us closer to the solution.

Best regards,
Tomasz
