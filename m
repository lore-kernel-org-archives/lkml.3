Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751449AbbAPFWn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 00:22:43 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49014 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbbAPFWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 00:22:41 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <54B8A014.7050003@jp.fujitsu.com>
Date: Fri, 16 Jan 2015 14:22:28 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        "Gu, Zheng" <guz.fnst@cn.fujitsu.com>,
        tangchen <tangchen@cn.fujitsu.com>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC PATCH 0/2 shit_A shit_B] workqueue: fix wq_numa bug
References: <54B5D8B4.7010708@cn.fujitsu.com> <1421225658-3978-1-git-send-email-laijs@cn.fujitsu.com>
In-Reply-To: <1421225658-3978-1-git-send-email-laijs@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lai,

Thanks you for posting the patch-set.

I'll try your it next Monday. So, please wait a while.

Thanks,
Yasuaki Ishimatsu


(2015/01/14 17:54), Lai Jiangshan wrote:
> Hi, All
> 
> This patches are un-changloged, un-compiled, un-booted, un-tested,
> they are just shits, I even hope them un-sent or blocked.
> 
> The patches include two -solutions-:
> 
> Shit_A:
>    workqueue: reset pool->node and unhash the pool when the node is
>      offline
>    update wq_numa when cpu_present_mask changed
> 
>   kernel/workqueue.c | 107 +++++++++++++++++++++++++++++++++++++++++------------
>   1 file changed, 84 insertions(+), 23 deletions(-)
> 
> 
> Shit_B:
>    workqueue: reset pool->node and unhash the pool when the node is
>      offline
>    workqueue: remove wq_numa_possible_cpumask
>    workqueue: directly update attrs of pools when cpu hot[un]plug
> 
>   kernel/workqueue.c | 135 +++++++++++++++++++++++++++++++++++++++--------------
>   1 file changed, 101 insertions(+), 34 deletions(-)
> 
> 
> Both patch1 of the both solutions are: reset pool->node and unhash the pool,
> it is suggested by TJ, I found it is a good leading-step for fixing the bug.
> 
> The other patches are handling wq_numa_possible_cpumask where the solutions
> diverge.
> 
> Solution_A uses present_mask rather than possible_cpumask. It adds
> wq_numa_notify_cpu_present_set/cleared() for notifications of
> the changes of cpu_present_mask.  But the notifications are un-existed
> right now, so I fake one (wq_numa_check_present_cpumask_changes())
> to imitate them.  I hope the memory people add a real one.
> 
> Solution_B uses online_mask rather than possible_cpumask.
> this solution remove more coupling between numa_code and workqueue,
> it just depends on cpumask_of_node(node).
> 
> Patch2_of_Solution_B removes the wq_numa_possible_cpumask and add
> overhead when cpu hot[un]plug, Patch3 reduce this overhead.
> 
> Thanks,
> Lai
> 
> 
> Reported-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> Cc: "Gu, Zheng" <guz.fnst@cn.fujitsu.com>
> Cc: tangchen <tangchen@cn.fujitsu.com>
> Cc: Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>
> 


