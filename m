Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308AbaJIN7V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 09:59:21 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:50861 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbaJIN7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 09:59:11 -0400
MIME-Version: 1.0
In-Reply-To: <20141008182123.GH4609@sirena.org.uk>
References: <rjui@broadcom.com>
	<1412743127-4523-1-git-send-email-rjui@broadcom.com>
	<20141008112143.GT4609@sirena.org.uk>
	<543562EB.8060300@broadcom.com>
	<20141008182123.GH4609@sirena.org.uk>
Date: Thu, 9 Oct 2014 15:59:05 +0200
X-Google-Sender-Auth: o_H8wFrdVrTSE9kbb7HwZoVnK6I
Message-ID: <CAMuHMdUyP-caZxTNWTTF1Z84+=RWzi673LdRbmd_Bovr_G0kqA@mail.gmail.com>
Subject: Re: [PATCH] spi: pl022: Fix broken spidev when DMA is enabled
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>
Cc: Ray Jui <rjui@broadcom.com>, Grant Likely <grant.likely@linaro.org>,
        linux-spi <linux-spi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JD Zheng <jdzheng@broadcom.com>, Scott Branden <sbranden@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 8, 2014 at 8:21 PM, Mark Brown <broonie@kernel.org> wrote:
> On Wed, Oct 08, 2014 at 09:14:35AM -0700, Ray Jui wrote:
>> Thanks for the reply. It looks like you are also the maintainer of spidev.
>> In this case, could you please help to confirm that you expect spidev to use
>> separate buffers for TX and RX? If so, I can go ahead and make the change in
>> spidev.
>
> Yes, that would be my expectation for maximum robustness (or if it is
> going to use one buffer it explicitly maps it for mixed use but I'd
> expect that to be asking for trouble).

Having two separate buffers avoids false successes when running
"spidev_test --loop" on a buggy SPI master driver.
Been there, done that ;-)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
