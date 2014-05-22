Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270AbaEVMZ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 08:25:57 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:61106 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755246AbaEVMZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 08:25:54 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-9a-537deccf4e9a
Message-id: <537DECCE.8000301@samsung.com>
Date: Thu, 22 May 2014 14:25:50 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Tomasz Figa <t.figa@samsung.com>, Tushar Behera <tushar.behera@linaro.org>
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
 <537DE714.1090407@samsung.com>
In-reply-to: <537DE714.1090407@samsung.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRmVeSWpSXmKPExsVy+t/xa7rn39QGGzx4rGYx9eETNov5R86x
	WvQuuMpmsenxNVaLy7vmsFnMOL+PyWLtkbvsFkuvX2SyeDrhIpvFoq1f2C2mLDrMatG69wi7
	xfoZr1ksVu36w2jR/ncvmwO/x5p5axg9ds66y+6xaVUnm8eda3vYPDYvqffo27KK0ePzJrkA
	9igum5TUnMyy1CJ9uwSujJMTDAr+8FW8ebSfrYFxLXcXIyeHhICJxN95d5khbDGJC/fWs3Ux
	cnEICSxllPg/dRkThPOJUeL9pAWsXYwcHLwCWhIbPxaCNLAIqEpcX/ufCcRmEzCU6D3axwhS
	IioQIfH4ghBImFdAUOLH5HssILaIgJ/EiT+HGEFGMgvsY5HY+Hk72GJhgUiJWxefs0DsWsAk
	cbJvFztIglNAW6J9/2uwbmYBdYlJ8xYxQ9jyEpvXvGWewCgwC8mSWUjKZiEpW8DIvIpRNLU0
	uaA4KT3XSK84Mbe4NC9dLzk/dxMjJI6+7mBceszqEKMAB6MSD29HVm2wEGtiWXFl7iFGCQ5m
	JRFexydAId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYwJrvpem5obbB7ksa6YfemqRKDaxEPB3Iab
	fp2ViuLnOLW80nL3Tm6+bXuqpxYHnXkfaN2adjYyvXtqb3jGDbbmp8kupQ+UIltfLWNf82hh
	vaS+id8Oh8y4ucvfFIZdN5d6pyV1WOPY2luz3J3adk3a/Ct++3/lYEdtpqvaiq/bxGLr5hyf
	6qTEUpyRaKjFXFScCAC/W/RIgQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/05/14 14:01, Tomasz Figa wrote:
>>>> >>> [ ... ]
>>>> >>>
>>>>> >>>> +    clkout->clk_table[0] = clk_register_composite(NULL, "clkout",
>>>>> >>>> +                            parent_names, parent_count, &clkout->mux.hw,
>>>>> >>>> +                            &clk_mux_ops, NULL, NULL, &clkout->gate.hw,
>>>>> >>>> +                            &clk_gate_ops, CLK_SET_RATE_PARENT
>>>>> >>>> +                            | CLK_SET_RATE_NO_REPARENT);
>>>> >>>
>>>> >>> Would you please remove CLK_SET_RATE_NO_REPARENT flag from here? Let me
>>>> >>> know if you have reservations against this.
>>> >>
>>> >> The problem with clock reparenting is that there are certain parent
>>> >> clocks of CLKOUT, rate of which changes at runtime, e.g. clocks derived
>>> >> from APLL or bus clocks, which can be reconfigured by cpufreq or devfreq.
>>> >>
>> > 
>> > +CC: Sylwester Nawrocki
>> > 
>> > Okay. But in cases where there is only 1 valid parent clock provided
>> > through DT (at the moment for Exynos5250/Exynos5420), would it be safe
>> > to set that clock as the parent of CLKOUT?
>
> This is not something to rely on. I have simply omitted remaining CLKOUT
> parents on Exynos 5 SoCs, as I don't have any board with them on which I
> could test this. Eventually they will be added.
> 
>> > Otherwise, this clock is
>> > not usable ATM.
>
> On many boards it is already configured properly by the bootloader.
> Although I don't see any reason why you couldn't reparent it in
> (board-specific) sound card driver right now.

This would require passing the parent's clock specifier in 'clocks'
property of the sound card device node, which I assume is not something
we're generally expected to do in mainline. Although some drivers
happen to be doing it already I think that's a bad example. It sounds
like an abuse of the current clock bindings.

--
Regards,
Sylwester
