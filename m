Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825AbaHMIDk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 04:03:40 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:36810 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbaHMIDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 04:03:12 -0400
MIME-Version: 1.0
In-Reply-To: <53EA99C3.90203@gmail.com>
References: <53EA99C3.90203@gmail.com>
Date: Wed, 13 Aug 2014 10:03:09 +0200
X-Google-Sender-Auth: akdVC_0qHM_mXakNRKqFAsS-ZCA
Message-ID: <CAMuHMdV_2b-A+eE--cXEFA68=72HK6mqx8+TCXRMVkyhESLYxQ@mail.gmail.com>
Subject: Re: [PATCH v2] arch: Kconfig: Let all little endian architectures
 define CPU_LITTLE_ENDIAN explicitly
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
        Jean Delvare <jdelvare@suse.de>, Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Mark Salter <msalter@redhat.com>,
        "a-jacquiot@ti.com" <a-jacquiot@ti.com>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-c6x-dev@linux-c6x.org,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC kbuild

On Wed, Aug 13, 2014 at 12:48 AM, Chen Gang <gang.chen.5i5j@gmail.com> wrote:
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index c49a775..0510a5d 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -199,6 +199,11 @@ config NEED_DMA_MAP_STATE
>  config ARCH_SUPPORTS_UPROBES
>         def_bool y
>
> +config CPU_LITTLE_ENDIAN
> +       depends on !CPU_BIG_ENDIAN
> +       def_bool y
> +
> +
>  config ARCH_HAS_DMA_SET_COHERENT_MASK
>         bool

As this is a common symbol, and replicated for all affected architectures,
I'm wondering if we should have the "config CPU_LITTLE_ENDIAN" in
common Kconfig code instead, and make the individual architectures do a
"select CPU_LITTLE_ENDIAN"?

Also we could have "config CPU_BIG_ENDIAN", too, and error out
if none or both are selected (can Kconfig error out?).

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
