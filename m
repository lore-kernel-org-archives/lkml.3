Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560Ab3GUOfk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 10:35:40 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:34004 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755519Ab3GUOfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 10:35:38 -0400
MIME-Version: 1.0
In-Reply-To: <20130701162849.GF10726@kw.sim.vm.gnt>
References: <1372247816-5590-1-git-send-email-simon.guinot@sequanux.org>
	<CACRpkda=BBo+yUcUorYQQasKaF68neSz8cVmq3PcwLGPY_FjtA@mail.gmail.com>
	<20130701162849.GF10726@kw.sim.vm.gnt>
Date: Sun, 21 Jul 2013 16:35:38 +0200
Message-ID: <CACRpkdbsogzeGjK_f45Kr-V1R0ZCo=-2tp+geLqt4+VFnpdrdA@mail.gmail.com>
Subject: Re: [PATCH] gpio: add GPIO support for F71882FG and F71889F
From: Linus Walleij <linus.walleij@linaro.org>
To: Simon Guinot <simon.guinot@sequanux.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vincent Donnefort <vdonnefort@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 1, 2013 at 6:28 PM, Simon Guinot <simon.guinot@sequanux.org> wrote:
> On Sun, Jun 30, 2013 at 01:35:00AM +0200, Linus Walleij wrote:

>> > +static struct platform_driver f7188x_gpio_driver = {
>> > +       .driver = {
>> > +               .owner  = THIS_MODULE,
>> > +               .name   = DRVNAME,
>> > +       },
>> > +       .probe          = f7188x_gpio_probe,
>> > +       .remove         = f7188x_gpio_remove,
>> > +};
>> > +
>> > +static int __init f7188x_gpio_init(void)
>> > +{
>> > +       int err;
>> > +       struct f7188x_sio sio;
>> > +
>> > +       if (f7188x_find(0x2e, &sio) &&
>> > +           f7188x_find(0x4e, &sio))
>> > +               return -ENODEV;
>>
>> This looks like the life on the ISA-bus. Is that not dangerous?
>
> I guess this looks like the ISA bus because this super-I/O uses the LPC
> bus which is ISA-compatible. At my knowledge, reading this I/O ports
> and trying to match the vendor and device IDs is the only way to
> identify the super-I/O chip. For example, have a look at the drivers
> f71882fg (hwmon) and f71808e_wdt (watchdog). Both are using the same
> identification mechanism.

As said yesterday, this is OK, I guess.

Auto-detection is always to be preferred.

I was just worrying if it could somehow be hazardous if this
module is loaded on systems without this hardware.

It also goes against the trend of describing hardware using
things like devicetree or ACPI tables, but that is a broader
discussion and something we cannot always influence.

Yours,
Linus Walleij
