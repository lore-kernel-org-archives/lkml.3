Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350Ab3GaLSJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 07:18:09 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:43406 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755596Ab3GaLSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 07:18:07 -0400
X-AuditID: cbfee61a-b7f196d000007dfa-d5-51f8f26d8c16
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Joonyoung Shim <jy0922.shim@samsung.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, liuj97@gmail.com,
        kosaki.motohiro@gmail.com
Subject: Re: [PATCH] Revert
 "mm/memory-hotplug: fix lowmem count overflow when offline pages"
Date: Wed, 31 Jul 2013 13:17:46 +0200
Message-id: <1572085.gN7iX7IvMe@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-45-generic; KDE/4.8.5; i686; ; )
In-reply-to: <1375260602-2462-1-git-send-email-jy0922.shim@samsung.com>
References: <1375260602-2462-1-git-send-email-jy0922.shim@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKLMWRmVeSWpSXmKPExsVy+t9jQd3cTz8CDR40y1rMWb+GzeLFvYss
	Fs+2cFtc3jWHzeLemv+sFs1HNjI5sHnsnHWX3WPTp0nsHidm/Gbx6NuyitHj8ya5ANYoLpuU
	1JzMstQifbsErox/56+zFrzjqfg96RNzA+Nxri5GTg4JAROJS4f3s0LYYhIX7q1n62Lk4hAS
	mM4o8frrbiinhUmi7+ZHFpAqNgEriYntqxi7GDk4RAR0JDacZAcJMwvUSVz5NpcRxBYWiJe4
	+/oEE4jNIqAqsffeU7AFvAKaEncnnASLiwq4Spxb9ANsJKeAu8SXW7+YQWwhATeJP8v/QNUL
	SvyYfI8FYr68xL79U1khbB2J/a3T2CYwCsxCUjYLSdksJGULGJlXMYqmFiQXFCel5xrqFSfm
	Fpfmpesl5+duYgQH9jOpHYwrGywOMQpwMCrx8Dpc+B4oxJpYVlyZe4hRgoNZSYRXPuhHoBBv
	SmJlVWpRfnxRaU5q8SFGaQ4WJXHeA63WgUIC6YklqdmpqQWpRTBZJg5OqQZGgfYn3290isQf
	NTZ9NfH6yu8bWYqtN2r49S54JNhnUSSV8PzT5vZDD06svmgfMlX1fQZ7hq/6V77GN5+uphed
	7fc6U7Etf5/Pyypj9qVsmYEHivQfzdrJ8+92X6HMiw+vtzeYLhN8esFYsWtNYln6oyVZX07J
	JPS/z1kwN/pL0eZXigHGTbaZSizFGYmGWsxFxYkA7E1ZP2gCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Wednesday, July 31, 2013 05:50:02 PM Joonyoung Shim wrote:
> This reverts commit cea27eb2a202959783f81254c48c250ddd80e129.

Could you please also include commit descriptions, i.e.
commit cea27eb2a202959783f81254c48c250ddd80e129 ("mm/memory-hotplug: fix
lowmem count overflow when offline pages")?

> Fixed to adjust totalhigh_pages when hot-removing memory by commit
> 3dcc0571cd64816309765b7c7e4691a4cadf2ee7, so that commit occurs
> duplicated decreasing of totalhigh_pages.

Could you please describe it a bit more (because it is non-obvious) how
the commit cea27eb effectively does the same totalhigh_pages adjustment
that is present in the commit 3dcc057?

> Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
> ---
> The commit cea27eb2a202959783f81254c48c250ddd80e129 is only for stable,
> is it right?

It is in Linus' tree now but you're probably right that it should be
limited to stable tree.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

>  mm/page_alloc.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index b100255..2b28216 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -6274,10 +6274,6 @@ __offline_isolated_pages(unsigned long start_pfn, unsigned long end_pfn)
>  		list_del(&page->lru);
>  		rmv_page_order(page);
>  		zone->free_area[order].nr_free--;
> -#ifdef CONFIG_HIGHMEM
> -		if (PageHighMem(page))
> -			totalhigh_pages -= 1 << order;
> -#endif
>  		for (i = 0; i < (1 << order); i++)
>  			SetPageReserved((page+i));
>  		pfn += (1 << order);

