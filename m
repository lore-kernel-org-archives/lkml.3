Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256AbaCGKyc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 05:54:32 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:58758 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbaCGKya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 05:54:30 -0500
MIME-Version: 1.0
In-Reply-To: <CANq1E4SbA5jCh+5UqyJ=oxdiYdbfkUcfrbB=jGjKRZJ-LAuaXg@mail.gmail.com>
References: <1394187271-5857-1-git-send-email-dh.herrmann@gmail.com>
	<CAMuHMdVxE2jXQE11swi8sM251GcWcdDYpgE37pCoxpb7oF1-Rg@mail.gmail.com>
	<CANq1E4SbA5jCh+5UqyJ=oxdiYdbfkUcfrbB=jGjKRZJ-LAuaXg@mail.gmail.com>
Date: Fri, 7 Mar 2014 11:54:29 +0100
X-Google-Sender-Auth: xzyJRK4Ima42AO-zn7MoA0Kws3U
Message-ID: <CAMuHMdUheaE00m289h=x0gxf+PAbPjhhdAKATAHGgOgk9YROVQ@mail.gmail.com>
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

On Fri, Mar 7, 2014 at 11:47 AM, David Herrmann <dh.herrmann@gmail.com> wrote:
>> Without the "depends on FRAMEBUFFER_CONSOLE", people who don't
>> have FRAMEBUFFER_CONSOLE set, but have set any of these:
>>
>> config EARLY_PRINTK_EFI
>>     select FONT_SUPPORT
>>
>> config VIDEO_VIVI
>>     select FONT_SUPPORT
>>     select FONT_8x16
>>
>> config SOLO6X10
>>     select FONT_SUPPORT
>>     select FONT_8x16
>>
>> config USB_SISUSBVGA
>>     select FONT_SUPPORT
>>     ...
>>     select FONT_8x16
>>
>> config SGI_NEWPORT_CONSOLE
>>     select FONT_SUPPORT
>>
>> config STI_CONSOLE
>>     select FONT_SUPPORT
>>
>> will now get more (unused) fonts in their kernel image.
>
> Why would they get more unused fonts? All those fonts are "default n"
> (except for some arch-specific stuff and 8x8 and obviously 8x16). I

So they get the 8x8 and the arch-specific ones by default (FONTS=n).

> don't mind if we drop this, but it makes font-selection impossible if
> fbcon is disabled, which is kinda unexpected.

IIRC, drivers that "select FONT_8x16" have the font name hardcoded in
the driver, so allowing to select more fonts doesn't gain anything for them.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
