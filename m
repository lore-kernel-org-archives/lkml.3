Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751548AbaHQU6R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 16:58:17 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:43963 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbaHQU6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 16:58:16 -0400
MIME-Version: 1.0
In-Reply-To: <1408308358-27494-1-git-send-email-geert@linux-m68k.org>
References: <1408308358-27494-1-git-send-email-geert@linux-m68k.org>
Date: Sun, 17 Aug 2014 22:58:14 +0200
X-Google-Sender-Auth: g9y5fx8yS09PW30YgTdBFjb1mSQ
Message-ID: <CAMuHMdUrBYrHiwj=S-kWYEHb+1CX2VUgYmvJhj_aaC-8ChFL_g@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.17-rc1
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
        Linux-sh list <linux-sh@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 17, 2014 at 10:45 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> 16 regressions:
>   + /scratch/kisskb/src/arch/powerpc/include/asm/floppy.h: error: 'isa_bridge_pcidev' undeclared (first use in this function):  => 142:20

powerpc-randconfig

>   + /scratch/kisskb/src/fs/hostfs/hostfs_user.c: error: 'AT_FDCWD' undeclared (first use in this function):  => 378
>   + /scratch/kisskb/src/fs/hostfs/hostfs_user.c: error: (Each undeclared identifier is reported only once:  => 378
>   + /scratch/kisskb/src/fs/hostfs/hostfs_user.c: error: for each function it appears in.):  => 378

um-defconfig

>   + /scratch/kisskb/src/kernel/locking/mcs_spinlock.h: error: implicit declaration of function 'cpu_relax_lowlatency' [-Werror=implicit-function-declaration]:  => 87:2

frv-defconfig (somehow the fix never made it past Linus' mbox)

>   + error: "flush_icache_range" [drivers/misc/lkdtm.ko] undefined!:  => N/A

sh-allmodconfig (woohoo, this means it has reached the link phase!)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
