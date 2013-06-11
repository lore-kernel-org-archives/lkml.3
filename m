Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430Ab3FKNhY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 09:37:24 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:53065 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab3FKNhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 09:37:23 -0400
Message-ID: <51B7280B.7080604@gmail.com>
Date: Tue, 11 Jun 2013 15:37:15 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        John Stultz <john.stultz@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/6] irqchip: add support for Marvell Orion SoCs
References: <1370536034-23956-1-git-send-email-sebastian.hesselbarth@gmail.com> <1370536034-23956-2-git-send-email-sebastian.hesselbarth@gmail.com> <alpine.LFD.2.02.1306111045520.22970@ionos> <alpine.LFD.2.02.1306111525180.22970@ionos>
In-Reply-To: <alpine.LFD.2.02.1306111525180.22970@ionos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/13 15:30, Thomas Gleixner wrote:
> On Tue, 11 Jun 2013, Thomas Gleixner wrote:
>
>> On Thu, 6 Jun 2013, Sebastian Hesselbarth wrote:
>>
>>> This patch adds an irqchip driver for the main interrupt controller found
>>> on Marvell Orion SoCs (Kirkwood, Dove, Orion5x, Discovery Innovation).
>>> Corresponding device tree documentation is also added.
>>>
>>> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>>
>> Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
>
> Second thoughts:
>
>> +static void orion_bridge_irq_handler(unsigned int irq, struct irq_desc *desc)
>> +{
>> +	struct irq_domain *d = irq_get_handler_data(irq);
>> +	struct irq_chip_generic *gc = irq_get_domain_generic_chip(d, irq);
>> +	u32 stat = readl_relaxed(gc->reg_base + ORION_BRIDGE_IRQ_CAUSE) &
>> +		gc->mask_cache;
>
> In init you map the first irq of that chip and install the chain
> handler for it. Now if that first irq fires, isn't that set in the
> cause register as well? And what acks that first irq?

It is "acked" by acking all unmasked bridge irqs.

Sebastian

