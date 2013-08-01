Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290Ab3HAOwB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 10:52:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48570 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754889Ab3HAOwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 10:52:00 -0400
Date: Thu, 1 Aug 2013 16:46:22 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 3/4] tracing/kprobes: Fail to unregister if probe
	event files are open
Message-ID: <20130801144622.GA15180@redhat.com>
References: <20130704034038.819592356@goodmis.org> <1375300192.5418.17.camel@gandalf.local.home> <20130731204003.GA30188@redhat.com> <1375310548.5418.21.camel@gandalf.local.home> <1375322866.5418.46.camel@gandalf.local.home> <1375325414.5418.50.camel@gandalf.local.home> <20130801133455.GB8703@redhat.com> <1375366669.1152.23.camel@gandalf.local.home> <20130801143307.GA12031@redhat.com> <1375368339.1152.28.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375368339.1152.28.camel@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01, Steven Rostedt wrote:
>
> On Thu, 2013-08-01 at 16:33 +0200, Oleg Nesterov wrote:
> > On 08/01, Steven Rostedt wrote:
> > >
> > > On Thu, 2013-08-01 at 15:34 +0200, Oleg Nesterov wrote:
> > > > >
> > > > >   __unregister_trace_probe(tp);
> > > > >   list_del(&tp->list)
> > > > >   unregister_probe_event(tp) <-- fails!
> > > > >   free_trace_probe(tp)
> > > >
> > > > Yes. But again, this doesn't explain why unregister_probe_event()->
> > > > __trace_remove_event_call() can't simply proceed and
> > > > do ftrace_event_enable_disable() + remove_event_from_tracers().
> > >
> > > The problem is with the soft disable.
> >
> > Exactly! This is another (also unlikely) race we need to prevent.
> >
>
> Is there a race even with these patches?

Sorry for confusion,

> I don't see one.

Neither me, but only with these changes.

I meant that this is another reason why trace_remove_event_call() should
fail and the caller should obviously abort in this case.

> Or are you just saying that these patches fix that case too?

Yes, sorry.

Oleg.

