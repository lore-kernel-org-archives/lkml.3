Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750834Ab3IFGcM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 02:32:12 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:17390 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab3IFGcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 02:32:10 -0400
Message-ID: <522976DC.8080301@oracle.com>
Date: Fri, 06 Sep 2013 14:31:56 +0800
From: Bob Liu <bob.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Weijie Yang <weijie.yang@samsung.com>
CC: sjenning@linux.vnet.ibm.com, minchan@kernel.org, weijie.yang.kh@gmail.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/4] mm/zswap: avoid unnecessary page scanning
References: <000701ceaac0$71c43590$554ca0b0$%yang@samsung.com>
In-Reply-To: <000701ceaac0$71c43590$554ca0b0$%yang@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 09/06/2013 01:16 PM, Weijie Yang wrote:
> add SetPageReclaim before __swap_writepage so that page can be moved to the
> tail of the inactive list, which can avoid unnecessary page scanning as this
> page was reclaimed by swap subsystem before.
> 
> Signed-off-by: Weijie Yang <weijie.yang@samsung.com>

Reviewed-by: Bob Liu <bob.liu@oracle.com>

> ---
>  mm/zswap.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 1be7b90..cc40e6a 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -556,6 +556,9 @@ static int zswap_writeback_entry(struct zbud_pool *pool, unsigned long handle)
>  		SetPageUptodate(page);
>  	}
>  
> +	/* move it to the tail of the inactive list after end_writeback */
> +	SetPageReclaim(page);
> +
>  	/* start writeback */
>  	__swap_writepage(page, &wbc, end_swap_bio_write);
>  	page_cache_release(page);
> 

-- 
Regards,
-Bob
