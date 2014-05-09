Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737AbaEIPHB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 11:07:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9429 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755219AbaEIPHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 11:07:00 -0400
Message-ID: <536CEE5E.9010609@redhat.com>
Date: Fri, 09 May 2014 11:03:58 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, mingo@kernel.org, mgorman@suse.de,
        chegu_vinod@hp.com
Subject: Re: [PATCH 2/4] sched,numa: weigh nearby nodes for task placement
 on complex NUMA topologies
References: <1399569811-14362-1-git-send-email-riel@redhat.com> <1399569811-14362-3-git-send-email-riel@redhat.com> <20140509101317.GU30445@twins.programming.kicks-ass.net>
In-Reply-To: <20140509101317.GU30445@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2014 06:13 AM, Peter Zijlstra wrote:
> On Thu, May 08, 2014 at 01:23:29PM -0400, riel@redhat.com wrote:
>> This patch does nothing on machines with simple NUMA topologies.
>
> Was this:
>
>> +	/*
>> +	 * No need to calculate a score if the system has a simple NUMA
>> +	 * topology, with no node distances between "local" and "far away".
>> +	 */
>> +	if (max_distance == LOCAL_DISTANCE)
>> +		return 0;
>
> Supposed to make that true?
>
> It doesn't. That test is a !numa test, not a fully connected test.
>

Look at patch 1/4.  I only set max_distance to !LOCAL_DISTANCE
if the system has multiple different distances in the SLIT
table.

I guess that needs to be cleaned up :)
