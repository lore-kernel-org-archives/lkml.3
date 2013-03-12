Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933628Ab3CLVmT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 17:42:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59639 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932732Ab3CLVmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 17:42:17 -0400
Date: Tue, 12 Mar 2013 14:42:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiang Liu <liuj97@gmail.com>
Cc: David Rientjes <rientjes@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Jianguo Wu <wujianguo@huawei.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Sam Ravnborg <sam@ravnborg.org>, sparclinux@vger.kernel.org
Subject: Re: [PATCH v2, part2 08/10] mm/SPARC: use free_highmem_page() to
 free highmem pages into buddy system
Message-Id: <20130312144215.1a92be86464bf82f81e3055e@linux-foundation.org>
In-Reply-To: <1362902470-25787-9-git-send-email-jiang.liu@huawei.com>
References: <1362902470-25787-1-git-send-email-jiang.liu@huawei.com>
	<1362902470-25787-9-git-send-email-jiang.liu@huawei.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Mar 2013 16:01:08 +0800 Jiang Liu <liuj97@gmail.com> wrote:

> Use helper function free_highmem_page() to free highmem pages into
> the buddy system.
> 
> ...
>
> --- a/arch/sparc/mm/init_32.c
> +++ b/arch/sparc/mm/init_32.c
> @@ -282,14 +282,8 @@ static void map_high_region(unsigned long start_pfn, unsigned long end_pfn)
>  	printk("mapping high region %08lx - %08lx\n", start_pfn, end_pfn);
>  #endif
>  
> -	for (tmp = start_pfn; tmp < end_pfn; tmp++) {
> -		struct page *page = pfn_to_page(tmp);
> -
> -		ClearPageReserved(page);
> -		init_page_count(page);
> -		__free_page(page);
> -		totalhigh_pages++;
> -	}
> +	for (tmp = start_pfn; tmp < end_pfn; tmp++)
> +		free_higmem_page(pfn_to_page(tmp));
>  }

This code isn't inside #ifdef CONFIG_HIGHMEM, but afaict that's OK
because CONFIG_HIGHMEM=n isn't possible on sparc32.

This patch and one other mistyped "free_highmem_page".  I got lazy and
edited those patches in-place.

