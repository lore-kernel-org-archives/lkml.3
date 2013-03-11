Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751775Ab3CKFVS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 01:21:18 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:28078 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750952Ab3CKFVR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 01:21:17 -0400
X-IronPort-AV: E=Sophos;i="4.84,820,1355068800"; 
   d="scan'208";a="6848632"
Message-ID: <513D689C.5030105@cn.fujitsu.com>
Date: Mon, 11 Mar 2013 13:16:12 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: Jiang Liu <liuj97@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Chris Clayton <chris2553@googlemail.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Jianguo Wu <wujianguo@huawei.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Eric Biederman <ebiederm@xmission.com>
Subject: Re: [PATCH v2, part1 29/29] mm,kexec: use common help functions to
 free reserved pages
References: <1362896833-21104-1-git-send-email-jiang.liu@huawei.com> <1362896833-21104-30-git-send-email-jiang.liu@huawei.com>
In-Reply-To: <1362896833-21104-30-git-send-email-jiang.liu@huawei.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/11 13:16:33,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/11 13:20:00
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年03月10日 14:27, Jiang Liu 写道:
> Use common help functions to free reserved pages.
> 
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Cc: Eric Biederman <ebiederm@xmission.com>

Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

> ---
>  kernel/kexec.c |    8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/kexec.c b/kernel/kexec.c
> index bddd3d7..be95397 100644
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -1118,12 +1118,8 @@ void __weak crash_free_reserved_phys_range(unsigned long begin,
>  {
>  	unsigned long addr;
>  
> -	for (addr = begin; addr < end; addr += PAGE_SIZE) {
> -		ClearPageReserved(pfn_to_page(addr >> PAGE_SHIFT));
> -		init_page_count(pfn_to_page(addr >> PAGE_SHIFT));
> -		free_page((unsigned long)__va(addr));
> -		totalram_pages++;
> -	}
> +	for (addr = begin; addr < end; addr += PAGE_SIZE)
> +		free_reserved_page(pfn_to_page(addr >> PAGE_SHIFT));
>  }
>  
>  int crash_shrink_memory(unsigned long new_size)

