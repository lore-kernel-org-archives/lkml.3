Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab3FOA5Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 20:57:25 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:47347 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053Ab3FOA5X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 20:57:23 -0400
References: <1368917790-23770-1-git-send-email-tomasz.figa@gmail.com> <54821523.hBKS2L2vLj@flatron> <20130614220030.82ECF3E0A56@localhost>
Mime-Version: 1.0 (1.0)
In-Reply-To: <20130614220030.82ECF3E0A56@localhost>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Message-Id: <19FA54F4-522D-4976-9D98-8EA2827D22F6@collabora.co.uk>
Cc: Tomasz Figa <tomasz.figa@gmail.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Mailer: iPhone Mail (10B329)
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: Re: [PATCH] of: irq: Pass trigger type in IRQ resource flags
Date: Sat, 15 Jun 2013 02:57:17 +0200
To: Grant Likely <grant.likely@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 15/06/2013, at 00:00, Grant Likely <grant.likely@linaro.org> wrote:

> On Wed, 05 Jun 2013 20:20:39 +0200, Tomasz Figa <tomasz.figa@gmail.com> wrote:
>> Hi,
>> 
>> On Sunday 19 of May 2013 00:56:30 Tomasz Figa wrote:
>>> Some drivers might rely on availability of trigger flags in IRQ
>>> resource, for example to configure the hardware for particular interrupt
>>> type. However current code creating IRQ resources from data in device
>>> tree does not configure trigger flags in resulting resources.
>>> 
>>> This patch solves the problem, based on the fact that
>>> irq_of_parse_and_map() configures the trigger based on DT interrupt
>>> specifier, IRQD_TRIGGER_* flags are consistent with IORESOURCE_IRQ_*,
>>> and we can get trigger type by calling irqd_get_trigger_type() after
>>> mapping the interrupt.
>>> 
>>> Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
>>> ---
>>> drivers/of/irq.c | 10 ++++++++++
>>> 1 file changed, 10 insertions(+)
>>> 
>>> diff --git a/drivers/of/irq.c b/drivers/of/irq.c
>>> index a3c1c5a..79a7a26 100644
>>> --- a/drivers/of/irq.c
>>> +++ b/drivers/of/irq.c
>>> @@ -355,6 +355,16 @@ int of_irq_to_resource(struct device_node *dev, int
>>> index, struct resource *r) r->start = r->end = irq;
>>>        r->flags = IORESOURCE_IRQ;
>>>        r->name = name ? name : dev->full_name;
>>> +
>>> +        /*
>>> +         * Some drivers might rely on availability of trigger
>> flags
>>> +         * in IRQ resource. Since irq_of_parse_and_map()
>> configures the
>>> +         * trigger based on interrupt specifier and IRQD_TRIGGER_*
>>> +         * flags are consistent with IORESOURCE_IRQ_*, we can get
>>> +         * trigger type that was just set and pass it through
>> resource
>>> +         * flags as well.
>>> +         */
>>> +        r->flags |= irqd_get_trigger_type(irq_get_irq_data(irq));
>>>    }
>>> 
>>>    return irq;
>> 
>> Any comments on this patch?
> 
> That's actually a pretty good solution and a whole lot less invasive
> that the approach that Javier was pursuing. Javier, I'm going to pick
> up this patch. Please yell if it doesn't solve the problem that you're
> trying to solve.
> 
> g.
> 

It solves the issue I was trying to solve and the solution is indeed more elegant and simpler than the one I posted.

Thanks a lot for pointing this out.

Best regards,
Javier