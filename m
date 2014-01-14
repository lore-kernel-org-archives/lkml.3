Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879AbaANPSK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 10:18:10 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:54542 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbaANPSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 10:18:07 -0500
MIME-Version: 1.0
In-Reply-To: <20140114145002.GR15567@sirena.org.uk>
References: <1389699411-29135-1-git-send-email-geert@linux-m68k.org>
	<20140114125242.GE15567@sirena.org.uk>
	<CAMuHMdVmSUh8yphZ4oPR=QYp5uMS9BXgPRVuwa19S9q7jWxxiQ@mail.gmail.com>
	<20140114134528.GG15567@sirena.org.uk>
	<CAMuHMdXEsNKRxYv8gh5sDzpg_QH2RmrjYhLhCZx0QCcRN+gdOg@mail.gmail.com>
	<20140114145002.GR15567@sirena.org.uk>
Date: Tue, 14 Jan 2014 16:18:06 +0100
X-Google-Sender-Auth: RkIIV4sWigkTOGDXe_92Y52vak8
Message-ID: <CAMuHMdVhmtA0ogEqu-jj8Kvii5CwV8qfHn+GzgQ9uFKzH7Ua6w@mail.gmail.com>
Subject: Re: [PATCH/RFC] spi: core: Fix logic mismatch in spi_master.set_cs()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Tue, Jan 14, 2014 at 3:50 PM, Mark Brown <broonie@kernel.org> wrote:
> On Tue, Jan 14, 2014 at 03:44:43PM +0100, Geert Uytterhoeven wrote:
>> On Tue, Jan 14, 2014 at 2:45 PM, Mark Brown <broonie@kernel.org> wrote:
>> >> > when calling set_cs() is probably OK though.
>
>> >> Just flipping the sense of enable still needs a documentation update.
>
>> > Huh?  Why were you updating the code then...
>
>> "true to assert" in the documentation means that enable is true when
>> enabling the chip select.
>> Currently the value of enable depends on SPI_CS_HIGH. Just "flipping
>> the sense of enable" doesn't change that dependency.
>
> Oh, so the code update was purely about factoring that out of the core?

No, it was about fixing the mismatch between code and documentation.

There are two ways to correct the mismatch:
  1. Make the code match the documentation.
      That's what I did, as it avoids a double conditional inversion on RSPI.
  2. Make the documentation match the code.
      It seems this is what you prefer?
      So "assert or deassert chip select, true to assert" has to be replaced by
      "Set the logical level of the chip select line"? Or do you have a better
      suggestion?

Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
