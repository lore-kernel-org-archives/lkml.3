Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758179Ab3DYLZm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 07:25:42 -0400
Received: from multi.imgtec.com ([194.200.65.239]:63549 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756462Ab3DYLZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 07:25:41 -0400
Message-ID: <517912B1.3030109@imgtec.com>
Date: Thu, 25 Apr 2013 12:25:37 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: <linux-kernel@vger.kernel.org>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        <devicetree-discuss@lists.ozlabs.org>, "Rob Landley" <rob@landley.net>,
        <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 3/8] irq-imgpdc: add ImgTec PDC irqchip driver
References: <1366727607-27444-1-git-send-email-james.hogan@imgtec.com> <1366727607-27444-4-git-send-email-james.hogan@imgtec.com> <alpine.LFD.2.02.1304231647400.21884@ionos>
In-Reply-To: <alpine.LFD.2.02.1304231647400.21884@ionos>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_04_25_12_25_38
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On 23/04/13 16:09, Thomas Gleixner wrote:
> On Tue, 23 Apr 2013, James Hogan wrote:
>> +	pdc_write(priv, PDC_IRQ_ROUTE, irq_route);
> 
>> +	spin_unlock_irqrestore(&priv->lock, flags);
>> +}
>> +
>> +static void perip_irq_unmask(struct irq_data *data)
>> +{
>> +	struct pdc_intc_priv *priv = irqd_to_priv(data);
>> +	unsigned int irq_route;
>> +	unsigned long flags;
>> +
>> +	spin_lock_irqsave(&priv->lock, flags);
>> +	irq_route = pdc_read(priv, PDC_IRQ_ROUTE);
>> +	irq_route |= 1 << data->hwirq;
>> +	pdc_write(priv, PDC_IRQ_ROUTE, irq_route);
> 
> This code is another slightly different copy of stuff which is
> available in kernel/irq/generic-chip.c
> 
> Can we please stop the code duplication and reuse existing
> infrastructure? Don't tell me it does not work for you.  I sent out a
> patch yesterday which makes the code suitable for irq domains.

If you're referring to the one that adds the IRQ_GC_MASK_FROM_HWIRQ
flag, as far as I can tell this means I'd have to call
irq_setup_generic_chip on each individual irq (since virqs may not be
linear), or else resort to creating a legacy irqdomain (which I thought
was... well for legacy use).

It feels a bit convoluted, and wrong given that it adds itself to
gc_list. Did I misunderstand how you were expecting me to make use of
the generic chip functions with a linear irqdomain?

Given that your patch presumably isn't upstream yet anyway, is it
acceptable to go with the current version (other fixes applied) and
update it later if necessary?

Thanks
James

