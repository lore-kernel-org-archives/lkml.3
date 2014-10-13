Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309AbaJMHNb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 03:13:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44891 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753261AbaJMHNW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 03:13:22 -0400
Message-ID: <543B7B74.7050706@redhat.com>
Date: Mon, 13 Oct 2014 03:12:52 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, mgorman@suse.de, chegu_vinod@hp.com,
        mingo@kernel.org, efault@gmx.de, vincent.guittot@linaro.org
Subject: Re: [PATCH RFC 3/5] sched,numa: preparations for complex topology
 placement
References: <1412797050-8903-1-git-send-email-riel@redhat.com> <1412797050-8903-4-git-send-email-riel@redhat.com> <20141012143735.GG3015@worktop>
In-Reply-To: <20141012143735.GG3015@worktop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2014 10:37 AM, Peter Zijlstra wrote:
> On Wed, Oct 08, 2014 at 03:37:28PM -0400, riel@redhat.com wrote:
>> From: Rik van Riel <riel@redhat.com>
>>
>> Preparatory patch for adding NUMA placement on systems with
>> complex NUMA topology. Also fix a potential divide by zero
>> in group_weight()
>>
>> Signed-off-by: Rik van Riel <riel@redhat.com>
>> ---
>>   include/linux/topology.h |  1 +
>>   kernel/sched/core.c      |  2 +-
>>   kernel/sched/fair.c      | 57 +++++++++++++++++++++++++++++++-----------------
>>   3 files changed, 39 insertions(+), 21 deletions(-)
>>
>> diff --git a/include/linux/topology.h b/include/linux/topology.h
>> index bf40d46..f8dfad9 100644
>> --- a/include/linux/topology.h
>> +++ b/include/linux/topology.h
>> @@ -47,6 +47,7 @@
>>   		if (nr_cpus_node(node))
>>
>>   int arch_update_cpu_topology(void);
>> +extern int sched_domains_numa_levels;
>>   extern int node_hops(int i, int j);
>>
>
> I'm not sure we want to share this globally, please consider using
> kernel/sched/sched.h
>
Good point. I will do that.
