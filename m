Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717AbaEVMcn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 08:32:43 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:12141 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234AbaEVMcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 08:32:39 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-22-537dee63020a
Message-id: <537DEE61.2050606@samsung.com>
Date: Thu, 22 May 2014 14:32:33 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tushar Behera <tushar.behera@linaro.org>
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
        Mark Brown <broonie@kernel.org>, Tomasz Figa <tomasz.figa@gmail.com>
Subject: Re: [PATCH 3/4] clk: samsung: Add driver to control CLKOUT line on
 Exynos SoCs
References: <1400604211-9447-1-git-send-email-t.figa@samsung.com>
 <1400604211-9447-4-git-send-email-t.figa@samsung.com>
 <537D8788.8030904@linaro.org> <537DD2C0.4060802@samsung.com>
 <CAHbNUh2gkpV-rt6S+-bUmFvYAuK_HNoXfyOStwYe29sZMJonUw@mail.gmail.com>
 <537DE714.1090407@samsung.com> <537DECCE.8000301@samsung.com>
In-reply-to: <537DECCE.8000301@samsung.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFLMWRmVeSWpSXmKPExsVy+t/xa7rJ72qDDZ6vNrGY+vAJm8X8I+dY
	LXoXXGWz2PT4GqvF5V1z2CxmnN/HZLH2yF12i6XXLzJZPJ1wkc1i0dYv7BZTFh1mtWjde4Td
	4vCbdlaLVbv+MFq0/93L5sDvsWbeGkaPnbPusntsWtXJ5nHn2h42j81L6j36tqxi9Pi8SS6A
	PYrLJiU1J7MstUjfLoEr487MeYwFTwUq5i/vZ2pgbODtYuTkkBAwkXj29CMLhC0mceHeejYQ
	W0hgKaPEvdVKXYxcQPZnRonX+16ygyR4BbQkTp59wApiswioShydspcRxGYTUJP43PAIrJkf
	qGZN03WgoRwcogIREo8vCEG0Ckr8mHwPbJeIQLTE6tX3mUDmMwvsY5HY+Hk7M0hCWCBS4tbF
	5ywQR+xnkrh8KBTE5hTQlth+/DjYLmYBdYlJ8xYxQ9jyEpvXvGWewCg4C8mOWUjKZiEpW8DI
	vIpRNLU0uaA4KT3XUK84Mbe4NC9dLzk/dxMjJL6+7GBcfMzqEKMAB6MSD6/A1epgIdbEsuLK
	3EOMEhzMSiK8jk9qg4V4UxIrq1KL8uOLSnNSiw8xMnFwSjUwzr5z9/Te3P9t+w2yFDfe/sG0
	SOP454UHlt83erhi6tLNu5IsYnj/CPYu+PF9p5qUi3Hhx8qcnYJLDrEE/Hbq6muwE3DNnlIf
	Np29rF3wlY6i5sKpv9+FnlP/3DrBXUHCZ55lxYRaJrfdzUVCaed7VKZ0LuGcskjm4o8An8uF
	FfelfvDdkpu2TomlOCPRUIu5qDgRAKBgE5eNAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 22.05.2014 14:25, Sylwester Nawrocki wrote:
> On 22/05/14 14:01, Tomasz Figa wrote:
>>>>>>>> [ ... ]
>>>>>>>>
>>>>>>>>>> +    clkout->clk_table[0] = clk_register_composite(NULL, "clkout",
>>>>>>>>>> +                            parent_names, parent_count, &clkout->mux.hw,
>>>>>>>>>> +                            &clk_mux_ops, NULL, NULL, &clkout->gate.hw,
>>>>>>>>>> +                            &clk_gate_ops, CLK_SET_RATE_PARENT
>>>>>>>>>> +                            | CLK_SET_RATE_NO_REPARENT);
>>>>>>>>
>>>>>>>> Would you please remove CLK_SET_RATE_NO_REPARENT flag from here? Let me
>>>>>>>> know if you have reservations against this.
>>>>>>
>>>>>> The problem with clock reparenting is that there are certain parent
>>>>>> clocks of CLKOUT, rate of which changes at runtime, e.g. clocks derived
>>>>>> from APLL or bus clocks, which can be reconfigured by cpufreq or devfreq.
>>>>>>
>>>>
>>>> +CC: Sylwester Nawrocki
>>>>
>>>> Okay. But in cases where there is only 1 valid parent clock provided
>>>> through DT (at the moment for Exynos5250/Exynos5420), would it be safe
>>>> to set that clock as the parent of CLKOUT?
>>
>> This is not something to rely on. I have simply omitted remaining CLKOUT
>> parents on Exynos 5 SoCs, as I don't have any board with them on which I
>> could test this. Eventually they will be added.
>>
>>>> Otherwise, this clock is
>>>> not usable ATM.
>>
>> On many boards it is already configured properly by the bootloader.
>> Although I don't see any reason why you couldn't reparent it in
>> (board-specific) sound card driver right now.
> 
> This would require passing the parent's clock specifier in 'clocks'
> property of the sound card device node, which I assume is not something
> we're generally expected to do in mainline. Although some drivers
> happen to be doing it already I think that's a bad example. It sounds
> like an abuse of the current clock bindings.

Well, an already board-specific driver might have some knowledge of the
SoC, so it might not be a huge problem, but I agree that this is not an
optimal solution.

Best regards,
Tomasz
