Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758784Ab3EBV4x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 17:56:53 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:54361 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757230Ab3EBV4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 17:56:52 -0400
Message-ID: <5182E11E.5010103@gmail.com>
Date: Thu, 02 May 2013 23:56:46 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Jean-Francois Moine <moinejf@free.fr>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] irqchip: add support for Marvell Orion SoCs
References: <1367519104-19677-1-git-send-email-sebastian.hesselbarth@gmail.com> <alpine.LFD.2.02.1305022324371.2891@ionos>
In-Reply-To: <alpine.LFD.2.02.1305022324371.2891@ionos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2013 11:34 PM, Thomas Gleixner wrote:
> please do not take the rant below personally. You just happen to
> trigger it.

Thomas,

it is okay for me - but thanks for the notice! I will comment below.

> On Thu, 2 May 2013, Sebastian Hesselbarth wrote:
>> +static void orion_irq_mask(struct irq_data *irqd)
>> +{
>> +	unsigned int irq = irqd_to_hwirq(irqd);
>> +	unsigned int irq_off = irq % 32;
>> +	int reg = irq / 32;
>> +	u32 val;
>> +
>> +	val = readl(orion_irq_base[reg] + ORION_IRQ_MASK);
>> +	writel(val&  ~(1<<  irq_off), orion_irq_base[reg] + ORION_IRQ_MASK);
>> +}
>> +
>> +static void orion_irq_unmask(struct irq_data *irqd)
>> +{
>> +	unsigned int irq = irqd_to_hwirq(irqd);
>> +	unsigned int irq_off = irq % 32;
>> +	int reg = irq / 32;
>> +	u32 val;
>> +
>> +	val = readl(orion_irq_base[reg] + ORION_IRQ_MASK);
>> +	writel(val | (1<<  irq_off), orion_irq_base[reg] + ORION_IRQ_MASK);
>> +}
>
> I'm really tired of looking at the next incarnation of an OF/DT irq
> chip driver, which reimplements stuff which I have consolidated in the
> generic irq chip implementation with a lot of effort.

Actually, non-irqchip implementation of orion intc was based on generic
irq chip already. I took a look at drivers/irqchip and realized that
at least sunxi (ARM again) was reimplementing mask/unmask the way
above. So I took the short path and copied that.

> Just look at the various implementations in drivers/irqchip/ and find
> out how similar they are. Moving code to drivers/irqchip/ does not
> make an excuse for reestablishing the mess which was addressed by the
> generic irq chip implementation.
>
> Can you - and that means all of you ARM folks - please get your gear
> together and add the missing features to the generic irq chip
> implementation? I'm not going to accept more of that OF/DT frenzy.

So you are suggesting to have a "linux,generic-intc" or you want me
to have "marvell,orion-intc" make use of generic irq chip again?

The second is easy, the first will take me a while to think about
proper DT properties how to encode mask/unmask/ack/.. availability
and offsets.

Regards,
   Sebastian
