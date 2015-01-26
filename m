Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894AbbAZN6X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 08:58:23 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:46549 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbbAZN6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 08:58:21 -0500
Message-ID: <54C647FA.7010300@linaro.org>
Date: Mon, 26 Jan 2015 14:58:18 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Baruch Siach <baruch@tkos.co.il>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 2/2] clocksource: driver for Conexant Digicolor SoC
 timer
References: <cover.1422272518.git.baruch@tkos.co.il> <ad84f7155286c45401ff7f6bc6506407cc3beb61.1422272518.git.baruch@tkos.co.il> <54C644AF.9030208@linaro.org> <20150126134751.GE3148@tarshish>
In-Reply-To: <20150126134751.GE3148@tarshish>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2015 02:47 PM, Baruch Siach wrote:
> Hi Daniel,
>
> On Mon, Jan 26, 2015 at 02:44:15PM +0100, Daniel Lezcano wrote:
>>> diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
>>> index 94d90b24b56b..a993c108be67 100644
>>> --- a/drivers/clocksource/Makefile
>>> +++ b/drivers/clocksource/Makefile
>>> @@ -10,6 +10,7 @@ obj-$(CONFIG_SH_TIMER_TMU)	+= sh_tmu.o
>>>   obj-$(CONFIG_EM_TIMER_STI)	+= em_sti.o
>>>   obj-$(CONFIG_CLKBLD_I8253)	+= i8253.o
>>>   obj-$(CONFIG_CLKSRC_MMIO)	+= mmio.o
>>> +obj-$(CONFIG_ARCH_DIGICOLOR)	+= timer-digicolor.o
>>
>> Ah, one minor change I forgot to mention in the last review (sorry about
>> that).
>>
>> Don't depend on the ARCH, add and select a TIMER_DIGICOLOR (or whatever the
>> name you prefer) in the mach-digicolor/Kconfig and use it here.
>
> OK. I'll make the change. I'm just curious: what is the advantage of having a
> separate config symbol for the timer?

It is because some timers could be used in different platforms, so the 
policy of the house is to let the platform Kconfig to select the timer.

Also, that let one platform to not select the timer if it is not needed. 
For example one SoC uses the architected timers and there is not power 
management on the board, hence no cpu is powered down and no backup 
timer is needed.

Even if the timer is expected to be used on only one platform, we try to 
keep the rule consistent across the different drivers (even if I admit 
some cleanups should be done in the Kconfig file).



-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

