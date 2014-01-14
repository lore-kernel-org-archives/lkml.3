Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618AbaANNXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 08:23:39 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:57314 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbaANNXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 08:23:37 -0500
MIME-Version: 1.0
In-Reply-To: <20140114125242.GE15567@sirena.org.uk>
References: <1389699411-29135-1-git-send-email-geert@linux-m68k.org>
	<20140114125242.GE15567@sirena.org.uk>
Date: Tue, 14 Jan 2014 14:23:37 +0100
X-Google-Sender-Auth: Ax0rtbMRqyqt_5Ciu1llQ3hZZfQ
Message-ID: <CAMuHMdVmSUh8yphZ4oPR=QYp5uMS9BXgPRVuwa19S9q7jWxxiQ@mail.gmail.com>
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

On Tue, Jan 14, 2014 at 1:52 PM, Mark Brown <broonie@kernel.org> wrote:
>On Tue, Jan 14, 2014 at 12:36:51PM +0100, Geert Uytterhoeven wrote:
>
>> The documentation for spi_master.set_cs() says:
>>
>>     assert or deassert chip select, true to assert
>>
>> i.e. its "enable" parameter uses assertion-level logic.

>> For SPI controller-based chip selects, active high chip selects must be
>> handled by the SPI master driver, if supported (some SPI controllers have
>> configurable chip select polarity).
>
> This also pushes the handling of CS_HIGH back out into the driver which
> doesn't seem like it's helping anything.  Flipping the sense of enable

It depends: on hardware with separate register bits for chip select polarity
and chip select assertion it avoids having to invert the enable value a second
time.

> when calling set_cs() is probably OK though.

Just flipping the sense of enable still needs a documentation update.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
