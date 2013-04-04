Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761518Ab3DDOMg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 10:12:36 -0400
Received: from mail-da0-f43.google.com ([209.85.210.43]:33657 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761367Ab3DDOMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 10:12:34 -0400
Date: Thu, 4 Apr 2013 07:12:29 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] workqueue: add __WQ_FREEZING and remove POOL_FREEZING
Message-ID: <20130404141229.GD9425@htj.dyndns.org>
References: <1365041143-3088-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365041143-3088-1-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Lai.

On Thu, Apr 04, 2013 at 10:05:32AM +0800, Lai Jiangshan wrote:
> @@ -4757,25 +4747,16 @@ void thaw_workqueues(void)
>  {
>  	struct workqueue_struct *wq;
>  	struct pool_workqueue *pwq;
> -	struct worker_pool *pool;
> -	int pi;
>  
>  	mutex_lock(&wq_pool_mutex);
>  
>  	if (!workqueue_freezing)
>  		goto out_unlock;
>  
> -	/* clear FREEZING */
> -	for_each_pool(pool, pi) {
> -		spin_lock_irq(&pool->lock);
> -		WARN_ON_ONCE(!(pool->flags & POOL_FREEZING));
> -		pool->flags &= ~POOL_FREEZING;
> -		spin_unlock_irq(&pool->lock);
> -	}
> -
>  	/* restore max_active and repopulate worklist */
>  	list_for_each_entry(wq, &workqueues, list) {
>  		mutex_lock(&wq->mutex);
> +		wq->flags &= ~__WQ_FREEZING;

I want an assertion here.  Maybe we can fold the next patch into this
one and add WARN_ON_ONCE() here?

>  		for_each_pwq(pwq, wq)
>  			pwq_adjust_max_active(pwq);
>  		mutex_unlock(&wq->mutex);

Thanks.

-- 
tejun
