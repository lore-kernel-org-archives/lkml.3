Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309AbaAQSt2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 13:49:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35124 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752733AbaAQStL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 13:49:11 -0500
Message-ID: <52D97ACD.10209@redhat.com>
Date: Fri, 17 Jan 2014 13:47:41 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org, mingo@redhat.com,
        chegu_vinod@hp.com, mgorman@suse.de, Rik van Riel <riel@surriel.com>
Subject: Re: [PATCH 6/6] numa,sched: normalize faults_from stats and weigh
 by CPU use
References: <1389939456-9541-1-git-send-email-riel@redhat.com> <1389939456-9541-7-git-send-email-riel@redhat.com> <20140117095459.GF11314@laptop.programming.kicks-ass.net> <52D94380.5040901@redhat.com> <20140117150409.GJ11314@laptop.programming.kicks-ass.net>
In-Reply-To: <20140117150409.GJ11314@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2014 10:04 AM, Peter Zijlstra wrote:
> On Fri, Jan 17, 2014 at 09:51:44AM -0500, Rik van Riel wrote:
>> On 01/17/2014 04:54 AM, Peter Zijlstra wrote:
>>> On Fri, Jan 17, 2014 at 01:17:36AM -0500, riel@redhat.com wrote:
>>>> +			/*
>>>> +			 * Normalize the faults_from, so all tasks in a group
>>>> +			 * count according to CPU use, instead of by the raw
>>>> +			 * number of faults. This prevents the situation where
>>>> +			 * the garbage collector totally dominates the stats,
>>>> +			 * and the access patterns of the worker threads are
>>>> +			 * ignored.
>>>> +			 */
>>>
>>> Instead of focusing on the one example (GC) here, I would suggest
>>> saying something along the lines of: Tasks with little runtime have
>>> little over-all impact on throughput and thus their faults are less
>>> important.
>>
>> Thanks for the review, I have updated the comment
>> accordingly.
>>
>> Does anybody else have comments on this series, or should
>> I start begging for Acked-by: and Reviewed-by: lines? :)
> 
> I still need to get me head around part of the previous patches, and I
> suppose Mel might have a look, give it a few days ;-)

Well, you didn't spot the divide by zero that Vinod somehow
managed to trigger :)

I am also going to add another patch, that prevents the temporary
values from "p->numa_faults[i] >>= 1;" becoming visible, by using
local variables for those calculations.

Expect a v2 soonish.

-- 
All rights reversed
