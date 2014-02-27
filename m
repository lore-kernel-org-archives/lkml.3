Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287AbaB0VAP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 16:00:15 -0500
Received: from exprod5og109.obsmtp.com ([64.18.0.188]:47359 "HELO
	exprod5og109.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751150AbaB0VAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 16:00:13 -0500
MIME-Version: 1.0
In-Reply-To: <87zjlc2xpb.fsf@sofa.wild-wind.fr.eu.org>
References: <1393526095-31479-1-git-send-email-fkan@apm.com>
	<87zjlc2xpb.fsf@sofa.wild-wind.fr.eu.org>
Date: Thu, 27 Feb 2014 13:00:07 -0800
Message-ID: <CAL85gmDk0hxaVbSbqTaVeVFsY4Xt1aKrBx=Pm57g0m0d_Qw-KQ@mail.gmail.com>
Subject: Re: [PATCH V2] irqchip:gic: change access of gicc_ctrl register to
 read modify write.
From: Feng Kan <fkan@apm.com>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: "tglx@linutronix.de" <tglx@linutronix.de>,
        "patches@apm.com" <patches@apm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vinayak Kale <vkale@apm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 10:54 AM, Marc Zyngier <marc.zyngier@arm.com> wrote:
> On Thu, Feb 27 2014 at  6:34:55 pm GMT, Feng Kan <fkan@apm.com> wrote:
>> This change is made to preserve the GIC v2 releated bits in the
>> GIC_CPU_CTRL register (also known as the GICC_CTLR register in spec).
>> The original code only set the enable/disable group bit in this register.
>> This code will preserve the bypass bits configured by the bootload except
>> the enable/disable bit. The main reason for this change is to allow the
>> bypass bits specified in the v2 spec to remain untouched by the current
>> GIC code. In the X-Gene platform, the bypass functionality is not used
>> and bypass must be disabled at all time.
>>
>> Signed-off-by: Vinayak Kale <vkale@apm.com>
>> Acked-by: Anup Patel <apatel@apm.com>
>> Signed-off-by: Feng Kan <fkan@apm.com>
>> ---
>> V2 Changes:
>>       - only mask off v2 bypass bits
>>
>>  drivers/irqchip/irq-gic.c |   22 +++++++++++++++++++---
>>  1 files changed, 19 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
>> index 341c601..757581b 100644
>> --- a/drivers/irqchip/irq-gic.c
>> +++ b/drivers/irqchip/irq-gic.c
>> @@ -418,6 +418,7 @@ static void gic_cpu_init(struct gic_chip_data *gic)
>>       void __iomem *dist_base = gic_data_dist_base(gic);
>>       void __iomem *base = gic_data_cpu_base(gic);
>>       unsigned int cpu_mask, cpu = smp_processor_id();
>> +     unsigned int ctrl_mask;
>>       int i;
>>
>>       /*
>> @@ -449,13 +450,24 @@ static void gic_cpu_init(struct gic_chip_data *gic)
>>               writel_relaxed(0xa0a0a0a0, dist_base + GIC_DIST_PRI + i * 4 / 4);
>>
>>       writel_relaxed(0xf0, base + GIC_CPU_PRIMASK);
>> -     writel_relaxed(1, base + GIC_CPU_CTRL);
>> +
>> +     ctrl_mask = readl(base + GIC_CPU_CTRL);
>> +     ctrl_mask |= 0x1;
>> +     writel_relaxed(ctrl_mask, base + GIC_CPU_CTRL);
>
> I think I'm quickly loosing the will to live, or at least to review this
> patch any further.
Hang in there Marc, though I had nothing to do with the flood in England. Maybe
I can instill a bit more will for you to live.

>
>         M.
> --
> AAAFNRAA
