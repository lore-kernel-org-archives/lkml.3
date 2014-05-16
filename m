Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932624AbaEPO6t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 10:58:49 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:33395 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932303AbaEPO6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 10:58:46 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-59-537627a2a3ef
Message-id: <5376279C.4070006@samsung.com>
Date: Fri, 16 May 2014 16:58:36 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Rahul Sharma <rahul.sharma@samsung.com>
Cc: Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Mark Brown <broonie@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Tomasz Figa <tomasz.figa@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Tushar Behera <tushar.behera@linaro.org>
Subject: Re: [PATCH RFC 3/4] clk: samsung: Add driver to control CLKOUT line on
 Exynos SoCs
References: <1400175151-27779-1-git-send-email-t.figa@samsung.com>
 <1400175151-27779-4-git-send-email-t.figa@samsung.com>
 <CAPdUM4P7Z1eLVKuc0N1iPaekM_7kNv7KCve2MgrEziszfnzz7A@mail.gmail.com>
 <5375EDFD.1020708@samsung.com>
 <CAPdUM4O4RKFZFR_tcwG4pd7E6KMkneG9R_VbZPt+m4fGG_UFVg@mail.gmail.com>
In-reply-to: <CAPdUM4O4RKFZFR_tcwG4pd7E6KMkneG9R_VbZPt+m4fGG_UFVg@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGLMWRmVeSWpSXmKPExsVy+t/xq7qL1MuCDS7u5rGY+vAJm8X8I+dY
	LXoXXGWz2PT4GqvF5V1z2CxmnN/HZLH2yF12i6XXLzJZPJ1wkc1i0dYv7BZTFh1mtWjde4Td
	YtWuP4wW7X/3sjnweayZt4bRY+esu+wem1Z1snncubaHzWPzknqPvi2rGD0+b5ILYI/isklJ
	zcksSy3St0vgyji8/zd7wRXBiv5zCQ2MU3m7GDk5JARMJA6/v88CYYtJXLi3nq2LkYtDSGAp
	o8SGTfOhnM+MEk/v/mUEqeIV0JJ4PfsCO4jNIqAq0fLjLBuIzSagJvG54RGYzQ9Us6bpOtBU
	Dg5RgQiJxxeEIFoFJX5Mvge2TERAW6LhWAvYfGaB9ywS9961g80UFoiVaP66gh1i8SomiT1n
	N4At5hQIltj/qhWsiFlAR2J/6zQ2CFteYvOat8wTGAVnIVkyC0nZLCRlCxiZVzGKppYmFxQn
	peca6hUn5haX5qXrJefnbmKExNWXHYyLj1kdYhTgYFTi4f3gVhosxJpYVlyZe4hRgoNZSYRX
	SqAsWIg3JbGyKrUoP76oNCe1+BAjEwenVAOjTQGrnaSfWMtp3WcFvYrWx1UTjqTeK/8aPeuK
	8b09/S+CEqS9Nn1q4Vy1dGPfEQU2H5aZTw98W9r1zYxfKuZU1Z/pyko7BZfNXdK1LMtk/VZG
	t7KaspDtUScba1Pdrr1LFGsJezH9xb6cRXsi8p/elu3XWG8tVz//fWXsyvPvhM7pHO45vfSB
	EktxRqKhFnNRcSIARY9nL4kCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.05.2014 16:35, Rahul Sharma wrote:
> On 16 May 2014 16:22, Tomasz Figa <t.figa@samsung.com> wrote:
>> Hi Rahul,
>>
>> On 16.05.2014 12:39, Rahul Sharma wrote:
>>> [snip]
>>>> +       gate->lock = &clkout_lock;
>>>> +
>>>> +       mux->reg = reg + EXYNOS_PMU_DEBUG_REG;
>>>> +       mux->mask = EXYNOS_CLKOUT_MUX_MASK;
>>>> +       mux->shift = EXYNOS_CLKOUT_MUX_SHIFT;
>>>> +       mux->lock = &clkout_lock;
>>>> +
>>>> +       clk = clk_register_composite(NULL, "clkout", parent_names,
>>>> +                                       parent_count, &mux->hw,
>>>> +                                       &clk_mux_ops, NULL, NULL, &gate->hw,
>>>> +                                       &clk_gate_ops, 0);
>>>> +       if (IS_ERR(clk))
>>>> +               goto err_unmap;
>>>> +
>>>
>>> Hi Tomasz,
>>>
>>> Do we really need a composite clock here? How about registering
>>> a mux and a gate separately?
>>
>> What's wrong with a composite clock? It simplifies the code as just a
>> single clock needs to be registered. I don't see any drawbacks compared
>> to registering two clocks separately.
>>
> 
> I always took it as a thumb rule to not to use composite clocks if you
> can easily represent the block using basic clocks structures.
> 
> There can be a problem when drivers using such clocks assume that such
> clock continue to offer composite functionality for all futures SoCs and
> write code around it. This is what we faced when fixing drivers during
> CCF migration.

The drivers using CLKOUT need to be designed this way, because they are
not Exynos-specific, such as drivers for HSIC hubs or audio codecs. They
can't have any Exynos-specific knowledge about clock hierarchy.

So regardless of whether this is implemented using the composite clock
or not, consumer device drivers need to be able to use just a single
clock to do whatever they need, e.g. gating or rate configuration.

However I can see one problem here with my implementation - it is
missing the CLK_SET_RATE_PARENT flag, so dividers of particular CLK_OUTs
from CMU blocks could be reconfigured.

Also the driver is missing save and restore of PMU_DEBUG register.

I will fix both in next version.

Best regards,
Tomasz
