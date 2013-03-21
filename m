Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306Ab3CUSEF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 14:04:05 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:33089 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab3CUSDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 14:03:49 -0400
Message-ID: <514B4B83.60809@gmail.com>
Date: Thu, 21 Mar 2013 13:03:47 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@arm.linux.org.uk>, haojian.zhuang@linaro.org,
        pawel.moll@arm.com, john.stultz@linaro.org, tglx@linutronix.de,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 02/11] ARM: remove extra timer-sp control register clearing
References: <1363820051-24428-1-git-send-email-robherring2@gmail.com> <1363820051-24428-3-git-send-email-robherring2@gmail.com> <CACRpkdZLn=KjJisPTN2eHn64UuaZvpBDDhmeqQXF-TVS8VZ7pA@mail.gmail.com>
In-Reply-To: <CACRpkdZLn=KjJisPTN2eHn64UuaZvpBDDhmeqQXF-TVS8VZ7pA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2013 12:58 PM, Linus Walleij wrote:
> On Wed, Mar 20, 2013 at 11:54 PM, Rob Herring <robherring2@gmail.com> wrote:
> 
>> From: Rob Herring <rob.herring@calxeda.com>
>>
>> The timer-sp initialization code clears the control register before
>> initializing the timers, so every platform doing this is redundant.
>>
>> For unused timers, we should not care what state they are in.
>>
>> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> (...)
>> diff --git a/arch/arm/mach-integrator/integrator_ap.c b/arch/arm/mach-integrator/integrator_ap.c
>> index ea96144..4cb322d 100644
>> --- a/arch/arm/mach-integrator/integrator_ap.c
>> +++ b/arch/arm/mach-integrator/integrator_ap.c
>> @@ -643,10 +643,6 @@ static void __init ap_timer_init(void)
>>         clk_prepare_enable(clk);
>>         rate = clk_get_rate(clk);
>>
>> -       writel(0, TIMER0_VA_BASE + TIMER_CTRL);
>> -       writel(0, TIMER1_VA_BASE + TIMER_CTRL);
>> -       writel(0, TIMER2_VA_BASE + TIMER_CTRL);
>> -
> 
> As noted this is not an init function for timer-sp.c so please drop this
> hunk of the patch. Maybe this zeroing is pointless but that would
> be a separate patch that I can test.

Okay. I'll split this out.

> 
>> diff --git a/arch/arm/mach-integrator/integrator_cp.c b/arch/arm/mach-integrator/integrator_cp.c
>> index 2b0db82..c68e7d8 100644
>> --- a/arch/arm/mach-integrator/integrator_cp.c
>> +++ b/arch/arm/mach-integrator/integrator_cp.c
>> @@ -33,7 +33,6 @@
>>  #include <mach/platform.h>
>>  #include <asm/setup.h>
>>  #include <asm/mach-types.h>
>> -#include <asm/hardware/arm_timer.h>
> 
> What doe this change has to do with $SUBJECT?

If I remove TIMER_CTRL use, then I don't need the header that defines it
any more.

Rob

