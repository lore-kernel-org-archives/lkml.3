Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab3H3JLG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 05:11:06 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:12789 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529Ab3H3JLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 05:11:04 -0400
Message-ID: <5220616D.6030403@huawei.com>
Date: Fri, 30 Aug 2013 17:10:05 +0800
From: Jianguo Wu <wujianguo@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, <laijs@cn.fujitsu.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, <zhangyanfei@cn.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 1/5] mm/vmalloc: use N_MEMORY instead of N_HIGH_MEMORY
References: <5220133E.4030204@huawei.com>
In-Reply-To: <5220133E.4030204@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.216]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/8/30 11:36, Jianguo Wu wrote:

> Since commit 8219fc48a(mm: node_states: introduce N_MEMORY),
> we introduced N_MEMORY, now N_MEMORY stands for the nodes that has any memory,
> and N_HIGH_MEMORY stands for the nodes that has normal or high memory.
> 
> The code here need to handle with the nodes which have memory,
> we should use N_MEMORY instead.
> 

As Michal pointed out in http://marc.info/?l=linux-kernel&m=137784852720861&w=2,
N_HIGH_MEMORY should be kept in these places, please ignore this series.

Sorry for the noise.

Thanks.

> Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
> ---
>  mm/vmalloc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 13a5495..1152947 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -2573,7 +2573,7 @@ static void show_numa_info(struct seq_file *m, struct vm_struct *v)
>  		for (nr = 0; nr < v->nr_pages; nr++)
>  			counters[page_to_nid(v->pages[nr])]++;
>  
> -		for_each_node_state(nr, N_HIGH_MEMORY)
> +		for_each_node_state(nr, N_MEMORY)
>  			if (counters[nr])
>  				seq_printf(m, " N%u=%u", nr, counters[nr]);
>  	}



