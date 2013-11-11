Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886Ab3KKXY4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 18:24:56 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:17175
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753706Ab3KKXYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 18:24:49 -0500
X-Forefront-Antispam-Report: CIP:66.35.236.232;KIP:(null);UIP:(null);IPV:NLI;H:SJ-ITEXEDGE02.altera.priv.altera.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(z579ehz98dI936eI1432I4015Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2fh2a8h839h93fhd24hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1e23h1fe8h1ff5h2218h2216h1155h)
Message-ID: <1384212295.3765.0.camel@linux-builds1>
Subject: Re: [PATCH V2 4/4] arm: socfgpa: make use of common
 scu_a9_get_base() interface
From: Dinh Nguyen <dinguyen@altera.com>
To: Jisheng Zhang <jszhang@marvell.com>
CC: <rob.herring@calxeda.com>, <linux@arm.linux.org.uk>,
        <kernel@pengutronix.de>, <baohua@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Date: Mon, 11 Nov 2013 17:24:55 -0600
In-Reply-To: <1383794204-4714-5-git-send-email-jszhang@marvell.com>
References: <1383794204-4714-1-git-send-email-jszhang@marvell.com>
	 <1383794204-4714-5-git-send-email-jszhang@marvell.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-OriginatorOrg: altera.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-11-07 at 11:16 +0800, Jisheng Zhang wrote:
> Make use of common scu_a9_get_base() and delete the comment since the
> interface is self commented.
> 
> Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
> ---
>  arch/arm/mach-socfpga/socfpga.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/mach-socfpga/socfpga.c b/arch/arm/mach-socfpga/socfpga.c
> index bfce964..b695887 100644
> --- a/arch/arm/mach-socfpga/socfpga.c
> +++ b/arch/arm/mach-socfpga/socfpga.c
> @@ -24,6 +24,7 @@
>  #include <asm/hardware/cache-l2x0.h>
>  #include <asm/mach/arch.h>
>  #include <asm/mach/map.h>
> +#include <asm/smp_scu.h>
>  
>  #include "core.h"
>  
> @@ -51,8 +52,7 @@ static void __init socfpga_scu_map_io(void)
>  {
>  	unsigned long base;
>  
> -	/* Get SCU base */
> -	asm("mrc p15, 4, %0, c15, c0, 0" : "=r" (base));
> +	base = scu_a9_get_base();
>  
>  	scu_io_desc.pfn = __phys_to_pfn(base);
>  	iotable_init(&scu_io_desc, 1);

Acked-by: Dinh Nguyen <dinguyen@altera.com>

Thanks,



