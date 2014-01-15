Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968AbaAOC5A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 21:57:00 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:37915 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750918AbaAOC46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 21:56:58 -0500
Date: Tue, 14 Jan 2014 21:56:55 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 01/17] tools lib traceevent: Add state member to struct
 trace_seq
Message-ID: <20140114215655.666d7480@gandalf.local.home>
In-Reply-To: <87k3e29cxz.fsf@sejong.aot.lge.com>
References: <1389750340-15965-1-git-send-email-namhyung@kernel.org>
	<1389750340-15965-2-git-send-email-namhyung@kernel.org>
	<20140114210058.6b75c47a@gandalf.local.home>
	<87k3e29cxz.fsf@sejong.aot.lge.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jan 2014 11:49:28 +0900
Namhyung Kim <namhyung@kernel.org> wrote:

> Hi Steve,
> 
> On Tue, 14 Jan 2014 21:00:58 -0500, Steven Rostedt wrote:
> > On Wed, 15 Jan 2014 10:45:24 +0900
> > Namhyung Kim <namhyung@kernel.org> wrote:
> >
> >>  
> >> @@ -32,8 +33,9 @@
> >>  #define TRACE_SEQ_POISON	((void *)0xdeadbeef)
> >>  #define TRACE_SEQ_CHECK(s)						\
> >>  do {									\
> >> -	if ((s)->buffer == TRACE_SEQ_POISON)			\
> >> -		die("Usage of trace_seq after it was destroyed");	\
> >> +	if (WARN_ONCE((s)->buffer == TRACE_SEQ_POISON,			\
> >> +		      "Usage of trace_seq after it was destroyed"))	\
> >> +		(s)->state = TRACE_SEQ__BUFFER_POISONED;		\
> >>  } while (0)
> >>  
> >> @@ -189,9 +205,15 @@ int trace_seq_putc(struct trace_seq *s, unsigned char c)
> >>  {
> >>  	TRACE_SEQ_CHECK(s);
> >>  
> >> +	if (s->state != TRACE_SEQ__GOOD)
> >> +		return 0;
> >> +
> >
> > Instead of adding all of these, we can extend the macro
> > TRACE_SEQ_CHECK() which does a
> > 	if (s->state != TRACE_SEQ__GOOD)
> > 		return;
> >
> > and a TRACE_SEQ_CHECK_RET() that does a return 0;
> 
> Oh, it looks better.  But I'd like to TRACE_SEQ_CHECK() as is for some
> cases.  How about this?
> 
> 

Looks good to me.

Acked-by: Steven Rostedt <rostedt@goodmis.org>

I'll try to look at the rest of the patches tomorrow.

-- Steve


