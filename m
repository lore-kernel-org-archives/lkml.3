Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932277Ab3D3OFJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 10:05:09 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:36561 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932249Ab3D3OFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 10:05:08 -0400
X-IronPort-AV: E=Sophos;i="4.87,582,1363132800"; 
   d="scan'208";a="21317247"
Date: Tue, 30 Apr 2013 15:05:04 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        "tixy@linaro.org" <tixy@linaro.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [PATCH] ARM: add the "bool" type definition to asm/mach/arch.h
In-Reply-To: <1367325487-8366-1-git-send-email-nicolas.ferre@atmel.com>
Message-ID: <alpine.DEB.2.02.1304301504530.5398@kaball.uk.xensource.com>
References: <517F8FF4.3050901@atmel.com> <1367325487-8366-1-git-send-email-nicolas.ferre@atmel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Apr 2013, Nicolas Ferre wrote:
> Addition of boolean field to machine_desc structure in commit
> 4dbfa9a25367cfa91aec0e56d75a6905d3242cd3 (ARM: Enable selection of
> SMP operations at boot time) was triggering compilation errors like:
> 
>   CC      arch/arm/mach-at91/at91sam9260_devices.o
> In file included from arch/arm/mach-at91/at91sam9260_devices.c:12:0:
> arch/arm/include/asm/mach/arch.h:46:2: error: expected specifier-qualifier-list before "bool"
> 
> So, we add the definition of "bool" by including the linux/types.h
> file to asm/mach/arch.h and make it self-contained.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>


>  arch/arm/include/asm/mach/arch.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm/include/asm/mach/arch.h b/arch/arm/include/asm/mach/arch.h
> index af8c54c..75bf079 100644
> --- a/arch/arm/include/asm/mach/arch.h
> +++ b/arch/arm/include/asm/mach/arch.h
> @@ -8,6 +8,8 @@
>   * published by the Free Software Foundation.
>   */
>  
> +#include <linux/types.h>
> +
>  #ifndef __ASSEMBLY__
>  
>  struct tag;
> -- 
> 1.8.0
> 
