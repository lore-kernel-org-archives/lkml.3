Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab3AXSpF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 13:45:05 -0500
Received: from mail-qe0-f45.google.com ([209.85.128.45]:47297 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755144Ab3AXSo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 13:44:59 -0500
Date: Thu, 24 Jan 2013 10:44:54 -0800
From: Tejun Heo <tj@kernel.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH v2 15/17] workqueue: remove global_cwq
Message-ID: <20130124184454.GO2373@mtj.dyndns.org>
References: <1358386969-945-1-git-send-email-tj@kernel.org>
 <1358386969-945-16-git-send-email-tj@kernel.org>
 <20130123180957.GF2373@mtj.dyndns.org>
 <20130124092936.GA2424@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130124092936.GA2424@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Joonsoo.

On Thu, Jan 24, 2013 at 06:29:36PM +0900, Joonsoo Kim wrote:
> > -static DEFINE_PER_CPU(struct global_cwq, global_cwq);
> > +static DEFINE_PER_CPU(struct worker_pool [NR_STD_WORKER_POOLS],
> > +		      cpu_std_worker_pools);
> >  static DEFINE_PER_CPU_SHARED_ALIGNED(atomic_t, pool_nr_running[NR_STD_WORKER_POOLS]);
> 
> AFAIK, worker_pool can be accessed by other cpus.
> So, I think that we also need "DEFINE_PER_CPU_SHARED_ALIGNED(struct worker_pool [], xxx)".

Hmmm... yean.  I think I'll just move pool_nr_running into
worker_pool.  Will prep a separate patch.

Thanks.

-- 
tejun
