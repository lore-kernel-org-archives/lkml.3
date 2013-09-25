Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954Ab3IYXzV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 19:55:21 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:54906 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825Ab3IYXzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 19:55:19 -0400
Message-ID: <524377E3.4050806@linaro.org>
Date: Wed, 25 Sep 2013 16:55:15 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        =?UTF-8?B?VXdlIEtsZWluZS1L?= =?UTF-8?B?w7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de
Subject: Re: [RFC, PATCH] clocksource: provide timekeeping for efm32 SoCs
References: <1379324644-20934-1-git-send-email-u.kleine-koenig@pengutronix.de> <5242F434.7060702@linaro.org> <20130925153207.GG16106@pengutronix.de> <524376A0.7020405@linaro.org>
In-Reply-To: <524376A0.7020405@linaro.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2013 04:49 PM, Daniel Lezcano wrote:
> On 09/25/2013 05:32 PM, Uwe Kleine-König wrote:
>> Hello Daniel,
>>
>> On Wed, Sep 25, 2013 at 04:33:24PM +0200, Daniel Lezcano wrote:
>>> On 09/16/2013 11:44 AM, Uwe Kleine-König wrote:
>>>> diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
>>>> index 41c6946..410b152 100644
>>>> --- a/drivers/clocksource/Kconfig
>>>> +++ b/drivers/clocksource/Kconfig
>>>> @@ -70,6 +70,14 @@ config CLKSRC_DBX500_PRCMU_SCHED_CLOCK
>>>>  	help
>>>>  	  Use the always on PRCMU Timer as sched_clock
>>>>  
>>>> +config CLKSRC_EFM32
>>>> +	bool "Clocksource for Energy Micro's EFM32 SoCs" if !ARCH_EFM32
>>>> +	depends on OF && ARM && (ARCH_EFM32 || COMPILE_TEST)
>>>> +	default ARCH_EFM32
>>>> +	help
>>>> +	  Support to use the timers of EFM32 SoCs as clock source and clock
>>>> +	  event device.
>>>> +
>>> No option for the timer. It must be selected by the platform.
>> It is. If ARCH_EFM32=y there is no prompt and the "default ARCH_EFM32"
>> makes it true.
> ok, with that but if ARCH_EFM32=no, you can enable it manually. AFAIK,
> we want to prevent this and let the correct arch to enable it.
>
> John ?

Right until there's really a compelling reason (which I've still not
heard), I don't want to introduce independent clocksource options. Any
such options should be something like a platform or board config option.

thanks
-john

