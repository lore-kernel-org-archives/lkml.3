Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431AbaFEBQV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 21:16:21 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:64660 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751460AbaFEBQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 21:16:20 -0400
X-IronPort-AV: E=Sophos;i="4.98,976,1392134400"; 
   d="scan'208";a="31473454"
Message-ID: <538FC5F8.1020605@cn.fujitsu.com>
Date: Thu, 5 Jun 2014 09:20:56 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] workqueue: use "pool->cpu < 0" to stand for an unbound
 pool
References: <1401780714-12127-1-git-send-email-laijs@cn.fujitsu.com>
In-Reply-To: <1401780714-12127-1-git-send-email-laijs@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping.

And would these patches be possible for 3.16?

Thanks,
Lai

On 06/03/2014 03:31 PM, Lai Jiangshan wrote:
> There is a piece of sanity checks code in the put_unbound_pool().
> The meaning of this code is "if it is not an unbound pool, it will complain
> and return" IIUC. But the code uses "pool->flags & POOL_DISASSOCIATED"
> imprecisely due to a non-unbound pool may also have this flags.
> 
> We should use "pool->cpu < 0" to stand for an unbound pool, so we covert the
> code to it.
> 
> There is no strictly wrong if we still keep "pool->flags & POOL_DISASSOCIATED"
> here, but it is just a noise if we keep it:
>   1) we focus on "unbound" here, not "[dis]association".
>   2) "pool->cpu < 0" already implies "pool->flags & POOL_DISASSOCIATED".
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
>  kernel/workqueue.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 90a0fa5..724ae35 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -3457,7 +3457,7 @@ static void put_unbound_pool(struct worker_pool *pool)
>  		return;
>  
>  	/* sanity checks */
> -	if (WARN_ON(!(pool->flags & POOL_DISASSOCIATED)) ||
> +	if (WARN_ON(!(pool->cpu < 0)) ||
>  	    WARN_ON(!list_empty(&pool->worklist)))
>  		return;
>  

