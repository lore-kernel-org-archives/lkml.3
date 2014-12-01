Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932505AbaLAQJK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 11:09:10 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:50068 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932397AbaLAQJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 11:09:06 -0500
Message-ID: <547C92A1.8000902@atmel.com>
Date: Mon, 1 Dec 2014 17:09:05 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Valentin Rothberg <valentinrothberg@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [PATCH 1/4] ARM: at91: remove at91sam9263 legacy board support
References: <cover.1416392687.git.nicolas.ferre@atmel.com>	 <cf26d39a4a251662dbc363092b319b788d223a7b.1416392687.git.nicolas.ferre@atmel.com> <1417434775.30245.29.camel@x220>
In-Reply-To: <1417434775.30245.29.camel@x220>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 01/12/2014 12:52, Paul Bolle a écrit :
> On Wed, 2014-11-19 at 11:31 +0100, Nicolas Ferre wrote:
>> Remove legacy support for at91sam9rl boards.
>> This include board files removal plus all legacy code for non DT boards
>> support.
>> Use the Device Tree for running this board with newer kernels.
>>
>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>> ---
> 
> There's some further cleanup possible after this patch. I noticed that
> when it landed in today's linux-next (ie, next-20141201) as commit
> 4403ac46edcd ("ARM: at91: remove at91sam9263 legacy board support").
> 
>>  arch/arm/configs/at91sam9263_defconfig   |  151 ---
>>  arch/arm/mach-at91/Kconfig.non_dt        |   21 -
>>  arch/arm/mach-at91/Makefile              |    4 -
>>  arch/arm/mach-at91/at91sam9263.c         |  399 --------
>>  arch/arm/mach-at91/at91sam9263_devices.c | 1538 ------------------------------
>>  arch/arm/mach-at91/board-sam9263ek.c     |  493 ----------
>>  6 files changed, 2606 deletions(-)
>>  delete mode 100644 arch/arm/configs/at91sam9263_defconfig
>>  delete mode 100644 arch/arm/mach-at91/at91sam9263_devices.c
>>  delete mode 100644 arch/arm/mach-at91/board-sam9263ek.c
>>
>> [...]
>> diff --git a/arch/arm/mach-at91/at91sam9263_devices.c b/arch/arm/mach-at91/at91sam9263_devices.c
>> deleted file mode 100644
>> index cef0e2f57068..000000000000
>> --- a/arch/arm/mach-at91/at91sam9263_devices.c
>> +++ /dev/null
>> [...]
>> -/* --------------------------------------------------------------------
>> - *  RTT
>> - * -------------------------------------------------------------------- */
>> -
>> -static struct resource rtt0_resources[] = {
>> -	{
>> -		.start	= AT91SAM9263_BASE_RTT0,
>> -		.end	= AT91SAM9263_BASE_RTT0 + SZ_16 - 1,
>> -		.flags	= IORESOURCE_MEM,
>> -	}, {
>> -		.flags	= IORESOURCE_MEM,
>> -	}, {
>> -		.flags  = IORESOURCE_IRQ,
>> -	}
>> -};
>> -
>> -static struct platform_device at91sam9263_rtt0_device = {
>> -	.name		= "at91_rtt",
>> -	.id		= 0,
>> -	.resource	= rtt0_resources,
>> -};
>> -
>> -static struct resource rtt1_resources[] = {
>> -	{
>> -		.start	= AT91SAM9263_BASE_RTT1,
>> -		.end	= AT91SAM9263_BASE_RTT1 + SZ_16 - 1,
>> -		.flags	= IORESOURCE_MEM,
>> -	}, {
>> -		.flags	= IORESOURCE_MEM,
>> -	}, {
>> -		.flags  = IORESOURCE_IRQ,
>> -	}
>> -};
>> -
>> -static struct platform_device at91sam9263_rtt1_device = {
>> -	.name		= "at91_rtt",
>> -	.id		= 1,
>> -	.resource	= rtt1_resources,
>> -};
>> -
>> -#if IS_ENABLED(CONFIG_RTC_DRV_AT91SAM9)
>> -static void __init at91_add_device_rtt_rtc(void)
>> -{
>> -	struct platform_device *pdev;
>> -	struct resource *r;
>> -
>> -	switch (CONFIG_RTC_DRV_AT91SAM9_RTT) {
> 
> This and...
> 
>> -	case 0:
>> -		/*
>> -		 * The second resource is needed only for the chosen RTT:
>> -		 * GPBR will serve as the storage for RTC time offset
>> -		 */
>> -		at91sam9263_rtt0_device.num_resources = 3;
>> -		at91sam9263_rtt1_device.num_resources = 1;
>> -		pdev = &at91sam9263_rtt0_device;
>> -		r = rtt0_resources;
>> -		break;
>> -	case 1:
>> -		at91sam9263_rtt0_device.num_resources = 1;
>> -		at91sam9263_rtt1_device.num_resources = 3;
>> -		pdev = &at91sam9263_rtt1_device;
>> -		r = rtt1_resources;
>> -		break;
>> -	default:
>> -		pr_err("at91sam9263: only supports 2 RTT (%d)\n",
>> -		       CONFIG_RTC_DRV_AT91SAM9_RTT);
> 
> this are the only places were the Kconfig symbol RTC_DRV_AT91SAM9_RTT
> was used. It is useless now. That matches its help text, that reads:
>     This option is only relevant for legacy board support and
>     won't be used when booting a DT board.
> 
>> -		return;
>> -	}
>> -
>> -	pdev->name = "rtc-at91sam9";
>> -	r[1].start = AT91SAM9263_BASE_GPBR + 4 * CONFIG_RTC_DRV_AT91SAM9_GPBR;
>> -	r[1].end = r[1].start + 3;
>> -	r[2].start = NR_IRQS_LEGACY + AT91_ID_SYS;
>> -	r[2].end = NR_IRQS_LEGACY + AT91_ID_SYS;
>> -}
>> -#else
>> -static void __init at91_add_device_rtt_rtc(void)
>> -{
>> -	/* Only one resource is needed: RTT not used as RTC */
>> -	at91sam9263_rtt0_device.num_resources = 1;
>> -	at91sam9263_rtt1_device.num_resources = 1;
>> -}
>> -#endif
>> -
>> -static void __init at91_add_device_rtt(void)
>> -{
>> -	at91_add_device_rtt_rtc();
>> -	platform_device_register(&at91sam9263_rtt0_device);
>> -	platform_device_register(&at91sam9263_rtt1_device);
>> -}
> 
> Is a patch to remove that symbol from drivers/rtc/Kconfig queued
> somewhere?

Hi Paul,

In fact these config options are flagged as being useless for !DT. As
the modifications of this Kconfig (in a "drivers" branch) and the
removal of !DT boards (in a "cleaup" branch) will happen in 3.19, I was
planning to come back to these 2 options by removing them later in order
to avoid to solve a merge conflict.

https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/drivers/rtc/Kconfig?id=3969eb48ad7f3f3bef61f5474b7214e601fd2d75

As you can see in the commit above, they have been properly tagged by Boris.

So, I suggest to get rid of them during 3.19-rc phase.

Thanks, bye.
-- 
Nicolas Ferre
