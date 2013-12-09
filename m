Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934123Ab3LIQ2l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 11:28:41 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:56097 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932938Ab3LIQ1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 11:27:52 -0500
Date: Mon, 9 Dec 2013 17:27:27 +0100
From: Vladimir Murzin <murzin.v@gmail.com>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/hwpoison: add '#' to hwpoison_inject
Message-ID: <20131209162723.GA2236@hp530>
References: <1386322013-29554-1-git-send-email-liwanp@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <1386322013-29554-1-git-send-email-liwanp@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wanpeng

On Fri, Dec 06, 2013 at 05:26:53PM +0800, Wanpeng Li wrote:
> Add '#' to hwpoison_inject just as done in madvise_hwpoison.
> 
> Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
> ---
>  mm/hwpoison-inject.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/hwpoison-inject.c b/mm/hwpoison-inject.c
> index 4c84678..146cead 100644
> --- a/mm/hwpoison-inject.c
> +++ b/mm/hwpoison-inject.c
> @@ -55,7 +55,7 @@ static int hwpoison_inject(void *data, u64 val)
>  		return 0;
>  
>  inject:
> -	printk(KERN_INFO "Injecting memory failure at pfn %lx\n", pfn);
> +	pr_info(KERN_INFO "Injecting memory failure at pfn %#lx\n", pfn);

You don't need KERN_INFO here.

Vladimir

>  	return memory_failure(pfn, 18, MF_COUNT_INCREASED);
>  }
>  
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
