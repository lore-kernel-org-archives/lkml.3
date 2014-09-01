Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596AbaIAHYt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 03:24:49 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:59660 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbaIAHYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 03:24:47 -0400
MIME-Version: 1.0
In-Reply-To: <20140901065916.28909.35097.stgit@zurg>
References: <20140901065916.28909.35097.stgit@zurg>
Date: Mon, 1 Sep 2014 09:24:45 +0200
X-Google-Sender-Auth: uZQes8Xo7WLOSu4Ov-OIJJbZi7s
Message-ID: <CAMuHMdXKyTJZM9fwcCZ+-vCX3SZ9JuhPiNNAhyu=vrZuOjsw8w@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] kconfig: store default ARCH in .config
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Paul Bolle <pebolle@tiscali.nl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Konstantin,

On Mon, Sep 1, 2014 at 9:16 AM, Konstantin Khlebnikov <koct9i@gmail.com> wrote:
> This is second attempt of fixing target archecture amnesia.
> v1 patch: http://lkml.kernel.org/r/20140706080234.19520.96704.stgit@zurg
>
> First version saved ARCH as CONFIG_DEFAULT_ARCH and used it as defult ARCH.
>
> This version changes semantic of Kconfig option env="...", now it acts more
> like the user input, except that the value comes from the environment.
> Variable from environment overrides all defaults and value from config file.
> If environment variable is not defined this option has no effect.
>
> So, now ARCH is saved as CONFIG_ARCH.
>
> Also this patchset links CONFIG_CROSS_COMPILE and CROSS_COMPILE in the same way.
> Changing it in command line/environment also updates value in the config file.

Thanks, I haven't tried this yet, but it looks promising!

For the record, right now I use a GNUmakefile (which takes precedence over
the Makefile) in the build directory containing e.g.

MAKEARGS = ARCH=arm CROSS_COMPILE=arm-unknown-linux-gnueabi-

MAKEFLAGS += --no-print-directory

.PHONY: all $(MAKECMDGOALS)

all := $(filter-out all Makefile,$(MAKECMDGOALS))

all:
        $(MAKE) $(MAKEARGS) $(all) -f Makefile

Makefile:;

$(all) %/: all
        @:

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
