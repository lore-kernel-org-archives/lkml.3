Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120AbaLVImW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 03:42:22 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:48021 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbaLVImU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 03:42:20 -0500
MIME-Version: 1.0
In-Reply-To: <1419237118-9712-1-git-send-email-geert@linux-m68k.org>
References: <1419237118-9712-1-git-send-email-geert@linux-m68k.org>
Date: Mon, 22 Dec 2014 09:42:18 +0100
X-Google-Sender-Auth: ETE27FZKFm2IfRKVAx___rUHTfs
Message-ID: <CAMuHMdU0ym7PLkEcdmDnxvDVBn879QWkOm=-zUXFaQMh2FHfrQ@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.19-rc1
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Miao Steven <realmz6@gmail.com>,
        "adi-buildroot-devel@lists.sourceforge.net" 
	<adi-buildroot-devel@lists.sourceforge.net>,
        Cris <linux-cris-kernel@axis.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2014 at 9:31 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> Below is the list of build error/warning regressions/improvements in
> v3.19-rc1[1] compared to v3.18[2].
>
> Summarized:
>   - build errors: +24/-16

  + /home/kisskb/slave/src/arch/powerpc/xmon/xmon.c: error: unused
variable 'badaddr' [-Werror=unused-variable]:  => 1185:13
  + /home/kisskb/slave/src/arch/powerpc/xmon/xmon.c: error: unused
variable 'mode' [-Werror=unused-variable]:  => 1183:6

powerpc-randconfig

  + /home/kisskb/slave/src/arch/sh/boards/mach-se/7343/irq.c: error:
too few arguments to function 'ioread16':  => 44:2
  + /home/kisskb/slave/src/arch/sh/boards/mach-se/7343/irq.c: error:
too few arguments to function 'iowrite16':  => 123:2

sh4/se7343_defconfig

  + /home/kisskb/slave/src/arch/sh/boards/mach-se/7722/irq.c: error:
too few arguments to function 'ioread16':  => 43:2
  + /home/kisskb/slave/src/arch/sh/boards/mach-se/7722/irq.c: error:
too few arguments to function 'iowrite16':  => 116:2

sh4/se7722_defconfig

  + /home/kisskb/slave/src/drivers/usb/musb/blackfin.c: error:
'bfin_writel' undeclared here (not in a function):  => 476:13

bfin/BF527-EZKIT-V2_defconfig

  + /home/kisskb/slave/src/drivers/usb/musb/musb_debugfs.c: error:
'MUSB_BABBLE_CTL' undeclared here (not in a function):  => 67:17
  + /home/kisskb/slave/src/drivers/usb/musb/musb_debugfs.c: error:
'MUSB_CONFIGDATA' undeclared here (not in a function):  => 62:18
  + /home/kisskb/slave/src/drivers/usb/musb/musb_debugfs.c: error:
'MUSB_EPINFO' undeclared here (not in a function):  => 74:14
  + /home/kisskb/slave/src/drivers/usb/musb/musb_debugfs.c: error:
'MUSB_RAMINFO' undeclared here (not in a function):  => 75:15
  + /home/kisskb/slave/src/drivers/usb/musb/musb_debugfs.c: error:
'MUSB_RXFIFOADD' undeclared here (not in a function):  => 71:17
  + /home/kisskb/slave/src/drivers/usb/musb/musb_debugfs.c: error:
'MUSB_RXFIFOSZ' undeclared here (not in a function):  => 69:16
  + /home/kisskb/slave/src/drivers/usb/musb/musb_debugfs.c: error:
'MUSB_TXFIFOADD' undeclared here (not in a function):  => 70:17
  + /home/kisskb/slave/src/drivers/usb/musb/musb_debugfs.c: error:
'MUSB_TXFIFOSZ' undeclared here (not in a function):  => 68:16

bfin/BF527-EZKIT_defconfig
bfin/BF527-EZKIT-V2_defconfig
bfin/BF548-EZKIT_defconfig
bfin/CM-BF548_defconfig
bfin/CM-BF527_defconfig

  + /home/kisskb/slave/src/include/linux/irq.h: error: conflicting
types for 'ioread16':  => 856:19
  + /home/kisskb/slave/src/include/linux/irq.h: error: conflicting
types for 'iowrite16':  => 847:20

sh4/se7343_defconfig
sh4/se7722_defconfig

  + error: "csum_partial_copy_nocheck" [net/ipv6/ipv6.ko] undefined!:  => N/A

cris/cris-allmodconfig

  + error: No rule to make target include/config/auto.conf:  => N/A

arm/arm-randconfig

> [1] http://kisskb.ellerman.id.au/kisskb/head/8241/ (262 out of 262 configs)
> [2] http://kisskb.ellerman.id.au/kisskb/head/8168/ (262 out of 262 configs)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
