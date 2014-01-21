Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004AbaAUQqU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 11:46:20 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:46736 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466AbaAUQqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 11:46:18 -0500
Message-ID: <52DEA455.7000208@gmail.com>
Date: Tue, 21 Jan 2014 17:46:13 +0100
From: Juri Lelli <juri.lelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
CC: Michael Kerrisk <mtk.manpages@gmail.com>,
        Dario Faggioli <raistlin@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, fweisbec@gmail.com, darren@dvhart.com,
        johan.eker@ericsson.com, p.faure@akatech.ch,
        Linux Kernel <linux-kernel@vger.kernel.org>, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        Paul McKenney <paulmck@linux.vnet.ibm.com>, insop.song@gmail.com,
        liming.wang@windriver.com, jkacur@redhat.com
Subject: Re: [PATCH 01/13] sched: Add 3 new scheduler syscalls to support
 an extended scheduling parameters ABI
References: <20131217122720.950475833@infradead.org> <20131217123352.692059839@infradead.org> <CAHO5Pa3=+Zhg72tVfddSUvgirUyObir6atJVo4_16bVWB2Osgw@mail.gmail.com> <20140121153851.GZ31570@twins.programming.kicks-ass.net> <20140121154603.GF3694@twins.programming.kicks-ass.net> <20140121110255.7d9af63d@gandalf.local.home> <20140121160647.GD31570@twins.programming.kicks-ass.net>
In-Reply-To: <20140121160647.GD31570@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2014 05:06 PM, Peter Zijlstra wrote:
> On Tue, Jan 21, 2014 at 11:02:55AM -0500, Steven Rostedt wrote:
>> On Tue, 21 Jan 2014 16:46:03 +0100
>> Peter Zijlstra <peterz@infradead.org> wrote:
>>
>>> On Tue, Jan 21, 2014 at 04:38:51PM +0100, Peter Zijlstra wrote:
>>>>     SCHED_DEADLINE: Sporadic task model deadline scheduling
>>>> 	SCHED_DEADLINE is an implementation of GEDF (Global Earliest
>>>> 	Deadline First) with additional CBS (Constant Bandwidth Server).
>>>
>>> We might want to re-word that to:
>>>
>>> 	SCHED_DEADLINE currently is an implementation of GEDF, however
>>> 	any policy that correctly schedules the sporadic task model is
>>> 	a valid implementation.
>>>
>>> To make sure we should not rely on the actual implementation; there's
>>> many possible algorithms to schedule the sporadic task model.
>>
>> Probably should post some links to GEDF documentation too?
> 
> At best I think we can do something like:
> 
> SEE ALSO
> 	Documentation/scheduler/sched_deadline.txt in the Linux kernel
> 	source tree (since kernel 3.14).
> 
> Possibly also an ISBN for a good scheduling theory book (if there exists
> such a thing), but I would have to rely on others to provide such as my
> shelfs are devoid of such material.
> 

Well, picking just one is not that easy, I'd say (among many others):

 - Handbook of Scheduling: Algorithms, Models, and Performance Analysis
   by Joseph Y-T. Leung, James H. Anderson - ISBN-10: 1584883979
   (especially cap. 30);
 - Hard Real-Time Computing Systems by Giorgio C. Buttazzo
   ISBN 978-1-4614-0675-4 (even if it is more about UP);
 - A survey of hard real-time scheduling for multiprocessor systems
   by RI Davis, A Burns - ACM Computing Surveys (CSUR), 2011
   (available at http://www-users.cs.york.ac.uk/~robdavis/papers/MPSurveyv5.0.pdf);

Probably last one is better (as is freely downloadable). We should add
something in the documentation too.

Thanks,

- Juri
