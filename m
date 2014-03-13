Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbaCMPJw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 11:09:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36418 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753215AbaCMPJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 11:09:50 -0400
Message-ID: <5321CA1E.2040504@redhat.com>
Date: Thu, 13 Mar 2014 16:09:18 +0100
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
CC: linux-arm-kernel@lists.infradead.org,
        devicetree <devicetree@vger.kernel.org>, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 4/4] irqchip: sun4i: Use handle_fasteoi_late_irq for
 the ENMI (irq 0)
References: <1394644627-12315-1-git-send-email-hdegoede@redhat.com> <1394644627-12315-5-git-send-email-hdegoede@redhat.com> <20140313093457.GF2815@lukather> <alpine.DEB.2.02.1403131212090.18573@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1403131212090.18573@ionos.tec.linutronix.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 03/13/2014 12:12 PM, Thomas Gleixner wrote:
> On Thu, 13 Mar 2014, Maxime Ripard wrote:
> 
>> On Wed, Mar 12, 2014 at 06:17:07PM +0100, Hans de Goede wrote:
>>> The ENMI needs to have the ack done *after* clearing the interrupt source,
>>> otherwise we will get a spurious interrupt for each real interrupt. Switch
>>> to the new handle_fasteoi_late_irq handler which gives us the desired behavior.
>>>
>>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>>> ---
>>>  drivers/irqchip/irq-sun4i.c | 11 +++++++++--
>>>  1 file changed, 9 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/irqchip/irq-sun4i.c b/drivers/irqchip/irq-sun4i.c
>>> index 8a2fbee..4b1c874 100644
>>> --- a/drivers/irqchip/irq-sun4i.c
>>> +++ b/drivers/irqchip/irq-sun4i.c
>>> @@ -77,15 +77,22 @@ static void sun4i_irq_unmask(struct irq_data *irqd)
>>>  static struct irq_chip sun4i_irq_chip = {
>>>  	.name		= "sun4i_irq",
>>>  	.irq_ack	= sun4i_irq_ack,
>>> +	.irq_eoi	= sun4i_irq_ack, /* For the ENMI */
>>
>> Hmmm, I wonder if that actually does something.
>>
>> There's been a patch floating around that I was sure was merged, but
>> apparently wasn't that remove sun4i_irq_ack, because the register we
>> were writing to are in read only, and it wasn't doing anything.
> 
> Well, it looks like it does something otherwise Hans would not see any
> improvement of the situation.

Right, I think that what Maxime meant is dropping the ack for all but IRQ 0,
and I've just run some tests and the ack indeed seems to be unnecessary for
all the other IRQs on this irqchip.

Regards,

Hans
