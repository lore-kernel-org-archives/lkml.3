Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264AbaICQkW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 12:40:22 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:36516 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889AbaICQkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 12:40:21 -0400
Message-ID: <5407444C.2080107@gmail.com>
Date: Wed, 03 Sep 2014 09:39:40 -0700
From: Florian Fainelli <f.fainelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, jason@lakedaemon.net,
        computersforpeace@gmail.com
Subject: Re: [PATCH 1/2] irqchip: add Broadcom BCM7120-style Level 2 interrupt
 controller
References: <1409265326-7579-1-git-send-email-f.fainelli@gmail.com> <1409265326-7579-2-git-send-email-f.fainelli@gmail.com> <alpine.DEB.2.10.1409031413230.3333@nanos>
In-Reply-To: <alpine.DEB.2.10.1409031413230.3333@nanos>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2014 05:18 AM, Thomas Gleixner wrote:
> On Thu, 28 Aug 2014, Florian Fainelli wrote:
>> +static void bcm7120_l2_intc_irq_handle(unsigned int irq, struct irq_desc *desc)
>> +{
>> +	struct bcm7120_l2_intc_data *b = irq_desc_get_handler_data(desc);
>> +	struct irq_chip *chip = irq_desc_get_chip(desc);
>> +	struct irq_chip_generic *gc = irq_get_domain_generic_chip(b->domain, 0);
>> +	u32 status;
>> +
>> +	chained_irq_enter(chip, desc);
>> +
>> +	irq_gc_lock(gc);
>> +	status = __raw_readl(b->base + IRQSTAT);
>> +	irq_gc_unlock(gc);
> 
> Why do you need locking around the status read out?

I was worried about potential concurrency issues, but I suppose that
this is just extra carefulness that brings nothing.

> 
>> +	for (irq = 0; irq < num_parent_irqs; irq++) {
>> +		ret = bcm7120_l2_intc_init_one(dn, data, irq, map_mask);
>> +		if (ret)
>> +			continue;
> 
> What's the exact purpose of this "if (ret)" construct?

It's pretty much useless the way it is now, I will rework that.

Thanks for the review!
--
Florian
