Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758565Ab3KHXNN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 18:13:13 -0500
Received: from relais.videotron.ca ([24.201.245.36]:14237 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758059Ab3KHXNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 18:13:12 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Fri, 08 Nov 2013 18:13:02 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: make OABI default to off
In-reply-to: <20131106211352.GA24006@www.outflux.net>
Message-id: <alpine.LFD.2.03.1311081809050.15571@syhkavp.arg>
References: <20131106211352.GA24006@www.outflux.net>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Nov 2013, Kees Cook wrote:

> Given recent discussions about the lack of OABI in the wild, switch
> CONFIG_OABI_COMPAT to off-by-default to encourage more system builders
> to avoid it.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Acked-by: Nicolas Pitre <nico@linaro.org>

> ---
>  arch/arm/Kconfig |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 1ad6fb6c094d..4ace7f33e8a1 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -1728,7 +1728,7 @@ config AEABI
>  config OABI_COMPAT
>  	bool "Allow old ABI binaries to run with this kernel (EXPERIMENTAL)"
>  	depends on AEABI && !THUMB2_KERNEL
> -	default y
> +	default n
>  	help
>  	  This option preserves the old syscall interface along with the
>  	  new (ARM EABI) one. It also provides a compatibility layer to
> @@ -1740,7 +1740,7 @@ config OABI_COMPAT
>  	  can say N here. If this option is not selected and you attempt
>  	  to execute a legacy ABI binary then the result will be
>  	  UNPREDICTABLE (in fact it can be predicted that it won't work
> -	  at all). If in doubt say Y.
> +	  at all). If in doubt say N.
>  
>  config ARCH_HAS_HOLES_MEMORYMODEL
>  	bool
> -- 
> 1.7.9.5
> 
> 
> -- 
> Kees Cook
> Chrome OS Security
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
