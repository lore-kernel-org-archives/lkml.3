Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302AbaCKRnX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 13:43:23 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:41835 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbaCKRnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 13:43:18 -0400
MIME-Version: 1.0
In-Reply-To: <1394528182-32013-1-git-send-email-geert@linux-m68k.org>
References: <1394528182-32013-1-git-send-email-geert@linux-m68k.org>
Date: Tue, 11 Mar 2014 18:43:18 +0100
X-Google-Sender-Auth: N1a2oU_yD1dmgZI15dsENoj0Tu8
Message-ID: <CAMuHMdWvQ3aux_901uoiw4k_YJ37Wbvdaroz3z-3GVxBPzoMWQ@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.14-rc6
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Linux-sh list <linux-sh@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2014 at 9:56 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> JFYI, when comparing v3.14-rc6[1]  to v3.14-rc5[3], the summaries are:
>   - build errors: +10/-4

Only fuzz from the randconfig police:

  + /scratch/kisskb/src/drivers/gpu/drm/drm_gem_cma_helper.c: error:
implicit declaration of function 'dma_alloc_writecombine'
[-Werror=implicit-function-declaration]:  => 91:2
  + /scratch/kisskb/src/drivers/gpu/drm/drm_gem_cma_helper.c: error:
implicit declaration of function 'dma_free_writecombine'
[-Werror=implicit-function-declaration]:  => 176:3

sh-randconfig

  + /scratch/kisskb/src/kernel/bounds.c: error: -mcall-aixdesc must be
big endian:  => 1:0
  + /scratch/kisskb/src/scripts/mod/devicetable-offsets.c: error:
-mcall-aixdesc must be big endian:  => 1:0
  + /scratch/kisskb/src/scripts/mod/empty.c: error: -mcall-aixdesc
must be big endian:  => 1:0
  + <stdin>: error: -mcall-aixdesc must be big endian:  => 1:0

powerpc-randconfig

  + error: No rule to make target /etc/sound/pndsperm.bin:  => N/A
  + error: No rule to make target /etc/sound/pndspini.bin:  => N/A
  + error: No rule to make target /etc/sound/trxpro.hex:  => N/A

i386-randconfig

  + error: initramfs.c: undefined reference to `__stack_chk_guard':
=> .init.text+0x1aef)

x86_64-randconfig

> [1] http://kisskb.ellerman.id.au/kisskb/head/7258/ (all 119 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/7236/ (all 119 configs)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
