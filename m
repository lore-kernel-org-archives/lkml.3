Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757792AbaDHT6A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 15:58:00 -0400
Received: from mail-qg0-f48.google.com ([209.85.192.48]:54946 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757756AbaDHT56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 15:57:58 -0400
MIME-Version: 1.0
In-Reply-To: <1396865589-9972-2-git-send-email-bigeasy@linutronix.de>
References: <1396865589-9972-1-git-send-email-bigeasy@linutronix.de>
	<1396865589-9972-2-git-send-email-bigeasy@linutronix.de>
Date: Tue, 8 Apr 2014 14:57:57 -0500
Message-ID: <CANk1AXTcZU-xbdw0RTFxtLv38Wb33xkTWa8CPu0vce4ZpUcxEQ@mail.gmail.com>
Subject: Re: [PATCH 1/5] gpio: dwapb: drop irq_setup_generic_chip()
From: delicious quinoa <delicious.quinoa@gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Jamie Iles <jamie@jamieiles.com>, Alan Tull <atull@altera.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dinh Nguyen <dinguyen@altera.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 7, 2014 at 5:13 AM, Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
> The driver calls irq_alloc_domain_generic_chips() which creates a gc and
> adds it to gc_list. The driver later then calls irq_setup_generic_chip()
> which also initializes the gc and adds it to the gc_list() and this
> corrupts the list. Enable LIST_DEBUG and you see the kernel complain.
> This isn't required, irq_alloc_domain_generic_chips() did the init.
>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  drivers/gpio/gpio-dwapb.c | 3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/drivers/gpio/gpio-dwapb.c b/drivers/gpio/gpio-dwapb.c
> index ed5711f..4d25a06b 100644
> --- a/drivers/gpio/gpio-dwapb.c
> +++ b/drivers/gpio/gpio-dwapb.c
> @@ -260,9 +260,6 @@ static void dwapb_configure_irqs(struct dwapb_gpio *gpio,
>         ct->regs.ack = GPIO_PORTA_EOI;
>         ct->regs.mask = GPIO_INTMASK;
>
> -       irq_setup_generic_chip(irq_gc, IRQ_MSK(port->bgc.gc.ngpio),
> -                       IRQ_GC_INIT_NESTED_LOCK, IRQ_NOREQUEST, 0);
> -
>         irq_set_chained_handler(irq, dwapb_irq_handler);
>         irq_set_handler_data(irq, gpio);
>
> --
> 1.9.1


I've tested this patch.  It does fix a problem that was making the
kernel hang while going down for a reboot.

Alan
