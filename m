Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760618Ab3GaRQQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 13:16:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17164 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757094Ab3GaRQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 13:16:14 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=M7EnmfK3RHIA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=6No3EKuEBNEA:10 a=Ijko4D0qC2GbBfvVtnsA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1375290972.5418.7.camel@gandalf.local.home>
Subject: Re: [PATCH v2 1/1] tracing: trace_remove_event_call() should fail
 if call/file is in use
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Alexander Z Lam <azl@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Sharp <dhsharp@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 31 Jul 2013 13:16:12 -0400
In-Reply-To: <1375289415.5418.4.camel@gandalf.local.home>
References: <20130729175008.GA26284@redhat.com>
	 <20130729175033.GB26284@redhat.com>
	 <1375289415.5418.4.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-31 at 12:50 -0400, Steven Rostedt wrote:
> On Mon, 2013-07-29 at 19:50 +0200, Oleg Nesterov wrote:
> >  
> > +static int probe_remove_event_call(struct ftrace_event_call *call)
> > +{
> > +	struct trace_array *tr;
> > +	struct ftrace_event_file *file;
> > +
> > +#ifdef CONFIG_PERF_EVENTS
> > +	if (call->perf_refcount)
> > +		return -EBUSY;
> > +#endif
> > +	do_for_each_event_file(tr, file) {
> > +		if (file->event_call != call)
> > +			continue;
> > +		/*
> > +		 * We can't rely on ftrace_event_enable_disable(enable => 0)
> > +		 * we are going to do, FTRACE_EVENT_FL_SOFT_MODE can suppress
> > +		 * TRACE_REG_UNREGISTER.
> > +		 */
> > +		if (file->flags & FTRACE_EVENT_FL_ENABLED)
> > +			return -EBUSY;
> > +		break;
> 
> I'm going to modify the patch to include a comment here about the break
> being used to go to the next trace_array and not leaving the loop.
> 

Screw it, I'm going to just add a separate patch to include it.

-- Steve



