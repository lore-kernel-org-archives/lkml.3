Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075AbaCGKjw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 05:39:52 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:34278 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbaCGKju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 05:39:50 -0500
MIME-Version: 1.0
In-Reply-To: <1394187271-5857-1-git-send-email-dh.herrmann@gmail.com>
References: <1394187271-5857-1-git-send-email-dh.herrmann@gmail.com>
Date: Fri, 7 Mar 2014 11:39:49 +0100
X-Google-Sender-Auth: d7ZIvuEvgW0qMpzNM6Bo7SDI2bo
Message-ID: <CAMuHMdVxE2jXQE11swi8sM251GcWcdDYpgE37pCoxpb7oF1-Rg@mail.gmail.com>
Subject: Re: [PATCH] lib: remove FBCON dependency for fonts
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 7, 2014 at 11:14 AM, David Herrmann <dh.herrmann@gmail.com> wrote:
> Fonts don't depend on CONFIG_FRAMEBUFFER_CONSOLE at all. Remove that.
> Besides, CONFIG_FONT_SUPPORT is 'select'ed anyway, so the dependencies
> aren't checked by most higher-level options.

CONFIG_FONT_SUPPORT is indeed selected, but the other options are about
which fonts to include by default. No dependencies are bypassed by the select.

Without the "depends on FRAMEBUFFER_CONSOLE", people who don't
have FRAMEBUFFER_CONSOLE set, but have set any of these:

config EARLY_PRINTK_EFI
    select FONT_SUPPORT

config VIDEO_VIVI
    select FONT_SUPPORT
    select FONT_8x16

config SOLO6X10
    select FONT_SUPPORT
    select FONT_8x16

config USB_SISUSBVGA
    select FONT_SUPPORT
    ...
    select FONT_8x16

config SGI_NEWPORT_CONSOLE
    select FONT_SUPPORT

config STI_CONSOLE
    select FONT_SUPPORT

will now get more (unused) fonts in their kernel image.

> It's a relict of the times when fonts where exclusive to the VT layer and
> fbcon.
>
> Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
> ---
>  lib/fonts/Kconfig | 11 ++---------
>  1 file changed, 2 insertions(+), 9 deletions(-)
>
> diff --git a/lib/fonts/Kconfig b/lib/fonts/Kconfig
> index 4dc1b99..0ca66a3 100644
> --- a/lib/fonts/Kconfig
> +++ b/lib/fonts/Kconfig
> @@ -9,7 +9,6 @@ if FONT_SUPPORT
>
>  config FONTS
>         bool "Select compiled-in fonts"
> -       depends on FRAMEBUFFER_CONSOLE
>         help
>           Say Y here if you would like to use fonts other than the default
>           your frame buffer console usually use.
> @@ -22,7 +21,6 @@ config FONTS
>
>  config FONT_8x8
>         bool "VGA 8x8 font" if FONTS
> -       depends on FRAMEBUFFER_CONSOLE
>         default y if !SPARC && !FONTS
>         help
>           This is the "high resolution" font for the VGA frame buffer (the one
> @@ -45,7 +43,6 @@ config FONT_8x16
>
>  config FONT_6x11
>         bool "Mac console 6x11 font (not supported by all drivers)" if FONTS
> -       depends on FRAMEBUFFER_CONSOLE
>         default y if !SPARC && !FONTS && MAC
>         help
>           Small console font with Macintosh-style high-half glyphs.  Some Mac
> @@ -53,7 +50,6 @@ config FONT_6x11
>
>  config FONT_7x14
>         bool "console 7x14 font (not supported by all drivers)" if FONTS
> -       depends on FRAMEBUFFER_CONSOLE
>         help
>           Console font with characters just a bit smaller than the default.
>           If the standard 8x16 font is a little too big for you, say Y.
> @@ -61,7 +57,6 @@ config FONT_7x14
>
>  config FONT_PEARL_8x8
>         bool "Pearl (old m68k) console 8x8 font" if FONTS
> -       depends on FRAMEBUFFER_CONSOLE
>         default y if !SPARC && !FONTS && AMIGA
>         help
>           Small console font with PC-style control-character and high-half
> @@ -69,7 +64,6 @@ config FONT_PEARL_8x8
>
>  config FONT_ACORN_8x8
>         bool "Acorn console 8x8 font" if FONTS
> -       depends on FRAMEBUFFER_CONSOLE
>         default y if !SPARC && !FONTS && ARM && ARCH_ACORN
>         help
>           Small console font with PC-style control characters and high-half
> @@ -81,13 +75,13 @@ config FONT_MINI_4x6
>
>  config FONT_SUN8x16
>         bool "Sparc console 8x16 font"
> -       depends on FRAMEBUFFER_CONSOLE && (!SPARC && FONTS || SPARC)
> +       depends on !SPARC && FONTS || SPARC
>         help
>           This is the high resolution console font for Sun machines. Say Y.
>
>  config FONT_SUN12x22
>         bool "Sparc console 12x22 font (not supported by all drivers)"
> -       depends on FRAMEBUFFER_CONSOLE && (!SPARC && FONTS || SPARC)
> +       depends on !SPARC && FONTS || SPARC
>         help
>           This is the high resolution console font for Sun machines with very
>           big letters (like the letters used in the SPARC PROM). If the
> @@ -95,7 +89,6 @@ config FONT_SUN12x22
>
>  config FONT_10x18
>         bool "console 10x18 font (not supported by all drivers)" if FONTS
> -       depends on FRAMEBUFFER_CONSOLE
>         help
>           This is a high resolution console font for machines with very
>           big letters. It fits between the sun 12x22 and the normal 8x16 font.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
