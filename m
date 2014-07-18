Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761146AbaGRJwa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 05:52:30 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:35942 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934416AbaGRJw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 05:52:27 -0400
Message-ID: <53C8EE4C.1000204@huawei.com>
Date: Fri, 18 Jul 2014 17:52:12 +0800
From: Wang Nan <wangnan0@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        "Mel Gorman" <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Pei Feiyue <peifeiyue@huawei.com>, <linux-mm@kvack.org>, <x86@kernel.org>,
        <linux-ia64@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-sh@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] memory-hotplug: x86_32: suitable memory should go
 to ZONE_MOVABLE
References: <1405670163-53747-1-git-send-email-wangnan0@huawei.com> <1405670163-53747-3-git-send-email-wangnan0@huawei.com>
In-Reply-To: <1405670163-53747-3-git-send-email-wangnan0@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.69.90]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/7/18 15:56, Wang Nan wrote:
> This patch add new memory to ZONE_MOVABLE if movable zone is setup
> and lower than newly added memory for x86_32.
> 
> Signed-off-by: Wang Nan <wangnan0@huawei.com>
> ---
>  arch/x86/mm/init_32.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
> index e395048..dd69833 100644
> --- a/arch/x86/mm/init_32.c
> +++ b/arch/x86/mm/init_32.c
> @@ -826,9 +826,15 @@ int arch_add_memory(int nid, u64 start, u64 size)
>  {
>  	struct pglist_data *pgdata = NODE_DATA(nid);
>  	struct zone *zone = pgdata->node_zones + ZONE_HIGHMEM;
> +	struct zone *movable_zone = pgdat->node_zones + ZONE_MOVABLE;

Sorry. pgdat should be pgdata.

>  	unsigned long start_pfn = start >> PAGE_SHIFT;
>  	unsigned long nr_pages = size >> PAGE_SHIFT;
>  
> +	if (!zone_is_empty(movable_zone))
> +		if (zone_spans_pfn(movable_zone, start_pfn) ||
> +				(zone_end_pfn(movable_zone) <= start_pfn))
> +			zone = movable_zone;
> +
>  	return __add_pages(nid, zone, start_pfn, nr_pages);
>  }
>  
> 


