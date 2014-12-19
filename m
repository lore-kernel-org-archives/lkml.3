Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168AbaLSIDV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 03:03:21 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:43100 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbaLSIDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 03:03:18 -0500
MIME-Version: 1.0
In-Reply-To: <1418849927.28384.1.camel@perches.com>
References: <1418849927.28384.1.camel@perches.com>
Date: Fri, 19 Dec 2014 09:03:16 +0100
X-Google-Sender-Auth: AtGx1oe7xaXa028NVT69VsGu_5U
Message-ID: <CAMuHMdXGsUeAuV63hknXFkrwFoW+9_SR5wt5tzPJttGnCR_YDQ@mail.gmail.com>
Subject: Re: rfc: remove early_printk from a few arches? (blackfin, m68k, mips)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Joe Perches <joe@perches.com>
Cc: linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-m68k <linux-m68k@vger.kernel.org>,
        Steven Miao <realmz6@gmail.com>, Ralf Baechle <ralf@linux-mips.org>,
        linux-mips <linux-mips@linux-mips.org>,
        Finn Thain <fthain@telegraphics.com.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2014 at 9:58 PM, Joe Perches <joe@perches.com> wrote:
> It seems like early_printk can be configured into
> a few architectures but also appear not to be used.
>
> $ git grep -w "early_printk"

[...]

> arch/m68k/kernel/Makefile:obj-$(CONFIG_EARLY_PRINTK)    += early_printk.o

[...]

> These seem to the only uses:
>
> arch/arm/mach-socfpga/socfpga.c:        early_printk("Early printk initialized\n");
> []
> arch/microblaze/kernel/cpu/cpuinfo-pvr-full.c:  early_printk("ERROR: Microblaze " x "-different for PVR and DTS\n");
> arch/microblaze/kernel/cpu/cpuinfo-static.c:    early_printk("ERROR: Microblaze " x "-different for kernel and DTS\n");
> []
> arch/tile/kernel/early_printk.c:        early_printk("Kernel panic - not syncing: %pV", &vaf);
> []
> arch/x86/kernel/e820.c: early_printk(msg);
> arch/x86/kernel/head64.c:               early_printk("Kernel alive\n");
> arch/x86/kernel/head_64.S:      call early_printk
> []
> kernel/events/core.c:           early_printk("perf interrupt took too long (%lld > %lld), lowering "
>
> So blackfin, m68k, and mips seems to have it possible to enable,
> but also don't appear at first glance to use it,
>
> Is early_printk really used by these architectures?
> Should it be removed?

The m68k "early_printk" match is not about the early_printk()
function, but about
the early printk functionality. Hence nothing to remove there.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
