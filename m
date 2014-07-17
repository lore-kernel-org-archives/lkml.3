Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053AbaGQGd7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 02:33:59 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:55854 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951AbaGQGdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 02:33:55 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.10.1407151147540.24854@nanos>
References: <1405413956-2772-1-git-send-email-lftan@altera.com>
	<1405413956-2772-13-git-send-email-lftan@altera.com>
	<alpine.DEB.2.10.1407151147540.24854@nanos>
Date: Thu, 17 Jul 2014 14:33:54 +0800
X-Google-Sender-Auth: 67fmWvK1nFmR2lUGzdqvGtHPYaQ
Message-ID: <CAFiDJ58oEfFN5CgLZxqTLSiGfuxNH2t3OFAaSUWLJ_P_B_QRBQ@mail.gmail.com>
Subject: Re: [PATCH v2 12/29] nios2: Interrupt handling
From: Ley Foon Tan <lftan@altera.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Chung-Lin Tang <cltang@codesourcery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 5:51 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Tue, 15 Jul 2014, Ley Foon Tan wrote:
>> +#ifndef _ASM_NIOS2_IRQ_H
>> +#define _ASM_NIOS2_IRQ_H
>> +
>> +#define NIOS2_CPU_NR_IRQS    32
>> +/* Reserve 32 additional interrupts for GPIO IRQs */
>> +#define NR_IRQS                      (NIOS2_CPU_NR_IRQS + 32)
>
> Please use sparse irqs. Hardcoded limits tend to work out really bad.
Yes, will change this.
>
>> +#include <linux/init.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/of.h>
>> +

>> +static void chip_unmask(struct irq_data *d)
>> +{
>> +     u32 ien;
>> +     ien = RDCTL(CTL_IENABLE);
>> +     ien |= (1 << d->hwirq);
>> +     WRCTL(CTL_IENABLE, ien);
>
> So this is UP only, right?
Yes, this is to enable one interrupt.
>
> Also why don't you cache the register content so spare the extra read
> from the hardware?
Need to make sure nobody modify the register if we cache the register content.
Will keep as it is.

Thanks.

Regards
Ley Foon
