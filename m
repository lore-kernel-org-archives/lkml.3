Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab3CEMCq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 07:02:46 -0500
Received: from mail.nanl.de ([217.115.11.12]:52603 "EHLO mail.nanl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351Ab3CEMCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 07:02:45 -0500
X-Greylist: delayed 619 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Mar 2013 07:02:45 EST
MIME-Version: 1.0
In-Reply-To: <1362477800.16460.69.camel@x61.thuisdomein>
References: <1362477800.16460.69.camel@x61.thuisdomein>
From: Jonas Gorski <jogo@openwrt.org>
Date: Tue, 5 Mar 2013 12:51:56 +0100
Message-ID: <CAOiHx=nzNVatEp0nyfZKU2p35+1kjrw6VsvZTP+QPJykWF3JAg@mail.gmail.com>
Subject: Re: [PATCH] MIPS: Get rid of CONFIG_CPU_HAS_LLSC again
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 March 2013 11:03, Paul Bolle <pebolle@tiscali.nl> wrote:
> Commit f7ade3c168e4f437c11f57be012992bbb0e3075c ("MIPS: Get rid of
> CONFIG_CPU_HAS_LLSC") did what it promised to do. But since then that
> macro and its Kconfig symbol popped up again. Get rid of those again.
>
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> 0) Untested.

Obviously :p.

> 1) The related commits are 1c773ea4dceff889c2f872343609a87ae0cfbf56
> ("MIPS: Netlogic: Add XLP makefiles and config") and
> 3070033a16edcc21688d5ea8967c89522f833862 ("MIPS: Add core files for MIPS
> SEAD-3 development platform.").
>
>  arch/mips/Kconfig                                        | 1 -
>  arch/mips/include/asm/mach-sead3/cpu-feature-overrides.h | 3 ---
>  2 files changed, 4 deletions(-)
>
> diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
> index ae9c716..310f1e6 100644
> --- a/arch/mips/Kconfig
> +++ b/arch/mips/Kconfig
> @@ -1493,7 +1493,6 @@ config CPU_XLP
>         select CPU_SUPPORTS_32BIT_KERNEL
>         select CPU_SUPPORTS_64BIT_KERNEL
>         select CPU_SUPPORTS_HIGHMEM
> -       select CPU_HAS_LLSC
>         select WEAK_ORDERING
>         select WEAK_REORDERING_BEYOND_LLSC
>         select CPU_HAS_PREFETCH
> diff --git a/arch/mips/include/asm/mach-sead3/cpu-feature-overrides.h b/arch/mips/include/asm/mach-sead3/cpu-feature-overrides.h
> index d9c8284..2a945b4 100644
> --- a/arch/mips/include/asm/mach-sead3/cpu-feature-overrides.h
> +++ b/arch/mips/include/asm/mach-sead3/cpu-feature-overrides.h
> @@ -28,9 +28,6 @@
>  /* #define cpu_has_prefetch    ? */
>  #define cpu_has_mcheck         1
>  /* #define cpu_has_ejtag       ? */
> -#ifdef CONFIG_CPU_HAS_LLSC
> -#define cpu_has_llsc           1
> -#else
>  #define cpu_has_llsc           0
>  #endif

You need to remove these two lines, too, else you have an #endif without an #if.

>  /* #define cpu_has_vtag_icache ? */
> --
> 1.7.11.7
>
>
