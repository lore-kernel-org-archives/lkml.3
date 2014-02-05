Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089AbaBEKP1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 05:15:27 -0500
Received: from mail-we0-f176.google.com ([74.125.82.176]:58094 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbaBEKPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 05:15:23 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v2 4/5] ARM: init: add support for reserved memory defined by device tree
To: Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-mm-sig@lists.linaro.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>, Michal Nazarewicz <mina86@mina86.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Laura Abbott <lauraa@codeaurora.org>, Rob Herring <robh+dt@gmail.com>,
        Olof Johansson <olof@lixom.net>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Kumar Gala <galak@codeaurora.org>,
        Nishanth Peethambaran <nishanth.p@gmail.com>,
        Marc <marc.ceeeee@gmail.com>, Josh Cartwright <joshc@codeaurora.org>
In-Reply-To: <1391515773-6112-5-git-send-email-m.szyprowski@samsung.com>
References: <1391515773-6112-1-git-send-email-m.szyprowski@samsung.com> < 1391515773-6112-5-git-send-email-m.szyprowski@samsung.com>
Date: Wed, 05 Feb 2014 10:15:10 +0000
Message-Id: <20140205101510.59A95C40A89@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Feb 2014 13:09:32 +0100, Marek Szyprowski <m.szyprowski@samsung.com> wrote:
> Enable reserved memory initialization from device tree.
> 
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Laura Abbott <lauraa@codeaurora.org>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  arch/arm/mm/init.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
> index 804d61566a53..ebafdb479410 100644
> --- a/arch/arm/mm/init.c
> +++ b/arch/arm/mm/init.c
> @@ -17,6 +17,7 @@
>  #include <linux/nodemask.h>
>  #include <linux/initrd.h>
>  #include <linux/of_fdt.h>
> +#include <linux/of_reserved_mem.h>
>  #include <linux/highmem.h>
>  #include <linux/gfp.h>
>  #include <linux/memblock.h>
> @@ -323,6 +324,8 @@ void __init arm_memblock_init(struct meminfo *mi,
>  	if (mdesc->reserve)
>  		mdesc->reserve();
>  
> +	early_init_dt_scan_reserved_mem();
> +

The new binding is being made fundamental. If the reserved-memory node
is present, then it needs to be honored, even if the kernel doesn't know
how to use the regions. Therefore, This needs to be unconditional for
all architectures. The hook should be called in early_init_dt_scan()
(drivers/of/fdt.c) immediately after the early_init_dt_scan_memory()
hook.

>  	/*
>  	 * reserve memory for DMA contigouos allocations,
>  	 * must come from DMA area inside low memory
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

