Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751407Ab3LJT4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 14:56:19 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60206 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab3LJT4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 14:56:18 -0500
Message-ID: <52A771EC.4080105@jp.fujitsu.com>
Date: Tue, 10 Dec 2013 14:56:28 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: qiuxishi@huawei.com, akpm@linux-foundation.org, mhocko@suse.cz,
        mgorman@suse.de, rientjes@google.com, n-horiguchi@ah.jp.nec.com
CC: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH V2] mm: add show num_poisoned_pages when oom
References: <52A670AC.6090504@huawei.com>
In-Reply-To: <52A670AC.6090504@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(12/9/2013 8:38 PM), Xishi Qiu wrote:
> Show num_poisoned_pages when oom, it is a little helpful to find the reason.
> Also it will be emitted anytime show_mem() is called.
> 
> Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
> Suggested-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Acked-by: Michal Hocko <mhocko@suse.cz>
> Acked-by: David Rientjes <rientjes@google.com>
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
> +	printk("%lu pages hwpoisoned\n", atomic_long_read(&num_poisoned_pages));
> +#endif
>  }

Looks ok.

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

