Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283Ab3ENMGx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 08:06:53 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:60063 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756288Ab3ENMGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 08:06:52 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1305122242430.5463@ayla.of.borg>
References: <alpine.DEB.2.00.1305122130270.3789@ayla.of.borg>
	<alpine.DEB.2.00.1305122239040.5463@ayla.of.borg>
	<alpine.DEB.2.00.1305122242430.5463@ayla.of.borg>
Date: Tue, 14 May 2013 14:06:51 +0200
X-Google-Sender-Auth: UXnmfUBKoRtNev_-YcJgTl8uXIg
Message-ID: <CAMuHMdW6p6tP=wwBNV9uAAbwwgpyzMiPxsBSJNOUazhznYC4iQ@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.10-rc1 (cris)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
Cc: Cris <linux-cris-kernel@axis.com>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 12, 2013 at 10:44 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> drivers/video/console/fonts.c:71:2: error: #error No fonts configured.: 2 errors in 2 logs
>         v3.10-rc1/cris/cris-allmodconfig v3.10-rc1/cris/cris-allyesconfig
>
>         Fbdev issue?

This is caused by cris not using the generic drivers/Kconfig, and thus not
traversing drivers/video/console/Kconfig.
As the build system does traverse drivers/video/console/Makefile, fonts.c
is compiled with an inconsistent configuration.

Two solutions:
  1. Add drivers/video/console/Kconfig to arch/cris/Kconfig,
  2. Switch cris to drivers/Kconfig,

I prefer two, as this is what's done by all (except h8300) other
architectures. This will seriously broaden the scope of allmodconfig,
though, and require more fixes (e.g. missing <asm/vga.h>).

Note: The decision logic for compiling drivers/video/console/fonts.c is
      overly complicated, and seems to be buggy for some stuff living
      outside drivers drivers/video (drivers/media/platform/vivi.c and
      drivers/staging/media/solo6x10/solo6x10-enc.c). I think this should
      be resolved in Kconfig logic, using a new FONT_SUPPORT
      symbol (FONTS is already taken).

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
