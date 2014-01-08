Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400AbaAHUYj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 15:24:39 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:64432 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653AbaAHUYg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 15:24:36 -0500
MIME-Version: 1.0
In-Reply-To: <1389211403.678513817@f123.i.mail.ru>
References: <1389210991-23688-1-git-send-email-john.tobias.ph@gmail.com>
	<1389211403.678513817@f123.i.mail.ru>
Date: Wed, 8 Jan 2014 12:24:34 -0800
Message-ID: <CACUGKYNnbQQAkw2=NxBhyrgvrwsOoTCqS4qzP1SYev+tXaMGDQ@mail.gmail.com>
Subject: Re: [PATCH v3] ARM: imx: add select on ARCH_MXC for cpufreq support
From: John Tobias <john.tobias.ph@gmail.com>
To: Alexander Shiyan <shc_work@mail.ru>
Cc: "<kernel@pengutronix.de>" <kernel@pengutronix.de>,
        "<linux@arm.linux.org.uk>" <linux@arm.linux.org.uk>,
        "<linux-arm-kernel@lists.infradead.org>" 
	<linux-arm-kernel@lists.infradead.org>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks for the info. Will fix it.

On Wed, Jan 8, 2014 at 12:03 PM, Alexander Shiyan <shc_work@mail.ru> wrote:
> Hello.
>
> Среда,  8 января 2014, 11:56 -08:00 от John Tobias <john.tobias.ph@gmail.com>:
>> Moved ARCH_HAS_CPUFREQ, HAVE_IMX_ANATOP and PM_OPP on ARCH_MXC so that
>> the user can enable the cpufreq support for iMX6Q and/or iMX6SL.
>>
>> Signed-off-by: John Tobias <john.tobias.ph@gmail.com>
>> ---
>>  arch/arm/mach-imx/Kconfig | 13 ++++++-------
>>  1 file changed, 6 insertions(+), 7 deletions(-)
>>
>> diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
>> index 7a6e6f7..3c326be 100644
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
>> +     select HAVE_IMX_ANATOP
>
> Maybe better:
> select HAVE_IMX_ANATOP if ARCH_MULTI_V6_V7
>
> ---
