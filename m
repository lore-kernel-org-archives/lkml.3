Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894AbaHLJVA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 05:21:00 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:45834 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551AbaHLJU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 05:20:58 -0400
MIME-Version: 1.0
In-Reply-To: <x49a97apxf6.fsf@segfault.boston.devel.redhat.com>
References: <x49a97apxf6.fsf@segfault.boston.devel.redhat.com>
Date: Tue, 12 Aug 2014 11:20:56 +0200
X-Google-Sender-Auth: UT8uf2LKpuI06r5sbdE53HNsOEM
Message-ID: <CAMuHMdWRsxFt+J0JufFtbUGFJeCncD99K6J538QJzhrxfHPXrg@mail.gmail.com>
Subject: Re: [patch] skd: add build dependency on HARDIRQ
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@fb.com>, Akhil.Bhansali@hgst.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

On Mon, Aug 11, 2014 at 10:46 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
> This driver won't build on architectures without generic hardirq
> support.
>
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
>
> diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
> index 014a1cf..f3a5300 100644
> --- a/drivers/block/Kconfig
> +++ b/drivers/block/Kconfig
> @@ -325,6 +325,7 @@ config BLK_DEV_SKD
>         tristate "STEC S1120 Block Driver"
>         depends on PCI
>         depends on 64BIT
> +       depends on GENERIC_HARDIRQS
>         ---help---
>         Saying Y or M here will enable support for the
>         STEC, Inc. S1120 PCIe SSD.

Which kernel version does this apply to?

GENERIC_HARDIRQS was removed in
commit 0244ad004a54e39308d495fee0a2e637f8b5c317
Author: Martin Schwidefsky <schwidefsky@de.ibm.com>
Date:   Fri Aug 30 09:39:53 2013 +0200

    Remove GENERIC_HARDIRQ config option

    After the last architecture switched to generic hard irqs the config
    options HAVE_GENERIC_HARDIRQS & GENERIC_HARDIRQS and the related code
    for !CONFIG_GENERIC_HARDIRQS can be removed.

    Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>

after it became supported by all architectures.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
