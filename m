Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356AbaFZLsW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 07:48:22 -0400
Received: from top.free-electrons.com ([176.31.233.9]:34699 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932176AbaFZLsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 07:48:21 -0400
Message-ID: <53AC0882.3010601@free-electrons.com>
Date: Thu, 26 Jun 2014 13:48:18 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: linux@maxim.org.za, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Boris Brezillon <boris@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/13] AT91: PIT: Move the driver to drivers/clocksource
References: <1403701605-26678-1-git-send-email-maxime.ripard@free-electrons.com> <1403701605-26678-14-git-send-email-maxime.ripard@free-electrons.com> <53ABAF1E.5030405@free-electrons.com> <20140626093006.GB3385@lukather>
In-Reply-To: <20140626093006.GB3385@lukather>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 26/06/2014 11:30, Maxime Ripard wrote:
> Hi Boris,
>
> On Thu, Jun 26, 2014 at 07:26:54AM +0200, Boris BREZILLON wrote:
>> On 25/06/2014 15:06, Maxime Ripard wrote:
>>> Now that we don't depend on anyting in the mach-at91 directory, we can just
>>> move the driver to where it belongs.
>>>
>>> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
>>> ---
>>>  arch/arm/mach-at91/Kconfig                                     | 4 ----
>>>  arch/arm/mach-at91/Makefile                                    | 1 -
>>>  drivers/clocksource/Kconfig                                    | 4 ++++
>>>  drivers/clocksource/Makefile                                   | 1 +
>>>  {arch/arm/mach-at91 => drivers/clocksource}/at91sam926x_time.c | 0
>>>  5 files changed, 5 insertions(+), 5 deletions(-)
>>>  rename {arch/arm/mach-at91 => drivers/clocksource}/at91sam926x_time.c (100%)
>>>
>>> diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
>>> index a64412a020d3..b10db0990999 100644
>>> --- a/arch/arm/mach-at91/Kconfig
>>> +++ b/arch/arm/mach-at91/Kconfig
>>> @@ -36,10 +36,6 @@ config AT91_SAM9G45_RESET
>>>  	bool
>>>  	default !ARCH_AT91X40
>>>  
>>> -config AT91_SAM9_TIME
>>> -	select CLKSRC_OF if OF
>>> -	bool
>>> -
>>>  config HAVE_AT91_SMD
>>>  	bool
>>>  
>>> diff --git a/arch/arm/mach-at91/Makefile b/arch/arm/mach-at91/Makefile
>>> index 78e9cec282f4..1a916ececbfd 100644
>>> --- a/arch/arm/mach-at91/Makefile
>>> +++ b/arch/arm/mach-at91/Makefile
>>> @@ -10,7 +10,6 @@ obj-		:=
>>>  obj-$(CONFIG_OLD_CLK_AT91)	+= clock.o
>>>  obj-$(CONFIG_AT91_SAM9_ALT_RESET) += at91sam9_alt_reset.o
>>>  obj-$(CONFIG_AT91_SAM9G45_RESET) += at91sam9g45_reset.o
>>> -obj-$(CONFIG_AT91_SAM9_TIME)	+= at91sam926x_time.o
>>>  obj-$(CONFIG_SOC_AT91SAM9)	+= sam9_smc.o
>>>  
>>>  # CPU-specific support
>>> diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
>>> index 065131cbfcc0..cd8b73ddbef3 100644
>>> --- a/drivers/clocksource/Kconfig
>>> +++ b/drivers/clocksource/Kconfig
>>> @@ -118,6 +118,10 @@ config CLKSRC_ARM_GLOBAL_TIMER_SCHED_CLOCK
>>>  	help
>>>  	 Use ARM global timer clock source as sched_clock
>>>  
>>> +config AT91_SAM9_TIME
>>> +	select CLKSRC_OF if OF
>>> +	bool
>>> +
>>>  config CLKSRC_METAG_GENERIC
>>>  	def_bool y if METAG
>>>  	help
>>> diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
>>> index 800b1303c236..3088928070f8 100644
>>> --- a/drivers/clocksource/Makefile
>>> +++ b/drivers/clocksource/Makefile
>>> @@ -1,5 +1,6 @@
>>>  obj-$(CONFIG_CLKSRC_OF)	+= clksrc-of.o
>>>  obj-$(CONFIG_ATMEL_TCB_CLKSRC)	+= tcb_clksrc.o
>>> +obj-$(CONFIG_AT91_SAM9_TIME)	+= at91sam926x_time.o
>> I would rename both Kconfig and source file name into ATMEL_PIT and
>> atmel_pit.c (or AT91_PIT and atmel_pit.c) to cleary show that this
>> driver add support for the PIT block.
> I actually had the same idea, but older AT91 SoCs (rm9200, for
> example) also mention the PIT, even though the IP is different.

I checked at91rm9200 datasheet, and indeed it mention the concept of PIT
(Periodic Interval Timer), but the HW block is called ST (System Timer).

How about using the name ATMEL_PIT for this driver and later use
ATMEL_ST when we decide to move at91rm9200_time.c driver into
drivers/clocksource ?

>
> Since AT91_PIT was just too generic and only added confusion, I left
> it as is, but maybe we can find a better name.
>
> Maxime
>

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

