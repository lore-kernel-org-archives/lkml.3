Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946109AbaGRWx5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 18:53:57 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:58540 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945991AbaGRWxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 18:53:55 -0400
Date: Fri, 18 Jul 2014 18:53:52 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] workqueue: remove the argument @wakeup from
 worker_set_flags()
Message-ID: <20140718225352.GD5739@htj.dyndns.org>
References: <1405505409-12058-1-git-send-email-laijs@cn.fujitsu.com>
 <1405505409-12058-2-git-send-email-laijs@cn.fujitsu.com>
 <20140718223826.GD1819@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140718223826.GD1819@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 06:38:26PM -0400, Tejun Heo wrote:
> On Wed, Jul 16, 2014 at 06:09:59PM +0800, Lai Jiangshan wrote:
> > worker_set_flags() doesn't necessarily wake next worker and the @wakeup
> > can be removed, the caller can use the following conbination instead
> > when needed:
> > 
> > 	worker_set_flags();
> > 	if (need_more_worker(pool))
> >  		wake_up_worker(pool);
> 
> Hmmm, yeah, there were more places where worker_set_flags() was used
> but it does seem excessive now.
> 
> > @@ -2045,7 +2032,7 @@ __acquires(&pool->lock)
> >  	 * management.  They're the scheduler's responsibility.
> >  	 */
> >  	if (unlikely(cpu_intensive))
> > -		worker_set_flags(worker, WORKER_CPU_INTENSIVE, true);
> > +		worker_set_flags(worker, WORKER_CPU_INTENSIVE);
> 
> But let's do this separately.  Please drop the previous patch and
> perform need_more_worker() test explicitly after setting
> CPU_INTENSIVE.

So, we can do it together at need_more_workers() but let's please
explain how different cases would behave there.

Thanks.

-- 
tejun
