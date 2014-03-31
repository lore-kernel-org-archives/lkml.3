Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355AbaCaHqN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 03:46:13 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:37166 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572AbaCaHqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 03:46:12 -0400
MIME-Version: 1.0
In-Reply-To: <1396137686-32678-4-git-send-email-schmitz@debian.org>
References: <1396137686-32678-1-git-send-email-schmitz@debian.org>
	<1396137686-32678-4-git-send-email-schmitz@debian.org>
Date: Mon, 31 Mar 2014 09:46:11 +0200
X-Google-Sender-Auth: AqTpp0zpEVoWDPXb5jjAMffrB0Q
Message-ID: <CAMuHMdWFuh5SpiAwp-0-KCnG=NFJT+DamDZUr2tAwdK=FrVW=w@mail.gmail.com>
Subject: Re: [PATCH 3/4] m68k/atari - ataflop: use correct virt/phys
 translation for DMA buffer
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jens Axboe <axboe@fb.com>
Cc: "Linux/m68k" <linux-m68k@vger.kernel.org>,
        Debian m68k <debian-68k@lists.debian.org>,
        Michael Schmitz <schmitz@debian.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

If you don't object, I'd like to take this one through the m68k tree, as it
depends on a new m68k platform function.

On Sun, Mar 30, 2014 at 1:01 AM, Michael Schmitz <schmitzmic@gmail.com> wrote:
> With new ST-RAM allocation to work also when the kernel is running
> from FastRAM, use dedicated virt/phys translation for this case.
>
> Signed-off-by: Michael Schmitz <schmitz@debian.org>
> ---
>  drivers/block/ataflop.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/block/ataflop.c b/drivers/block/ataflop.c
> index 0e30c6e..f54655a 100644
> --- a/drivers/block/ataflop.c
> +++ b/drivers/block/ataflop.c
> @@ -1952,7 +1952,7 @@ static int __init atari_floppy_init (void)
>                 goto Enomem;
>         }
>         TrackBuffer = DMABuffer + 512;
> -       PhysDMABuffer = virt_to_phys(DMABuffer);
> +       PhysDMABuffer = atari_stram_to_phys(DMABuffer);
>         PhysTrackBuffer = virt_to_phys(TrackBuffer);
>         BufferDrive = BufferSide = BufferTrack = -1;
>
> --
> 1.7.0.4

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
