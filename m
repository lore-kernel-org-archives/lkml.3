Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755685Ab3I3SkF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 14:40:05 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:53703 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755244Ab3I3SkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 14:40:02 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: takasi-y@ops.dti.ne.jp
Cc: SH-Linux <linux-sh@vger.kernel.org>, Magnus Damm <magnus.damm@gmail.com>,
        ben.dooks@codethink.co.uk,
        Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>,
        devicetree@vger.kernel.org, linux-serial@vger.kernel.org,
        Simon Horman <horms@verge.net.au>, Paul Mundt <lethal@linux-sh.org>,
        Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] sh: clkfwk: Select sh-/common- clkfwk alternatively
Date: Mon, 30 Sep 2013 20:40:08 +0200
Message-ID: <1663688.MHxO4ng5PY@avalon>
User-Agent: KMail/4.10.5 (Linux/3.8.13-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20130924131206.d57d07f5faa5cb0773fc328c@ops.dti.ne.jp>
References: <52410F86.4040301@renesas.com> <20130924131206.d57d07f5faa5cb0773fc328c@ops.dti.ne.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yoshii-san,

Thank you for the patch.

On Tuesday 24 September 2013 13:12:06 takasi-y@ops.dti.ne.jp wrote:
> Make sh clock framework core depend on HAVE_MACH_CLKDEV, and
> set it
> - y on sh for backward compatibility
> - !CONFIG_COMMON_CLK on sh-mobile
> This is a preparation for migration to common clock framework
> from sh clock framework on sh-mobile.

While I agree with this patch, I believe the use of the HAVE_MACH_CLKDEV 
configuration option to select whether to compile core.o in is a bit of an 
abuse. I would have created a new configuration option (SH_CLK_CORE in 
drivers/sh/Kconfig for instance) as 'def_bool y' that depends on SH || (ARM && 
!COMMON_CLK).

However, as all ARCH_SHMOBILE platforms should be converted to the common 
clock framework, this is only temporary and could be revisited later, so I'm 
fine with keeping the patch as-is.

> Signed-off-by: Takashi Yoshii <takashi.yoshii.zj@renesas.com>
> ---
>  arch/arm/Kconfig        | 2 +-
>  arch/sh/Kconfig         | 1 +
>  drivers/sh/clk/Makefile | 3 +--
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 3f7714d..53044ca 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -650,7 +650,7 @@ config ARCH_SHMOBILE
>  	select HAVE_ARM_SCU if SMP
>  	select HAVE_ARM_TWD if SMP
>  	select HAVE_CLK
> -	select HAVE_MACH_CLKDEV
> +	select HAVE_MACH_CLKDEV if !COMMON_CLK
>  	select HAVE_SMP
>  	select MIGHT_HAVE_CACHE_L2X0
>  	select MULTI_IRQ_HANDLER
> diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
> index 224f4bc..f57e47f 100644
> --- a/arch/sh/Kconfig
> +++ b/arch/sh/Kconfig
> @@ -41,6 +41,7 @@ config SUPERH
>  	select MODULES_USE_ELF_RELA
>  	select OLD_SIGSUSPEND
>  	select OLD_SIGACTION
> +	select HAVE_MACH_CLKDEV
>  	help
>  	  The SuperH is a RISC processor targeted for use in embedded systems
>  	  and consumer electronics; it was also used in the Sega Dreamcast
> diff --git a/drivers/sh/clk/Makefile b/drivers/sh/clk/Makefile
> index 5d15ebf..e73b031 100644
> --- a/drivers/sh/clk/Makefile
> +++ b/drivers/sh/clk/Makefile
> @@ -1,3 +1,2 @@
> -obj-y	:= core.o
> -
> +obj-$(CONFIG_HAVE_MACH_CLKDEV)	+= core.o
>  obj-$(CONFIG_SH_CLK_CPG)	+= cpg.o
-- 
Regards,

Laurent Pinchart

