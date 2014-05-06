Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751133AbaEFQ1O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 12:27:14 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:51469 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbaEFQ1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 12:27:13 -0400
MIME-Version: 1.0
In-Reply-To: <20140505150217.GH11231@htj.dyndns.org>
References: <1398571754-12443-1-git-send-email-laijs@cn.fujitsu.com>
	<1398571754-12443-4-git-send-email-laijs@cn.fujitsu.com>
	<20140505150217.GH11231@htj.dyndns.org>
Date: Wed, 7 May 2014 00:27:13 +0800
X-Google-Sender-Auth: B06_U5EYbaunsHHl80fctTJv8aQ
Message-ID: <CACvQF53z7=kRxmEMqguxNOzrpb=E3zQsKptBJzRC1nm+6AKp=g@mail.gmail.com>
Subject: Re: [PATCH 03/10] workqueue: async worker destruction
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 5, 2014 at 11:02 PM, Tejun Heo <tj@kernel.org> wrote:
> On Sun, Apr 27, 2014 at 12:08:58PM +0800, Lai Jiangshan wrote:
>>  /**
>> + * worker_unbind_pool() - unbind the worker from the pool
>> + * @worker: worker which is bound to its pool
>> + *
>> + * Undo the pool-binding which had been done in create_worker()
>> + */
>> +static void worker_unbind_pool(struct worker *worker)
>
> worker_unbind_from_pool() would be a better name but I don't think
> using bind/unbind for this purpose is a good idea.  We already use
> that pair of verbs for workers/pools being bound and unbound to CPUs.
> I don't think we want to overload the terms for this purpose.  It gets
> pretty confusing.  How about something like worker_detach_from_pool()
> and later worker_attach_to_pool()?

I considered several names (searching from an English dictionary)
assoc/pin/bind/attach/add...

The last I chose the winner "bind" from the last two candidates assoc&bind.

worker_OP[_to]_pool()
        OP(assoc/pin/bind/attach/add) the worker to OP_list of the
pool, do cpu-binding for the worker
OP_list
        the list in the pool for the workers, iterating(when
cpu-binding and worker concurrency [un]bound)
OP_entry
        worker entry for OP_list, for  iterating(when cpu-binding and
worker concurrency [un]bound)
OP_mutex
        protects worker_OP_to_pool() protect cpu-binding for the workers,
        protect iterating(when cpu-binding and worker concurrency [un]bound)

every sentence has "bind", so I think "bind_mutex" is proper.
since I used "bind_mutex", I will use bind_list and worker_bind_pool().

I don't refuse to use worker_attach_to_pool(), but I hope you choose
other names for me:

attach_list VS bind_list
attach_mutex VS bind_mutex

I guess they will be attach_list&attach_mutex.  it's a little pity to
drop the nice name bind_mutex.

Thanks,
Lai

>
> Thanks.
>
> --
> tejun
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
