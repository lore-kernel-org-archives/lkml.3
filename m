Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606AbaH2TN1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 15:13:27 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:64482 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807AbaH2TN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 15:13:26 -0400
MIME-Version: 1.0
In-Reply-To: <20140829173752.GX29327@sirena.org.uk>
References: <1409328631-1420-1-git-send-email-geert@linux-m68k.org>
	<20140829173752.GX29327@sirena.org.uk>
Date: Fri, 29 Aug 2014 21:13:24 +0200
X-Google-Sender-Auth: 0zdyNzCcVPkvGfz5RvFXnsfi9PE
Message-ID: <CAMuHMdW3RBxXNrfK=2d_uHCesE+NaLFheGgdBEP7JuPcd8Xd1Q@mail.gmail.com>
Subject: Re: [PATCH v2] spi/drivers: Restrict COMPILE_TEST by HAS_DMA where needed
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi <linux-spi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Fri, Aug 29, 2014 at 7:37 PM, Mark Brown <broonie@kernel.org> wrote:
> On Fri, Aug 29, 2014 at 06:10:31PM +0200, Geert Uytterhoeven wrote:
>> commit dd1053a93fdc11d4 ("spi/drivers: Enable build of drivers with
>> COMPILE_TEST") allows compile-testing drivers on platforms they're not
>> meant for.
>
>> However, adding "|| COMPILE_TEST" bypasses all other implicit dependencies
>> assumed by the platform dependencies before, like HAS_DMA.
>
> I'm wondering if it isn't better to have the non-DMA platforms define
> stub (always error) DMA functions instead - it's less error prone and
> with SPI there's a bunch of drivers which can run perfectly usefully
> without DMA while optionally supporting DMA.

The SPI problem will sort itself out once all SPI master drivers have been
converted to use the SPI DMA core ;-)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
