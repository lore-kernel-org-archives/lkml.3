Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758131Ab3EWJw2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 05:52:28 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:43684 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757890Ab3EWJw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 05:52:26 -0400
MIME-Version: 1.0
Date: Thu, 23 May 2013 11:52:25 +0200
X-Google-Sender-Auth: pC-pQ24bY2Xj_Si7hfokftIvjWM
Message-ID: <CAMuHMdXAGBU97pg2SzoZteFk9fd7FOpOVtu=buZ40z+SwRpE6Q@mail.gmail.com>
Subject: Blocking allmodconfig with missing defaults (was: Re: kbuild: Fix
 missing '\n' for NEW symbols in yes "" | make oldconfig >conf.new)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michal Marek <mmarek@suse.cz>, Ben Hutchings <bhutchings@solarflare.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 9:37 PM, Linux Kernel Mailing List
<linux-kernel@vger.kernel.org> wrote:
> Gitweb:     http://git.kernel.org/linus/;a=commit;h=62dc989921df2a98d1a73aacd085abe941cb9828
>
>     According to Documentation/kbuild/kconfig.txt, the commands:
>
>         yes "" | make oldconfig >conf.new
>         grep "(NEW)" conf.new
>
>     should list the new config symbols with their default values.

There are other cases where this is not working.
If there are int or hex symbols without a default value, "allmodconfig",
"allyesconfig", "allnoconfig", and "randconfig" fill in empty string values,
causing a subsequent build (which does oldconfig) to wait for user input.

This is easy to reproduce:
    make ARCH=h8300 allmodconfig
    make ARCH=h8300 oldconfig

Should kconfig generate default values for these cases?
Should all int/hex symbols provide default values? If yes, I think
kconfig should
complain about missing defaults.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
