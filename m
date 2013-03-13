Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173Ab3CMGez (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 02:34:55 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:17805 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755144Ab3CMGex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 02:34:53 -0400
Date: Wed, 13 Mar 2013 07:34:52 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiang Liu <liuj97@gmail.com>, David Rientjes <rientjes@google.com>,
        Jiang Liu <jiang.liu@huawei.com>, Wen Congyang <wency@cn.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Jianguo Wu <wujianguo@huawei.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: Re: [PATCH v2, part2 08/10] mm/SPARC: use free_highmem_page() to
	free highmem pages into buddy system
Message-ID: <20130313063452.GA19698@merkur.ravnborg.org>
References: <1362902470-25787-1-git-send-email-jiang.liu@huawei.com> <1362902470-25787-9-git-send-email-jiang.liu@huawei.com> <20130312144215.1a92be86464bf82f81e3055e@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130312144215.1a92be86464bf82f81e3055e@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 02:42:15PM -0700, Andrew Morton wrote:
> On Sun, 10 Mar 2013 16:01:08 +0800 Jiang Liu <liuj97@gmail.com> wrote:
> 
> > Use helper function free_highmem_page() to free highmem pages into
> > the buddy system.
> > 
> > ...
> >
> > --- a/arch/sparc/mm/init_32.c
> > +++ b/arch/sparc/mm/init_32.c
> > @@ -282,14 +282,8 @@ static void map_high_region(unsigned long start_pfn, unsigned long end_pfn)
> >  	printk("mapping high region %08lx - %08lx\n", start_pfn, end_pfn);
> >  #endif
> >  
> > -	for (tmp = start_pfn; tmp < end_pfn; tmp++) {
> > -		struct page *page = pfn_to_page(tmp);
> > -
> > -		ClearPageReserved(page);
> > -		init_page_count(page);
> > -		__free_page(page);
> > -		totalhigh_pages++;
> > -	}
> > +	for (tmp = start_pfn; tmp < end_pfn; tmp++)
> > +		free_higmem_page(pfn_to_page(tmp));
> >  }
> 
> This code isn't inside #ifdef CONFIG_HIGHMEM, but afaict that's OK
> because CONFIG_HIGHMEM=n isn't possible on sparc32.
Correct - from arch/sparc/Kconfig

config HIGHMEM
        bool
        default y if SPARC32


> This patch and one other mistyped "free_highmem_page".  I got lazy and
> edited those patches in-place.
Good spot!

You can add my:
Acked-by: Sam Ravnborg <sam@ravnborg.org>

	Sam
 
