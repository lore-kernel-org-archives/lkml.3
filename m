Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162Ab3AWBKF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 20:10:05 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:37376 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab3AWBKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 20:10:02 -0500
Date: Tue, 22 Jan 2013 17:09:58 -0800
From: Tejun Heo <tj@kernel.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH 15/17] workqueue: remove global_cwq
Message-ID: <20130123010958.GI5359@htj.dyndns.org>
References: <1358386969-945-1-git-send-email-tj@kernel.org>
 <1358386969-945-16-git-send-email-tj@kernel.org>
 <20130122065039.GA4417@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130122065039.GA4417@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 03:50:39PM +0900, Joonsoo Kim wrote:
> > -static DEFINE_PER_CPU(struct global_cwq, global_cwq);
> > +static DEFINE_PER_CPU_ALIGNED(struct worker_pool [NR_STD_WORKER_POOLS],
> > +			      cpu_std_worker_pools);
> >  static DEFINE_PER_CPU_SHARED_ALIGNED(atomic_t, pool_nr_running[NR_STD_WORKER_POOLS]);
> 
> Why worker_pool is defined as DEFINE_PER_CPU_ALIGNED?
> 
> And this makes only worker_pool[0] aligned with cacheline.
> worker_pool[1] is not aligned with cacheline.
> Now, we have a spin_lock for each instance of worker_pool and
> each one is independent instance.
> So, IMHO, it is better to align worker_pool[1] with cacheline.

Right, it's just carried over from the time when there was single pool
implemented as global_gcwq.  We probably should define struct
worker_pool as cache aligned.

Thanks.

-- 
tejun
