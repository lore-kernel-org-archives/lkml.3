Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562Ab3H2Q5r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 12:57:47 -0400
Received: from a194-81.smtp-out.amazonses.com ([199.255.194.81]:13241 "EHLO
	a194-81.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754951Ab3H2Q5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 12:57:44 -0400
Date: Thu, 29 Aug 2013 16:57:43 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Ingo Molnar <mingo@kernel.org>
cc: Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        akpm@linuxfoundation.org, Ingo Molnar <mingo@redhat.com>,
        linux-arch@vger.kernel.org, Steven Rostedt <srostedt@redhat.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [gcv v3 06/35] scheduler: Replace __get_cpu_var uses
In-Reply-To: <20130829100143.GA29672@gmail.com>
Message-ID: <00000140cb02576f-e106763c-d382-4b66-bb85-d7a9cb266b81-000000@email.amazonses.com>
References: <20130828193457.140443630@linux.com> <00000140c67817eb-b582280a-f059-499f-a24c-a11f3d59b86e-000000@email.amazonses.com> <20130829075818.GW10002@twins.programming.kicks-ass.net> <20130829100143.GA29672@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.194.81
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Aug 2013, Ingo Molnar wrote:

>
> >
> >
> > Seriously first fix the debug and validation bits of the *this_cpu*
> > stuff.
>
> Note that most of the other 'gcv' patches have these problems as well, so
> it's a NAK from me as well for most of the other patches as well ...

Note that this only affects __this_cpu_read and __this_cpu_write not the
this_cpu_ptr() operation.

The objection against having other variants of this_cpu operations before
was that there were too many. If we want to reintroduce the preemption
checks in the __ operations then we would need another variant for those
places that do not need it.

Right now we only have the regular ops which are interrupt safe and the
unsafe variant that can be used anyplace.

We could add a ____this_cpu variant that would be used in the cases we do
not want preemption checks? There should not be too many but it will
mean a whole lot of new definitions in percpu.h.


