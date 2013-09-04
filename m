Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762267Ab3IDIVF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 04:21:05 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754980Ab3IDIVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 04:21:03 -0400
Message-ID: <5226ED69.8080506@nod.at>
Date: Wed, 04 Sep 2013 10:20:57 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>
CC: dedekind1@gmail.com, dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, richard.genoud@gmail.com
Subject: Re: [PATCH] UBI: fix refill_wl_user_pool()
References: <1377511730-14834-1-git-send-email-richard@nod.at>
In-Reply-To: <1377511730-14834-1-git-send-email-richard@nod.at>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 26.08.2013 12:08, schrieb Richard Weinberger:
> If no free PEBs are available refill_wl_user_pool() must not
> return with -ENOSPC immediately.
> It has to block till produce_free_peb() produced a free PEB.
> 
> Reported-and-Tested-by: Richard Genoud <richard.genoud@gmail.com>
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  drivers/mtd/ubi/wl.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
> index c95bfb1..02317c1 100644
> --- a/drivers/mtd/ubi/wl.c
> +++ b/drivers/mtd/ubi/wl.c
> @@ -599,10 +599,6 @@ static void refill_wl_user_pool(struct ubi_device *ubi)
>  	return_unused_pool_pebs(ubi, pool);
>  
>  	for (pool->size = 0; pool->size < pool->max_size; pool->size++) {
> -		if (!ubi->free.rb_node ||
> -		   (ubi->free_count - ubi->beb_rsvd_pebs < 1))
> -			break;
> -
>  		pool->pebs[pool->size] = __wl_get_peb(ubi);
>  		if (pool->pebs[pool->size] < 0)
>  			break;
> 

Artem, please don't forget do apply this patch.

Thanks,
//richard
