Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929AbaCGKrI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 05:47:08 -0500
Received: from mail-ig0-f172.google.com ([209.85.213.172]:32835 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbaCGKrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 05:47:05 -0500
MIME-Version: 1.0
In-Reply-To: <CAMuHMdVxE2jXQE11swi8sM251GcWcdDYpgE37pCoxpb7oF1-Rg@mail.gmail.com>
References: <1394187271-5857-1-git-send-email-dh.herrmann@gmail.com>
	<CAMuHMdVxE2jXQE11swi8sM251GcWcdDYpgE37pCoxpb7oF1-Rg@mail.gmail.com>
Date: Fri, 7 Mar 2014 11:47:04 +0100
Message-ID: <CANq1E4SbA5jCh+5UqyJ=oxdiYdbfkUcfrbB=jGjKRZJ-LAuaXg@mail.gmail.com>
Subject: Re: [PATCH] lib: remove FBCON dependency for fonts
From: David Herrmann <dh.herrmann@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Fri, Mar 7, 2014 at 11:39 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Fri, Mar 7, 2014 at 11:14 AM, David Herrmann <dh.herrmann@gmail.com> wrote:
>> Fonts don't depend on CONFIG_FRAMEBUFFER_CONSOLE at all. Remove that.
>> Besides, CONFIG_FONT_SUPPORT is 'select'ed anyway, so the dependencies
>> aren't checked by most higher-level options.
>
> CONFIG_FONT_SUPPORT is indeed selected, but the other options are about
> which fonts to include by default. No dependencies are bypassed by the select.

Indeed, I missed that, sorry.

> Without the "depends on FRAMEBUFFER_CONSOLE", people who don't
> have FRAMEBUFFER_CONSOLE set, but have set any of these:
>
> config EARLY_PRINTK_EFI
>     select FONT_SUPPORT
>
> config VIDEO_VIVI
>     select FONT_SUPPORT
>     select FONT_8x16
>
> config SOLO6X10
>     select FONT_SUPPORT
>     select FONT_8x16
>
> config USB_SISUSBVGA
>     select FONT_SUPPORT
>     ...
>     select FONT_8x16
>
> config SGI_NEWPORT_CONSOLE
>     select FONT_SUPPORT
>
> config STI_CONSOLE
>     select FONT_SUPPORT
>
> will now get more (unused) fonts in their kernel image.

Why would they get more unused fonts? All those fonts are "default n"
(except for some arch-specific stuff and 8x8 and obviously 8x16). I
don't mind if we drop this, but it makes font-selection impossible if
fbcon is disabled, which is kinda unexpected.

Thanks
David
