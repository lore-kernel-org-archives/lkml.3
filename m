Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077Ab3KUEMN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 23:12:13 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:45471 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab3KUEMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 23:12:09 -0500
Date: Thu, 21 Nov 2013 13:12:06 +0900
From: Simon Horman <horms@verge.net.au>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH 04/05] ARM: shmobile: Add r8a7791 thermal platform device
Message-ID: <20131121041204.GM31130@verge.net.au>
References: <20131120075921.23557.23231.sendpatchset@w520>
 <20131120075956.23557.51924.sendpatchset@w520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131120075956.23557.51924.sendpatchset@w520>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 04:59:56PM +0900, Magnus Damm wrote:
> From: Magnus Damm <damm@opensource.se>
> 
> Add a thermal platform device for the legacy case
> on the r8a7791 SoC. This keeps the r8a7791 in sync
> with the r8a7790 sister device.
> 
> Signed-off-by: Magnus Damm <damm@opensource.se>
> ---
> 
>  arch/arm/mach-shmobile/setup-r8a7791.c |   12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 


Thanks, I will queue this up.
Assuming all goes will I plan to push this and other updates
today or tomorrow.

> --- 0001/arch/arm/mach-shmobile/setup-r8a7791.c
> +++ work/arch/arm/mach-shmobile/setup-r8a7791.c	2013-11-20 15:54:42.000000000 +0900
> @@ -189,6 +189,17 @@ static struct resource irqc0_resources[]
>  					  &irqc##idx##_data,		\
>  					  sizeof(struct renesas_irqc_config))
>  
> +static const struct resource thermal_resources[] __initconst = {
> +	DEFINE_RES_MEM(0xe61f0000, 0x14),
> +	DEFINE_RES_MEM(0xe61f0100, 0x38),
> +	DEFINE_RES_IRQ(gic_spi(69)),
> +};
> +
> +#define r8a7791_register_thermal()					\
> +	platform_device_register_simple("rcar_thermal", -1,		\
> +					thermal_resources,		\
> +					ARRAY_SIZE(thermal_resources))
> +
>  void __init r8a7791_add_dt_devices(void)
>  {
>  	r8a7791_register_scif(SCIFA0);
> @@ -213,6 +224,7 @@ void __init r8a7791_add_standard_devices
>  {
>  	r8a7791_add_dt_devices();
>  	r8a7791_register_irqc(0);
> +	r8a7791_register_thermal();
>  }
>  
>  void __init r8a7791_init_early(void)
> 
