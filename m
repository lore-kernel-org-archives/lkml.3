Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760072Ab3ICO0F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 10:26:05 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:44574 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752474Ab3ICO0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 10:26:03 -0400
Date: Tue, 3 Sep 2013 14:26:01 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Steven Rostedt <rostedt@goodmis.org>
cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        Ingo Molnar <mingo@redhat.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [gcv v3 06/35] scheduler: Replace __get_cpu_var uses
In-Reply-To: <20130829143053.3fc2caa8@gandalf.local.home>
Message-ID: <00000140e4373c9e-ea44cb7f-985f-4d33-86ed-cfd54ec7327b-000000@email.amazonses.com>
References: <20130828193457.140443630@linux.com> <00000140c67817eb-b582280a-f059-499f-a24c-a11f3d59b86e-000000@email.amazonses.com> <20130829075818.GW10002@twins.programming.kicks-ass.net> <20130829100143.GA29672@gmail.com>
 <00000140cb02576f-e106763c-d382-4b66-bb85-d7a9cb266b81-000000@email.amazonses.com> <20130829173256.GB6276@home.goodmis.org> <00000140cb49bdde-1279ffb0-5c49-400d-970c-a481d527e98a-000000@email.amazonses.com> <20130829143053.3fc2caa8@gandalf.local.home>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Aug 2013, Steven Rostedt wrote:

> How many places use the this_cpu_*() without preemption disabled? I
> wouldn't think there's many. I never complained about another variant,
> so you need to ask those that have. The tough question for me is what
> that variant name should be ;-)

Tried to add preemption checks but the basic issue is that many of the
checks themselves use this_cpu_ops. percpu.h is very basic to the
operation of fundamental primitives for preempt etc. Use of a BUG_ON needs
a seris of includes in percpu.h that cause more trouble.

If I switch __this_cpu ops to check for preemption then the logic for
preemption etc must use the raw_this_cpu ops.
