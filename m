Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924AbaEVMOc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 08:14:32 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:57252 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754792AbaEVMO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 08:14:29 -0400
MIME-Version: 1.0
In-Reply-To: <537DE714.1090407@samsung.com>
References: <1400604211-9447-1-git-send-email-t.figa@samsung.com>
	<1400604211-9447-4-git-send-email-t.figa@samsung.com>
	<537D8788.8030904@linaro.org>
	<537DD2C0.4060802@samsung.com>
	<CAHbNUh2gkpV-rt6S+-bUmFvYAuK_HNoXfyOStwYe29sZMJonUw@mail.gmail.com>
	<537DE714.1090407@samsung.com>
Date: Thu, 22 May 2014 17:44:28 +0530
Message-ID: <CAHbNUh2+tWdDiL0uLXW_fG4SdpQ3kEchsDkVeK9XkqO7tgcgYg@mail.gmail.com>
Subject: Re: [PATCH 3/4] clk: samsung: Add driver to control CLKOUT line on
 Exynos SoCs
From: Tushar Behera <tushar.behera@linaro.org>
To: Mark Brown <broonie@kernel.org>
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
        Tomasz Figa <tomasz.figa@gmail.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 May 2014 17:31, Tomasz Figa <t.figa@samsung.com> wrote:
> On 22.05.2014 13:44, Tushar Behera wrote:
>> On 22 May 2014 16:04, Tomasz Figa <t.figa@samsung.com> wrote:
>>> On 22.05.2014 07:13, Tushar Behera wrote:
>>>> On 05/20/2014 10:13 PM, Tomasz Figa wrote:
>>>>> This patch introduces a driver that handles configuration of CLKOUT pin
>>>>> of Exynos SoCs that can be used to output certain clocks from inside of
>>>>> the SoC to a dedicated output pin.
>>>>>
>>>>> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
>>>>> ---
>>>>>  .../devicetree/bindings/arm/samsung/pmu.txt        |  30 ++++
>>>>>  drivers/clk/samsung/Makefile                       |   1 +
>>>>>  drivers/clk/samsung/clk-exynos-clkout.c            | 153 +++++++++++++++++++++
>>>>>  3 files changed, 184 insertions(+)
>>>>>  create mode 100644 drivers/clk/samsung/clk-exynos-clkout.c
>>>>>
>>>>
>>>> [ ... ]
>>>>
>>>>> +    clkout->clk_table[0] = clk_register_composite(NULL, "clkout",
>>>>> +                            parent_names, parent_count, &clkout->mux.hw,
>>>>> +                            &clk_mux_ops, NULL, NULL, &clkout->gate.hw,
>>>>> +                            &clk_gate_ops, CLK_SET_RATE_PARENT
>>>>> +                            | CLK_SET_RATE_NO_REPARENT);
>>>>
>>>> Would you please remove CLK_SET_RATE_NO_REPARENT flag from here? Let me
>>>> know if you have reservations against this.
>>>
>>> The problem with clock reparenting is that there are certain parent
>>> clocks of CLKOUT, rate of which changes at runtime, e.g. clocks derived
>>> from APLL or bus clocks, which can be reconfigured by cpufreq or devfreq.
>>>
>>
>> +CC: Sylwester Nawrocki
>>
>> Okay. But in cases where there is only 1 valid parent clock provided
>> through DT (at the moment for Exynos5250/Exynos5420), would it be safe
>> to set that clock as the parent of CLKOUT?
>
> This is not something to rely on. I have simply omitted remaining CLKOUT
> parents on Exynos 5 SoCs, as I don't have any board with them on which I
> could test this. Eventually they will be added.
>
>> Otherwise, this clock is
>> not usable ATM.
>
> On many boards it is already configured properly by the bootloader.
> Although I don't see any reason why you couldn't reparent it in
> (board-specific) sound card driver right now.
>

Mark,

Is this (clock reparenting in sound card driver) an acceptable solution for you?


-- 
Tushar Behera
