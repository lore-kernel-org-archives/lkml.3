Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768Ab3H2Sa5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 14:30:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14477 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756529Ab3H2Sa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 14:30:56 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=LpxhMNE_n7QA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=qNUMAmISgnoA:10 a=NufY4J3AAAAA:8 a=_P2Xt4MCIiuXImbTLIEA:9 a=CjuIK1q_8ugA:10 a=re9sYKne76oA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Thu, 29 Aug 2013 14:30:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Christoph Lameter <cl@linux.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        Ingo Molnar <mingo@redhat.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [gcv v3 06/35] scheduler: Replace __get_cpu_var uses
Message-ID: <20130829143053.3fc2caa8@gandalf.local.home>
In-Reply-To: <00000140cb49bdde-1279ffb0-5c49-400d-970c-a481d527e98a-000000@email.amazonses.com>
References: <20130828193457.140443630@linux.com>
	<00000140c67817eb-b582280a-f059-499f-a24c-a11f3d59b86e-000000@email.amazonses.com>
	<20130829075818.GW10002@twins.programming.kicks-ass.net>
	<20130829100143.GA29672@gmail.com>
	<00000140cb02576f-e106763c-d382-4b66-bb85-d7a9cb266b81-000000@email.amazonses.com>
	<20130829173256.GB6276@home.goodmis.org>
	<00000140cb49bdde-1279ffb0-5c49-400d-970c-a481d527e98a-000000@email.amazonses.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Aug 2013 18:15:43 +0000
Christoph Lameter <cl@linux.com> wrote:

> On Thu, 29 Aug 2013, Steven Rostedt wrote:
> 
> Its not really an atomic operation in the classic sense.

It doesn't need to be atomic, it could mean it is used within atomic
locations. Basically, "can't be interrupted here". I just said
"something like", it didn't even need to be that.

> 
> this_cpu_no_preempt_check_read ?

I would make it much shorter. You could use "raw_this_cpu_read()",
which usually means "no checks here". Or, "this_cpu_read_nopreempt()".

> 
> The problem that I have is also that a kernel with preemption is not
> something that see anywhere these days. Looks more like an academic
> exercise? Does this really matter? All the distro I see use

Um, my paycheck depends on PREEMPT_RT working. And there's a lot of
interest in real PREEMPT by audio folks. It's no more an
academic exercise than people wanting really low kernel latency.

> PREEMPT_VOLUNTARY. Performance degradation is significant if massive
> amounts of checks and preempt disable/enable points are added to the
> kernel.

They are usually disabled for production systems. But we run a bunch of
tests with the debug checks enabled, which catch bugs before we ship a
kernel for a production system.

> 
> Do we agree that it is necessary and useful to add another variant of
> this_cpu ops for this? The concern of having too many variants is no
> longer there? Adding another variant is not that difficult just code
> intensive.

How many places use the this_cpu_*() without preemption disabled? I
wouldn't think there's many. I never complained about another variant,
so you need to ask those that have. The tough question for me is what
that variant name should be ;-)

-- Steve
