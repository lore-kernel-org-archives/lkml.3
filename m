Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756Ab3DMJiA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 05:38:00 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:60831 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283Ab3DMJh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 05:37:59 -0400
Date: Sat, 13 Apr 2013 15:01:44 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Anton Arapov <anton@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] uprobes/tracing: Make uprobe_{trace,perf}_print()
 uretprobe-friendly
Message-ID: <20130413093144.GA11721@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20130401160827.GA19206@redhat.com>
 <20130401160851.GA19576@redhat.com>
 <20130407103159.GA6810@linux.vnet.ibm.com>
 <20130409133333.GA19185@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20130409133333.GA19185@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041309-7408-0000-0000-00000EDFF882
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2013-04-09 15:33:33]:

> On 04/07, Srikar Dronamraju wrote:
> >
> > * Oleg Nesterov <oleg@redhat.com> [2013-04-01 18:08:51]:
> >
> > > diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
> > > index e91a354..db2718a 100644
> > > --- a/kernel/trace/trace_uprobe.c
> > > +++ b/kernel/trace/trace_uprobe.c
> > > @@ -515,15 +515,26 @@ static void uprobe_trace_print(struct trace_uprobe *tu,
> > >  	int size, i;
> > >  	struct ftrace_event_call *call = &tu->call;
> > >
> > > -	size = SIZEOF_TRACE_ENTRY(1) + tu->size;
> > > +	if (is_ret_probe(tu))
> >
> > One nit:
> > Here and couple of places below .. we could check for func instead of
> > is_ret_probe() right?
> 
> Yes we could. And note that we do not really need both uprobe_trace_func()
> and uretprobe_perf_func(), we could use a single function and check "func".
> 
> But:
> 
> > Or is there an advantage of checking is_ret_probe() over func?
> 
> I believe yes. Firstly, we can't use 0ul as "invalid func address" to detect
> the !is_ret_probe() case, we need, say, -1ul which probably needs a symbolic
> name. In fact, I'd prefer to add another "is_return" argument if we want to
> avoid is_ret_probe() and unify 2 functions.
> 
> But more importantly, I think that is_ret_probe() is much more grep-friendly
> and thus more understandable and consistent with other checks which can not
> rely on "func".

Okay, Agree. 


