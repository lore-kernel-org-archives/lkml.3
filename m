Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757745Ab3G3Uld (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 16:41:33 -0400
Received: from mga11.intel.com ([192.55.52.93]:12168 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757331Ab3G3Ulc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 16:41:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,781,1367996400"; 
   d="scan'208";a="378568925"
Date: Tue, 30 Jul 2013 13:41:25 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: James Hogan <james.hogan@imgtec.com>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH] usb: xhci: add missing dma-mapping.h includes
Message-ID: <20130730204125.GD10202@xanatos>
References: <1374842083-5935-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374842083-5935-1-git-send-email-james.hogan@imgtec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the patch James!  I'll send it off to Greg in a couple days.

Sarah Sharp

On Fri, Jul 26, 2013 at 01:34:43PM +0100, James Hogan wrote:
> A randconfig build hit the following build errors because xhci.c and
> xhci-mem.c use dma mapping functions but don't include
> <linux/dma-mapping.h>. Add the missing includes to fix the build errors.
> 
> drivers/usb/host/xhci.c In function 'xhci_gen_setup':
> drivers/usb/host/xhci.c +4872 : error: implicit declaration of function 'dma_set_mask'
> drivers/usb/host/xhci.c +4872 : error: implicit declaration of function 'DMA_BIT_MASK'
> 
> drivers/usb/host/xhci-mem.c In function 'xhci_free_stream_ctx':
> drivers/usb/host/xhci-mem.c +435 : error: implicit declaration of function 'dma_free_coherent'
> drivers/usb/host/xhci-mem.c In function 'xhci_alloc_stream_ctx':
> drivers/usb/host/xhci-mem.c +463 : error: implicit declaration of function 'dma_alloc_coherent'
> 
> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: linux-usb@vger.kernel.org
> Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>
> ---
>  drivers/usb/host/xhci-mem.c | 1 +
>  drivers/usb/host/xhci.c     | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
> index fbf75e5..3e27d92 100644
> --- a/drivers/usb/host/xhci-mem.c
> +++ b/drivers/usb/host/xhci-mem.c
> @@ -24,6 +24,7 @@
>  #include <linux/pci.h>
>  #include <linux/slab.h>
>  #include <linux/dmapool.h>
> +#include <linux/dma-mapping.h>
>  
>  #include "xhci.h"
>  
> diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
> index d8f640b..247020c 100644
> --- a/drivers/usb/host/xhci.c
> +++ b/drivers/usb/host/xhci.c
> @@ -27,6 +27,7 @@
>  #include <linux/moduleparam.h>
>  #include <linux/slab.h>
>  #include <linux/dmi.h>
> +#include <linux/dma-mapping.h>
>  
>  #include "xhci.h"
>  
> -- 
> 1.8.1.2
> 
> 
