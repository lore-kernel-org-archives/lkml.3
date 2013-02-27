Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757684Ab3B0B1l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 20:27:41 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:49120 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724Ab3B0B1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 20:27:39 -0500
Date: Wed, 27 Feb 2013 10:27:36 +0900
From: Simon Horman <horms@verge.net.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hideki EIRAKU <hdk@igel.co.jp>, Joerg Roedel <joro@8bytes.org>
Subject: Re: linux-next: manual merge of the renesas tree with Linus' tree
Message-ID: <20130227012736.GC13199@verge.net.au>
References: <20130227121706.899a861e9ab868621e3a968b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130227121706.899a861e9ab868621e3a968b@canb.auug.org.au>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 12:17:06PM +1100, Stephen Rothwell wrote:
> Hi Simon,
> 
> Today's linux-next merge of the renesas tree got a conflict in
> arch/arm/mach-shmobile/setup-sh73a0.c between commit 9a27dee73f55 ("ARM:
> mach-shmobile: sh73a0: Add IPMMU device") from Linus' tree and commit
> 73b21f40b61c ("ARM: shmobile: sh73a0: Do not use early devices with DT
> reference") from the renesas tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Thanks Stephen,

resolution below looks correct to me.

> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc arch/arm/mach-shmobile/setup-sh73a0.c
> index bdab575,6e80c5d..0000000
> --- a/arch/arm/mach-shmobile/setup-sh73a0.c
> +++ b/arch/arm/mach-shmobile/setup-sh73a0.c
> @@@ -781,36 -781,7 +782,36 @@@ static struct platform_device pmu_devic
>   	.resource	= pmu_resources,
>   };
>   
>  +/* an IPMMU module for ICB */
>  +static struct resource ipmmu_resources[] = {
>  +	[0] = {
>  +		.name	= "IPMMU",
>  +		.start	= 0xfe951000,
>  +		.end	= 0xfe9510ff,
>  +		.flags	= IORESOURCE_MEM,
>  +	},
>  +};
>  +
>  +static const char * const ipmmu_dev_names[] = {
>  +	"sh_mobile_lcdc_fb.0",
>  +};
>  +
>  +static struct shmobile_ipmmu_platform_data ipmmu_platform_data = {
>  +	.dev_names = ipmmu_dev_names,
>  +	.num_dev_names = ARRAY_SIZE(ipmmu_dev_names),
>  +};
>  +
>  +static struct platform_device ipmmu_device = {
>  +	.name           = "ipmmu",
>  +	.id             = -1,
>  +	.dev = {
>  +		.platform_data = &ipmmu_platform_data,
>  +	},
>  +	.resource       = ipmmu_resources,
>  +	.num_resources  = ARRAY_SIZE(ipmmu_resources),
>  +};
>  +
> - static struct platform_device *sh73a0_early_devices_dt[] __initdata = {
> + static struct platform_device *sh73a0_devices_dt[] __initdata = {
>   	&scif0_device,
>   	&scif1_device,
>   	&scif2_device,


