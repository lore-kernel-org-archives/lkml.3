Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175AbaEFMP4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 08:15:56 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:64908 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbaEFMPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 08:15:55 -0400
MIME-Version: 1.0
In-Reply-To: <1399377878-29995-1-git-send-email-geert@linux-m68k.org>
References: <1399377878-29995-1-git-send-email-geert@linux-m68k.org>
Date: Tue, 6 May 2014 14:15:54 +0200
X-Google-Sender-Auth: F1sxpSCPriWeivL7hPjxCSNaZi8
Message-ID: <CAMuHMdUxTDCLFWEDxYT2CT8__xyZcp83dXLYqeJfoG+u8BDVBg@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.15-rc4
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 6, 2014 at 2:04 PM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> JFYI, when comparing v3.15-rc4[1]  to v3.15-rc3[3], the summaries are:
>   - build errors: +7/-1

  + /scratch/kisskb/src/arch/powerpc/include/asm/fixmap.h: error:
overflow in enumeration values  CC      drivers/hwmon/smsc47m192.o:
=> 51:2
  + /scratch/kisskb/src/arch/powerpc/include/asm/fixmap.h: error:
overflow in enumeration values  CC [M]  drivers/usb/gadget/f_rndis.o:
=> 51:2
  + /scratch/kisskb/src/arch/powerpc/include/asm/fixmap.h: error:
overflow in enumeration values:  => 51:2

powerpc-randconfig (looks scary, is CONFIG_HIGHMEM=y broken on ppc?)

  + /scratch/kisskb/src/arch/powerpc/kernel/head_44x.S: Error: invalid
operands (*ABS* and *UND* sections) for `|':  => 686, 603
  + /scratch/kisskb/src/arch/powerpc/mm/tlb_nohash_low.S: Error:
unsupported relocation against PPC47x_TLBE_SIZE:  => 113

powerpc-randconfig

  + /scratch/kisskb/src/arch/powerpc/platforms/powernv/setup.c: error:
implicit declaration of function 'get_hard_smp_processor_id'
[-Werror=implicit-function-declaration]:  => 179:4

ppc64_defconfig+UP

Lemme guess: If CONFIG_SMP=n, <linux/smp.h> does not include <asm/smp.h>,
so it needs an explicit #include <asm/smp.h>?

  + error: initramfs.c: undefined reference to `__stack_chk_guard':
=> .init.text+0x19dc)

x86_64-randconfig

> [1] http://kisskb.ellerman.id.au/kisskb/head/7449/ (all 119 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/7427/ (all 119 configs)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
