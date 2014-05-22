Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567AbaEVLov (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 07:44:51 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:39858 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875AbaEVLou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 07:44:50 -0400
MIME-Version: 1.0
In-Reply-To: <537DD2C0.4060802@samsung.com>
References: <1400604211-9447-1-git-send-email-t.figa@samsung.com>
	<1400604211-9447-4-git-send-email-t.figa@samsung.com>
	<537D8788.8030904@linaro.org>
	<537DD2C0.4060802@samsung.com>
Date: Thu, 22 May 2014 17:14:49 +0530
Message-ID: <CAHbNUh2gkpV-rt6S+-bUmFvYAuK_HNoXfyOStwYe29sZMJonUw@mail.gmail.com>
Subject: Re: [PATCH 3/4] clk: samsung: Add driver to control CLKOUT line on
 Exynos SoCs
From: Tushar Behera <tushar.behera@linaro.org>
To: Tomasz Figa <t.figa@samsung.com>
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 May 2014 16:04, Tomasz Figa <t.figa@samsung.com> wrote:
> On 22.05.2014 07:13, Tushar Behera wrote:
>> On 05/20/2014 10:13 PM, Tomasz Figa wrote:
>>> This patch introduces a driver that handles configuration of CLKOUT pin
>>> of Exynos SoCs that can be used to output certain clocks from inside of
>>> the SoC to a dedicated output pin.
>>>
>>> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
>>> ---
>>>  .../devicetree/bindings/arm/samsung/pmu.txt        |  30 ++++
>>>  drivers/clk/samsung/Makefile                       |   1 +
>>>  drivers/clk/samsung/clk-exynos-clkout.c            | 153 +++++++++++++++++++++
>>>  3 files changed, 184 insertions(+)
>>>  create mode 100644 drivers/clk/samsung/clk-exynos-clkout.c
>>>
>>
>> [ ... ]
>>
>>> +    clkout->clk_table[0] = clk_register_composite(NULL, "clkout",
>>> +                            parent_names, parent_count, &clkout->mux.hw,
>>> +                            &clk_mux_ops, NULL, NULL, &clkout->gate.hw,
>>> +                            &clk_gate_ops, CLK_SET_RATE_PARENT
>>> +                            | CLK_SET_RATE_NO_REPARENT);
>>
>> Would you please remove CLK_SET_RATE_NO_REPARENT flag from here? Let me
>> know if you have reservations against this.
>
> The problem with clock reparenting is that there are certain parent
> clocks of CLKOUT, rate of which changes at runtime, e.g. clocks derived
> from APLL or bus clocks, which can be reconfigured by cpufreq or devfreq.
>

+CC: Sylwester Nawrocki

Okay. But in cases where there is only 1 valid parent clock provided
through DT (at the moment for Exynos5250/Exynos5420), would it be safe
to set that clock as the parent of CLKOUT? Otherwise, this clock is
not usable ATM.

>>
>> With RFC patches, I am able to do a clk_set_rate() on this clock to
>> get a 24MHz output to the codec clock. With this flag set, I again have
>> to rely on the default value set to this register in bootloader.
>>
>
> This problem should be handled by initializing clocks from DT. I'm not
> sure why it hasn't been implemented yet...

I would be happy to get it done that way. I can see a patch from
Sylwester regarding this, but there hasn't been a conclusion as of
yet.

https://lkml.org/lkml/2014/4/9/173

Thanks,
-- 
Tushar Behera
