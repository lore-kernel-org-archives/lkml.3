Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794AbbAPIDK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 03:03:10 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:63750 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750934AbbAPIDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 03:03:08 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="56159602"
Message-ID: <54B8C5F9.9050907@cn.fujitsu.com>
Date: Fri, 16 Jan 2015 16:04:09 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
CC: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        "Gu, Zheng" <guz.fnst@cn.fujitsu.com>,
        tangchen <tangchen@cn.fujitsu.com>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC PATCH 0/2 shit_A shit_B] workqueue: fix wq_numa bug
References: <54B5D8B4.7010708@cn.fujitsu.com> <1421225658-3978-1-git-send-email-laijs@cn.fujitsu.com> <54B8A014.7050003@jp.fujitsu.com>
In-Reply-To: <54B8A014.7050003@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2015 01:22 PM, Yasuaki Ishimatsu wrote:
> Hi Lai,
> 
> Thanks you for posting the patch-set.
> 
> I'll try your it next Monday. So, please wait a while.
> 

I think it is just waste for testing before the maintainer make the decision.
(discussions/ideas are welcome.)

Before TJ's decision, maybe you can do this at first:

"Make numa code maintain the mapping to the best of its knowledge and
invoke notification callbacks when it changes. "

Thanks,
Lai

> Thanks,
> Yasuaki Ishimatsu
> 
> 
> (2015/01/14 17:54), Lai Jiangshan wrote:
>> Hi, All
>>
>> This patches are un-changloged, un-compiled, un-booted, un-tested,
>> they are just shits, I even hope them un-sent or blocked.
>>
>> The patches include two -solutions-:
>>
>> Shit_A:
>>    workqueue: reset pool->node and unhash the pool when the node is
>>      offline
>>    update wq_numa when cpu_present_mask changed
>>
>>   kernel/workqueue.c | 107 +++++++++++++++++++++++++++++++++++++++++------------
>>   1 file changed, 84 insertions(+), 23 deletions(-)
>>
>>
>> Shit_B:
>>    workqueue: reset pool->node and unhash the pool when the node is
>>      offline
>>    workqueue: remove wq_numa_possible_cpumask
>>    workqueue: directly update attrs of pools when cpu hot[un]plug
>>
>>   kernel/workqueue.c | 135 +++++++++++++++++++++++++++++++++++++++--------------
>>   1 file changed, 101 insertions(+), 34 deletions(-)
>>
>>
>> Both patch1 of the both solutions are: reset pool->node and unhash the pool,
>> it is suggested by TJ, I found it is a good leading-step for fixing the bug.
>>
>> The other patches are handling wq_numa_possible_cpumask where the solutions
>> diverge.
>>
>> Solution_A uses present_mask rather than possible_cpumask. It adds
>> wq_numa_notify_cpu_present_set/cleared() for notifications of
>> the changes of cpu_present_mask.  But the notifications are un-existed
>> right now, so I fake one (wq_numa_check_present_cpumask_changes())
>> to imitate them.  I hope the memory people add a real one.
>>
>> Solution_B uses online_mask rather than possible_cpumask.
>> this solution remove more coupling between numa_code and workqueue,
>> it just depends on cpumask_of_node(node).
>>
>> Patch2_of_Solution_B removes the wq_numa_possible_cpumask and add
>> overhead when cpu hot[un]plug, Patch3 reduce this overhead.
>>
>> Thanks,
>> Lai
>>
>>
>> Reported-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>> Cc: Tejun Heo <tj@kernel.org>
>> Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>> Cc: "Gu, Zheng" <guz.fnst@cn.fujitsu.com>
>> Cc: tangchen <tangchen@cn.fujitsu.com>
>> Cc: Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>
>>
> 
> 
> .
> 

