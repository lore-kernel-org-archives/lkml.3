Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020AbaEFQbj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 12:31:39 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:64658 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963AbaEFQbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 12:31:37 -0400
Date: Tue, 6 May 2014 12:31:34 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/10] workqueue: async worker destruction
Message-ID: <20140506163134.GE27738@htj.dyndns.org>
References: <1398571754-12443-1-git-send-email-laijs@cn.fujitsu.com>
 <1398571754-12443-4-git-send-email-laijs@cn.fujitsu.com>
 <20140505150217.GH11231@htj.dyndns.org>
 <CACvQF53z7=kRxmEMqguxNOzrpb=E3zQsKptBJzRC1nm+6AKp=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACvQF53z7=kRxmEMqguxNOzrpb=E3zQsKptBJzRC1nm+6AKp=g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Lai.

On Wed, May 07, 2014 at 12:27:13AM +0800, Lai Jiangshan wrote:
> I considered several names (searching from an English dictionary)
> assoc/pin/bind/attach/add...

Yeah, naming is hard.

> The last I chose the winner "bind" from the last two candidates assoc&bind.
> 
> worker_OP[_to]_pool()
>         OP(assoc/pin/bind/attach/add) the worker to OP_list of the
> pool, do cpu-binding for the worker
> OP_list
>         the list in the pool for the workers, iterating(when
> cpu-binding and worker concurrency [un]bound)
> OP_entry
>         worker entry for OP_list, for  iterating(when cpu-binding and
> worker concurrency [un]bound)

So, VERB_list or VERB_entry doesn't really work well unless they're
really for a list which is specifically created for the action.

> OP_mutex
>         protects worker_OP_to_pool() protect cpu-binding for the workers,
>         protect iterating(when cpu-binding and worker concurrency [un]bound)
> 
> every sentence has "bind", so I think "bind_mutex" is proper.
> since I used "bind_mutex", I will use bind_list and worker_bind_pool().

I don't think it's necessary for all those entries to share the same
prefix.  It could have some benefits but as long as the locking
requirements are clearly indicated in the comment, I don't think the
benefit is large enough to overrule the downsides of such naming.

> I don't refuse to use worker_attach_to_pool(), but I hope you choose
> other names for me:
> 
> attach_list VS bind_list
> attach_mutex VS bind_mutex

Just use worker->node and pool->workers for the list.  I don't think
attach_mutex sounds too bad.

> I guess they will be attach_list&attach_mutex.  it's a little pity to
> drop the nice name bind_mutex.

Why is bind_mutex any better than attach_mutex?

Thanks.

-- 
tejun
