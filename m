Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202AbaETJtx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 05:49:53 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:35637 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751755AbaETJtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 05:49:51 -0400
X-IronPort-AV: E=Sophos;i="4.98,873,1392134400"; 
   d="scan'208";a="30762969"
Message-ID: <537B263F.3050904@cn.fujitsu.com>
Date: Tue, 20 May 2014 17:54:07 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/10 V2] workqueue: async worker destruction
References: <20140505150514.GI11231@htj.dyndns.org> <1399877792-13046-1-git-send-email-laijs@cn.fujitsu.com> <1399877792-13046-4-git-send-email-laijs@cn.fujitsu.com> <20140512212022.GC18959@mtj.dyndns.org> <5371BC94.5080507@cn.fujitsu.com> <20140513141418.GA23710@htj.dyndns.org>
In-Reply-To: <20140513141418.GA23710@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2014 10:14 PM, Tejun Heo wrote:
> Hello,

> Given how other kworkers are named, maybe a better name is
> "kworker/dying" or "kworker/detached"?

I use "kworker/dying". the name of "attach/detach" should be hidden from userspace 

> 
> On Tue, May 13, 2014 at 02:32:52PM +0800, Lai Jiangshan wrote:
>>>> +	if (detach_completion)
>>>> +		complete(detach_completion);
>>>> +}
>>>
>>> Are we gonna use this function from somewhere else too?
>>
>> it is called from worker_thread().
>>
>> I don't want to unfold it into worker_thread(), it is better
>> readability when it is wrapped and it will be called in patch10
>> for rescuer.
> 
> Yeah, it's shared by rescuer later, so it's fine but, again, it
> probably helps to mention that it's planned to do so; otherwise, the
> rationale is kinda weak and what belongs to that function is rather
> arbitrary.

changelog is updated.

> 
>>>>  	/*
>>>>  	 * Become the manager and destroy all workers.  Grabbing
>>>> -	 * manager_arb prevents @pool's workers from blocking on
>>>> -	 * manager_mutex.
>>>> +	 * manager_arb ensures manage_workers() finish and enter idle.
>>>
>>> I don't follow what the above comment update is trying to say.
>>
>> If a pool is destroying, the worker will not call manage_workers().
>> but the existing manage_workers() may be still running.
>>
>> mutex_lock(&manager_arb) in put_unbound_pool() should wait this manage_workers()
>> finished due to the manager-worker (non-idle-worker) can't be destroyed.
> 
> Hmmm... I think it'd be better to spell it out then.  The single
> sentence is kinda cryptic especially because the two verbs in the
> sentence don't have the same subject (managee_workers() can't enter
> idle).
> 

All your comments in this patchset are handled except this one.
modifying to this comments is not necessarily in this patchset, so I just
remove this it. Your original comments in the code is OK for me.

Thanks,
Lai
