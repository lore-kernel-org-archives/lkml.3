Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760068Ab3ICNW3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 09:22:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10308 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759923Ab3ICNW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 09:22:27 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=zPOsvTia2KMA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=WTZMFJfwhtIA:10 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8 a=-qwggQqQbrKdNP6x2tEA:9 a=CjuIK1q_8ugA:10 a=jeBq3FmKZ4MA:10 a=jEp0ucaQiEUA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Tue, 3 Sep 2013 09:22:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC][PATCH 03/18 v2] ftrace: Set ftrace internal function
 tracing RCU safe
Message-ID: <20130903092224.2ca84f5f@gandalf.local.home>
In-Reply-To: <20130831194431.GK3871@linux.vnet.ibm.com>
References: <20130831051117.884125230@goodmis.org>
	<20130831051700.928372852@goodmis.org>
	<20130831194431.GK3871@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Aug 2013 12:44:31 -0700
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> On Sat, Aug 31, 2013 at 01:11:20AM -0400, Steven Rostedt wrote:
> > From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> > 
> > Since none of the internal ftrace function tracing uses RCU in
> > their callbacks, it is OK to set the global_ops (the one that
> > they all use) to RCU safe.
> > 
> > Cc: Jiri Olsa <jolsa@redhat.com>
> > Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

You must have liked this patch so much... that you acked it twice ;-)

-- Steve

> 
> > ---
> >  kernel/trace/ftrace.c |    4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> > index d61f431..a45deaa 100644
> > --- a/kernel/trace/ftrace.c
> > +++ b/kernel/trace/ftrace.c
> > @@ -1146,7 +1146,9 @@ static struct ftrace_ops global_ops = {
> >  	.func			= ftrace_stub,
> >  	.notrace_hash		= EMPTY_HASH,
> >  	.filter_hash		= EMPTY_HASH,
> > -	.flags			= FTRACE_OPS_FL_RECURSION_SAFE | FTRACE_OPS_FL_INITIALIZED,
> > +	.flags			= FTRACE_OPS_FL_RECURSION_SAFE |
> > +				  FTRACE_OPS_FL_INITIALIZED |
> > +				  FTRACE_OPS_FL_RCU_SAFE,
> >  	INIT_REGEX_LOCK(global_ops)
> >  };
> > 
> > -- 
> > 1.7.10.4
> > 
> > 

