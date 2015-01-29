Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407AbbA2NxD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 08:53:03 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:56473 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbbA2NxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 08:53:01 -0500
Message-ID: <54CA3B38.507@linaro.org>
Date: Thu, 29 Jan 2015 14:52:56 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: tglx@linutronix.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Barry.Song@csr.com,
        baruch@tkos.co.il, linux@rempel-privat.de, rob.herring@linaro.org,
        thierry.reding@gmail.com
Subject: Re: [PATCH 6/9] clocksource: Driver for Conexant Digicolor SoC timer
References: <54CA3044.6070501@linaro.org>	 <1422536899-16609-1-git-send-email-daniel.lezcano@linaro.org>	 <1422536899-16609-6-git-send-email-daniel.lezcano@linaro.org> <1422538656.32520.4.camel@x220>
In-Reply-To: <1422538656.32520.4.camel@x220>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2015 02:37 PM, Paul Bolle wrote:
> On Thu, 2015-01-29 at 14:08 +0100, Daniel Lezcano wrote:
>> From: Baruch Siach <baruch@tkos.co.il>
>>
>> Add clocksource driver to the Conexant CX92755 SoC, part of the Digicolor SoCs
>> series. Hardware provides 8 timers, A to H. Timer A is dedicated to a future
>> watchdog driver so we don't use it here. Use timer B for sched_clock, and timer
>> C for clock_event.
>>
>> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
>> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
>> ---
>>   drivers/clocksource/Kconfig           |   3 +
>>   drivers/clocksource/Makefile          |   1 +
>>   drivers/clocksource/timer-digicolor.c | 199 ++++++++++++++++++++++++++++++++++
>>   3 files changed, 203 insertions(+)
>>   create mode 100644 drivers/clocksource/timer-digicolor.c
>>
>> diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
>> index a89120b..72a3827 100644
>> --- a/drivers/clocksource/Kconfig
>> +++ b/drivers/clocksource/Kconfig
>> @@ -18,6 +18,9 @@ config CLKBLD_I8253
>>   config CLKSRC_MMIO
>>   	bool
>>
>> +config DIGICOLOR_TIMER
>> +	bool
>> +
>
> And the select for this symbol (see https://lkml.org/lkml/2015/1/26/360)
> will be provided in a separate patch? Because this patch, by itself,
> won't allow DIGICOLOR_TIMER to be set, will it?

You are right, that should be done in a separate patch. I believe Baruch 
should have done that.

-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

