Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350AbaGAB4I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 21:56:08 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:44037 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374AbaGAB4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 21:56:04 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdXFf0VXJikw1d6b6NAC91NUfDvw64oEME=fc7=+Sms98g@mail.gmail.com>
References: <1404097610-5739-1-git-send-email-xerofoify@gmail.com>
	<871tu6ux2c.fsf@igel.home>
	<CAMuHMdXFf0VXJikw1d6b6NAC91NUfDvw64oEME=fc7=+Sms98g@mail.gmail.com>
Date: Mon, 30 Jun 2014 21:56:03 -0400
Message-ID: <CAPDOMVjMU7vWUUeC89dg4aRkvZQf7mB+bNvF7Cazs5JWY1D0Ug@mail.gmail.com>
Subject: Re: [PATCH] Fixes q40_irq_startup to return -ENXIO
From: Nick Krause <xerofoify@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andreas Schwab <schwab@linux-m68k.org>,
        linux-m68k <linux-m68k@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seems fair if there is another way of doing it then I will rewrite this patch.
Cheers Nick

On Mon, Jun 30, 2014 at 1:52 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Mon, Jun 30, 2014 at 7:27 PM, Andreas Schwab <schwab@linux-m68k.org> wrote:
>> Nicholas Krause <xerofoify@gmail.com> writes:
>>
>>> Fixes q40_irq_startup to return -ENXIO for cases 11-13 in the switch
>>> statement of this function to handle these failure cases.
>>>
>>> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
>>> ---
>>>  arch/m68k/q40/q40ints.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/arch/m68k/q40/q40ints.c b/arch/m68k/q40/q40ints.c
>>> index 513f9bb..9dfa1ea 100644
>>> --- a/arch/m68k/q40/q40ints.c
>>> +++ b/arch/m68k/q40/q40ints.c
>>> @@ -49,7 +49,7 @@ static unsigned int q40_irq_startup(struct irq_data *data)
>>>       case 1: case 2: case 8: case 9:
>>>       case 11: case 12: case 13:
>>>               printk("%s: ISA IRQ %d not implemented by HW\n", __func__, irq);
>>> -             /* FIXME return -ENXIO; */
>>> +             return -ENXIO;
>>
>> There must be more to it, given the FIXME.
>
> I think I really just forgot to get rid of it. It was introduced in commit
> c288bf2533e57174b90b07860c4391bcd1ea269c ("m68k/irq: Rename
> irq_controller to irq_chip").
>
> I think I added the FIXME because I got puzzled by the return value change
> from (signed) int to unsigned int, which doesn't match well with a negative
> error number.
>
> However:
>   1. While irq_chip.irq_startup() returns unsigned int, irq_startup()
> does return
>      int (why this difference, historical reasons?), so it becomes a negative
>      number again later,
>   2. The return value of irq_startup() seems to used in
>      kernel/irq/autoprobe.c:probe_irq_on() only, and the actual (non-zero) value
>      doesn't matter, just whether it returns zero or non-zero.
>
> So I'm gonna take this patch, unless someone screams with a very good reason.
>
> Gr{oetje,eeting}s,
>
>                         Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
