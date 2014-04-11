Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbaDKRmO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 13:42:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58357 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751273AbaDKRmM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 13:42:12 -0400
Message-ID: <53482953.3070201@redhat.com>
Date: Fri, 11 Apr 2014 13:41:39 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-kernel@vger.kernel.org, mingo@kernel.org, peterz@infradead.org,
        chegu_vinod@hp.com, mgorman@suse.de
Subject: Re: [PATCH 1/3] sched,numa: count pages on active node as local
References: <1397235629-16328-1-git-send-email-riel@redhat.com>	 <1397235629-16328-2-git-send-email-riel@redhat.com> <1397237673.7113.22.camel@joe-AO722>
In-Reply-To: <1397237673.7113.22.camel@joe-AO722>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2014 01:34 PM, Joe Perches wrote:
> On Fri, 2014-04-11 at 13:00 -0400, riel@redhat.com wrote:
>> This should reduce the overhead of the automatic NUMA placement
>> code, when a workload spans multiple NUMA nodes.
> 
> trivial style note:
> 
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> []
>> @@ -1737,6 +1737,7 @@ void task_numa_fault(int last_cpupid, int mem_node, int pages, int flags)
>>  	struct task_struct *p = current;
>>  	bool migrated = flags & TNF_MIGRATED;
>>  	int cpu_node = task_node(current);
>> +	int local = !!(flags & TNF_FAULT_LOCAL);
> 
> Perhaps local would look nicer as bool
> and be better placed next to migrated.

The problem is, at the end of the function, local is used as an
array index...

        p->numa_faults_locality[local] += pages;
}

I'm not sure I really want to use a bool as an array index :)

-- 
All rights reversed
