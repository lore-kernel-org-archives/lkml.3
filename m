Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761619Ab3LIVtz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 16:49:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56518 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761443Ab3LIVtx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 16:49:53 -0500
Date: Mon, 09 Dec 2013 16:49:38 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Xishi Qiu <qiuxishi@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Mel Gorman <mgorman@suse.de>,
        rientjes@google.com, LKML <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org
Message-ID: <1386625778-kutyp5f6-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <52A592DE.7010302@huawei.com>
References: <52A592DE.7010302@huawei.com>
Subject: Re: [PATCH] mm: add show num_poisoned_pages when oom
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <52A592DE.7010302@huawei.com>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 09, 2013 at 05:52:30PM +0800, Xishi Qiu wrote:
> Show num_poisoned_pages when oom, it is helpful to find the reason.
> 
> Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
> ---
>  lib/show_mem.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/lib/show_mem.c b/lib/show_mem.c
> index 5847a49..1cbdcd8 100644
> --- a/lib/show_mem.c
> +++ b/lib/show_mem.c
> @@ -46,4 +46,7 @@ void show_mem(unsigned int filter)
>  	printk("%lu pages in pagetable cache\n",
>  		quicklist_total_size());
>  #endif
> +#ifdef CONFIG_MEMORY_FAILURE
> +	printk("%lu pages poisoned\n", atomic_long_read(&num_poisoned_pages));
> +#endif
>  }

I think that just "poisoned" could be confusing because this word seems to
be used also in other context (like slab and list_debug handling.)
"hwpoisoned" or "hardware corrupted" (which is the same label in /proc/meminfo)
looks better to me.

Thanks,
Naoya Horiguchi
