Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189AbaHEPWc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 11:22:32 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:32427 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122AbaHEPWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 11:22:31 -0400
Date: Tue, 5 Aug 2014 11:22:24 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] swiotlb: Make linux/swiotlb.h standalone includable
Message-ID: <20140805152224.GD19709@laptop.dumpdata.com>
References: <1407243531-20538-1-git-send-email-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407243531-20538-1-git-send-email-thierry.reding@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2014 at 02:58:51PM +0200, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> This header file uses the enum dma_data_direction and struct page types
> without explicitly including the corresponding header files. This makes
> it rely on the includer to have included the proper headers before.
> 
> To fix this, include linux/dma-direction.h and forward-declare struct
> page. The swiotlb_free() function is also annotated __init, therefore
> requires linux/init.h to be included as well.
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
> Alternatively rather than include linux/init.h for swiotlb_free() it
> should be possible to simply remove the annotation in the header since
> the implementation already has it and that's where it matters.

This is fine. Will queue it up for 3.17. Thanks!
> 
>  include/linux/swiotlb.h | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
> index e7a018eaf3a2..017fced60242 100644
> --- a/include/linux/swiotlb.h
> +++ b/include/linux/swiotlb.h
> @@ -1,10 +1,13 @@
>  #ifndef __LINUX_SWIOTLB_H
>  #define __LINUX_SWIOTLB_H
>  
> +#include <linux/dma-direction.h>
> +#include <linux/init.h>
>  #include <linux/types.h>
>  
>  struct device;
>  struct dma_attrs;
> +struct page;
>  struct scatterlist;
>  
>  extern int swiotlb_force;
> -- 
> 2.0.4
> 
