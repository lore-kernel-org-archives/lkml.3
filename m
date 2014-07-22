Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640AbaGVDKK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 23:10:10 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:62183 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbaGVDKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 23:10:08 -0400
Message-ID: <53CDD5EE.1030805@huawei.com>
Date: Tue, 22 Jul 2014 11:09:34 +0800
From: Wang Nan <wangnan0@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Wang Nan <wangnan0@huawei.com>, Ingo Molnar <mingo@redhat.com>,
        Yinghai Lu <yinghai@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Dave Hansen <dave.hansen@intel.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>, <peifeiyue@huawei.com>,
        <linux-mm@kvack.org>, <x86@kernel.org>, <linux-ia64@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-sh@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH v2 7/7] memory-hotplug: tile: suitable memory should go
 to ZONE_MOVABLE
References: <1405914402-66212-1-git-send-email-wangnan0@huawei.com> <1405914402-66212-8-git-send-email-wangnan0@huawei.com>
In-Reply-To: <1405914402-66212-8-git-send-email-wangnan0@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.69.90]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Please drop patch 7/7 from -mm tree and keep other 6 patches.

arch_add_memory() in tile is different from others: no nid parameter.
Patch 7/7 will block compiling.

I cc this mail to Chris Metcalf and hope he can look at this issue.

Other 6 patches looks good.

On 2014/7/21 11:46, Wang Nan wrote:
> This patch introduces zone_for_memory() to arch_add_memory() on tile to
> ensure new, higher memory added into ZONE_MOVABLE if movable zone has
> already setup.
> 
> This patch also fix a problem: on tile, new memory should be added into
> ZONE_HIGHMEM by default, not MAX_NR_ZONES-1, which is ZONE_MOVABLE.
> 
> Signed-off-by: Wang Nan <wangnan0@huawei.com>
> Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
> Cc: Dave Hansen <dave.hansen@intel.com>
> ---
>  arch/tile/mm/init.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/tile/mm/init.c b/arch/tile/mm/init.c
> index bfb3127..22ac6c1 100644
> --- a/arch/tile/mm/init.c
> +++ b/arch/tile/mm/init.c
> @@ -872,7 +872,8 @@ void __init mem_init(void)
>  int arch_add_memory(u64 start, u64 size)
>  {
>  	struct pglist_data *pgdata = &contig_page_data;
> -	struct zone *zone = pgdata->node_zones + MAX_NR_ZONES-1;
> +	struct zone *zone = pgdata->node_zones +
> +		zone_for_memory(nid, start, size, ZONE_HIGHMEM);
>  	unsigned long start_pfn = start >> PAGE_SHIFT;
>  	unsigned long nr_pages = size >> PAGE_SHIFT;
>  
> 


