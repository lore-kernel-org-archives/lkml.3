Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231AbaGQGPt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 02:15:49 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:50164 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122AbaGQGPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 02:15:45 -0400
MIME-Version: 1.0
In-Reply-To: <5170097.X9RFbxSEnp@wuerfel>
References: <1405413956-2772-1-git-send-email-lftan@altera.com>
	<1405413956-2772-13-git-send-email-lftan@altera.com>
	<5170097.X9RFbxSEnp@wuerfel>
Date: Thu, 17 Jul 2014 14:15:44 +0800
X-Google-Sender-Auth: 7Wz0m9iWKnXNguauLh12JZL13E0
Message-ID: <CAFiDJ5_dTKXSVPtr20uDU32=v_jb3NKUDHGw4OFjW6DuvoZyeA@mail.gmail.com>
Subject: Re: [PATCH v2 12/29] nios2: Interrupt handling
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

On Tue, Jul 15, 2014 at 5:27 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 15 July 2014 16:45:39 Ley Foon Tan wrote:
>> +#ifndef _ASM_NIOS2_IRQ_H
>> +#define _ASM_NIOS2_IRQ_H
>> +
>> +#define NIOS2_CPU_NR_IRQS    32
>> +/* Reserve 32 additional interrupts for GPIO IRQs */
>> +#define NR_IRQS                      (NIOS2_CPU_NR_IRQS + 32)
>
> Is this intentional? I would expect that you use SPARSE_IRQ
> instead and not define NR_IRQS.
Okay, will change to use SPARSE_IRQ.
>
>> +#ifndef NO_IRQ
>> +#define NO_IRQ                       (-1)
>> +#endif
>
> New architectures should no longer define NO_IRQ. Please fix all users
> you encounter instead.
Okay.

>
>> diff --git a/arch/nios2/kernel/irq.c b/arch/nios2/kernel/irq.c
>> new file mode 100644
>> index 0000000..8770d50
>> --- /dev/null
>> +++ b/arch/nios2/kernel/irq.c
>> +#include <linux/init.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/of.h>
>
> Maybe move this into drivers/irqchip/? Probably doesn't matter either way,
> your choice.
Will keep it here.
BTW, this interrupt controller is part of Nios2 cpu architecture.
Should we move to drivers/irqchip/ if that's the case? Any example of
arch doing this?
Thanks.

Regards
Ley Foon
