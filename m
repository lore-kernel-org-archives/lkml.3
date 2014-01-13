Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751283AbaAMEyZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 23:54:25 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:48316 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbaAMEyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 23:54:21 -0500
MIME-Version: 1.0
In-Reply-To: <20140113032043.GF23525@S2101-09.ap.freescale.net>
References: <1389321592-33220-1-git-send-email-john.tobias.ph@gmail.com>
	<20140113032043.GF23525@S2101-09.ap.freescale.net>
Date: Sun, 12 Jan 2014 20:54:18 -0800
Message-ID: <CACUGKYMx_o6TLsvMxK3Gb+cmOUCX3Toj+6MeJmo=ahfyc=vXCA@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] ARM: imx: add select on ARCH_MXC for cpufreq support
From: John Tobias <john.tobias.ph@gmail.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: rjw@rjwysocki.net, Viresh Kumar <viresh.kumar@linaro.org>,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "<kernel@pengutronix.de>" <kernel@pengutronix.de>,
        "<linux@arm.linux.org.uk>" <linux@arm.linux.org.uk>,
        "<linux-arm-kernel@lists.infradead.org>" 
	<linux-arm-kernel@lists.infradead.org>,
        Fabio Estevam <festevam@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I tested leaving the HAVE_IMX_ANATOP under SOC_IMX6Q and SOC_IMX6SL.
The iMX6Q cpufreq driver won't show up in menu config / gconfig and
that's the reason why I added it.

Regards,

john

On Sun, Jan 12, 2014 at 7:20 PM, Shawn Guo <shawn.guo@linaro.org> wrote:
> On Thu, Jan 09, 2014 at 06:39:51PM -0800, John Tobias wrote:
>> Moved ARCH_HAS_CPUFREQ, HAVE_IMX_ANATOP and PM_OPP on ARCH_MXC so that
>> the user can enable the cpufreq support for iMX6Q and/or iMX6SL.
>
> All I was asking is to move the following:
>
>         select ARCH_HAS_CPUFREQ
>         select ARCH_HAS_OPP
>         select PM_OPP if PM
>
> So leave HAVE_IMX_ANATOP out there, and only move the above ones please.
>
> Shawn
>
>>
>> Signed-off-by: John Tobias <john.tobias.ph@gmail.com>
>> ---
>>  arch/arm/mach-imx/Kconfig | 13 ++++++-------
>>  1 file changed, 6 insertions(+), 7 deletions(-)
>>
>> diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
>> index 7a6e6f7..d6aa34d 100644
>> --- a/arch/arm/mach-imx/Kconfig
>> +++ b/arch/arm/mach-imx/Kconfig
>> @@ -1,5 +1,6 @@
>>  config ARCH_MXC
>>       bool "Freescale i.MX family" if ARCH_MULTI_V4_V5 || ARCH_MULTI_V6_V7
>> +     select ARCH_HAS_CPUFREQ
>>       select ARCH_REQUIRE_GPIOLIB
>>       select ARM_CPU_SUSPEND if PM
>>       select ARM_PATCH_PHYS_VIRT
>> @@ -9,8 +10,10 @@ config ARCH_MXC
>>       select GENERIC_ALLOCATOR
>>       select GENERIC_CLOCKEVENTS
>>       select GENERIC_IRQ_CHIP
>> +     select HAVE_IMX_ANATOP if SOC_IMX6Q || SOC_IMX6SL
>>       select MIGHT_HAVE_CACHE_L2X0 if ARCH_MULTI_V6_V7
>>       select MULTI_IRQ_HANDLER
>> +     select PM_OPP if PM
>>       select SOC_BUS
>>       select SPARSE_IRQ
>>       select USE_OF
>> @@ -779,16 +782,14 @@ config  SOC_IMX53
>>
>>  config SOC_IMX6Q
>>       bool "i.MX6 Quad/DualLite support"
>> -     select ARCH_HAS_CPUFREQ
>> -     select ARCH_HAS_OPP
>> +     select ARCH_HAS_OPP
>>       select ARM_ERRATA_754322
>>       select ARM_ERRATA_764369 if SMP
>>       select ARM_ERRATA_775420
>>       select ARM_GIC
>>       select CPU_V7
>>       select HAVE_ARM_SCU if SMP
>> -     select HAVE_ARM_TWD if SMP
>> -     select HAVE_IMX_ANATOP
>> +     select HAVE_ARM_TWD if SMP
>>       select HAVE_IMX_GPC
>>       select HAVE_IMX_MMDC
>>       select HAVE_IMX_SRC
>> @@ -800,8 +801,7 @@ config SOC_IMX6Q
>>       select PINCTRL_IMX6Q
>>       select PL310_ERRATA_588369 if CACHE_PL310
>>       select PL310_ERRATA_727915 if CACHE_PL310
>> -     select PL310_ERRATA_769419 if CACHE_PL310
>> -     select PM_OPP if PM
>> +     select PL310_ERRATA_769419 if CACHE_PL310
>>
>>       help
>>         This enables support for Freescale i.MX6 Quad processor.
>> @@ -812,7 +812,6 @@ config SOC_IMX6SL
>>       select ARM_ERRATA_775420
>>       select ARM_GIC
>>       select CPU_V7
>> -     select HAVE_IMX_ANATOP
>>       select HAVE_IMX_GPC
>>       select HAVE_IMX_MMDC
>>       select HAVE_IMX_SRC
>> --
>> 1.8.3.2
>>
>
