Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276AbaBLQtO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 11:49:14 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:40129 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbaBLQtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 11:49:12 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [RFC/PATCH 2/3] arm: Add ARCH_WANT_OF_RANDOMNESS
To: Laura Abbott <lauraa@codeaurora.org>, Rob Herring <robh+dt@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: Laura Abbott <lauraa@codeaurora.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kumar Gala <galak@codeaurora.org>, Kees Cook <keescook@chromium.org>
In-Reply-To: <1392168805-14200-3-git-send-email-lauraa@codeaurora.org>
References: <1392168805-14200-1-git-send-email-lauraa@codeaurora.org> < 1392168805-14200-3-git-send-email-lauraa@codeaurora.org>
Date: Wed, 12 Feb 2014 16:49:07 +0000
Message-Id: <20140212164907.0E958C407C9@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Feb 2014 17:33:24 -0800, Laura Abbott <lauraa@codeaurora.org> wrote:
> The stack canary for ARM is currently the same across reboots
> due to lack of randomness early enough. Add ARCH_WANT_OF_RANDOMNESS
> to allow devices to add whatever randomness they need.
> 
> Signed-off-by: Laura Abbott <lauraa@codeaurora.org>

Do you have a draft patch for a user of this yet?

g.

> ---
>  arch/arm/Kconfig              |    3 +++
>  arch/arm/kernel/vmlinux.lds.S |    1 +
>  2 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index e254198..7ab0db1 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -222,6 +222,9 @@ config NEED_RET_TO_USER
>  config ARCH_MTD_XIP
>  	bool
>  
> +config ARCH_WANT_OF_RANDOMNESS
> +	def_bool n
> +
>  config VECTORS_BASE
>  	hex
>  	default 0xffff0000 if MMU || CPU_HIGH_VECTOR
> diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
> index 7bcee5c..2198258 100644
> --- a/arch/arm/kernel/vmlinux.lds.S
> +++ b/arch/arm/kernel/vmlinux.lds.S
> @@ -202,6 +202,7 @@ SECTIONS
>  		INIT_SETUP(16)
>  		INIT_CALLS
>  		CON_INITCALL
> +		EARLY_RANDOM_FUNCS
>  		SECURITY_INITCALL
>  		INIT_RAM_FS
>  	}
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
> 

