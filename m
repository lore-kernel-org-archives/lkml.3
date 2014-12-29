Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371AbaL2UWo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 15:22:44 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:46123 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbaL2UWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 15:22:43 -0500
MIME-Version: 1.0
In-Reply-To: <1419883144-13523-1-git-send-email-geert@linux-m68k.org>
References: <1419883144-13523-1-git-send-email-geert@linux-m68k.org>
Date: Mon, 29 Dec 2014 21:22:41 +0100
X-Google-Sender-Auth: Z0cBaxhgu0WAyCTG1126-sWj6PA
Message-ID: <CAMuHMdXccHA6Zzv-avucH3e5CpguUT-nAAHQ=E+V-rdVLiEV7g@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.19-rc2
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 29, 2014 at 8:59 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> JFYI, when comparing v3.19-rc2[1]  to v3.19-rc1[3], the summaries are:
>   - build errors: +8/-5

Surprise! No new R_PPC64_REL24 relocation truncations, hence not much new
generic code was added. Bloat-o-meter on atari_defconfig agrees: +36 bytes.

  + /home/kisskb/slave/src/arch/powerpc/platforms/pseries/hotplug-memory.c:
error: 'SECTION_SIZE_BITS' undeclared (first use in this function):
=> 27:31
  + /home/kisskb/slave/src/mm/memory_hotplug.c: error:
'PAGES_PER_SECTION' undeclared (first use in this function):  =>
1836:46, 1178:18
  + /home/kisskb/slave/src/mm/memory_hotplug.c: error:
'PAGE_SECTION_MASK' undeclared (first use in this function):  =>
1177:20
  + /home/kisskb/slave/src/mm/memory_hotplug.c: error: implicit
declaration of function '__nr_to_section'
[-Werror=implicit-function-declaration]:  => 1841:3
  + /home/kisskb/slave/src/mm/memory_hotplug.c: error: implicit
declaration of function 'find_memory_block_hinted'
[-Werror=implicit-function-declaration]:  => 1848:3
  + /home/kisskb/slave/src/mm/memory_hotplug.c: error: implicit
declaration of function 'pfn_to_section_nr'
[-Werror=implicit-function-declaration]:  => 1837:3
  + /home/kisskb/slave/src/mm/memory_hotplug.c: error: implicit
declaration of function 'present_section_nr'
[-Werror=implicit-function-declaration]:  => 1838:3

powerpc-randconfig

  + error: initramfs.c: undefined reference to `__stack_chk_guard':
=> .init.text+0x3132)

i386-randconfig

> [1] http://kisskb.ellerman.id.au/kisskb/head/8257/ (all 262 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/8241/ (all 262 configs)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
