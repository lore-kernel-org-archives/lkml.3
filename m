Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab3KDPNy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 10:13:54 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:36233 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539Ab3KDPNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 10:13:53 -0500
Date: Mon, 4 Nov 2013 10:13:36 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Bob Liu <lliubbo@gmail.com>
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        Bob Liu <bob.liu@oracle.com>
Subject: Re: [PATCH] drivers: xen-selfballoon: consider slab pages
Message-ID: <20131104151336.GA32546@phenom.dumpdata.com>
References: <1383568764-30478-1-git-send-email-bob.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383568764-30478-1-git-send-email-bob.liu@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 04, 2013 at 08:39:24PM +0800, Bob Liu wrote:
> Currently the goal_page in xen-selfballon doesn't consider much about pages used
> in kernel space.
> A typical usage is slab pages, without consider slab pages the goal_page result
> may be too rough and lead extra memory pressure to guest os.

Does  "lead extra memory pressure" mean OOM?

> 
> Signed-off-by: Bob Liu <bob.liu@oracle.com>
> ---
>  drivers/xen/xen-selfballoon.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/xen/xen-selfballoon.c b/drivers/xen/xen-selfballoon.c
> index 21e18c1..4814759 100644
> --- a/drivers/xen/xen-selfballoon.c
> +++ b/drivers/xen/xen-selfballoon.c
> @@ -191,6 +191,8 @@ static void selfballoon_process(struct work_struct *work)
>  		tgt_pages = cur_pages; /* default is no change */
>  		goal_pages = vm_memory_committed() +
>  				totalreserve_pages +
> +				global_page_state(NR_SLAB_RECLAIMABLE) +
> +				global_page_state(NR_SLAB_UNRECLAIMABLE) +
>  				MB2PAGES(selfballoon_reserved_mb);
>  #ifdef CONFIG_FRONTSWAP
>  		/* allow space for frontswap pages to be repatriated */
> -- 
> 1.7.10.4
> 
