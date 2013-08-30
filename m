Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658Ab3H3GyY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 02:54:24 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57778 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978Ab3H3GyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 02:54:23 -0400
Date: Fri, 30 Aug 2013 08:54:18 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        akpm@linuxfoundation.org, Ingo Molnar <mingo@redhat.com>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [gcv v3 06/35] scheduler: Replace __get_cpu_var uses
Message-ID: <20130830065418.GA13867@gmail.com>
References: <20130828193457.140443630@linux.com>
 <00000140c67817eb-b582280a-f059-499f-a24c-a11f3d59b86e-000000@email.amazonses.com>
 <20130829075818.GW10002@twins.programming.kicks-ass.net>
 <20130829100143.GA29672@gmail.com>
 <00000140cb02576f-e106763c-d382-4b66-bb85-d7a9cb266b81-000000@email.amazonses.com>
 <20130829173256.GB6276@home.goodmis.org>
 <00000140cb49bdde-1279ffb0-5c49-400d-970c-a481d527e98a-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000140cb49bdde-1279ffb0-5c49-400d-970c-a481d527e98a-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Lameter <cl@linux.com> wrote:

> On Thu, 29 Aug 2013, Steven Rostedt wrote:
> 
> > On Thu, Aug 29, 2013 at 04:57:43PM +0000, Christoph Lameter wrote:
> > >
> > > We could add a ____this_cpu variant that would be used in the cases we do
> > > not want preemption checks? There should not be too many but it will
> > > mean a whole lot of new definitions in percpu.h.
> >
> > Let's get away from underscores as they are meaningless.
> >
> > A this_cpu_atomic() or other descriptive name would be much more
> > appropriate.
> 
> Its not really an atomic operation in the classic sense.
> 
> this_cpu_no_preempt_check_read ?
> 
> The problem that I have is also that a kernel with preemption is not 
> something that see anywhere these days. Looks more like an academic 
> exercise? Does this really matter? All the distro I see use 
> PREEMPT_VOLUNTARY. Performance degradation is significant if massive 
> amounts of checks and preempt disable/enable points are added to the 
> kernel.
> 
> Do we agree that it is necessary and useful to add another variant of 
> this_cpu ops for this? The concern of having too many variants is no 
> longer there? Adding another variant is not that difficult just code 
> intensive.

Just stop the lame excuses and fix it already. This has come up in the 
past and you know it: you were told to fix the this_cpu debug checks by 
Linus as well, yet you didn't ... Don't send crap you know is broken.

Thanks,

	Ingo
