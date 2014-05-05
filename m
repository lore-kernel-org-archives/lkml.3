Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbaEEHKq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 03:10:46 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:52718 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473AbaEEHKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 03:10:44 -0400
MIME-Version: 1.0
In-Reply-To: <20140505041721.GD11606@lukather>
References: <1398705774-12361-1-git-send-email-maxime.ripard@free-electrons.com>
	<20140429183758.GH15125@sirena.org.uk>
	<20140430180609.GC3000@lukather>
	<20140501011811.GF3245@sirena.org.uk>
	<20140501223629.GJ3000@lukather>
	<CAMuHMdUWa1_n94sDvv=L_goc+SOnD9CAKi5DzifrY7GWYRdQmw@mail.gmail.com>
	<20140505041721.GD11606@lukather>
Date: Mon, 5 May 2014 09:10:43 +0200
X-Google-Sender-Auth: tcUAwlccfrRS5ijP3akiqxqoYLQ
Message-ID: <CAMuHMdWZ1rvC+tkT=CbfMwZtppyJ_KpzT7JrLd5k5P2oxzA+8g@mail.gmail.com>
Subject: Re: [PATCH] spi: Force the registration of the spidev devices
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Mark Brown <broonie@kernel.org>, linux-spi <linux-spi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maxime,

On Mon, May 5, 2014 at 6:17 AM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:
> On Fri, May 02, 2014 at 01:28:26AM +0200, Geert Uytterhoeven wrote:
>> On Fri, May 2, 2014 at 12:36 AM, Maxime Ripard
>> <maxime.ripard@free-electrons.com> wrote:
>> > But it actually doesn't work in a case where you can't really predict
>> > what is on the other side of the bus. Either because, on the board
>> > you're using the pins are exposed and it's pretty much up to the user
>> > to know what to put on it. That could be handled by DT overlays
>> > though.
>> >
>> > What never works is where the device on the other side is so generic
>> > that you really can't tell what it does. Think of a microcontroller
>> > that would behave as a SPI slave. It's behaviour and what it does is
>> > pretty much dependant of what we flashed on it, and suddenly the
>> > compatible string is not the proper reprensentation anymore.
>>
>> So you will (hopefully soon) use overlay DT to change the DTS to match what's
>> connected?
>
> Not really, because you can't declare a spidev device in the DT.

Yes you can. I've done it before.

See also "git grep -w spidev -- arch/arm/*/dts/".

>> And then you want spidev to bind to it. Would it help if DT offered a feature
>> to add a compatible entry to a driver at runtime, cfr.
>> /sys/bus/pci/drivers/.../new_id on PCI?
>
> The thing is, in the core SPI bus, devices are only instiated (in the
> DT case), by parsing the DT. So, to bind a device to a new driver, it
> has to exist in the first place, and it won't exist, because there
> won't be any node in the DT for this device. But since DT is
> unsuitable for such a device, you go back to where we were initially.

So you add a node in the overlay DT? Or what am I missing?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
