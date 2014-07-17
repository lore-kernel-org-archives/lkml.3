Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298AbaGQAyK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 20:54:10 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:1060 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753997AbaGQAyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 20:54:08 -0400
X-IronPort-AV: E=Sophos;i="5.00,905,1396972800"; 
   d="scan'208";a="33382143"
Message-ID: <53C71EF3.8010901@cn.fujitsu.com>
Date: Thu, 17 Jul 2014 08:55:15 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Pranith Kumar <bobby.prani@gmail.com>
CC: <paulmck@linux.vnet.ibm.com>, <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] rcu: Remove stale comment in tree.c
References: <1405463509-2468-1-git-send-email-bobby.prani@gmail.com> <1405463509-2468-2-git-send-email-bobby.prani@gmail.com> <20140715225313.GB24290@cloud> <53C5B1F7.3000409@gmail.com> <20140716124729.GR8690@linux.vnet.ibm.com> <53C67E2E.7080402@gmail.com>
In-Reply-To: <53C67E2E.7080402@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2014 09:29 PM, Pranith Kumar wrote:
> On 07/16/2014 08:47 AM, Paul E. McKenney wrote:
>> On Tue, Jul 15, 2014 at 06:57:59PM -0400, Pranith Kumar wrote:
>>>
>>> On 07/15/2014 06:53 PM, josh@joshtriplett.org wrote:
>>>> On Tue, Jul 15, 2014 at 06:31:48PM -0400, Pranith Kumar wrote:
>>>>> This commit removes a stale comment in rcu/tree.c.
>>>>> FYI, an updated comment exists a few lines below this.
>>>>>
>>>>> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
>>>> In general, when removing a stale comment, I'd suggest explaining why
>>>> the comment is stale.  Was code removed without removing the
>>>> corresponding comment, or was code changed such that the comment no
>>>> longer applies, or...?
>>>
>>> I guess it was left out when code was moved around previously. And I did mention that an updated comment is there a few lines below.
>>>
>>> For reference this is the new comment which is below the old comment, they mean the same :)
>>>
>>>     /* Remove the outgoing CPU from the masks in the rcu_node hierarchy. */
>>
>> Indeed that is the case.
>>
>> Please update the commit log with this explanation and resend.
>>
>> 								Thanx, Paul
>>
> 
> Please find the updated patch below.
> 
> --
> Pranith
> 
> From: Pranith Kumar <bobby.prani@gmail.com>
> Date: Mon, 14 Jul 2014 16:01:05 -0400
> Subject: [PATCH 2/3] rcu: Remove stale comment in tree.c
> 
> This commit removes a stale comment in rcu/tree.c which was left out when some
> code was moved around previously.

Which commit caused this leftover comment? Could you mention that commit in
your changlog?

12BitsCmmtID ("commit title...")

> 
> For reference, the following updated comment exists a few lines below this which
> means the same.
> 
> /* Remove the outgoing CPU from the masks in the rcu_node hierarchy. */
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> ---
>  kernel/rcu/tree.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> index a1abaa8..e67246e 100644
> --- a/kernel/rcu/tree.c
> +++ b/kernel/rcu/tree.c
> @@ -2211,8 +2211,6 @@ static void rcu_cleanup_dead_cpu(int cpu, struct rcu_state *rsp)
>  	/* Adjust any no-longer-needed kthreads. */
>  	rcu_boost_kthread_setaffinity(rnp, -1);
>  
> -	/* Remove the dead CPU from the bitmasks in the rcu_node hierarchy. */
> -
>  	/* Exclude any attempts to start a new grace period. */
>  	mutex_lock(&rsp->onoff_mutex);
>  	raw_spin_lock_irqsave(&rsp->orphan_lock, flags);

