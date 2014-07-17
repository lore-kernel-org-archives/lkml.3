Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbaGQB0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 21:26:18 -0400
Received: from mail-yk0-f182.google.com ([209.85.160.182]:60208 "EHLO
	mail-yk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbaGQB0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 21:26:16 -0400
Message-ID: <53C72652.6010801@gmail.com>
Date: Wed, 16 Jul 2014 21:26:42 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: paulmck@linux.vnet.ibm.com, josh@joshtriplett.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] rcu: Remove stale comment in tree.c
References: <1405463509-2468-1-git-send-email-bobby.prani@gmail.com> <1405463509-2468-2-git-send-email-bobby.prani@gmail.com> <20140715225313.GB24290@cloud> <53C5B1F7.3000409@gmail.com> <20140716124729.GR8690@linux.vnet.ibm.com> <53C67E2E.7080402@gmail.com> <53C71EF3.8010901@cn.fujitsu.com> <53C72080.5040501@gmail.com> <53C725FD.5070405@cn.fujitsu.com>
In-Reply-To: <53C725FD.5070405@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2014 09:25 PM, Lai Jiangshan wrote:
> On 07/17/2014 09:01 AM, Pranith Kumar wrote:
>> On 07/16/2014 08:55 PM, Lai Jiangshan wrote:
>>> On 07/16/2014 09:29 PM, Pranith Kumar wrote:
>>>> On 07/16/2014 08:47 AM, Paul E. McKenney wrote:
>>>>> On Tue, Jul 15, 2014 at 06:57:59PM -0400, Pranith Kumar wrote:
>>>>>>
>>>>>> On 07/15/2014 06:53 PM, josh@joshtriplett.org wrote:
>>>>>>> On Tue, Jul 15, 2014 at 06:31:48PM -0400, Pranith Kumar wrote:
>>>>>>>> This commit removes a stale comment in rcu/tree.c.
>>>>>>>> FYI, an updated comment exists a few lines below this.
>>>>>>>>
>>>>>>>> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
>>>>>>> In general, when removing a stale comment, I'd suggest explaining why
>>>>>>> the comment is stale.  Was code removed without removing the
>>>>>>> corresponding comment, or was code changed such that the comment no
>>>>>>> longer applies, or...?
>>>>>>
>>>>>> I guess it was left out when code was moved around previously. And I did mention that an updated comment is there a few lines below.
>>>>>>
>>>>>> For reference this is the new comment which is below the old comment, they mean the same :)
>>>>>>
>>>>>>     /* Remove the outgoing CPU from the masks in the rcu_node hierarchy. */
>>>>>
>>>>> Indeed that is the case.
>>>>>
>>>>> Please update the commit log with this explanation and resend.
>>>>>
>>>>> 								Thanx, Paul
>>>>>
>>>>
>>>> Please find the updated patch below.
>>>>
>>>> --
>>>> Pranith
>>>>
>>>> From: Pranith Kumar <bobby.prani@gmail.com>
>>>> Date: Mon, 14 Jul 2014 16:01:05 -0400
>>>> Subject: [PATCH 2/3] rcu: Remove stale comment in tree.c
>>>>
>>>> This commit removes a stale comment in rcu/tree.c which was left out when some
>>>> code was moved around previously.
>>>
>>> Which commit caused this leftover comment? Could you mention that commit in
>>> your changlog?
>>>
>>> 12BitsCmmtID ("commit title...")
>>>
>>
>> Sure, please find an updated patch with Josh Triplett's sign-off added:
>>
>> From: Pranith Kumar <bobby.prani@gmail.com>
>> Date: Mon, 14 Jul 2014 16:01:05 -0400
>> Subject: [PATCH 2/3] rcu: Remove stale comment in tree.c
>>
>>
>> This commit removes a stale comment in rcu/tree.c which was left out in
>> commit 2036d94a7b61ca5032ce (rcu:  Rework detection of use of RCU by offline CPUs)
> 
> I suggest you use the following syntax in future.
> 
> 2036d94a7b61 ("rcu:  Rework detection of use of RCU by offline CPUs")
> 

OK. I will do that from now on. Thanks! :)

--
Pranith

>>
>> For reference, the following updated comment exists a few lines below this which
>> means the same.
>>
>> /* Remove the outgoing CPU from the masks in the rcu_node hierarchy. */
>>
>> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
>> Reviewed-by: Joe Tripplett <josh@joshtriplett.org>
> 
> Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> 
>> ---
>>  kernel/rcu/tree.c | 2 --
>>  1 file changed, 2 deletions(-)
>>
>> diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
>> index a1abaa8..e67246e 100644
>> --- a/kernel/rcu/tree.c
>> +++ b/kernel/rcu/tree.c
>> @@ -2211,8 +2211,6 @@ static void rcu_cleanup_dead_cpu(int cpu, struct rcu_state *rsp)
>>  	/* Adjust any no-longer-needed kthreads. */
>>  	rcu_boost_kthread_setaffinity(rnp, -1);
>>  
>> -	/* Remove the dead CPU from the bitmasks in the rcu_node hierarchy. */
>> -
>>  	/* Exclude any attempts to start a new grace period. */
>>  	mutex_lock(&rsp->onoff_mutex);
>>  	raw_spin_lock_irqsave(&rsp->orphan_lock, flags);
> 

