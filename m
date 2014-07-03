Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905AbaGCCRI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 22:17:08 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:57878 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbaGCCRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 22:17:05 -0400
Message-ID: <53B4BD11.2030406@linux.vnet.ibm.com>
Date: Thu, 03 Jul 2014 10:16:49 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>
CC: Mike Galbraith <umgwanakikbuti@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Alex Shi <alex.shi@linaro.org>, Paul Turner <pjt@google.com>,
        Mel Gorman <mgorman@suse.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: select 'idle' cfs_rq per task-group to prevent
 tg-internal imbalance
References: <53A11A89.5000602@linux.vnet.ibm.com> <20140623094251.GS19860@laptop.programming.kicks-ass.net> <53A8F1DE.2060908@linux.vnet.ibm.com> <20140701082020.GL6758@twins.programming.kicks-ass.net> <53B273A2.5050500@linux.vnet.ibm.com> <53B41B7E.8020009@redhat.com>
In-Reply-To: <53B41B7E.8020009@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070302-1396-0000-0000-000005281B15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2014 10:47 PM, Rik van Riel wrote:
> On 07/01/2014 04:38 AM, Michael wang wrote:
>> On 07/01/2014 04:20 PM, Peter Zijlstra wrote:
>> [snip]
>>>>
>>>> Just wondering could we make this another scheduler feature?
>>>
>>> No; sched_feat() is for debugging, BIG CLUE: its guarded by
>>> CONFIG_SCHED_DEBUG, anybody using it in production or anywhere else is
>>> broken.
>>>
>>> If people are using it, I should remove or at least randomize the
>>> interface.
>>
>> Fair enough... but is there any suggestions on how to handle this issue?
>>
>> Currently when dbench running with stress, it could only gain one CPU,
>> and cpu-cgroup cpu.shares is meaningless, is there any good methods to
>> address that?

Hi, Rik

> 
> select_idle_sibling will iterate over all of the CPUs
> in an LLC domain if there is no idle cpu in the domain.
> 
> I suspect it would not take much extra code to track
> down the idlest CPU in the LLC domain, and make sure to
> schedule tasks there, in case no completely idle CPU
> was found.
> 
> Are there any major problems with that thinking?

There are some try to improve that part previously, but testing show
that logical is somewhat cheap and good...

And in our cases this is cheap too since no idle CPU is there, 12 stress
will occupy all the CPU, and select_idle_sibling() will go through the
path very quick, since whenever there is a non-idle CPU in sg, sg will
be abandoned.

Regards,
Michael Wang

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

