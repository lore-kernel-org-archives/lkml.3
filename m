Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933241AbaEEPFc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 11:05:32 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:35874 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933011AbaEEPFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 11:05:30 -0400
Date: Mon, 5 May 2014 11:05:14 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/10] workqueue: async worker destruction and
 pool-binding synchronization
Message-ID: <20140505150514.GI11231@htj.dyndns.org>
References: <1398571754-12443-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398571754-12443-1-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2014 at 12:08:55PM +0800, Lai Jiangshan wrote:
> Patch1-4: async worker destruction
> 
> The old version(https://lkml.org/lkml/2014/2/17/418) code of async worker
> destruction has to dance with pool->lock and worker_idr, it is complicated.
> 
> But worker_idr in the new version dosn't requies pool->lock, and the code in
> put_unbound_pool() which waits workers exit is changed to wait on a
> wait_queue_head_t. These two changes make the new async worker destruction
> much simpler.
> 
> Patch2 reduces the review burden. It will be easier to review the whole
> patchset if we know destroy_worker() is forced to destroy idle workers only.
> 
> ==========
> Patch5-10: pool-binding synchronization and simplify the workers management
> 
> The code which binds a worker to the pool and unbind a worker from the pool
> is unfolded in create_worker()/destroy_worker().
> The patchset moves this pool-binding code out and wraps them.
> 
> patch3-4 moves the pool-unbinding code out from destroy_worker(), and make
> manger_mutex only protects the pool-unbinding code only rather than
> protects the whole worker-destruction path.
> 
> patch5-7 makes manger_mutex only protects the pool-binding code rather than the
> whole worker-creation path.
> 
> patch8: rename manger_mutex to bind_mutex
> patch9-10: moves the pool-binding code out from create_worker() and use it for
> rescuer.

Sorry about the late review.  I've been pretty sick last week.
Overall, excellent work.  We'll prolly go through a couple more
iterations but I really like what's going on.

Thanks a lot!

-- 
tejun
