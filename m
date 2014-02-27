Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679AbaB0I7p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 03:59:45 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:47027 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbaB0I7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 03:59:43 -0500
MIME-Version: 1.0
In-Reply-To: <20140227045032.GN9383@sirena.org.uk>
References: <1393324819-3810-1-git-send-email-geert@linux-m68k.org>
	<20140227045032.GN9383@sirena.org.uk>
Date: Thu, 27 Feb 2014 09:59:42 +0100
X-Google-Sender-Auth: mfs1q54iWq3lRE8MWXzmflVuKWY
Message-ID: <CAMuHMdUx7imXCDWLAF9oOdLi-OtrZovwCpAXkvvq95B8q7m0cw@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] spi: spidev: Restore all SPI mode flags on ioctl failure
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi <linux-spi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Thu, Feb 27, 2014 at 5:50 AM, Mark Brown <broonie@kernel.org> wrote:
> > In commit f477b7fb13df2b843997559ff34e87d054ba6538 ("spi: DUAL and QUAD
> > support"), spi_device.mode was enlarged from 8 to 16 bits.
>
> Applied, thanks.

Thanks a lot!

>> For SPI_IOC_WR_MODE this is probably not so important, as it doesn't allow
>> setting Quad or Dual mode anyway, but SPI_IOC_WR_LSB_FIRST is used to just
>> set or clear a single bit.
>
> Since there's no API for it at present I'd not expect somethng that is
> using spidev to be able to have enabled any of the high mode bits.
> Unless I'm missing some path for this?

No, you're right.

While Quad mode could have been enabled in board info or DT, you can't use
it without setting [rt]x_nbits, and you can't share an SPI slave between spidev
and another driver[*]. I forgot about the latter.

[*] It would be a nice feature for debugging, though. In fact I'm
doing it, as the
    RSPI driver currently ignores the chip select number, so I have 3 m25p80
    drivers (in single, dual, resp. quad mode), and an spidev driver,
all talking to
    the same SPI FLASH.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
