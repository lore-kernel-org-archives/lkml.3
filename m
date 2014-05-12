Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758669AbaELVkf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 17:40:35 -0400
Received: from mail-qg0-f44.google.com ([209.85.192.44]:33558 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647AbaELVke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 17:40:34 -0400
Date: Mon, 12 May 2014 17:40:30 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/10 V2] workqueue: convert worker_idr to worker_ida
Message-ID: <20140512214030.GG18959@mtj.dyndns.org>
References: <20140505150514.GI11231@htj.dyndns.org>
 <1399877792-13046-1-git-send-email-laijs@cn.fujitsu.com>
 <1399877792-13046-7-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399877792-13046-7-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 02:56:18PM +0800, Lai Jiangshan wrote:
> @@ -1681,7 +1682,6 @@ static void worker_detach_from_pool(struct worker *worker,
>  	struct completion *detach_completion = NULL;
>  
>  	mutex_lock(&pool->manager_mutex);
> -	idr_remove(&pool->worker_idr, worker->id);
>  	list_del(&worker->node);
>  	if (list_empty(&pool->workers))
>  		detach_completion = pool->detach_completion;

Why are we moving ida removal to the caller here?  Does
worker_detach_from_pool() get used for something else later?  Up until
this point, the distinction seems pretty arbitrary.

> @@ -1757,8 +1754,6 @@ static struct worker *create_worker(struct worker_pool *pool)
>  	if (pool->flags & POOL_DISASSOCIATED)
>  		worker->flags |= WORKER_UNBOUND;
>  
> -	/* successful, commit the pointer to idr */
> -	idr_replace(&pool->worker_idr, worker, worker->id);

Ah, the comment is removed altogether.  Please disregard my previous
review on the comment.

Thanks.

-- 
tejun
