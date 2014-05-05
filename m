Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932916AbaEEOXA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 10:23:00 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:48006 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932743AbaEEOW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 10:22:58 -0400
MIME-Version: 1.0
In-Reply-To: <20140505135701.GA21940@piout.net>
References: <1398705774-12361-1-git-send-email-maxime.ripard@free-electrons.com>
	<20140429183758.GH15125@sirena.org.uk>
	<20140430180609.GC3000@lukather>
	<20140501011811.GF3245@sirena.org.uk>
	<20140501223629.GJ3000@lukather>
	<CAMuHMdUWa1_n94sDvv=L_goc+SOnD9CAKi5DzifrY7GWYRdQmw@mail.gmail.com>
	<20140505041721.GD11606@lukather>
	<CAMuHMdWZ1rvC+tkT=CbfMwZtppyJ_KpzT7JrLd5k5P2oxzA+8g@mail.gmail.com>
	<20140505135701.GA21940@piout.net>
Date: Mon, 5 May 2014 16:22:57 +0200
X-Google-Sender-Auth: byM_RPDYHNsrYfk-3Y9D0kNnLdM
Message-ID: <CAMuHMdU2Wq4VGN5OkOTny6Gze9VFz4kNxWd9ZHhA8ze5diL_NQ@mail.gmail.com>
Subject: Re: [PATCH] spi: Force the registration of the spidev devices
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Mark Brown <broonie@kernel.org>, linux-spi <linux-spi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexandre,

On Mon, May 5, 2014 at 3:57 PM, Alexandre Belloni
<alexandre.belloni@free-electrons.com> wrote:
> On 05/05/2014 at 09:10:43 +0200, Geert Uytterhoeven wrote :
>> On Mon, May 5, 2014 at 6:17 AM, Maxime Ripard
>> <maxime.ripard@free-electrons.com> wrote:
>> > On Fri, May 02, 2014 at 01:28:26AM +0200, Geert Uytterhoeven wrote:
>> >> On Fri, May 2, 2014 at 12:36 AM, Maxime Ripard
>> >> <maxime.ripard@free-electrons.com> wrote:
>> >> > But it actually doesn't work in a case where you can't really predict
>> >> > what is on the other side of the bus. Either because, on the board
>> >> > you're using the pins are exposed and it's pretty much up to the user
>> >> > to know what to put on it. That could be handled by DT overlays
>> >> > though.
>> >> >
>> >> > What never works is where the device on the other side is so generic
>> >> > that you really can't tell what it does. Think of a microcontroller
>> >> > that would behave as a SPI slave. It's behaviour and what it does is
>> >> > pretty much dependant of what we flashed on it, and suddenly the
>> >> > compatible string is not the proper reprensentation anymore.
>> >>
>> >> So you will (hopefully soon) use overlay DT to change the DTS to match what's
>> >> connected?
>> >
>> > Not really, because you can't declare a spidev device in the DT.
>>
>> Yes you can. I've done it before.
>>
>> See also "git grep -w spidev -- arch/arm/*/dts/".
>
> I'm pretty sure that doesn't work as there is no compatible matching
> "spidev"

See the last line of spi_match_device():

        return strcmp(spi->modalias, drv->name) == 0;

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
