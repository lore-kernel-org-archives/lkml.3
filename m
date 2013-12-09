Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933858Ab3LIPuI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 10:50:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60805 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932587Ab3LIPuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 10:50:04 -0500
Date: Mon, 9 Dec 2013 16:50:02 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Xishi Qiu <qiuxishi@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, rientjes@google.com,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH] mm: add show num_poisoned_pages when oom
Message-ID: <20131209155002.GE3597@dhcp22.suse.cz>
References: <52A592DE.7010302@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52A592DE.7010302@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 09-12-13 17:52:30, Xishi Qiu wrote:
> Show num_poisoned_pages when oom, it is helpful to find the reason.
> 
> Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>

I would not expect the number of these pages would be too high to matter in
real life but having the information cannot be harmful in any way.

Acked-by: Michal Hocko <mhocko@suse.cz>

> ---
>  lib/show_mem.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/lib/show_mem.c b/lib/show_mem.c
> index 5847a49..1cbdcd8 100644
> --- a/lib/show_mem.c
> +++ b/lib/show_mem.c
> @@ -46,4 +46,7 @@ void show_mem(unsigned int filter)
>  	printk("%lu pages in pagetable cache\n",
>  		quicklist_total_size());
>  #endif
> +#ifdef CONFIG_MEMORY_FAILURE
> +	printk("%lu pages poisoned\n", atomic_long_read(&num_poisoned_pages));
> +#endif
>  }
> -- 
> 1.7.1
> 

-- 
Michal Hocko
SUSE Labs
