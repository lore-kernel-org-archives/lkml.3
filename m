Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464Ab3K0Rkk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 12:40:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44907 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757280Ab3K0RkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 12:40:21 -0500
Date: Wed, 27 Nov 2013 18:41:17 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [RFC PATCH 0/2] tracing: Teach FETCH_MTD_symbol to handle
	per-cpu data
Message-ID: <20131127174117.GC26138@redhat.com>
References: <20131123201543.GA22148@redhat.com> <20131125172106.GA14516@redhat.com> <20131125172206.GD14516@redhat.com> <52946B42.40603@hitachi.com> <20131126174355.GB14028@redhat.com> <5295C304.1050702@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5295C304.1050702@hitachi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27, Masami Hiramatsu wrote:
>
> (2013/11/27 2:43), Oleg Nesterov wrote:
> >
> > This doesn't allow to read the data from other CPUs, but at least
> > the changes are simple and this_cpu_ is better than the reading
> > from the obviously wrong address.
>
> Yeah, usually per_cpu variable is used in current cpu context.
>
> >> For the dynamic allocated per-cpu things, it is also good to give
> >> a straight operation, like +10(percpu(%rdi)).
> >
> > Probably yes, but this needs more changes and I am still not sure
> > this is really useful. And if we do this, we probably also need
> > to allow to read from other CPUs...
>
> No, it is enough to provide "percpu(FETCHARG)" which just returns
> current cpu's percpu variable address.

I don't really agree. I am not saying this is terribly useful, but:

> (Note that kprobes handler
> runs in interrupt)

but this doesn't matter at all, I think. The code can execute, say,
__percpu_counter_sum-like code.

And even if we dump the .data..percpu memory (@percpu_symbol) the
user might want to know the "global" state of this per-cpu object.

And note that sometimes DEFINE_PER_CPU doesn't really connect to
smp_processor_id(). Just for example, bp_cpuinfo[]. It is never
used as this-cpu-data. This means that @bp_cpuinfo+whatever is
always pointless.

But anyway I agree, this is not that important, lets ignore.

Oleg.

