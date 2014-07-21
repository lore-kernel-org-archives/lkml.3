Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491AbaGUKHI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 06:07:08 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:38624 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143AbaGUKHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 06:07:03 -0400
MIME-Version: 1.0
In-Reply-To: <5348663.eHVXUR5shS@wuerfel>
References: <1405413956-2772-1-git-send-email-lftan@altera.com>
	<1405413956-2772-20-git-send-email-lftan@altera.com>
	<5348663.eHVXUR5shS@wuerfel>
Date: Mon, 21 Jul 2014 18:07:02 +0800
X-Google-Sender-Auth: GBJj4VnmyjcAj7OtJwKM8N-5HhQ
Message-ID: <CAFiDJ5-v7BEuLNEn0OyLpbLUJkeeZuKnDrFZZwQrjhFSU4PZSw@mail.gmail.com>
Subject: Re: [PATCH v2 19/29] nios2: Time keeping
From: Ley Foon Tan <lftan@altera.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Chung-Lin Tang <cltang@codesourcery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 5:45 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 15 July 2014 16:45:46 Ley Foon Tan wrote:
>> +
>> +static inline void __delay(unsigned long loops)
>> +{
>> +     int dummy;
>> +
>> +     __asm__ __volatile__(
>> +     "1:\n\t"
>> +     "    beq    %0,zero,2f\n\t"
>> +     "    addi   %0, %0, -1\n\t"
>> +     "    br     1b\n\t"
>> +     "2:\n\t"
>> +     :  "=r" (dummy)         /* Need output for optimizer */
>> +     :  "0" (loops));        /* %0  Input */
>> +}
>
> Do you have a reliable clock source? If you do, it would be better
> to replace the delay loop with an implementation that waits for
> the exact time to pass instead. This will also avoid the loop
> calibration during boot and give you better boot times.
Okay, will change this to use timer instead.

>
>> +#ifndef _ASM_NIOS2_TIMEX_H
>> +#define _ASM_NIOS2_TIMEX_H
>> +
>> +/* Supply dummy tick-rate. Real value will be read from devicetree */
>> +#define CLOCK_TICK_RATE              (HZ * 100000UL)
>> +
>> +#include <asm-generic/timex.h>
>> +
>> +#endif
>
> CLOCK_TICK_RATE is no longer used anywhere, no need for this file.

I found jiffies.h still using this define. Can we still remove this?
In include/linux/jiffies.h:
#define LATCH ((CLOCK_TICK_RATE + HZ/2) / HZ)   /* For divider */

>
>> diff --git a/arch/nios2/kernel/time.c b/arch/nios2/kernel/time.c
>> new file mode 100644
>> index 0000000..111ade1
>> --- /dev/null
>> +++ b/arch/nios2/kernel/time.c
>
> Maybe move this to drivers/clocksource? Same argument as for the
> irqchip driver, so either move both or neither.
Will keep this here since we don't move irq driver.

Thanks.

Regards
Ley Foon
