Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759322Ab3EWUPl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 16:15:41 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:55286 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758731Ab3EWUPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 16:15:40 -0400
MIME-Version: 1.0
In-Reply-To: <1367507786-505303-20-git-send-email-arnd@arndb.de>
References: <1367507786-505303-1-git-send-email-arnd@arndb.de>
	<1367507786-505303-20-git-send-email-arnd@arndb.de>
Date: Thu, 23 May 2013 22:15:39 +0200
X-Google-Sender-Auth: kURDRXHjROQuLz7nw32r3go7thc
Message-ID: <CAMuHMdWrVCndJ=Cre5LUgTSyQMxn_XkHUCFa2qCz-ETUO+T-ug@mail.gmail.com>
Subject: Re: [PATCH, RFC 19/22] staging/solo6x10: depend on CONFIG_FONTS
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 2, 2013 at 5:16 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> The new SOLO6X10 driver needs the built-in console fonts, specifically
> the VGA8x16 font and building it without console support results in
> a link error error.
>
> drivers/built-in.o: In function `solo_osd_print':
>  :(.text+0x7d3424): undefined reference to `find_font'
>
> This adds a dependency on the CONFIG_FONTS symbol and changes the
> console code to always build the base driver even if there are
> no specific fonts built-in.
>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Sorry for only noticing this now, but CONFIG_FONTS is not about font support.
It's about allowing the user to override the default list of builtin fonts.
I know it's a bad name, but changing this would break make oldconfig.
Or is this allowed?

My fix for the solo6x10 build breakage is
http://marc.info/?l=linux-kernel&m=136861809223875

> ---
>  drivers/staging/media/solo6x10/Kconfig | 1 +
>  drivers/video/console/Makefile         | 2 ++
>  2 files changed, 3 insertions(+)
>
> diff --git a/drivers/staging/media/solo6x10/Kconfig b/drivers/staging/media/solo6x10/Kconfig
> index ec32776..df6569b 100644
> --- a/drivers/staging/media/solo6x10/Kconfig
> +++ b/drivers/staging/media/solo6x10/Kconfig
> @@ -1,6 +1,7 @@
>  config SOLO6X10
>         tristate "Softlogic 6x10 MPEG codec cards"
>         depends on PCI && VIDEO_DEV && SND && I2C
> +       depends on FONTS
>         select VIDEOBUF2_DMA_SG
>         select VIDEOBUF2_DMA_CONTIG
>         select SND_PCM
> diff --git a/drivers/video/console/Makefile b/drivers/video/console/Makefile
> index a862e91..48da25c 100644
> --- a/drivers/video/console/Makefile
> +++ b/drivers/video/console/Makefile
> @@ -18,6 +18,8 @@ font-objs-$(CONFIG_FONT_MINI_4x6)  += font_mini_4x6.o
>
>  font-objs += $(font-objs-y)
>
> +obj-$(CONFIG_FONTS) += font.o
> +
>  # Each configuration option enables a list of files.
>
>  obj-$(CONFIG_DUMMY_CONSOLE)       += dummycon.o

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
