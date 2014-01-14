Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898AbaANOos (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 09:44:48 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:56873 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869AbaANOoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 09:44:44 -0500
MIME-Version: 1.0
In-Reply-To: <20140114134528.GG15567@sirena.org.uk>
References: <1389699411-29135-1-git-send-email-geert@linux-m68k.org>
	<20140114125242.GE15567@sirena.org.uk>
	<CAMuHMdVmSUh8yphZ4oPR=QYp5uMS9BXgPRVuwa19S9q7jWxxiQ@mail.gmail.com>
	<20140114134528.GG15567@sirena.org.uk>
Date: Tue, 14 Jan 2014 15:44:43 +0100
X-Google-Sender-Auth: OIAYvQLz3BE1H9Zd3xt4ExRZIFs
Message-ID: <CAMuHMdXEsNKRxYv8gh5sDzpg_QH2RmrjYhLhCZx0QCcRN+gdOg@mail.gmail.com>
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

On Tue, Jan 14, 2014 at 2:45 PM, Mark Brown <broonie@kernel.org> wrote:
> On Tue, Jan 14, 2014 at 02:23:37PM +0100, Geert Uytterhoeven wrote:
>> On Tue, Jan 14, 2014 at 1:52 PM, Mark Brown <broonie@kernel.org> wrote:
>> >On Tue, Jan 14, 2014 at 12:36:51PM +0100, Geert Uytterhoeven wrote:
>
>> > This also pushes the handling of CS_HIGH back out into the driver which
>> > doesn't seem like it's helping anything.  Flipping the sense of enable
>
>> It depends: on hardware with separate register bits for chip select polarity
>> and chip select assertion it avoids having to invert the enable value a second
>> time.
>
> If we're manually setting /CS it really makes no difference what the
> chip thinks the polarity is - something that is controlling /CS
> autonomously can't implement this operation and something that can just
> set it at any time doesn't need to worry if the chip thinks it's
> asserted or not.

Doh, so I'm the only one where it does matter, as RSPI has separate
Slave Select Signal Polarity (high/low) and Slave Select Output Setting
(enable/disable)...

>> > when calling set_cs() is probably OK though.
>
>> Just flipping the sense of enable still needs a documentation update.
>
> Huh?  Why were you updating the code then...

"true to assert" in the documentation means that enable is true when
enabling the chip select.
Currently the value of enable depends on SPI_CS_HIGH. Just "flipping
the sense of enable" doesn't change that dependency.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
