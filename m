Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141Ab3ENAfM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 20:35:12 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:48324 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642Ab3ENAfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 20:35:09 -0400
Date: Tue, 14 May 2013 09:35:04 +0900
From: Simon Horman <horms@verge.net.au>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Michal Simek <michal.simek@xilinx.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jamie Iles <jamie@jamieiles.com>, Magnus Damm <magnus.damm@gmail.com>,
        Christian Daudt <csd@broadcom.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        David Brown <davidb@codeaurora.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Shawn Guo <shawn.guo@linaro.org>, Barry Song <baohua.song@csr.com>,
        Tony Prisk <linux@prisktech.co.nz>,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH 05/14] ARM: shmobile: Remove init_irq declaration in
 machine description
Message-ID: <20130514003504.GE12228@verge.net.au>
References: <1368438253-28218-1-git-send-email-maxime.ripard@free-electrons.com>
 <1368438253-28218-6-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368438253-28218-6-git-send-email-maxime.ripard@free-electrons.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 13, 2013 at 11:44:04AM +0200, Maxime Ripard wrote:
> Commit ebafed7a ("ARM: irq: Call irqchip_init if no init_irq function is
> specified") removed the need to explictly setup the init_irq field in
> the machine description when using only irqchip_init. Remove that
> declaration for shmobile as well.

Hi Maxime,

If possible, I would prefer separate patches for each board and SoC.

> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  arch/arm/mach-shmobile/board-ape6evm.c         | 1 -
>  arch/arm/mach-shmobile/board-kzm9g-reference.c | 1 -
>  arch/arm/mach-shmobile/board-lager.c           | 1 -
>  arch/arm/mach-shmobile/setup-emev2.c           | 1 -
>  arch/arm/mach-shmobile/setup-r8a73a4.c         | 1 -
>  arch/arm/mach-shmobile/setup-r8a7790.c         | 1 -
>  arch/arm/mach-shmobile/setup-sh73a0.c          | 1 -
>  7 files changed, 7 deletions(-)
> 
> diff --git a/arch/arm/mach-shmobile/board-ape6evm.c b/arch/arm/mach-shmobile/board-ape6evm.c
> index 55b8c9f..913ce31 100644
> --- a/arch/arm/mach-shmobile/board-ape6evm.c
> +++ b/arch/arm/mach-shmobile/board-ape6evm.c
> @@ -87,7 +87,6 @@ static const char *ape6evm_boards_compat_dt[] __initdata = {
>  };
>  
>  DT_MACHINE_START(APE6EVM_DT, "ape6evm")
> -	.init_irq	= irqchip_init,
>  	.init_time	= shmobile_timer_init,
>  	.init_machine	= ape6evm_add_standard_devices,
>  	.dt_compat	= ape6evm_boards_compat_dt,
> diff --git a/arch/arm/mach-shmobile/board-kzm9g-reference.c b/arch/arm/mach-shmobile/board-kzm9g-reference.c
> index aefa50d..eaec498 100644
> --- a/arch/arm/mach-shmobile/board-kzm9g-reference.c
> +++ b/arch/arm/mach-shmobile/board-kzm9g-reference.c
> @@ -100,7 +100,6 @@ DT_MACHINE_START(KZM9G_DT, "kzm9g-reference")
>  	.map_io		= sh73a0_map_io,
>  	.init_early	= sh73a0_init_delay,
>  	.nr_irqs	= NR_IRQS_LEGACY,
> -	.init_irq	= irqchip_init,
>  	.init_machine	= kzm_init,
>  	.init_time	= shmobile_timer_init,
>  	.dt_compat	= kzm9g_boards_compat_dt,
> diff --git a/arch/arm/mach-shmobile/board-lager.c b/arch/arm/mach-shmobile/board-lager.c
> index f587187..c384c9f 100644
> --- a/arch/arm/mach-shmobile/board-lager.c
> +++ b/arch/arm/mach-shmobile/board-lager.c
> @@ -39,7 +39,6 @@ static const char *lager_boards_compat_dt[] __initdata = {
>  };
>  
>  DT_MACHINE_START(LAGER_DT, "lager")
> -	.init_irq	= irqchip_init,
>  	.init_time	= r8a7790_timer_init,
>  	.init_machine	= lager_add_standard_devices,
>  	.dt_compat	= lager_boards_compat_dt,
> diff --git a/arch/arm/mach-shmobile/setup-emev2.c b/arch/arm/mach-shmobile/setup-emev2.c
> index 899a86c..098ca63 100644
> --- a/arch/arm/mach-shmobile/setup-emev2.c
> +++ b/arch/arm/mach-shmobile/setup-emev2.c
> @@ -454,7 +454,6 @@ DT_MACHINE_START(EMEV2_DT, "Generic Emma Mobile EV2 (Flattened Device Tree)")
>  	.smp		= smp_ops(emev2_smp_ops),
>  	.init_early	= emev2_init_delay,
>  	.nr_irqs	= NR_IRQS_LEGACY,
> -	.init_irq	= irqchip_init,
>  	.init_machine	= emev2_add_standard_devices_dt,
>  	.dt_compat	= emev2_boards_compat_dt,
>  MACHINE_END
> diff --git a/arch/arm/mach-shmobile/setup-r8a73a4.c b/arch/arm/mach-shmobile/setup-r8a73a4.c
> index c5a75a7..6b19d50 100644
> --- a/arch/arm/mach-shmobile/setup-r8a73a4.c
> +++ b/arch/arm/mach-shmobile/setup-r8a73a4.c
> @@ -194,7 +194,6 @@ static const char *r8a73a4_boards_compat_dt[] __initdata = {
>  };
>  
>  DT_MACHINE_START(R8A73A4_DT, "Generic R8A73A4 (Flattened Device Tree)")
> -	.init_irq	= irqchip_init,
>  	.init_machine	= r8a73a4_add_standard_devices_dt,
>  	.init_time	= shmobile_timer_init,
>  	.dt_compat	= r8a73a4_boards_compat_dt,
> diff --git a/arch/arm/mach-shmobile/setup-r8a7790.c b/arch/arm/mach-shmobile/setup-r8a7790.c
> index 49de2d5..d639aad 100644
> --- a/arch/arm/mach-shmobile/setup-r8a7790.c
> +++ b/arch/arm/mach-shmobile/setup-r8a7790.c
> @@ -142,7 +142,6 @@ static const char *r8a7790_boards_compat_dt[] __initdata = {
>  };
>  
>  DT_MACHINE_START(R8A7790_DT, "Generic R8A7790 (Flattened Device Tree)")
> -	.init_irq	= irqchip_init,
>  	.init_machine	= r8a7790_add_standard_devices_dt,
>  	.init_time	= r8a7790_timer_init,
>  	.dt_compat	= r8a7790_boards_compat_dt,
> diff --git a/arch/arm/mach-shmobile/setup-sh73a0.c b/arch/arm/mach-shmobile/setup-sh73a0.c
> index fdf3894..3a7d24a 100644
> --- a/arch/arm/mach-shmobile/setup-sh73a0.c
> +++ b/arch/arm/mach-shmobile/setup-sh73a0.c
> @@ -1035,7 +1035,6 @@ DT_MACHINE_START(SH73A0_DT, "Generic SH73A0 (Flattened Device Tree)")
>  	.map_io		= sh73a0_map_io,
>  	.init_early	= sh73a0_init_delay,
>  	.nr_irqs	= NR_IRQS_LEGACY,
> -	.init_irq	= irqchip_init,
>  	.init_machine	= sh73a0_add_standard_devices_dt,
>  	.dt_compat	= sh73a0_boards_compat_dt,
>  MACHINE_END
> -- 
> 1.8.1.2
> 
