Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696Ab3CTR3u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 13:29:50 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:63971 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754768Ab3CTR3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 13:29:49 -0400
Date: Wed, 20 Mar 2013 10:29:43 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/21] workqueue: don't free pool->worker_idr by RCU
Message-ID: <20130320172943.GC28968@htj.dyndns.org>
References: <1363721306-2030-1-git-send-email-laijs@cn.fujitsu.com>
 <1363721306-2030-3-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363721306-2030-3-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 03:28:02AM +0800, Lai Jiangshan wrote:
> pool->worker_idr nor worker->id is not protected by RCU.
> don't need to free pool->worker_idr by RCU.
> 
> Just free it directly.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
...
> @@ -3462,6 +3461,7 @@ static void put_unbound_pool(struct worker_pool *pool)
>  		destroy_worker(worker);
>  	WARN_ON(pool->nr_workers || pool->nr_idle);
>  
> +	idr_destroy(&pool->worker_idr);
>  	spin_unlock_irq(&pool->lock);
>  	mutex_unlock(&pool->manager_mutex);
>  	mutex_unlock(&pool->manager_arb);

I don't know about this one.  It is correct but I'd prefer to have all
frees grouped together in one function rather than scattered across
two functions.  It's not like idr_destroy() is expensive or anything.

Thanks.

-- 
tejun
