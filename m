Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713Ab3ICPpA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 11:45:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29221 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332Ab3ICPo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 11:44:58 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=LpxhMNE_n7QA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=qNUMAmISgnoA:10 a=pGLkceISAAAA:8 a=NufY4J3AAAAA:8 a=x9zbOqYJgs6x7dz7IGYA:9 a=CjuIK1q_8ugA:10 a=MSl-tDqOz04A:10 a=re9sYKne76oA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Tue, 3 Sep 2013 11:44:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Christoph Lameter <cl@linux.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        akpm@linuxfoundation.org, Ingo Molnar <mingo@redhat.com>,
        linux-arch@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [gcv v3 06/35] scheduler: Replace __get_cpu_var uses
Message-ID: <20130903114454.2a995f41@gandalf.local.home>
In-Reply-To: <CAFTL4hyEuePJC4GG60DqQCfu-JiV9krRCf3FwWAy15Hyzu2AUw@mail.gmail.com>
References: <20130828193457.140443630@linux.com>
	<00000140c67817eb-b582280a-f059-499f-a24c-a11f3d59b86e-000000@email.amazonses.com>
	<20130829075818.GW10002@twins.programming.kicks-ass.net>
	<20130829100143.GA29672@gmail.com>
	<00000140cb02576f-e106763c-d382-4b66-bb85-d7a9cb266b81-000000@email.amazonses.com>
	<20130829173256.GB6276@home.goodmis.org>
	<00000140cb49bdde-1279ffb0-5c49-400d-970c-a481d527e98a-000000@email.amazonses.com>
	<20130829143053.3fc2caa8@gandalf.local.home>
	<00000140e4373c9e-ea44cb7f-985f-4d33-86ed-cfd54ec7327b-000000@email.amazonses.com>
	<CAFTL4hyEuePJC4GG60DqQCfu-JiV9krRCf3FwWAy15Hyzu2AUw@mail.gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Sep 2013 16:45:45 +0200
Frederic Weisbecker <fweisbec@gmail.com> wrote:

> 2013/9/3 Christoph Lameter <cl@linux.com>:
> > On Thu, 29 Aug 2013, Steven Rostedt wrote:
> >
> >> How many places use the this_cpu_*() without preemption disabled? I
> >> wouldn't think there's many. I never complained about another variant,
> >> so you need to ask those that have. The tough question for me is what
> >> that variant name should be ;-)
> >
> > Tried to add preemption checks but the basic issue is that many of the
> > checks themselves use this_cpu_ops. percpu.h is very basic to the
> > operation of fundamental primitives for preempt etc. Use of a BUG_ON needs
> > a seris of includes in percpu.h that cause more trouble.
> >
> > If I switch __this_cpu ops to check for preemption then the logic for
> > preemption etc must use the raw_this_cpu ops.
> 
> IIUC the issue is that preempt debug checks themselves use per cpu
> operations that can result in preempt debug checks? Hence a recursion.
> Do you have an example of that?
> 
> Also in this case this must be fixed anyway given the checks that
> already exist in smp_processor_id(), __get_cpu_var(), ...

Right, that's why there's a raw_smp_processor_id() and
__raw_get_cpu_var(). Those two are the ones without checks, and they
are called by the non "raw" versions after the check is done.

Really, what's so damn hard about this?

-- Steve
