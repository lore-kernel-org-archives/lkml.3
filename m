Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226Ab3LFRso (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 12:48:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61998 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932148Ab3LFRsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 12:48:43 -0500
Date: Fri, 06 Dec 2013 12:48:19 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Message-ID: <1386352099-a1o7ki65-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1386322013-29554-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1386322013-29554-1-git-send-email-liwanp@linux.vnet.ibm.com>
Subject: Re: [PATCH] mm/hwpoison: add '#' to hwpoison_inject
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <1386322013-29554-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 06, 2013 at 05:26:53PM +0800, Wanpeng Li wrote:
> Add '#' to hwpoison_inject just as done in madvise_hwpoison.
> 
> Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>

It could affect some test code, but I checked mce-test and it doesn't
depend on this message. So maybe it's OK.

Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

Thanks,
Naoya

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
> 
