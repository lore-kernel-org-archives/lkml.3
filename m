Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524AbaAFJF1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 04:05:27 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:43707 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995AbaAFJFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 04:05:22 -0500
MIME-Version: 1.0
In-Reply-To: <1388998868-31448-1-git-send-email-geert@linux-m68k.org>
References: <1388998868-31448-1-git-send-email-geert@linux-m68k.org>
Date: Mon, 6 Jan 2014 10:05:21 +0100
X-Google-Sender-Auth: qLRvH2b8qolUb-AuehvQEzJWRH4
Message-ID: <CAMuHMdWfHtGQQ-s1z0u-PKagD0i+_pd4=H02=TyMiFfcJW63og@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.13-rc7
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Linux-sh list <linux-sh@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 6, 2014 at 10:01 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> JFYI, when comparing v3.13-rc7[1] to v3.13-rc6[3], the summaries are:
>   - build errors: +14/-4

  + /scratch/kisskb/src/arch/sh/mm/cache-sh4.c: error:
'cached_to_uncached' undeclared (first use in this function):  =>
99:17
  + /scratch/kisskb/src/arch/sh/mm/cache-sh4.c: error: implicit
declaration of function 'cpu_context'
[-Werror=implicit-function-declaration]:  => 192:2
  + /scratch/kisskb/src/drivers/mtd/maps/vmu-flash.c: error: (near
initialization for 'vmu_flash_driver.drv'):  => 805:3, 803:3, 804:3
  + /scratch/kisskb/src/drivers/mtd/maps/vmu-flash.c: error: expected
declaration specifiers or '...' before string constant:  => 824:20,
822:16, 823:15
  + /scratch/kisskb/src/drivers/mtd/maps/vmu-flash.c: error: field
name not in record or union initializer:  => 805:3, 803:3, 804:3
  + /scratch/kisskb/src/include/linux/maple.h: error: field 'dev' has
incomplete type:  => 80:16
  + /scratch/kisskb/src/include/linux/maple.h: error: field 'drv' has
incomplete type:  => 85:23

sh-randconfig

  + /scratch/kisskb/src/drivers/tty/serial/nwpserial.c: error:
implicit declaration of function 'udelay'
[-Werror=implicit-function-declaration]:  => 53:3
  + error: No rule to make target drivers/scsi/aic7xxx/aicasm/*.[chyl]:  => N/A

powerpc-randconfig

  + error: No rule to make target /etc/sound/msndinit.bin:  => N/A
  + error: No rule to make target /etc/sound/msndperm.bin:  => N/A
  + error: No rule to make target /etc/sound/pndsperm.bin:  => N/A
  + error: No rule to make target /etc/sound/pndspini.bin:  => N/A

i386-randconfig

> [1] http://kisskb.ellerman.id.au/kisskb/head/7037/ (119 out of 120 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/7026/ (119 out of 120 configs)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
