Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697AbaEIPLd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 11:11:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908AbaEIPLc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 11:11:32 -0400
Message-ID: <536CEF6E.1090604@redhat.com>
Date: Fri, 09 May 2014 11:08:30 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, mingo@kernel.org, mgorman@suse.de,
        chegu_vinod@hp.com
Subject: Re: [PATCH 1/4] numa,x86: store maximum numa node distance
References: <1399569811-14362-1-git-send-email-riel@redhat.com> <1399569811-14362-2-git-send-email-riel@redhat.com> <20140509094543.GP30445@twins.programming.kicks-ass.net>
In-Reply-To: <20140509094543.GP30445@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2014 05:45 AM, Peter Zijlstra wrote:
> On Thu, May 08, 2014 at 01:23:28PM -0400, riel@redhat.com wrote:
>> From: Rik van Riel <riel@redhat.com>
>>
>> Store the maximum node distance, so the numa placement code can do
>> better placement on systems with complex numa topology.
>>
>> The function max_node_distance will return LOCAL_DISTANCE if the
>> system has simple NUMA topology, with only a single level of
>> remote distance.
>>
>> Signed-off-by: Rik van Riel <riel@redhat.com>
>> Tested-by: Chegu Vinod <chegu_vinod@hp.com>
>> ---
>>   arch/x86/include/asm/topology.h |  3 +++
>>   arch/x86/mm/numa.c              | 25 +++++++++++++++++++++++++
>>   include/linux/topology.h        |  3 +++
>>   3 files changed, 31 insertions(+)
>>
>
> Why are you doing this in arch code? I would've expected some extra code
> to sched_init_numa() which is generic code that analyses the distance
> table and reconstructs the actual topology from it.

The only reason it is in the arch code is that node_distance()
is in arch code today.

If there is no good reason for node_distance and the node
distances array to be in arch code, I could take a stab at
making it generic...

