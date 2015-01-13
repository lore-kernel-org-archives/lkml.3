Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007AbbAMPYw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 10:24:52 -0500
Received: from mail-qg0-f44.google.com ([209.85.192.44]:54103 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958AbbAMPYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 10:24:49 -0500
Date: Tue, 13 Jan 2015 10:24:45 -0500
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "Gu, Zheng" <guz.fnst@cn.fujitsu.com>,
        tangchen <tangchen@cn.fujitsu.com>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 3/5] workqueue: fixup existing pool->node
Message-ID: <20150113152445.GB2976@htj.dyndns.org>
References: <1418379595-6281-1-git-send-email-laijs@cn.fujitsu.com>
 <1418379595-6281-4-git-send-email-laijs@cn.fujitsu.com>
 <20141212172546.GC20020@htj.dyndns.org>
 <548E3825.9020204@cn.fujitsu.com>
 <20141225201406.GB22951@htj.dyndns.org>
 <54B4C46C.1000404@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54B4C46C.1000404@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 03:08:28PM +0800, Lai Jiangshan wrote:
> On 12/26/2014 04:14 AM, Tejun Heo wrote:
> > On Mon, Dec 15, 2014 at 09:23:49AM +0800, Lai Jiangshan wrote:
> >> The pwqs of the old node's cpumask do be discarded. But the pools of the old
> >> node's cpumask maybe recycle. For example, a new workqueue's affinity is set to
> >> the old node's cpumask before the pool is dead. Any old pool can long live.
> > 
> > Hah?  Why can't it just be unhashed so that it can't be looked up for
> > new pwqs anymore?
> > 
> 
> unhashing doesn't reduce the complexity in my code.
> 
> 	for_each_pool(pool, pi) {
> 		node = calc_pool_node(pool);
> 		if (pool->node != node)
> -			pool->node = node;
> +			unhash_pool(pool);
> 	}

Hah?  You shouldn't need any of the dynamic updating code.  How does
that not reduce complexity?

> And any old pool can long live due to:
> 	some works queues themself back and back
> 	the old pool has extremely long pending works

As long as you don't give out new refs, it's fine.  It'll eventually
get drained.  Why is this a problem?

> So I prefer to fixup existing pool->node.

Can you please elaborate how this wouldn't remove the dynamic update
code?

Thanks.

-- 
tejun
