Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947Ab3GKM0y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 08:26:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57217 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755418Ab3GKM0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 08:26:53 -0400
Date: Thu, 11 Jul 2013 14:26:26 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH 1/4] perf tools: Remove event types framework only user
Message-ID: <20130711122626.GB1056@krava.brq.redhat.com>
References: <1373388539-9347-1-git-send-email-jolsa@redhat.com>
 <1373388539-9347-2-git-send-email-jolsa@redhat.com>
 <87oba9y62a.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87oba9y62a.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 03:16:45PM +0900, Namhyung Kim wrote:
> Hi Jiri,
> 
> On Tue,  9 Jul 2013 18:48:56 +0200, Jiri Olsa wrote:
> > The only user of the event types data is 'perf timechart'
> > command and uses this info to identify proper tracepoints
> > based on its name.
> >
> > Switching this code to use traceevent library API to obtain
> > IDs for needed tracepoints. This should also make the samples
> > processing faster as we no longer compare strings but numbers.
> 
> A better way I think is using tracepoint handlers.  You don't need to
> compare anything this way since an evsel can know its handler.
> 
> Please see perf_session__set_tracepoints_handlers() and builtin-
> {kmem,lock,sched}.c.

nice, that will be better

> 
> 
> [SNIP]
> >  
> > -/*
> > - * trace_flag_type is an enumeration that holds different
> > - * states when a trace occurs. These are:
> > - *  IRQS_OFF            - interrupts were disabled
> > - *  IRQS_NOSUPPORT      - arch does not support irqs_disabled_flags
> > - *  NEED_RESCED         - reschedule is requested
> > - *  HARDIRQ             - inside an interrupt handler
> > - *  SOFTIRQ             - inside a softirq handler
> > - */
> > -enum trace_flag_type {
> > -	TRACE_FLAG_IRQS_OFF		= 0x01,
> > -	TRACE_FLAG_IRQS_NOSUPPORT	= 0x02,
> > -	TRACE_FLAG_NEED_RESCHED		= 0x04,
> > -	TRACE_FLAG_HARDIRQ		= 0x08,
> > -	TRACE_FLAG_SOFTIRQ		= 0x10,
> > -};
> 
> Why did you remove this part?  Isn't it used by elsewhere?  Anyway, it
> seems unrelated to this change.

it's now defined in <traceevent/event-parse.h>
leftover from some earlier change I guess

> 
> 
> [SNIP]
> > +static int get_id(const char *sys, const char *name, u32 *id)
> > +{
> > +	struct event_format *format;
> > +
> > +	format = event_format__new(sys, name);
> 
> No.  You need to access to tracepoints in the perf session data, not
> ones in the current system.  The perf_session__set_tracepoints_handlers()
> deals with it correctly.

right you are.. need to access data

thanks,
jirka
