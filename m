Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195AbaLOOKo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:10:44 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:35432 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbaLOOKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:10:39 -0500
MIME-Version: 1.0
In-Reply-To: <20141215090404.6d5cb86e@lwn.net>
References: <1418651737-10016-1-git-send-email-geert@linux-m68k.org>
	<20141215090404.6d5cb86e@lwn.net>
Date: Mon, 15 Dec 2014 15:10:38 +0100
X-Google-Sender-Auth: zUOB4YBvAsgDhPTSrWAUhmonZz8
Message-ID: <CAMuHMdVGXyGJU1SoTMCX4P5BJEStpYrp0_dJ8TqaPhQTC_-guA@mail.gmail.com>
Subject: Re: [PATCH/RESEND] [media] VIDEO_CAFE_CCIC should select VIDEOBUF2_DMA_SG
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jon,

On Mon, Dec 15, 2014 at 3:04 PM, Jonathan Corbet <corbet@lwn.net> wrote:
> On Mon, 15 Dec 2014 14:55:37 +0100
> Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
>> If VIDEO_CAFE_CCIC=y, but VIDEOBUF2_DMA_SG=m:
>>
>> drivers/built-in.o: In function `mcam_v4l_open':
>> mcam-core.c:(.text+0x1c2e81): undefined reference to `vb2_dma_sg_memops'
>> mcam-core.c:(.text+0x1c2eb0): undefined reference to `vb2_dma_sg_init_ctx'
>> drivers/built-in.o: In function `mcam_v4l_release':
>> mcam-core.c:(.text+0x1c34bf): undefined reference to `vb2_dma_sg_cleanup_ctx'
>
> I've been mildly resistant to this because I've never figured out how
> such a configuration can come about.  The Cafe chip only appeared in the
> OLPC XO-1 and cannot even come close to doing S/G I/O.  So this patch
> robs a bit of memory for no use on a platform that can ill afford it.

If the driver cannot do SG, perhaps this block should be removed from
drivers/media/platform/marvell-ccic/mcam-core.h?

    #if IS_ENABLED(CONFIG_VIDEOBUF2_DMA_SG)
    #define MCAM_MODE_DMA_SG 1
    #endif

Oh, this seems to be a reason for the breakage, too: IS_ENABLED()
evaluates to true for modular options...

> OTOH, the number of people building contemporary kernels for the XO-1 has
> got to be pretty small.  So, in the interest of mollifying randconfig
> users out there, you can add my:
>
> Acked-by: Jonathan Corbet <corbet@lwn.net>

Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
