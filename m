Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325AbaGBCsP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 22:48:15 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:36239 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbaGBCrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 22:47:43 -0400
Message-ID: <53B372C6.5000107@linux.vnet.ibm.com>
Date: Wed, 02 Jul 2014 10:47:34 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Mike Galbraith <umgwanakikbuti@gmail.com>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Alex Shi <alex.shi@linaro.org>,
        Paul Turner <pjt@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: select 'idle' cfs_rq per task-group to prevent
 tg-internal imbalance
References: <53A11A89.5000602@linux.vnet.ibm.com> <20140623094251.GS19860@laptop.programming.kicks-ass.net> <53A8F1DE.2060908@linux.vnet.ibm.com> <20140701082020.GL6758@twins.programming.kicks-ass.net> <53B273A2.5050500@linux.vnet.ibm.com> <20140701085658.GM6758@twins.programming.kicks-ass.net>
In-Reply-To: <20140701085658.GM6758@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070202-5490-0000-0000-00000054B77F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2014 04:56 PM, Peter Zijlstra wrote:
> On Tue, Jul 01, 2014 at 04:38:58PM +0800, Michael wang wrote:
[snip]
>> Currently when dbench running with stress, it could only gain one CPU,
>> and cpu-cgroup cpu.shares is meaningless, is there any good methods to
>> address that?
> 
> So as far as I understood this is because of 'other' tasks; these other
> tasks have never been fully qualified, but I suspect they're workqueue
> thingies. One solution would be to have work run in the same cgroup as
> the task creating it.

Yes, they are kworkers.

> 
> The thing is, this is not a scheduler problem, so we should not fix it
> in the scheduler.

I won't argue on that point, while even we get rid of the cgroup stuff,
let's say we just run 12 stress, then 'dbench 6' will suffered a low
performance too, this kind of mixed workloads is not treated well enough
from the view of dbench, and no methods provided by scheduler could
address that...

The opinion on features actually make me a little confusing... I used to
think the scheduler is willing on providing kinds of way to adapt itself
to different situation, and some features do help on that, make them
only a debug option make the scheduler more static to users, but I know
that's not what I should touched...

Anyway, the problem is still there and seems like we have to adopt some
optional solution to address it, we'll still working and practice on
that, please let us know if you have any ideas we could help on ;-)

Regards,
Michael Wang

> 

