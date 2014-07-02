Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185AbaGBOsV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 10:48:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46051 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754039AbaGBOsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 10:48:20 -0400
Message-ID: <53B41B7E.8020009@redhat.com>
Date: Wed, 02 Jul 2014 10:47:26 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Michael wang <wangyun@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
CC: Mike Galbraith <umgwanakikbuti@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Alex Shi <alex.shi@linaro.org>, Paul Turner <pjt@google.com>,
        Mel Gorman <mgorman@suse.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: select 'idle' cfs_rq per task-group to prevent
 tg-internal imbalance
References: <53A11A89.5000602@linux.vnet.ibm.com> <20140623094251.GS19860@laptop.programming.kicks-ass.net> <53A8F1DE.2060908@linux.vnet.ibm.com> <20140701082020.GL6758@twins.programming.kicks-ass.net> <53B273A2.5050500@linux.vnet.ibm.com>
In-Reply-To: <53B273A2.5050500@linux.vnet.ibm.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2014 04:38 AM, Michael wang wrote:
> On 07/01/2014 04:20 PM, Peter Zijlstra wrote:
> [snip]
>>>
>>> Just wondering could we make this another scheduler feature?
>>
>> No; sched_feat() is for debugging, BIG CLUE: its guarded by
>> CONFIG_SCHED_DEBUG, anybody using it in production or anywhere else is
>> broken.
>>
>> If people are using it, I should remove or at least randomize the
>> interface.
> 
> Fair enough... but is there any suggestions on how to handle this issue?
> 
> Currently when dbench running with stress, it could only gain one CPU,
> and cpu-cgroup cpu.shares is meaningless, is there any good methods to
> address that?

select_idle_sibling will iterate over all of the CPUs
in an LLC domain if there is no idle cpu in the domain.

I suspect it would not take much extra code to track
down the idlest CPU in the LLC domain, and make sure to
schedule tasks there, in case no completely idle CPU
was found.

Are there any major problems with that thinking?

