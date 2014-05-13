Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933597AbaEMOR5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 10:17:57 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:53665 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932617AbaEMOR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 10:17:56 -0400
Date: Tue, 13 May 2014 10:17:52 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/10 V2] workqueue: convert worker_idr to worker_ida
Message-ID: <20140513141752.GB23710@htj.dyndns.org>
References: <20140505150514.GI11231@htj.dyndns.org>
 <1399877792-13046-1-git-send-email-laijs@cn.fujitsu.com>
 <1399877792-13046-7-git-send-email-laijs@cn.fujitsu.com>
 <20140512214030.GG18959@mtj.dyndns.org>
 <5371BEFA.9060902@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5371BEFA.9060902@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, May 13, 2014 at 02:43:06PM +0800, Lai Jiangshan wrote:
> On 05/13/2014 05:40 AM, Tejun Heo wrote:
> > On Mon, May 12, 2014 at 02:56:18PM +0800, Lai Jiangshan wrote:
> >> @@ -1681,7 +1682,6 @@ static void worker_detach_from_pool(struct worker *worker,
> >>  	struct completion *detach_completion = NULL;
> >>  
> >>  	mutex_lock(&pool->manager_mutex);
> >> -	idr_remove(&pool->worker_idr, worker->id);
> >>  	list_del(&worker->node);
> >>  	if (list_empty(&pool->workers))
> >>  		detach_completion = pool->detach_completion;
> > 
> > Why are we moving ida removal to the caller here?  Does
> 
> ida							is for worker ID
> pool->workers list and worker_detach_from_pool()	are for attaching/detaching
> 
> moving ida removal to the caller removes the unneeded coupling.

This is completely arbitrary.  For example, if rescuers needed IDs to
be allocated and deallocated on attach/detach, ID allocation should be
included in the above two functions, right?  This makes sense only
because rescuers don't have IDs and we're gonna use the above
functions for the rescuers too.  There's nothing inherent in
decoupling a worker's attachment to its pool and its pool ID
allocation.  The design developed this way only because there's
certain specific usage for it.  The code is fine but it usually is a
lot more helpful for reviewing and later reference if you actually
explain why things are done in certain specific ways because in
isolation the above decoupling is completely arbitrary.

Thanks.

-- 
tejun
