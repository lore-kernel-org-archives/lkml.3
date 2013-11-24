Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573Ab3KXDnK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 22:43:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36793 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381Ab3KXDnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 22:43:07 -0500
Date: Sat, 23 Nov 2013 19:43:45 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] CMA: Fix the phys_addr_t print types
Message-ID: <20131124034345.GA3873@kroah.com>
References: <1385264221-29952-1-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385264221-29952-1-git-send-email-santosh.shilimkar@ti.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 23, 2013 at 10:37:01PM -0500, Santosh Shilimkar wrote:
> Otherwise prints would truncate the variables on LPAE machines.
> 
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> ---
>  drivers/base/dma-contiguous.c |    9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/base/dma-contiguous.c b/drivers/base/dma-contiguous.c
> index 165c2c2..b303a98 100644
> --- a/drivers/base/dma-contiguous.c
> +++ b/drivers/base/dma-contiguous.c
> @@ -201,9 +201,8 @@ int __init dma_contiguous_reserve_area(phys_addr_t size, phys_addr_t base,
>  	phys_addr_t alignment;
>  	int ret = 0;
>  
> -	pr_debug("%s(size %lx, base %08lx, limit %08lx)\n", __func__,
> -		 (unsigned long)size, (unsigned long)base,
> -		 (unsigned long)limit);
> +	pr_info("%s(size %pa, base %pa, limit %pa)\n", __func__,
> +		 &size, &base, &limit);

Why did you change the logging level of this message?
