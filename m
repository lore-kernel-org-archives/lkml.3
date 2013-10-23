Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085Ab3JWNlq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 09:41:46 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:47068 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752Ab3JWNlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 09:41:44 -0400
Date: Wed, 23 Oct 2013 09:41:38 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Jim Davis <jim.epost@gmail.com>, Zoltan Kiss <zoltan.kiss@citrix.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing/events: Fix swiotlb tracepoint creation
Message-ID: <20131023134138.GA27771@phenom.dumpdata.com>
References: <20131022180625.GD20496@phenom.dumpdata.com>
 <1382527924-12892-1-git-send-email-treding@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382527924-12892-1-git-send-email-treding@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 01:32:04PM +0200, Thierry Reding wrote:
> Tracepoints are only created when Xen support is enabled, but they are
> also referenced within lib/swiotlb.c. So unless Xen support is enabled
> the tracepoints will be missing, therefore causing builds to fail. Fix
> this by moving the tracepoint creation to lib/swiotlb.c, which works
> nicely because the Xen swiotlb support selects the generic swiotlb
> support.

Sweet. Thanks!
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
>  drivers/xen/swiotlb-xen.c | 1 -
>  lib/swiotlb.c             | 1 +
>  2 files changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
> index b310810..44af9d8 100644
> --- a/drivers/xen/swiotlb-xen.c
> +++ b/drivers/xen/swiotlb-xen.c
> @@ -43,7 +43,6 @@
>  #include <xen/xen-ops.h>
>  #include <xen/hvc-console.h>
>  
> -#define CREATE_TRACE_POINTS
>  #include <trace/events/swiotlb.h>
>  /*
>   * Used to do a quick range check in swiotlb_tbl_unmap_single and
> diff --git a/lib/swiotlb.c b/lib/swiotlb.c
> index f0d8419..5558706 100644
> --- a/lib/swiotlb.c
> +++ b/lib/swiotlb.c
> @@ -38,6 +38,7 @@
>  #include <linux/bootmem.h>
>  #include <linux/iommu-helper.h>
>  
> +#define CREATE_TRACE_POINTS
>  #include <trace/events/swiotlb.h>
>  
>  #define OFFSET(val,align) ((unsigned long)	\
> -- 
> 1.8.4
> 
