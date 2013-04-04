Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762016Ab3DDOi5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 10:38:57 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:50422 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761857Ab3DDOi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 10:38:56 -0400
Date: Thu, 4 Apr 2013 07:38:38 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] workqueue: node-awared allocation for unbound pool
Message-ID: <20130404143838.GI9425@htj.dyndns.org>
References: <1365041143-3088-1-git-send-email-laijs@cn.fujitsu.com>
 <1365041143-3088-6-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365041143-3088-6-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Apr 04, 2013 at 10:05:37AM +0800, Lai Jiangshan wrote:
> calculate the node of the pool earlier, and allocate the pool
> from the node.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
>  kernel/workqueue.c |   29 +++++++++++++++--------------
>  1 files changed, 15 insertions(+), 14 deletions(-)
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 737646d..3f33077 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -539,7 +539,7 @@ static int worker_pool_assign_id(struct worker_pool *pool)
>   * @wq: the target workqueue
>   * @node: the node ID
>   *
> - * This must be called either with pwq_lock held or sched RCU read locked.
> + * This must be called either with wq->mutex held or sched RCU read locked.

It'd be nice to mention it in the patch description.  Just add
something like "while at it, fix the wrong locking comment in XXX".

> @@ -3563,29 +3563,30 @@ static struct worker_pool *get_unbound_pool(const struct workqueue_attrs *attrs)
>  	hash_for_each_possible(unbound_pool_hash, pool, hash_node, hash) {
>  		if (wqattrs_equal(pool->attrs, attrs)) {
>  			pool->refcnt++;
> -			goto out_unlock;
> +			goto out_pool;

return pool; ?

Thanks.

-- 
tejun
