Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417AbaEWWoe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 18:44:34 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:64604 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbaEWWoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 18:44:32 -0400
MIME-Version: 1.0
In-Reply-To: <537FB995.5070604@gmail.com>
References: <1400841343-6016-1-git-send-email-t.dakhran@samsung.com>
	<1400841343-6016-2-git-send-email-t.dakhran@samsung.com>
	<537FB995.5070604@gmail.com>
Date: Sat, 24 May 2014 02:44:30 +0400
Message-ID: <CANhyOUd8Q2nzh_bF6LZNuv8keVUB3F45PocYrLP_B=D_Q3tWuQ@mail.gmail.com>
Subject: Re: [PATCH v10 1/3] ARM: EXYNOS: Add support for EXYNOS5410 SoC
From: Tarek Dakhran <t.dakhran@gmail.com>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Tarek Dakhran <t.dakhran@samsung.com>,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomazs,

On Sat, May 24, 2014 at 1:11 AM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
> Hi Tarek,
>
> With v2 of the series I mentioned in review of previous version [1],
> this patch can be skipped.
>
> [1] http://www.spinics.net/lists/linux-samsung-soc/msg31258.html
>
> Best regards,
> Tomasz
>
> On 23.05.2014 12:35, Tarek Dakhran wrote:
[snip]
>> diff --git a/arch/arm/mach-exynos/firmware.c b/arch/arm/mach-exynos/firmware.c
>> index 739bdc8..971baf0 100644
>> --- a/arch/arm/mach-exynos/firmware.c
>> +++ b/arch/arm/mach-exynos/firmware.c
>> @@ -50,7 +50,7 @@ static int exynos_set_cpu_boot_addr(int cpu, unsigned long boot_addr)
>>
>>       boot_reg = sysram_ns_base_addr + 0x1c;
>>
>> -     if (!soc_is_exynos4212())
>> +     if (!soc_is_exynos4212() && !soc_is_exynos5410())
>>               boot_reg += 4*cpu;
>>
>>       __raw_writel(boot_addr, boot_reg);
>>

I need to define SoC type to set correct bootreg in firmware,
otherwise only one cpu can be booted.
So, this stuff is needed.

Best regards,
     Tarek
