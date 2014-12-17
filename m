Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945AbaLQIEz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 03:04:55 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:58450 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbaLQIEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 03:04:54 -0500
MIME-Version: 1.0
In-Reply-To: <20141217065814.GB1018@katana>
References: <1418650624-28174-1-git-send-email-geert@linux-m68k.org>
	<20141217065814.GB1018@katana>
Date: Wed, 17 Dec 2014 09:04:52 +0100
X-Google-Sender-Auth: Ou1Wl23nWnMs85ncpFUssa_U1pw
Message-ID: <CAMuHMdWShh+m_0c_3cnGt_2J03u0dhWytER0AqLWoLtauEh5aA@mail.gmail.com>
Subject: Re: [PATCH] i2c: sh_mobile: I2C_SH_MOBILE should depend on HAS_DMA
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Linux I2C <linux-i2c@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

On Wed, Dec 17, 2014 at 7:58 AM, Wolfram Sang <wsa@the-dreams.de> wrote:
> On Mon, Dec 15, 2014 at 02:37:04PM +0100, Geert Uytterhoeven wrote:
>> If NO_DMA=y:
>>
>> drivers/built-in.o: In function `sh_mobile_i2c_dma_unmap':
>> i2c-sh_mobile.c:(.text+0x60de42): undefined reference to `dma_unmap_single'
>> drivers/built-in.o: In function `sh_mobile_i2c_xfer_dma':
>> i2c-sh_mobile.c:(.text+0x60df22): undefined reference to `dma_map_single'
>> i2c-sh_mobile.c:(.text+0x60df2e): undefined reference to `dma_mapping_error'
>>
>> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>
> Thanks for spotting this. However, since DMA is opt-in, isn't this
> dependency too much? I can't think of anything better than #ifdeffing
> the code, though.

You're right.

E.g. drivers/spi/spi.c (in SPI the mapping is handled by the core), this
code is #ifdefed out.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
