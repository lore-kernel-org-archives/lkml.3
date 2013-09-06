Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750789Ab3IFGbg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 02:31:36 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:17181 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab3IFGbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 02:31:35 -0400
Message-ID: <522976B4.3010509@oracle.com>
Date: Fri, 06 Sep 2013 14:31:16 +0800
From: Bob Liu <bob.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Weijie Yang <weijie.yang@samsung.com>
CC: sjenning@linux.vnet.ibm.com, minchan@kernel.org, weijie.yang.kh@gmail.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/4] mm/zswap: bugfix: memory leak when re-swapon
References: <000901ceaac0$a5f28420$f1d78c60$%yang@samsung.com>
In-Reply-To: <000901ceaac0$a5f28420$f1d78c60$%yang@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 09/06/2013 01:16 PM, Weijie Yang wrote:
> zswap_tree is not freed when swapoff, and it got re-kmalloc in swapon,
> so memory-leak occurs.
> 
> Modify: free memory of zswap_tree in zswap_frontswap_invalidate_area().
> 
> Signed-off-by: Weijie Yang <weijie.yang@samsung.com>

Reviewed-by: Bob Liu <bob.liu@oracle.com>

> ---
>  mm/zswap.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index deda2b6..cbd9578 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -816,6 +816,10 @@ static void zswap_frontswap_invalidate_area(unsigned type)
>  	}
>  	tree->rbroot = RB_ROOT;
>  	spin_unlock(&tree->lock);
> +
> +	zbud_destroy_pool(tree->pool);
> +	kfree(tree);
> +	zswap_trees[type] = NULL;
>  }
>  
>  static struct zbud_ops zswap_zbud_ops = {
> 

-- 
Regards,
-Bob
