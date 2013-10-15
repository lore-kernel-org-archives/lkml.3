Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757590Ab3JOIX1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 04:23:27 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:36431 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409Ab3JOIXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 04:23:24 -0400
Message-ID: <525CFB77.90201@gmail.com>
Date: Tue, 15 Oct 2013 10:23:19 +0200
From: Juri Lelli <juri.lelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: tglx@linutronix.de, mingo@redhat.com, rostedt@goodmis.org, oleg@redhat.com,
        fweisbec@gmail.com, darren@dvhart.com, johan.eker@ericsson.com,
        p.faure@akatech.ch, linux-kernel@vger.kernel.org,
        claudio@evidence.eu.com, michael@amarulasolutions.com,
        fchecconi@gmail.com, tommaso.cucinotta@sssup.it,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@gmail.com, liming.wang@windriver.com,
        jkacur@redhat.com, harald.gustafsson@ericsson.com,
        vincent.guittot@linaro.org,
        bruce.ashfield@windriver.com--no-chain-reply-to
Subject: Re: [PATCH 06/14] sched: add period support for -deadline tasks.
References: <1381747426-31334-1-git-send-email-juri.lelli@gmail.com> <1381747426-31334-7-git-send-email-juri.lelli@gmail.com> <20131014120724.GI3081@twins.programming.kicks-ass.net>
In-Reply-To: <20131014120724.GI3081@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2013 02:07 PM, Peter Zijlstra wrote:
> On Mon, Oct 14, 2013 at 12:43:38PM +0200, Juri Lelli wrote:
>> From: Harald Gustafsson <harald.gustafsson@ericsson.com>
>>
>> Make it possible to specify a period (different or equal than
>> deadline) for -deadline tasks.
> 
> Could we add a little blurb here as to why we'd want this?
> 
> (I think I do, and I certainly know where to find the answer, but its
> better to have a more complete changelog).
> 

Yes, I could amend the commit message in something like this:

Make it possible to specify a period (different or equal than deadline) for
-deadline tasks. Relative deadlines (D_i) are used on task arrivals to generate
new scheduling (absolute) deadlines as "d = t + D_i", and periods (P_i) to
postpone the scheduling deadlines as "d = d + P_i" when the budget is zero.
This is in general useful to model (and schedule) tasks that have slow
activation rates (long periods), but have to be scheduled soon once activated
(short deadlines).

What do you think?

Thanks,

- Juri
