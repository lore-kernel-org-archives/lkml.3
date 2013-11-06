Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612Ab3KFV32 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 16:29:28 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:19577 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755026Ab3KFV31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 16:29:27 -0500
Date: Wed, 6 Nov 2013 16:29:19 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: david.vrabel@citrix.com, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xen/balloon: Set balloon's initial state to number of
 existing RAM pages
Message-ID: <20131106212919.GB23133@phenom.dumpdata.com>
References: <1383770260-15395-1-git-send-email-boris.ostrovsky@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383770260-15395-1-git-send-email-boris.ostrovsky@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 03:37:40PM -0500, Boris Ostrovsky wrote:
> Currently balloon's initial value is set to max_pfn which includes
> non-RAM ranges such as MMIO hole. As result, initial memory target
> (specified by guest's configuration file) will appear smaller than
> what balloon driver perceives to be the current number of available
> pages. Thus it will balloon down "extra" pages, decreasing amount of
> available memory for no good reason.

Duh!

Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

> 
> Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> ---
>  drivers/xen/balloon.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
> index b232908..1b62304 100644
> --- a/drivers/xen/balloon.c
> +++ b/drivers/xen/balloon.c
> @@ -641,7 +641,7 @@ static int __init balloon_init(void)
>  
>  	balloon_stats.current_pages = xen_pv_domain()
>  		? min(xen_start_info->nr_pages - xen_released_pages, max_pfn)
> -		: max_pfn;
> +		: get_num_physpages();
>  	balloon_stats.target_pages  = balloon_stats.current_pages;
>  	balloon_stats.balloon_low   = 0;
>  	balloon_stats.balloon_high  = 0;
> -- 
> 1.8.1.4
> 
