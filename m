Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586AbaFPQ5k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 12:57:40 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:60964 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbaFPQ5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 12:57:39 -0400
Message-ID: <539F21F4.20206@infradead.org>
Date: Mon, 16 Jun 2014 09:57:24 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Xishi Qiu <qiuxishi@huawei.com>, Andrew Morton <akpm@linux-foundation.org>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, aquini@redhat.com,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>
CC: Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH 8/8] doc: update Documentation/sysctl/vm.txt
References: <539EB803.9070001@huawei.com>
In-Reply-To: <539EB803.9070001@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/14 02:25, Xishi Qiu wrote:
> Update the doc.
> 
> Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
> ---
>  Documentation/sysctl/vm.txt |   43 +++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 43 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
> index dd9d0e3..8008e53 100644
> --- a/Documentation/sysctl/vm.txt
> +++ b/Documentation/sysctl/vm.txt
> @@ -20,6 +20,10 @@ Currently, these files are in /proc/sys/vm:
>  
>  - admin_reserve_kbytes
>  - block_dump
> +- cache_limit_mbytes
> +- cache_limit_ratio
> +- cache_reclaim_s
> +- cache_reclaim_weight
>  - compact_memory
>  - dirty_background_bytes
>  - dirty_background_ratio
> @@ -97,6 +101,45 @@ information on block I/O debugging is in Documentation/laptops/laptop-mode.txt.
>  
>  ==============================================================
>  
> +cache_limit_mbytes
> +
> +This is used to limit page cache amount. The input unit is MB, value range
> +is from 0 to totalram_pages. If this is set to 0, it will not limit page cache.

Where does one find the value of totalram_pages?

Is totalram_pages in MB or does totalram_pages need to be divided by some value
to convert it to MB?

> +When written to the file, cache_limit_ratio will be updated too.
> +
> +The default value is 0.
> +
> +==============================================================
> +
> +cache_limit_ratio
> +
> +This is used to limit page cache amount. The input unit is percent, value
> +range is from 0 to 100. If this is set to 0, it will not limit page cache.
> +When written to the file, cache_limit_mbytes will be updated too.
> +
> +The default value is 0.
> +
> +==============================================================
> +
> +cache_reclaim_s
> +
> +This is used to reclaim page cache in circles. The input unit is second,
> +the minimum value is 0. If this is set to 0, it will disable the feature.
> +
> +The default value is 0.
> +
> +==============================================================
> +
> +cache_reclaim_weight
> +
> +This is used to speed up page cache reclaim. It depend on enabling

                                                   depends on

> +cache_limit_mbytes/cache_limit_ratio or cache_reclaim_s. Value range is
> +from 1(slow) to 100(fast).
> +
> +The default value is 1.
> +
> +==============================================================
> +
>  compact_memory
>  
>  Available only when CONFIG_COMPACTION is set. When 1 is written to the file,
> 


-- 
~Randy
