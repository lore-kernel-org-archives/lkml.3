Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533Ab3G3Pka (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 11:40:30 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:19208 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755523Ab3G3Pk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 11:40:29 -0400
Message-ID: <1375198768.10300.9.camel@misato.fc.hp.com>
Subject: Re: [PATCH] mm/hotplug: remove unnecessary BUG_ON in
 __offline_pages()
From: Toshi Kani <toshi.kani@hp.com>
To: Xishi Qiu <qiuxishi@huawei.com>
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 30 Jul 2013 09:39:28 -0600
In-Reply-To: <51F761E7.5090403@huawei.com>
References: <51F761E7.5090403@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-30 at 14:49 +0800, Xishi Qiu wrote:
> I think we can remove "BUG_ON(start_pfn >= end_pfn)" in __offline_pages(),
> because in memory_block_action() "nr_pages = PAGES_PER_SECTION * sections_per_block" 
> is always greater than 0.

BUG_ON() is used for checking a condition that should never happen,
unless there is a bug.  So, to me, what you described seems to match
with the use of BUG_ON() to prevent a potential bug in the caller.

Thanks,
-Toshi


> memory_block_action()
> 	offline_pages()
> 		__offline_pages()
> 			BUG_ON(start_pfn >= end_pfn)
> 
> Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
> ---
>  mm/memory_hotplug.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index ca1dd3a..8e333f9 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1472,7 +1472,6 @@ static int __ref __offline_pages(unsigned long start_pfn,
>  	struct zone *zone;
>  	struct memory_notify arg;
>  
> -	BUG_ON(start_pfn >= end_pfn);
>  	/* at least, alignment against pageblock is necessary */
>  	if (!IS_ALIGNED(start_pfn, pageblock_nr_pages))
>  		return -EINVAL;


