Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557Ab3LJN3q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 08:29:46 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:64908 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145Ab3LJN3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 08:29:44 -0500
Message-ID: <52A71746.6080809@linaro.org>
Date: Tue, 10 Dec 2013 14:29:42 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>
CC: Axel Lin <axel.lin@ingics.com>, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH] clocksource: time-efm32: Select CLKSRC_MMIO
References: <1384913711.13115.2.camel@phoenix> <20131210132431.GB18888@pengutronix.de>
In-Reply-To: <20131210132431.GB18888@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2013 02:24 PM, Uwe Kleine-König wrote:
> On Wed, Nov 20, 2013 at 10:15:11AM +0800, Axel Lin wrote:
>> The time-efm32 driver uses the clocksource MMIO functions.
>> Thus it needs to select CLKSRC_MMIO in Kconfig.
>>
>> Signed-off-by: Axel Lin <axel.lin@ingics.com>
>> ---
>> This fixes build error when COMPILE_TEST=y.
>> drivers/built-in.o: In function `efm32_clocksource_init':
>> drivers/clocksource/time-efm32.c:162: undefined reference to `clocksource_mmio_init'
>> drivers/built-in.o: In function `efm32_timer_init':
>> drivers/clocksource/time-efm32.c:274: undefined reference to `clocksource_mmio_readl_up'
>> make: *** [vmlinux] Error 1
>>
>>   drivers/clocksource/Kconfig | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
>> index bdb953e..99763eb 100644
>> --- a/drivers/clocksource/Kconfig
>> +++ b/drivers/clocksource/Kconfig
>> @@ -75,6 +75,7 @@ config CLKSRC_DBX500_PRCMU_SCHED_CLOCK
>>   config CLKSRC_EFM32
>>   	bool "Clocksource for Energy Micro's EFM32 SoCs" if !ARCH_EFM32
>>   	depends on OF && ARM && (ARCH_EFM32 || COMPILE_TEST)
>> +	select CLKSRC_MMIO
>>   	default ARCH_EFM32
> I'd like to send support for arch/arm/mach-efm32 for 3.14. Formerly I
> had ARCH_EFM32 select CLKSRC_MMIO, but having it here is obviously the
> correct thing to do. So my possibilities are:
>
>   a) I take this patch and apply mach-efm32 on top of it; or
>   b) you take it early enough for me into 3.13-rc to base mach-efm32 on
>      it; or

I sent the PR with this patch. If everything is ok, it should be in the 
next -rc.

>   c) I send mach-efm32 with ARCH_EFM32 selecting CLKSRC_MMIO and drop
>      this select later; or
>   d) we life with the build failure (i.e.
>      drivers/clocksource/time-efm32.c:274: undefined reference to
>      `clocksource_mmio_readl_up' and the same for clocksource_mmio_init
>      in a different line) until this patch and mine come together.
>
> I don't like d), but don't have a clear favorite between a), b) and c).
> What do you think? Probably a) is the easiest for all if there are no
> merge conflicts (I don't expect any). In this case I'd need Daniel's or
> Thomas' ack.
>
> Thanks
> Uwe
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

