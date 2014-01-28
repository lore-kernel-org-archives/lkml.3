Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567AbaA1SWl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 13:22:41 -0500
Received: from ms01.sssup.it ([193.205.80.99]:19950 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755324AbaA1SWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 13:22:39 -0500
Message-ID: <52E7F56A.7080707@sssup.it>
Date: Tue, 28 Jan 2014 18:22:34 +0000
From: Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Luca Abeni <luca.abeni@unitn.it>, Henrik Austad <henrik@austad.us>,
        Juri Lelli <juri.lelli@gmail.com>, tglx@linutronix.de,
        mingo@redhat.com, rostedt@goodmis.org, oleg@redhat.com,
        fweisbec@gmail.com, darren@dvhart.com, johan.eker@ericsson.com,
        p.faure@akatech.ch, linux-kernel@vger.kernel.org,
        claudio@evidence.eu.com, michael@amarulasolutions.com,
        fchecconi@gmail.com, nicola.manica@disi.unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@gmail.com, liming.wang@windriver.com,
        jkacur@redhat.com, harald.gustafsson@ericsson.com,
        vincent.guittot@linaro.org, bruce.ashfield@windriver.com,
        rob@landley.net
Subject: Re: [PATCH] sched/deadline: Add sched_dl documentation
References: <20140120131616.GB8907@austad.us> <52DD2711.9080504@unitn.it> <20140121102016.GA12002@austad.us> <52DE5B7F.8020900@unitn.it> <20140121123334.GJ30183@twins.programming.kicks-ass.net> <52DE6D21.1080602@unitn.it> <20140121135559.GK30183@twins.programming.kicks-ass.net> <52DFC196.7020301@unitn.it> <20140122135159.GQ31570@twins.programming.kicks-ass.net> <52E23BA3.7090206@sssup.it> <20140128093101.GE11314@laptop.programming.kicks-ass.net>
In-Reply-To: <20140128093101.GE11314@laptop.programming.kicks-ass.net>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/01/14 09:31, Peter Zijlstra wrote:
>> Exactly. I can remember also a huge period might be harmful, because with it
>> even a tiny utilization may lead to a big runtime that starves the whole non
>> RT tasks for a significant time. 
> 
> Another way to solve that is with explicit slack time scheduling, where
> slack here means the time/utilization not allocated to dl tasks (a quick
> google shows various different usages of slack, including laxity).
> 
> So suppose we have 50% utilization but with a huge period, we could
> schedule the other 50% at a fixed but smaller period and have that run
> the rt/fair/etc tasks.
> 
> So effectively we'll always fill up the utilization to 100% and use the
> 'slack' time as a server for the other classes.

Yesss :-)! Indeed, AFAICR in the AQuoSA API there was the QOS_F_DEFAULT flag

  http://aquosa.sourceforge.net/aquosa-docs/aquosa-qosres/html/qos__types_8h_source.html

(that could only be set by a  privileged process) just there to allow
for creating a server serving "default" tasks (namely, every non-aquosa task).
This way, you could create for example at system boot time a default
reservation with a precise (runtime, period) for Linux, so that non-aquosa
tasks could have a chance to run in that reservation, even in presence of
a RT reservation with a significantly long runtime.

	T.

