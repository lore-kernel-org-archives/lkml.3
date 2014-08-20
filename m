Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751717AbaHTIAx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 04:00:53 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:48288 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbaHTIAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 04:00:51 -0400
MIME-Version: 1.0
In-Reply-To: <1408482065-18457-1-git-send-email-bobby.prani@gmail.com>
References: <1408482065-18457-1-git-send-email-bobby.prani@gmail.com>
Date: Wed, 20 Aug 2014 10:00:50 +0200
X-Google-Sender-Auth: bvtIOVqQaOFUnCCtazXnBwmY268
Message-ID: <CAMuHMdWz+4ctGr92fJmi0GB1QrxRMy3GKC_KDpZfK-sriYP-FQ@mail.gmail.com>
Subject: Re: [PATCH] powerpc: Fix build failure when MEMORY_HOTPLUG=y
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "open list:LINUX FOR POWERPC..." <linuxppc-dev@lists.ozlabs.org>,
        open list <linux-kernel@vger.kernel.org>,
        Andew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 11:01 PM, Pranith Kumar <bobby.prani@gmail.com> wrote:
> ARCH_ENABLE_MEMORY_HOTPLUG is enabled by default for powerpc. This causes build
> failures when SPARSEMEM=n as memory hotplug needs definition which are defined
> only when SPARSEMEM=y. The error is as follows:
>
> arch/powerpc/platforms/pseries/hotplug-memory.c:27:31: error: 'SECTION_SIZE_BITS' undeclared (first use in this function)
> arch/powerpc/platforms/pseries/hotplug-memory.c:27:31: note: each undeclared identifier is reported only once for each function it appears in
> arch/powerpc/platforms/pseries/hotplug-memory.c: In function 'pseries_remove_memblock':
> arch/powerpc/platforms/pseries/hotplug-memory.c:98:34: error: 'SECTION_SIZE_BITS' undeclared (first use in this function)
> make[2]: *** [arch/powerpc/platforms/pseries/hotplug-memory.o] Error 1
>
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> CC: Andew Morton <akpm@linux-foundation.org>
> ---
>  arch/powerpc/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index 9c1aa77..da16ffe 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -383,6 +383,7 @@ config ARCH_CPU_PROBE_RELEASE
>
>  config ARCH_ENABLE_MEMORY_HOTPLUG
>         def_bool y
> +       depends on SPARSEMEM
>
>  config ARCH_HAS_WALK_MEMORY
>         def_bool y
> --
> 1.9.1

In light of my investigation for your spufs patch, I guess this is a non-SMP
PSERIES config?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
