Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751366AbaEWWsL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 18:48:11 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:36646 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbaEWWsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 18:48:09 -0400
Message-ID: <537FD021.2020808@gmail.com>
Date: Sat, 24 May 2014 00:48:01 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Tarek Dakhran <t.dakhran@gmail.com>
CC: Tarek Dakhran <t.dakhran@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Mike Turquette <mturquette@linaro.org>,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Romain Naour <romain.naour@openwide.fr>,
        Chander Kashyap <chander.kashyap@linaro.org>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH v10 1/3] ARM: EXYNOS: Add support for EXYNOS5410 SoC
References: <1400841343-6016-1-git-send-email-t.dakhran@samsung.com>	<1400841343-6016-2-git-send-email-t.dakhran@samsung.com>	<537FB995.5070604@gmail.com> <CANhyOUd8Q2nzh_bF6LZNuv8keVUB3F45PocYrLP_B=D_Q3tWuQ@mail.gmail.com>
In-Reply-To: <CANhyOUd8Q2nzh_bF6LZNuv8keVUB3F45PocYrLP_B=D_Q3tWuQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.05.2014 00:44, Tarek Dakhran wrote:
> Hi Tomazs,
> 
> On Sat, May 24, 2014 at 1:11 AM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
>> Hi Tarek,
>>
>> With v2 of the series I mentioned in review of previous version [1],
>> this patch can be skipped.
>>
>> [1] http://www.spinics.net/lists/linux-samsung-soc/msg31258.html
>>
>> Best regards,
>> Tomasz
>>
>> On 23.05.2014 12:35, Tarek Dakhran wrote:
> [snip]
>>> diff --git a/arch/arm/mach-exynos/firmware.c b/arch/arm/mach-exynos/firmware.c
>>> index 739bdc8..971baf0 100644
>>> --- a/arch/arm/mach-exynos/firmware.c
>>> +++ b/arch/arm/mach-exynos/firmware.c
>>> @@ -50,7 +50,7 @@ static int exynos_set_cpu_boot_addr(int cpu, unsigned long boot_addr)
>>>
>>>       boot_reg = sysram_ns_base_addr + 0x1c;
>>>
>>> -     if (!soc_is_exynos4212())
>>> +     if (!soc_is_exynos4212() && !soc_is_exynos5410())
>>>               boot_reg += 4*cpu;
>>>
>>>       __raw_writel(boot_addr, boot_reg);
>>>
> 
> I need to define SoC type to set correct bootreg in firmware,
> otherwise only one cpu can be booted.
> So, this stuff is needed.

The patch I referred to in my previous reply changes this condition from
!soc_is_exynos4212() to soc_is_exynos4412(), which makes the 4*cpu
offset being added only in case of Exynos4412 (and so not being added
for Exynos5410). What else is needed?

Best regards,
Tomasz
