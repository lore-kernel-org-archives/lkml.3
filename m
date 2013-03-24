Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459Ab3CXMHZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 08:07:25 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:35487 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386Ab3CXMHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 08:07:22 -0400
Message-ID: <514EEC39.40107@cogentembedded.com>
Date: Sun, 24 Mar 2013 16:06:17 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Jiang Liu <liuj97@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Jianguo Wu <wujianguo@huawei.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>, Tang Chen <tangchen@cn.fujitsu.com>,
        linux-sh@vger.kernel.org
Subject: Re: [RFC PATCH v2, part4 31/39] mm/SH: prepare for removing num_physpages
 and simplify mem_init()
References: <1364109934-7851-1-git-send-email-jiang.liu@huawei.com> <1364109934-7851-54-git-send-email-jiang.liu@huawei.com>
In-Reply-To: <1364109934-7851-54-git-send-email-jiang.liu@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 24-03-2013 11:25, Jiang Liu wrote:

> Prepare for removing num_physpages and simplify mem_init().

> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: Wen Congyang <wency@cn.fujitsu.com>
> Cc: Tang Chen <tangchen@cn.fujitsu.com>
> Cc: linux-sh@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>   arch/sh/mm/init.c |   25 ++++---------------------
>   1 file changed, 4 insertions(+), 21 deletions(-)

> diff --git a/arch/sh/mm/init.c b/arch/sh/mm/init.c
> index aecd913..3826596 100644
> --- a/arch/sh/mm/init.c
> +++ b/arch/sh/mm/init.c
> @@ -407,24 +407,18 @@ unsigned int mem_init_done = 0;
>
>   void __init mem_init(void)
>   {
> -	int codesize, datasize, initsize;
> -	int nid;
> +	pg_data_t *pgdat;
>
>   	iommu_init();
>
> -	num_physpages = 0;
>   	high_memory = NULL;
>
> -	for_each_online_node(nid) {
> -		pg_data_t *pgdat = NODE_DATA(nid);
> +	for_each_online_pgdat(pgdat) {
>   		void *node_high_memory;
>
> -		num_physpages += pgdat->node_present_pages;
> -
>   		if (pgdat->node_spanned_pages)
>   			free_all_bootmem_node(pgdat);
>
> -
>   		node_high_memory = (void *)__va((pgdat->node_start_pfn +
>   						 pgdat->node_spanned_pages) <<
>   						 PAGE_SHIFT);
> @@ -441,19 +435,8 @@ void __init mem_init(void)
>
>   	vsyscall_init();
>
> -	codesize =  (unsigned long) &_etext - (unsigned long) &_text;
> -	datasize =  (unsigned long) &_edata - (unsigned long) &_etext;
> -	initsize =  (unsigned long) &__init_end - (unsigned long) &__init_begin;
> -
> -	printk(KERN_INFO "Memory: %luk/%luk available (%dk kernel code, "
> -	       "%dk data, %dk init)\n",
> -		nr_free_pages() << (PAGE_SHIFT-10),
> -		num_physpages << (PAGE_SHIFT-10),
> -		codesize >> 10,
> -		datasize >> 10,
> -		initsize >> 10);
> -
> -	printk(KERN_INFO "virtual kernel memory layout:\n"
> +	mem_init_print_info(NULL);
> +	pr_info("virtual kernel memory layout:\n"
>   		"    fixmap  : 0x%08lx - 0x%08lx   (%4ld kB)\n"
>   #ifdef CONFIG_HIGHMEM
>   		"    pkmap   : 0x%08lx - 0x%08lx   (%4ld kB)\n"
>

    Hm, isn't patch 31 the same as patch 30?

WBR, Sergei

