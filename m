Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827Ab3KVPW2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 10:22:28 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:28389 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750Ab3KVPW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 10:22:26 -0500
Date: Fri, 22 Nov 2013 10:21:10 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Matt Wilson <msw@linux.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: xen-devel@lists.xenproject.org, Matt Wilson <msw@amazon.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Anthony Liguori <aliguori@amazon.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xen/gnttab: leave lazy MMU mode in the case of a m2p
 override failure
Message-ID: <20131122152110.GA3124@phenom.dumpdata.com>
References: <1384978295-18292-1-git-send-email-msw@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384978295-18292-1-git-send-email-msw@linux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 12:11:35PM -0800, Matt Wilson wrote:
> From: Matt Wilson <msw@amazon.com>
> 
> Commit f62805f1 introduced a bug where lazy MMU mode isn't exited if a
> m2p_add/remove_override call fails.

Stefano?

> 
> Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> Cc: David Vrabel <david.vrabel@citrix.com>
> Cc: Anthony Liguori <aliguori@amazon.com>
> Cc: xen-devel@lists.xenproject.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Matt Wilson <msw@amazon.com>
> ---
>  drivers/xen/grant-table.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
> index 62ccf54..0283871 100644
> --- a/drivers/xen/grant-table.c
> +++ b/drivers/xen/grant-table.c
> @@ -930,9 +930,10 @@ int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
>  		ret = m2p_add_override(mfn, pages[i], kmap_ops ?
>  				       &kmap_ops[i] : NULL);
>  		if (ret)
> -			return ret;
> +			goto out;
>  	}
>  
> + out:
>  	if (lazy)
>  		arch_leave_lazy_mmu_mode();
>  
> @@ -969,9 +970,10 @@ int gnttab_unmap_refs(struct gnttab_unmap_grant_ref *unmap_ops,
>  		ret = m2p_remove_override(pages[i], kmap_ops ?
>  				       &kmap_ops[i] : NULL);
>  		if (ret)
> -			return ret;
> +			goto out;
>  	}
>  
> + out:
>  	if (lazy)
>  		arch_leave_lazy_mmu_mode();
>  
> -- 
> 1.7.9.5
> 
