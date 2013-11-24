Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602Ab3KXDnt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 22:43:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36799 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756499Ab3KXDns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 22:43:48 -0500
Date: Sat, 23 Nov 2013 19:44:26 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] CMA: Fix the phys_addr_t print types
Message-ID: <20131124034426.GB3873@kroah.com>
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
> @@ -250,8 +249,8 @@ int __init dma_contiguous_reserve_area(phys_addr_t size, phys_addr_t base,
>  	*res_cma = cma;
>  	cma_area_count++;
>  
> -	pr_info("CMA: reserved %ld MiB at %08lx\n", (unsigned long)size / SZ_1M,
> -		(unsigned long)base);
> +	pr_info("CMA: reserved %ld MiB at %pa\n", (unsigned long)size / SZ_1M,
> +		&base);

Why is this pr_info() at all?  That's just noise, please move it to
pr_debug().

thanks,

greg k-h
