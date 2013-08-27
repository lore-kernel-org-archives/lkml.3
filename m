Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab3H0OaX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 10:30:23 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:42015 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab3H0OaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 10:30:21 -0400
MIME-Version: 1.0
In-Reply-To: <CAGa+x84dE_RwN2G1y_9OJFxnq3JKq5g0YZd+mFueOjjvMzyyew@mail.gmail.com>
References: <1374067753-29560-1-git-send-email-oleksandr.savchenko@ti.com>
	<CAGa+x84dE_RwN2G1y_9OJFxnq3JKq5g0YZd+mFueOjjvMzyyew@mail.gmail.com>
Date: Tue, 27 Aug 2013 07:30:19 -0700
Message-ID: <CAGa+x859+7H3pjZfTFcECe4qMt4=SE_kmToZBt9zoVt0=sUcvA@mail.gmail.com>
Subject: Re: [PATCH] serial: omap: Fix IRQ handling return value
From: Kevin Hilman <khilman@linaro.org>
To: gregkh@linuxfoundation.org
Cc: Alexander Savchenko <oleksandr.savchenko@ti.com>, jslaby@suse.cz,
        linux-serial@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        balbi@ti.com, linux-omap <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,


On Tue, Aug 20, 2013 at 8:44 AM, Kevin Hilman <khilman@linaro.org> wrote:
> +Felipe
>
> On Wed, Jul 17, 2013 at 6:29 AM, Alexander Savchenko
> <oleksandr.savchenko@ti.com> wrote:
>> From: Ruchika Kharwar <ruchika@ti.com>
>>
>> Ensure the Interrupt handling routine return IRQ_HANDLED vs
>> IRQ_NONE.
>
> Why?
>
> By unconditionally returning IRQ_HANDLED, this patch will surely break
> systems where the UART IRQ is shared with other platforms.
>
> I just noticed this patch when bisecting a related problem.  Why
> wasn't this Cc'd to linux-omap where OMAP users might have been more
> likely to see it?
>
> Greg, without a better justification in the changelog, I think this
> patch should be dropped from tty-next.

Can you drop this from tty-next please?

The authors aren't responding (one of the ti.com addresses bounced)
and this "fix" is most is not correct.

Kevin

> Kevin
>
>> Signed-off-by: Ruchika Kharwar <ruchika@ti.com>
>> Signed-off-by: Alexander Savchenko <oleksandr.savchenko@ti.com>
>> ---
>>  drivers/tty/serial/omap-serial.c |    4 +---
>>  1 file changed, 1 insertion(+), 3 deletions(-)
>>
>> diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
>> index b6d1728..70feeb3 100644
>> --- a/drivers/tty/serial/omap-serial.c
>> +++ b/drivers/tty/serial/omap-serial.c
>> @@ -479,7 +479,6 @@ static irqreturn_t serial_omap_irq(int irq, void *dev_id)
>>         struct uart_omap_port *up = dev_id;
>>         unsigned int iir, lsr;
>>         unsigned int type;
>> -       irqreturn_t ret = IRQ_NONE;
>>         int max_count = 256;
>>
>>         spin_lock(&up->port.lock);
>> @@ -490,7 +489,6 @@ static irqreturn_t serial_omap_irq(int irq, void *dev_id)
>>                 if (iir & UART_IIR_NO_INT)
>>                         break;
>>
>> -               ret = IRQ_HANDLED;
>>                 lsr = serial_in(up, UART_LSR);
>>
>>                 /* extract IRQ type from IIR register */
>> @@ -529,7 +527,7 @@ static irqreturn_t serial_omap_irq(int irq, void *dev_id)
>>         pm_runtime_put_autosuspend(up->dev);
>>         up->port_activity = jiffies;
>>
>> -       return ret;
>> +       return IRQ_HANDLED;
>>  }
>>
>>  static unsigned int serial_omap_tx_empty(struct uart_port *port)
>> --
>> 1.7.9.5
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
