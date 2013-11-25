Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256Ab3KYQQO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 11:16:14 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:49270 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757225Ab3KYQQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 11:16:11 -0500
MIME-Version: 1.0
In-Reply-To: <1382039212-26062-1-git-send-email-geert@linux-m68k.org>
References: <1382039212-26062-1-git-send-email-geert@linux-m68k.org>
Date: Mon, 25 Nov 2013 17:16:10 +0100
X-Google-Sender-Auth: aqUxG2Rx2Kai1qW-9oT8U1ns2SQ
Message-ID: <CAMuHMdUUvzc1eGhJjqye7aOcNQoGgOEfT=TDLQgbef6-0vT=qQ@mail.gmail.com>
Subject: Re: [PATCH/RFC] m68k/amiga: Fix specifying multiple debug= parameters
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k <linux-m68k@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 9:46 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> Since commit d6713b4091a99fa2af2fabdcd2f3fb97f32ecf2e ("m68k: early
> parameter support"), the user can specify multiple debug consoles using the
> "debug=" kernel command line parameter.
> However, as the struct console object was shared, it would actually register
> the same console object multiple times, causing the following warning:
>
> WARNING: CPU: 0 PID: 0 at kernel/printk/printk.c:2233 register_console+0x36/0x2b6()
> console 'debug0' already registered
>
> Note that only the console corresponding to the last "debug=" parameter became
> active, as the .write() method was overwritten before registration.
>
> Use separate console objects to allow using multiple debug consoles.
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
> Notes:
>   1. This patch was only compile-tested.
>   2. Do we want to fix it this way? Alternatives are:
>        a. Reject a second debug= parameter by checking for a non-NULL .write()
>           method
>           => only the first debug console will be used,
>        b. Skip console registration in case of a non-NULL .write() method
>           => only the last debug console will be used,
>   3. Atari has a similar issue, with even more (4) debug consoles.

No opinions?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
