Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174AbaBYBnp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 20:43:45 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:53318 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbaBYBnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 20:43:43 -0500
MIME-Version: 1.0
In-Reply-To: <CAMuHMdWF5BnPPFoWPqASQjc+9GCYZQEVcWRZaLNFzdz0rAt0_A@mail.gmail.com>
References: <1392907389-21798-1-git-send-email-geert@linux-m68k.org>
	<1392907389-21798-9-git-send-email-geert@linux-m68k.org>
	<20140222032700.GX25940@sirena.org.uk>
	<CAMuHMdWF5BnPPFoWPqASQjc+9GCYZQEVcWRZaLNFzdz0rAt0_A@mail.gmail.com>
Date: Tue, 25 Feb 2014 10:43:41 +0900
Message-ID: <CANqRtoQG8dsTfahz-A8NpC6tFG7LnALHXZfEsgOrR-t5Eyj8yA@mail.gmail.com>
Subject: Re: [PATCH 08/10] spi: sh-msiof: Move clock management to (un)prepare_message()
From: Magnus Damm <magnus.damm@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mark Brown <broonie@kernel.org>, Takashi Yoshii <takasi-y@ops.dti.ne.jp>,
        linux-spi <linux-spi@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On Mon, Feb 24, 2014 at 6:48 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> Hi Mark, Magnus,
>
> On Sat, Feb 22, 2014 at 4:27 AM, Mark Brown <broonie@kernel.org> wrote:
>> On Thu, Feb 20, 2014 at 03:43:07PM +0100, Geert Uytterhoeven wrote:
>>
>>> +     if (!test_and_set_bit(0, &p->flags)) {
>>> +             pm_runtime_get_sync(&p->pdev->dev);
>>> +             clk_enable(p->clk);
>>> +     }
>>
>> That test_and_set_bit() is a bit odd - what's going on there, perhaps a
>> comment is in order?  I'd also like to see return value checks, though
>
> My first guess was to support multiple CS, but you can't have multiple
> active SPI slaves at the same time.
>
> Perhaps it's because the bitbang core may call the .chipselect() callback
> multiple times with is_on == BITBANG_CS_ACTIVE, and obviously the
> clock should be enabled/disabled only once?
> The current code doesn't seem to do that, but perhaps it was different when
> the sh-msiof driver was written?
>
> Ah, there's also the initial .chipselect(..., BITBANG_CS_INACTIVE) call
> in spi_bitbang_setup(), which should not disable the clock.
> But it should still call sh_msiof_spi_set_pin_regs() and set the optional
> GPIO CS. Which is no longer done after my series. I'll fix that.
>
> Magnus, do you remember the rationale for the test_and_set_bit()?

Sorry, I don't remember. Perhaps it was related to the CS bitbang handling.

> Anyway, it seems safe to remove it, as .(un)prepare_message() is
> guaranteed to be called in matching pairs.

Yes, I agree!

Thanks,

/ magnus
