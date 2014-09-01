Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489AbaIAHfJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 03:35:09 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:63150 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbaIAHfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 03:35:07 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdXKyTJZM9fwcCZ+-vCX3SZ9JuhPiNNAhyu=vrZuOjsw8w@mail.gmail.com>
References: <20140901065916.28909.35097.stgit@zurg>
	<CAMuHMdXKyTJZM9fwcCZ+-vCX3SZ9JuhPiNNAhyu=vrZuOjsw8w@mail.gmail.com>
Date: Mon, 1 Sep 2014 11:35:06 +0400
Message-ID: <CALYGNiPUCFkx6sgLbCKrXbDVERhyaWyGJPp64fowBWpUALXqEQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] kconfig: store default ARCH in .config
From: Konstantin Khlebnikov <koct9i@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Michal Marek <mmarek@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Paul Bolle <pebolle@tiscali.nl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 1, 2014 at 11:24 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> Hi Konstantin,
>
> On Mon, Sep 1, 2014 at 9:16 AM, Konstantin Khlebnikov <koct9i@gmail.com> wrote:
>> This is second attempt of fixing target archecture amnesia.
>> v1 patch: http://lkml.kernel.org/r/20140706080234.19520.96704.stgit@zurg
>>
>> First version saved ARCH as CONFIG_DEFAULT_ARCH and used it as defult ARCH.
>>
>> This version changes semantic of Kconfig option env="...", now it acts more
>> like the user input, except that the value comes from the environment.
>> Variable from environment overrides all defaults and value from config file.
>> If environment variable is not defined this option has no effect.
>>
>> So, now ARCH is saved as CONFIG_ARCH.
>>
>> Also this patchset links CONFIG_CROSS_COMPILE and CROSS_COMPILE in the same way.
>> Changing it in command line/environment also updates value in the config file.
>
> Thanks, I haven't tried this yet, but it looks promising!
>
> For the record, right now I use a GNUmakefile (which takes precedence over
> the Makefile) in the build directory containing e.g.

Heh, I've used and seen a lot of such hacks.
GNUmakefile also might include Makefile after defining environment.

>
> MAKEARGS = ARCH=arm CROSS_COMPILE=arm-unknown-linux-gnueabi-
>
> MAKEFLAGS += --no-print-directory
>
> .PHONY: all $(MAKECMDGOALS)
>
> all := $(filter-out all Makefile,$(MAKECMDGOALS))
>
> all:
>         $(MAKE) $(MAKEARGS) $(all) -f Makefile
>
> Makefile:;
>
> $(all) %/: all
>         @:
>
> Gr{oetje,eeting}s,
>
>                         Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
