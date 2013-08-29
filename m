Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675Ab3H2SaA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 14:30:00 -0400
Received: from a9-97.smtp-out.amazonses.com ([54.240.9.97]:49379 "EHLO
	a9-97.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754623Ab3H2S36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 14:29:58 -0400
X-Greylist: delayed 853 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Aug 2013 14:29:58 EDT
Date: Thu, 29 Aug 2013 18:15:43 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Steven Rostedt <rostedt@goodmis.org>
cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        Ingo Molnar <mingo@redhat.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [gcv v3 06/35] scheduler: Replace __get_cpu_var uses
In-Reply-To: <20130829173256.GB6276@home.goodmis.org>
Message-ID: <00000140cb49bdde-1279ffb0-5c49-400d-970c-a481d527e98a-000000@email.amazonses.com>
References: <20130828193457.140443630@linux.com> <00000140c67817eb-b582280a-f059-499f-a24c-a11f3d59b86e-000000@email.amazonses.com> <20130829075818.GW10002@twins.programming.kicks-ass.net> <20130829100143.GA29672@gmail.com>
 <00000140cb02576f-e106763c-d382-4b66-bb85-d7a9cb266b81-000000@email.amazonses.com> <20130829173256.GB6276@home.goodmis.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.08.29-54.240.9.97
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Aug 2013, Steven Rostedt wrote:

> On Thu, Aug 29, 2013 at 04:57:43PM +0000, Christoph Lameter wrote:
> >
> > We could add a ____this_cpu variant that would be used in the cases we do
> > not want preemption checks? There should not be too many but it will
> > mean a whole lot of new definitions in percpu.h.
>
> Let's get away from underscores as they are meaningless.
>
> A this_cpu_atomic() or other descriptive name would be much more
> appropriate.

Its not really an atomic operation in the classic sense.

this_cpu_no_preempt_check_read ?

The problem that I have is also that a kernel with preemption is not
something that see anywhere these days. Looks more like an academic
exercise? Does this really matter? All the distro I see use
PREEMPT_VOLUNTARY. Performance degradation is significant if massive
amounts of checks and preempt disable/enable points are added to the
kernel.

Do we agree that it is necessary and useful to add another variant of
this_cpu ops for this? The concern of having too many variants is no
longer there? Adding another variant is not that difficult just code
intensive.

