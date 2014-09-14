Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554AbaINIp1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 04:45:27 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:62044 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458AbaINIpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 04:45:25 -0400
MIME-Version: 1.0
In-Reply-To: <541552B8.8020807@gmail.com>
References: <541552B8.8020807@gmail.com>
Date: Sun, 14 Sep 2014 10:45:23 +0200
X-Google-Sender-Auth: 1VrAt2fmfeicT8BSS2GwdIrPRWs
Message-ID: <CAMuHMdU6adYoOafUZ2STZCeuQa3cU-_kD7FHW3x=Tq-O+aqrZw@mail.gmail.com>
Subject: Re: [PATCH] arch/microblaze/kernel/setup.c: Add default 'screen_info"
 for fixing compiling break
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Michal Simek <monstr@monstr.eu>, Rob Herring <rob.herring@calxeda.com>,
        Paul Bolle <pebolle@tiscali.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chen,

On Sun, Sep 14, 2014 at 10:32 AM, Chen Gang <gang.chen.5i5j@gmail.com> wrote:
> Add default one just like other architectures have done (e.g. cris,
> score, sh ...), the related error with allmodconfig:
>
>     LD      init/built-in.o
>   drivers/built-in.o: In function `vgacon_save_screen':
>   drivers/video/console/.tmp_vgacon.o:(.text+0x834d0): undefined reference to `screen_info'
>   drivers/video/console/.tmp_vgacon.o:(.text+0x834ec): undefined reference to `screen_info'
>   drivers/built-in.o: In function `vgacon_resize':
>   drivers/video/console/.tmp_vgacon.o:(.text+0x83cdc): undefined reference to `screen_info'
>   drivers/video/console/.tmp_vgacon.o:(.text+0x83d38): undefined reference to `screen_info'
>   drivers/built-in.o: In function `vgacon_switch':
>   drivers/video/console/.tmp_vgacon.o:(.text+0x83f50): undefined reference to `screen_info'
>   drivers/built-in.o:drivers/video/console/.tmp_vgacon.o:(.text+0x8407c): more undefined references to `screen_info' follow
>   make: *** [vmlinux] Error 1

Can microblaze actually have VGA?

If not, it's better to disable it.

BTW, it's interesting you mention cris, as VGA_CONSOLE depends on !CRIS
in drivers/video/console/Kconfig...

I (still) think it's time to introduce ARCH_MIGHT_HAVE_VGA, and make
VGA_CONSOLE depend on that, cfr.

commit f13399f033ae3d49e1808bacabd83d116844c94e
Merge: 049ffa8ab33a b2c32b32a212
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri Nov 15 14:05:15 2013 -0800

    Merge tag 'for-linus' of
git://linux-c6x.org/git/projects/linux-c6x-upstreaming

    Pull Kconfig cleanups from Mark Salter:
     "Remove some unused config options from C6X and clean up PC_PARPORT
      dependencies.  The latter was discussed here:

        https://lkml.org/lkml/2013/10/8/12"

    * tag 'for-linus' of git://linux-c6x.org/git/projects/linux-c6x-upstreaming:
      c6x: remove unused COMMON_CLKDEV Kconfig parameter
      Kconfig cleanup (PARPORT_PC dependencies)
      x86: select ARCH_MIGHT_HAVE_PC_PARPORT
      unicore32: select ARCH_MIGHT_HAVE_PC_PARPORT
      sparc: select ARCH_MIGHT_HAVE_PC_PARPORT
      sh: select ARCH_MIGHT_HAVE_PC_PARPORT
      powerpc: select ARCH_MIGHT_HAVE_PC_PARPORT
      parisc: select ARCH_MIGHT_HAVE_PC_PARPORT
      mips: select ARCH_MIGHT_HAVE_PC_PARPORT
      microblaze: select ARCH_MIGHT_HAVE_PC_PARPORT
      m68k: select ARCH_MIGHT_HAVE_PC_PARPORT
      ia64: select ARCH_MIGHT_HAVE_PC_PARPORT
      arm: select ARCH_MIGHT_HAVE_PC_PARPORT
      alpha: select ARCH_MIGHT_HAVE_PC_PARPORT
      c6x: remove unused parameter in Kconfig

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
