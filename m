Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756964Ab3HAOpm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 10:45:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20469 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755293Ab3HAOpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 10:45:40 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=0VS4G58IZu0A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=laNjaRT52OkA:10 a=2SMtyIa_ma7wPbuik7AA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1375368339.1152.28.camel@gandalf.local.home>
Subject: Re: [RFC][PATCH 3/4] tracing/kprobes: Fail to unregister if probe
 event files are open
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 01 Aug 2013 10:45:39 -0400
In-Reply-To: <20130801143307.GA12031@redhat.com>
References: <20130704033347.807661713@goodmis.org>
	 <20130704034038.819592356@goodmis.org>
	 <1375300192.5418.17.camel@gandalf.local.home>
	 <20130731204003.GA30188@redhat.com>
	 <1375310548.5418.21.camel@gandalf.local.home>
	 <1375322866.5418.46.camel@gandalf.local.home>
	 <1375325414.5418.50.camel@gandalf.local.home>
	 <20130801133455.GB8703@redhat.com>
	 <1375366669.1152.23.camel@gandalf.local.home>
	 <20130801143307.GA12031@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-01 at 16:33 +0200, Oleg Nesterov wrote:
> On 08/01, Steven Rostedt wrote:
> >
> > On Thu, 2013-08-01 at 15:34 +0200, Oleg Nesterov wrote:
> > > >
> > > >   __unregister_trace_probe(tp);
> > > >   list_del(&tp->list)
> > > >   unregister_probe_event(tp) <-- fails!
> > > >   free_trace_probe(tp)
> > >
> > > Yes. But again, this doesn't explain why unregister_probe_event()->
> > > __trace_remove_event_call() can't simply proceed and
> > > do ftrace_event_enable_disable() + remove_event_from_tracers().
> >
> > The problem is with the soft disable.
> 
> Exactly! This is another (also unlikely) race we need to prevent.
> 

Is there a race even with these patches? I don't see one. To link a
function to an event (set the soft disable mode), the event_mutex is
taken. If the event is gone, it wont be able to link. If the soft
disable is attached (after found and set under event_mutex), the event
can't be deleted.

Or are you just saying that these patches fix that case too?

-- Steve


