Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229AbaATSvp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 13:51:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35062 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822AbaATSvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 13:51:41 -0500
Message-ID: <52DD7016.9080708@redhat.com>
Date: Mon, 20 Jan 2014 13:51:02 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, chegu_vinod@hp.com,
        mgorman@suse.de, mingo@redhat.com,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 4/7] numa,sched: tracepoints for NUMA balancing active
 nodemask changes
References: <1389993129-28180-1-git-send-email-riel@redhat.com> <1389993129-28180-5-git-send-email-riel@redhat.com> <20140120165205.GJ31570@twins.programming.kicks-ass.net>
In-Reply-To: <20140120165205.GJ31570@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2014 11:52 AM, Peter Zijlstra wrote:
> On Fri, Jan 17, 2014 at 04:12:06PM -0500, riel@redhat.com wrote:

>> +++ b/kernel/sched/fair.c
>> @@ -1300,10 +1300,14 @@ static void update_numa_active_node_mask(struct task_struct *p)
>>  		faults = numa_group->faults_from[task_faults_idx(nid, 0)] +
>>  			 numa_group->faults_from[task_faults_idx(nid, 1)];
>>  		if (!node_isset(nid, numa_group->active_nodes)) {
>> -			if (faults > max_faults * 4 / 10)
>> +			if (faults > max_faults * 4 / 10) {
>> +				trace_update_numa_active_nodes_mask(current->pid, numa_group->gid, nid, true, faults, max_faults);
> 
> While I think the tracepoint hookery is smart enough to avoid evaluating
> arguments when they're disabled, it might be best to simply pass:
> current and numa_group and do the dereference in fast_assign().
> 
> That said, this is the first and only numa tracepoint, I'm not sure why
> this qualifies and other metrics do not.

It's there because I needed it in development.

If you think it is not merge material, I would be comfortable
leaving it out.

-- 
All rights reversed
