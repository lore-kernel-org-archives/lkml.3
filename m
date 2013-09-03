Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759420Ab3ICFfU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 01:35:20 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:17638 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759378Ab3ICFfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 01:35:19 -0400
X-IronPort-AV: E=Sophos;i="4.89,1011,1367942400"; 
   d="scan'208";a="8387063"
Message-ID: <52257502.5010405@cn.fujitsu.com>
Date: Tue, 03 Sep 2013 13:34:58 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] mm/vmalloc: don't set area->caller twice
References: <1378177220-26218-1-git-send-email-liwanp@linux.vnet.ibm.com>
In-Reply-To: <1378177220-26218-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/03 13:33:06,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/03 13:33:09,
	Serialize complete at 2013/09/03 13:33:09
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2013 11:00 AM, Wanpeng Li wrote:
> Changelog:
>  * rebase against mmotm tree
> 
> The caller address has already been set in set_vmalloc_vm(), there's no need
> to set it again in __vmalloc_area_node.
> 
> Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>

Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

> ---
>  mm/vmalloc.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 1074543..d78d117 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -1566,7 +1566,6 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
>  		pages = kmalloc_node(array_size, nested_gfp, node);
>  	}
>  	area->pages = pages;
> -	area->caller = caller;
>  	if (!area->pages) {
>  		remove_vm_area(area->addr);
>  		kfree(area);
> 


-- 
Thanks.
Zhang Yanfei
