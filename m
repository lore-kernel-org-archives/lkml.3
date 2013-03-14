Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105Ab3CNPbs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 11:31:48 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:44522 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755773Ab3CNPbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 11:31:47 -0400
Date: Thu, 14 Mar 2013 10:30:25 -0500
From: scameron@beardog.cce.hp.com
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: mike.miller@hp.com, axboe@kernel.dk, akpm@linux-foundation.org,
        yongjun_wei@trendmicro.com.cn, iss_storagedev@hp.com,
        linux-kernel@vger.kernel.org, scameron@beardog.cce.hp.com
Subject: Re: [PATCH] cciss: fix invalid use of sizeof in cciss_find_cfgtables()
Message-ID: <20130314153025.GJ28545@beardog.cce.hp.com>
References: <CAPgLHd-8dxVHPbeZgcSu3XcyJozuws5YUftDO3W9W1OQVGy1Kw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPgLHd-8dxVHPbeZgcSu3XcyJozuws5YUftDO3W9W1OQVGy1Kw@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 11:19:45PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> sizeof() when applied to a pointer typed expression gives the
> size of the pointer, not that of the pointed data.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/block/cciss.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
> index ade58bc..1c1b8e5 100644
> --- a/drivers/block/cciss.c
> +++ b/drivers/block/cciss.c
> @@ -4206,7 +4206,7 @@ static int cciss_find_cfgtables(ctlr_info_t *h)
>  	if (rc)
>  		return rc;
>  	h->cfgtable = remap_pci_mem(pci_resource_start(h->pdev,
> -		cfg_base_addr_index) + cfg_offset, sizeof(h->cfgtable));
> +		cfg_base_addr_index) + cfg_offset, sizeof(*h->cfgtable));
>  	if (!h->cfgtable)
>  		return -ENOMEM;
>  	rc = write_driver_ver_to_cfgtable(h->cfgtable);
> 

Ack.

I suppose it has worked all this time because ioremap can't map less
than a page, and sizeof(*h->cfgtable) is less than a page, and likely
starts on a page boundary.

-- steve

