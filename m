Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262AbaEBVJU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 17:09:20 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:44633 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399AbaEBVJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 17:09:18 -0400
MIME-Version: 1.0
In-Reply-To: <20140502171411.GS3245@sirena.org.uk>
References: <1399004974-19566-1-git-send-email-geert@linux-m68k.org>
	<20140502171411.GS3245@sirena.org.uk>
Date: Fri, 2 May 2014 23:09:18 +0200
X-Google-Sender-Auth: 7byMtcJaMM75kFVKGpLb1wAWXIg
Message-ID: <CAMuHMdW6kGfVq8y_HV7Aupa7jB9+qdtM4PYGGG54=aCi1AvRYg@mail.gmail.com>
Subject: Re: [PATCH] spi: core: Protect DMA code by #ifdef CONFIG_HAS_DMA
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi <linux-spi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Fri, May 2, 2014 at 7:14 PM, Mark Brown <broonie@kernel.org> wrote:
> On Fri, May 02, 2014 at 06:29:34AM +0200, Geert Uytterhoeven wrote:
>> If NO_DMA=y:
>>
>> drivers/built-in.o: In function `spi_map_buf':
>> spi.c:(.text+0x21bc60): undefined reference to `dma_map_sg'
>> drivers/built-in.o: In function `spi_unmap_buf.isra.33':
>> spi.c:(.text+0x21c32e): undefined reference to `dma_unmap_sg'
>> make[3]: *** [vmlinux] Error 1
>
> Ugh.  It would seem better to have these functions stubbed out.  But

As long as we have include/asm-generic/dma-mapping-broken.h,
it'll be like this...

> applied anyway.

Thanks!

BTW, I have a few more "depends on HAS_DMA" patches lying around for
drivers...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
