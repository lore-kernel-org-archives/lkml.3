Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927Ab3IEQVL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 12:21:11 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:54114 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751625Ab3IEQVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 12:21:10 -0400
Date: Thu, 5 Sep 2013 17:20:27 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
Subject: Re: [PATCH v5 05/13] xen/arm,arm64: move Xen initialization earlier
Message-ID: <20130905162026.GJ11887@arm.com>
References: <alpine.DEB.2.02.1308291917290.6397@kaball.uk.xensource.com>
 <1377801154-29215-5-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377801154-29215-5-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 07:32:26PM +0100, Stefano Stabellini wrote:
> Move Xen initialization earlier, before any DMA requests can be made.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

I guess you should cc the corresponding maintainers here.

>  arch/arm/include/asm/xen/hypervisor.h |    8 ++++++++
>  arch/arm/kernel/setup.c               |    2 ++
>  arch/arm/xen/enlighten.c              |   21 ++++++++++++++-------
>  arch/arm64/kernel/setup.c             |    2 ++
>  4 files changed, 26 insertions(+), 7 deletions(-)

[...]

> --- a/arch/arm64/kernel/setup.c
> +++ b/arch/arm64/kernel/setup.c
> @@ -53,6 +53,7 @@
>  #include <asm/traps.h>
>  #include <asm/memblock.h>
>  #include <asm/psci.h>
> +#include <asm/xen/hypervisor.h>
>  
>  unsigned int processor_id;
>  EXPORT_SYMBOL(processor_id);
> @@ -267,6 +268,7 @@ void __init setup_arch(char **cmdline_p)
>  	unflatten_device_tree();
>  
>  	psci_init();
> +	xen_early_init();

So Xen guests don't have any hope for single Image? Basically you set
dma_ops unconditionally in xen_early_init(), even if the kernel is not
intended to run under Xen.

-- 
Catalin
