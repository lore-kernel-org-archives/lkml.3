Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569AbbATSfq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 13:35:46 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:53782 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165AbbATSfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 13:35:44 -0500
MIME-Version: 1.0
In-Reply-To: <54BE5F3C.50907@ti.com>
References: <1421624259-24127-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<54BC8F2B.10509@ti.com>
	<54BE5F3C.50907@ti.com>
Date: Tue, 20 Jan 2015 19:35:41 +0100
Message-ID: <CAKXHbyPtoF2UqjCFu5VsxNSRRyjgxFda9jnY+kcN5Lh2FNkkOA@mail.gmail.com>
Subject: Re: [PATCH] ARM: mach-davinci: Remove driver CDCE949
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Sekhar Nori <nsekhar@ti.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2015-01-20 14:59 GMT+01:00 Sekhar Nori <nsekhar@ti.com>:
> On Monday 19 January 2015 10:29 AM, Sekhar Nori wrote:
>> Hi,
>>
>> On Monday 19 January 2015 05:07 AM, Rickard Strandqvist wrote:
>>> Remove driver CDCE949 because it is not used anywhere.
>>>
>>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>>
>>
>>> diff --git a/arch/arm/mach-davinci/board-dm646x-evm.c b/arch/arm/mach-davinci/board-dm646x-evm.c
>>> index ae129bc..8be5aef 100644
>>> --- a/arch/arm/mach-davinci/board-dm646x-evm.c
>>> +++ b/arch/arm/mach-davinci/board-dm646x-evm.c
>>> @@ -45,7 +45,6 @@
>>>  #include <mach/irqs.h>
>>>  #include <mach/serial.h>
>>>  #include <mach/clock.h>
>>> -#include <mach/cdce949.h>
>>>
>>>  #include "davinci.h"
>>>  #include "clock.h"
>>> @@ -399,9 +398,6 @@ static struct i2c_board_info __initdata i2c_info[] =  {
>>>      {
>>>              I2C_BOARD_INFO("cpld_video", 0x3b),
>>>      },
>>> -    {
>>> -            I2C_BOARD_INFO("cdce949", 0x6c),
>>> -    },
>>>  };
>>
>> There is cdce_clk_init() and associated data structures that also need
>> to be removed.
>
> In the interest of time, I made this change myself.
> I will be merging the attached patch with this one.
>
> Thanks,
> Sekhar
>
> ---8<---
> diff --git a/arch/arm/mach-davinci/board-dm646x-evm.c b/arch/arm/mach-davinci/board-dm646x-evm.c
> index 8be5aef3aca9..846a84ddc28e 100644
> --- a/arch/arm/mach-davinci/board-dm646x-evm.c
> +++ b/arch/arm/mach-davinci/board-dm646x-evm.c
> @@ -711,31 +711,6 @@ static void __init evm_init_i2c(void)
>         evm_init_video();
>  }
>
> -#define CDCE949_XIN_RATE       27000000
> -
> -/* CDCE949 support - "lpsc" field is overridden to work as clock number */
> -static struct clk cdce_clk_in = {
> -       .name   = "cdce_xin",
> -       .rate   = CDCE949_XIN_RATE,
> -};
> -
> -static struct clk_lookup cdce_clks[] = {
> -       CLK(NULL, "xin", &cdce_clk_in),
> -       CLK(NULL, NULL, NULL),
> -};
> -
> -static void __init cdce_clk_init(void)
> -{
> -       struct clk_lookup *c;
> -       struct clk *clk;
> -
> -       for (c = cdce_clks; c->clk; c++) {
> -               clk = c->clk;
> -               clkdev_add(c);
> -               clk_register(clk);
> -       }
> -}
> -
>  #define DM6467T_EVM_REF_FREQ           33000000
>
>  static void __init davinci_map_io(void)
> @@ -744,8 +719,6 @@ static void __init davinci_map_io(void)
>
>         if (machine_is_davinci_dm6467tevm())
>                 davinci_set_refclk_rate(DM6467T_EVM_REF_FREQ);
> -
> -       cdce_clk_init();
>  }
>
>  #define DM646X_EVM_PHY_ID              "davinci_mdio-0:01"
>


Hello Sekhar

I had started a bit on this, but seeing that I missed the answer you
that I had started.
But then there is a solution now, and that was the important thing :)

Kind regards
Rickard Strandqvist
