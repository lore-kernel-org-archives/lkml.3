Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481AbaJLN2v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 09:28:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19637 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115AbaJLN2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 09:28:50 -0400
Message-ID: <543A81E4.4090504@redhat.com>
Date: Sun, 12 Oct 2014 09:28:04 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, mgorman@suse.de, chegu_vinod@hp.com,
        mingo@kernel.org, efault@gmx.de, vincent.guittot@linaro.org
Subject: Re: [PATCH RFC 1/5] sched,numa: build table of node hop distance
References: <1412797050-8903-1-git-send-email-riel@redhat.com> <1412797050-8903-2-git-send-email-riel@redhat.com> <20141012131714.GE3015@worktop>
In-Reply-To: <20141012131714.GE3015@worktop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2014 09:17 AM, Peter Zijlstra wrote:
> On Wed, Oct 08, 2014 at 03:37:26PM -0400, riel@redhat.com wrote:
>> +	sched_domains_numa_hops = kzalloc(sizeof(int) * nr_node_ids * nr_node_ids, GFP_KERNEL);
>> +	if (!sched_domains_numa_hops)
>> +		return;
>
> That's potentially a _BIG_ table (1M for a 512 node system).
> The node_distance has magic allocations and is of u8 size, is there any
> way we can re-use node_distance and avoid a second O(n^2) allocation?

You are right, this should be a u8 at the least.

Beyond that, I am not convinced that merging things into
the same array is worthwhile, since (IIRC) nr_node_ids
should be set to the actual number of nodes on the system
by then.
