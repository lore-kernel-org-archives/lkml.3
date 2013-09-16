Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751671Ab3IPV2P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 17:28:15 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45489 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630Ab3IPV2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 17:28:12 -0400
Message-ID: <5237617F.6010107@jp.fujitsu.com>
Date: Mon, 16 Sep 2013 15:52:31 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: liwanp@linux.vnet.ibm.com
CC: akpm@linux-foundation.org, iamjoonsoo.kim@lge.com, rientjes@google.com,
        kosaki.motohiro@jp.fujitsu.com, zhangyanfei@cn.fujitsu.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH v5 1/4] mm/vmalloc: don't set area->caller twice
References: <1379202342-23140-1-git-send-email-liwanp@linux.vnet.ibm.com>
In-Reply-To: <1379202342-23140-1-git-send-email-liwanp@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/14/2013 7:45 PM, Wanpeng Li wrote:
> Changelog:
>  *v1 -> v2: rebase against mmotm tree
> 
> The caller address has already been set in set_vmalloc_vm(), there's no need

                                            setup_vmalloc_vm()

> to set it again in __vmalloc_area_node.
> 
> Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
> Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
> ---
>  mm/vmalloc.c | 1 -
>  1 file changed, 1 deletion(-)
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

Then, __vmalloc_area_node() no longer need "caller" argument. It can use area->caller instead.


