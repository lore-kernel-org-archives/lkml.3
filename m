Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978Ab3D2I0K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 04:26:10 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:59640 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756869Ab3D2I0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 04:26:08 -0400
Date: Mon, 29 Apr 2013 09:25:12 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the xen-arm
 tree
Message-ID: <20130429082511.GA539@arm.com>
References: <20130429175426.9423279609437a2d746cbb7b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130429175426.9423279609437a2d746cbb7b@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen,

On Mon, Apr 29, 2013 at 08:54:26AM +0100, Stephen Rothwell wrote:
> Today's linux-next merge of the arm-soc tree got a conflict in
> arch/arm/mach-virt/platsmp.c between commit fe4bff02886b ("arm: introduce
> psci_smp_ops") from the xen-arm tree and commit c0114709ed85 ("irqchip:
> gic: Perform the gic_secondary_init() call via CPU notifier") from the
> arm-soc tree.
> 
> The former renamed the file (and contents) so I applied the following
> patch and can carry the fix as necessary (no action is required).
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 29 Apr 2013 17:52:27 +1000
> Subject: [PATCH] arm: fix for Perform the gic_secondary_init() call via CPU
>  notifier
> 
> due to code movement.
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  arch/arm/kernel/psci_smp.c | 7 -------
>  1 file changed, 7 deletions(-)
> 
> diff --git a/arch/arm/kernel/psci_smp.c b/arch/arm/kernel/psci_smp.c
> index 6ef139d..cd9acc7 100644
> --- a/arch/arm/kernel/psci_smp.c
> +++ b/arch/arm/kernel/psci_smp.c
> @@ -14,7 +14,6 @@
>   */
>  
>  #include <linux/init.h>
> -#include <linux/irqchip/arm-gic.h>
>  #include <linux/smp.h>
>  #include <linux/of.h>
>  
> @@ -55,11 +54,6 @@ static int __cpuinit psci_boot_secondary(unsigned int cpu,
>  	return -ENODEV;
>  }
>  
> -static void __cpuinit psci_secondary_init(unsigned int cpu)
> -{
> -	gic_secondary_init(0);
> -}
> -
>  #ifdef CONFIG_HOTPLUG_CPU
>  void __ref psci_cpu_die(unsigned int cpu)
>  {
> @@ -84,7 +78,6 @@ bool __init psci_smp_available(void)
>  }
>  
>  struct smp_operations __initdata psci_smp_ops = {
> -	.smp_secondary_init	= psci_secondary_init,
>  	.smp_boot_secondary	= psci_boot_secondary,
>  	.cpu_die		= psci_cpu_die,
>  };

The fix looks fine. Thanks.

-- 
Catalin
