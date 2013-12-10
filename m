Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963Ab3LJCcJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 21:32:09 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:64520 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787Ab3LJCcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 21:32:05 -0500
Date: Tue, 10 Dec 2013 03:31:37 +0100
From: Vladimir Murzin <murzin.v@gmail.com>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/hwpoison: add '#' to hwpoison_inject
Message-ID: <20131210023133.GA1849@hp530>
References: <1386632757-11783-1-git-send-email-liwanp@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <1386632757-11783-1-git-send-email-liwanp@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 07:45:57AM +0800, Wanpeng Li wrote:
> Changelog:
>  v1 -> v2:
>   * remove KERN_INFO in pr_info().
> 
> Add '#' to hwpoison_inject just as done in madvise_hwpoison.
> 
> Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
> ---
>  mm/hwpoison-inject.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/hwpoison-inject.c b/mm/hwpoison-inject.c
> index 4c84678..95487c7 100644
> --- a/mm/hwpoison-inject.c
> +++ b/mm/hwpoison-inject.c
> @@ -55,7 +55,7 @@ static int hwpoison_inject(void *data, u64 val)
>  		return 0;
>  
>  inject:
> -	printk(KERN_INFO "Injecting memory failure at pfn %lx\n", pfn);
> +	pr_info("Injecting memory failure at pfn %#lx\n", pfn);
>  	return memory_failure(pfn, 18, MF_COUNT_INCREASED);
>  }

Reviewed-by: Vladimir Murzin <murzin.v@gmail.com>

>  
> -- 
> 1.7.5.4
> 
