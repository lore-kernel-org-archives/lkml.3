Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245Ab3INBF5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 21:05:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18816 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755827Ab3INBF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 21:05:56 -0400
X-Authority-Analysis: v=2.0 cv=R/aB6KtX c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=RZAKnY_hAFgA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=3NymGdysGKUA:10 a=QyXUC8HyAAAA:8 a=liYPCVhtAAAA:8 a=KDBg1F0KbQRzURRz1OwA:9 a=CjuIK1q_8ugA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Fri, 13 Sep 2013 21:05:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Tom Zanussi <tom.zanussi@linux.intel.com>
Cc: masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 04/10] tracing: Add 'snapshot' event trigger command
Message-ID: <20130913210553.543859df@gandalf.local.home>
In-Reply-To: <1379106619.1558.45.camel@empanada>
References: <cover.1378565610.git.tom.zanussi@linux.intel.com>
	<c1245b886d62b5154f20480c63d41a368af7cffa.1378565610.git.tom.zanussi@linux.intel.com>
	<20130913160100.30686d60@gandalf.local.home>
	<1379106619.1558.45.camel@empanada>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Sep 2013 16:10:19 -0500
Tom Zanussi <tom.zanussi@linux.intel.com> wrote:

> On Fri, 2013-09-13 at 16:01 -0400, Steven Rostedt wrote:
> > On Sat,  7 Sep 2013 10:29:00 -0500
> > Tom Zanussi <tom.zanussi@linux.intel.com> wrote:
> > 
> > 
> > > --- a/kernel/trace/trace_events_trigger.c
> > > +++ b/kernel/trace/trace_events_trigger.c
> > > @@ -696,6 +696,74 @@ static struct event_command trigger_traceoff_cmd = {
> > >  	.get_trigger_ops	= onoff_get_trigger_ops,
> > >  };
> > >  
> > > +static void
> > > +snapshot_trigger(struct event_trigger_data *data)
> > > +{
> > > +	tracing_snapshot();
> > > +}
> > 
> > If CONFIG_TRACER_SNAPSHOT is not defined, then we should not bother
> > implementing the snapshot trigger. This should be encapsulated around
> > ifdefs.
> 
> OK, I guess I was just trying to avoid the ifdef since
> tracing_snapshot() is already ifdef'ed out (but with a WARN_ONCE()) if
> CONFIG_TRACER_SNAPSHOT isn't defined.
> 
> I agree though, it would be better to just ignore all the snapshot
> trigger code if that's the case.  Same for the stacktrace trigger,
> though as much as I hate to put big ifdefs in the main code...
> 

#ifdef's are OK when they surround entire functions and structures. I
don't think ifdef'ing out these will cause #ifdef's within functions.
That's when things start to look ugly.

-- Steve

