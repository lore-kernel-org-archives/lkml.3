Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899AbaEIPRX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 11:17:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2875 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744AbaEIPRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 11:17:21 -0400
Message-ID: <536CF0CD.2090504@redhat.com>
Date: Fri, 09 May 2014 11:14:21 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, mingo@kernel.org, mgorman@suse.de,
        chegu_vinod@hp.com
Subject: Re: [PATCH 2/4] sched,numa: weigh nearby nodes for task placement
 on complex NUMA topologies
References: <1399569811-14362-1-git-send-email-riel@redhat.com> <1399569811-14362-3-git-send-email-riel@redhat.com> <20140509095324.GQ30445@twins.programming.kicks-ass.net>
In-Reply-To: <20140509095324.GQ30445@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2014 05:53 AM, Peter Zijlstra wrote:
> On Thu, May 08, 2014 at 01:23:29PM -0400, riel@redhat.com wrote:
>> +		/*
>> +		 * For nodes with distances in-between LOCAL_DISTANCE
>> +		 * and max_distance, we count the faults on those nodes
>> +		 * in proportion to their distance, using this formula:
>> +		 *
>> +		 * max_distance - node_distance
>> +		 * -----------------------------
>> +		 * max_distance - LOCAL_DISTANCE
>> +		 */
>> +		if (task)
>> +			faults = task_faults(p, node);
>> +		else
>> +			faults = group_faults(p, node);
>> +
>> +		score += 1000 * faults *
>> +				(max_distance - distance) /
>> +				(max_distance - LOCAL_DISTANCE);
>
> OK that makes sense, except I would suggest you use a power-of-two scale
> factor :-)

I guess we could build a NUMA distance table that
counts the number of hops, and use that.

That is likely to result in better/easier values
for grouping than the (somewhat arbitrary) distances
in the SLIT table, anyway...
