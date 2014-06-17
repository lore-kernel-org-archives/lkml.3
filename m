Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933425AbaFQP1A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 11:27:00 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:26555 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932869AbaFQP07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 11:26:59 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-fc-53a05e40d99f
Message-id: <53A05E2D.6020702@samsung.com>
Date: Tue, 17 Jun 2014 17:26:37 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Pankaj Dubey <pankaj.dubey@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, chow.kim@samsung.com,
        vikas.sajjan@samsung.com, joshi@samsung.com
Subject: Re: [PATCH v4 06/11] ARM: EXYNOS: Add support for mapping PMU base
 address via DT
References: <1399704998-13321-1-git-send-email-pankaj.dubey@samsung.com>
 <1399704998-13321-7-git-send-email-pankaj.dubey@samsung.com>
 <53973C0B.2000903@samsung.com> <000401cf89f7$7db93190$792b94b0$@samsung.com>
In-reply-to: <000401cf89f7$7db93190$792b94b0$@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFLMWRmVeSWpSXmKPExsVy+t/xq7oOcQuCDY5/lbFYNukum8X3XV/Y
	LXoXXGWz2PT4GqvF5V1z2CxmnN/HZHH7Mq/Foq1AyZvPtjM5cHq0NPeweWxeUu/Rt2UVo8fn
	TXIBLFFcNimpOZllqUX6dglcGcf/7mIv2CZSsbeVtYFxkUAXIyeHhICJxOxXjxkhbDGJC/fW
	s3UxcnEICSxllFh/spsJJCEk8JlR4t509y5GDg5eAS2JZe+5QcIsAqoSxxZfAOtlE1CT+Nzw
	iA3E5gcqWdN0nQWkXFQgQuLxBSGQMK+AoMSPyfdYQMaLCExhlLjYs4wRpIZZoExi2hoVkBph
	gRiJg/v/sUKccI1R4ljnchaQBKeAlcSliduZQWxmAR2J/a3T2CBseYnNa94yT2AUnIVkxywk
	ZbOQlC1gZF7FKJpamlxQnJSea6hXnJhbXJqXrpecn7uJERL+X3YwLj5mdYhRgINRiYc34tL8
	YCHWxLLiytxDjBIczEoivCXiC4KFeFMSK6tSi/Lji0pzUosPMTJxcEo1MLKUNk2/Xqwk+XWB
	R54Af/i1PLaOTTMPnlv19NKtTTkuwTd/zjl90yyp4/kFtevGU51WBc64vj/w9EuGktcWIUf+
	LpNa972Zi/3/Qq6MAJH5Z8/b8U50KvmVdbdHMFhBT9TVzHkTj1twdLHegjanE/IVV9YwPpUw
	cVc2luAQ51TIi50xYePFCUosxRmJhlrMRcWJANudLC5dAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pankaj,

On 17.06.2014 08:43, Pankaj Dubey wrote:
> Hi Tomasz,
> 
>> Hi,
>>
>> On 10.05.2014 08:56, Pankaj Dubey wrote:
>>> From: Young-Gun Jang <yg1004.jang@samsung.com>
>>>
>>> Add support for mapping Samsung Power Management Unit (PMU) base
>>> address from device tree. This patch also adds helper function as
>>> "get_exynos_pmuregmap". This function can be used by other machine
>>> files such as "pm.c", "hotplug.c" for accessing PMU regmap handle.
>>>
>>
>> I don't think there is a need to use regmap to provide access to PMU to
> such low
>> level code such as pm.c or hotplug.c. Moreover, I believe that it might be
> undesirable
>> in some cases, e.g. very low level code running at early resume or late
> suspend.
>>
>> IMHO, based on what we now have for SYSRAM, you could simply map PMU from
>> device tree one time, before SMP init, and keep the address in some
> globally
>> accessible variable, like those for SYSRAM we have right now
> (sysram_base_addr,
>> sysram_ns_base_addr -> pmu_base_addr).
>>
> 
> Thanks for review. 
> 
> Well I adopted same approach in V1 of this patch series. 
> 
> V1: https://lkml.org/lkml/2014/4/2/48
> 
> So, if we do not have issues with that approach, I think we can map PMU
> address
> one time and use it for all machine files including pmu.c. 

The approach itself is fine, but I believe there is no reason to use fdt
there. My recommendation is to follow the method used to map SYSRAMs in
patch "b3205dea8f ARM: EXYNOS: Map SYSRAM through generic DT bindings"
and taking into account patch "b87abf7deb ARM: exynos: move sysram info
to exynos.c", which moves things around source files.

> Also I can see that early_syscon patch [1] is not progressing anymore,
> so in next version of this series better I remove dependency of early syscon
> and usage
> of regmap.

I have another proposal, basically something I already proposed in
review of one of previous versions of this series. I will send a patch
as a reply to this message.

> 
> 1: https://lkml.org/lkml/2014/4/8/239
> 
> Tomasz, It will be good if you can review remaining patches under this
> series, specially patch [2].
> So that, I can update this series after addressing all comments.
> 
> 2: https://lkml.org/lkml/2014/5/10/26
> 

Most of the patches have already received my reviewed-by tag. I'm
generally hesitating to review remaining ones, because the general
architecture will be quite different after changing things mentioned
above. However let me see and try to point issues I can find.

Best regards,
Tomasz
