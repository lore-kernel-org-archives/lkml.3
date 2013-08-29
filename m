Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932Ab3H2RYN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 13:24:13 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:60455 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754946Ab3H2RYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 13:24:12 -0400
MIME-Version: 1.0
In-Reply-To: <521F5684.3090703@ti.com>
References: <1377599455-9379-1-git-send-email-george.cherian@ti.com>
	<CACRpkdbME_M8_X=5OttSFKDknqVEKSZc+7u=VLM-T-g3c_uv6Q@mail.gmail.com>
	<521F5684.3090703@ti.com>
Date: Thu, 29 Aug 2013 19:24:11 +0200
Message-ID: <CACRpkdYqHmw13t0Qj19Ko9qvus80eykjt25iXT0GP1aKETP+gQ@mail.gmail.com>
Subject: Re: [PATCH] gpio: pcf857x: cleanup irq_demux_work and use threaded irq
From: Linus Walleij <linus.walleij@linaro.org>
To: George Cherian <george.cherian@ti.com>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Nikolay Balandin <n.a.balandin@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 4:11 PM, George Cherian <george.cherian@ti.com> wrote:
> On 8/29/2013 6:27 PM, Linus Walleij wrote:

>>>          int                     irq;            /* real irq number */
>>> +       int                     irq_mapped;     /* mapped gpio irqs  */
>>
>> This seems like an u32 or atleast unsigned, and state that its one
>> bit flag per IRQ. How many GPIO lines are there?
>
> pcf857x driver supports expanders with 8 and 16 gpio lines.

OK should be an u16 then?

>>>   static int pcf857x_irq_domain_map(struct irq_domain *domain, unsigned
>>> int virq,
>>>                                   irq_hw_number_t hw)
>>>   {
>>> +       struct pcf857x  *gpio = domain->host_data;
>>>          irq_set_chip_and_handler(virq,
>>>                                   &dummy_irq_chip,
>>>                                   handle_level_irq);
>>> +       set_irq_flags(virq, IRQF_VALID);
>>> +       gpio->irq_mapped |= (1 << hw);
>>
>> I'm a bit uneasy about this. It feels like its the irqdomain's
>> responsibility to keep track of whether an IRQ is mapped
>> or not.
>
> Mainly these expanders dont have an ier sort of registers and if at all the
> initial value is not set proper
> then it gives bad irq prints only once per changed bit for which there is no
> handler.
> Should I drop this in v2?

I don't know, I mean if it's causing a problem or filling the console
with error prints it is really annoying, and if there is nothing to do
about the condition then there is not much more we can do I guess.

But please take a second look.

Yours,
Linus Walleij
