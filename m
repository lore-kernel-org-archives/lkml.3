Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751184AbaKFAej (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 19:34:39 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:6063 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750970AbaKFAei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 19:34:38 -0500
Date: Wed, 5 Nov 2014 19:34:35 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] trace: Replace seq_printf by simpler equivalents
Message-ID: <20141105193435.4f620acb@gandalf.local.home>
In-Reply-To: <87tx2de08u.fsf@rasmusvillemoes.dk>
References: <1410513954-28909-1-git-send-email-linux@rasmusvillemoes.dk>
	<1410513954-28909-5-git-send-email-linux@rasmusvillemoes.dk>
	<20141105173454.7aa47289@gandalf.local.home>
	<87tx2de08u.fsf@rasmusvillemoes.dk>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Nov 2014 23:44:17 +0100
Rasmus Villemoes <linux@rasmusvillemoes.dk> wrote:

> On Wed, Nov 05 2014, Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > On Fri, 12 Sep 2014 11:25:52 +0200
> > Rasmus Villemoes <linux@rasmusvillemoes.dk> wrote:
> >
> >> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> >> index 5916a8e..7b9ce28 100644
> >> --- a/kernel/trace/ftrace.c
> >> +++ b/kernel/trace/ftrace.c
> >> @@ -556,13 +556,13 @@ static int function_stat_cmp(void *p1, void *p2)
> >>  static int function_stat_headers(struct seq_file *m)
> >>  {
> >>  #ifdef CONFIG_FUNCTION_GRAPH_TRACER
> >> -	seq_printf(m, "  Function                               "
> >> -		   "Hit    Time            Avg             s^2\n"
> >> -		      "  --------                               "
> >> -		   "---    ----            ---             ---\n");
> >> +	seq_puts(m,
> >> +		 "  Function                               " "Hit    Time            Avg             s^2\n"
> >> +		 "  --------                               " "---    ----            ---             ---\n");
> >
> > Please keep the original format. I know that it's considered bad form
> > to split strings like this, but I consider this one of the exceptions
> > to the rule.
> 
> OK. Want me to resend?

Yeah, can you.


> 
> >> @@ -3250,7 +3250,7 @@ static int t_show(struct seq_file *m, void *v)
> >>  	if (!t)
> >>  		return 0;
> >>  
> >> -	seq_printf(m, "%s", t->name);
> >> +	seq_puts(m, t->name);
> >
> > This is wrong and dangerous.
> >
> > What happens if "t->name" contains "%d" or "%s"?
> 
> Then those characters will be printed to the seq_file, just as they
> would previously? puts doesn't interpret its string argument in any
> way...
> 
> >> --- a/kernel/trace/trace_events_trigger.c
> >> +++ b/kernel/trace/trace_events_trigger.c
> >> @@ -373,7 +373,7 @@ event_trigger_print(const char *name, struct seq_file *m,
> >>  {
> >>  	long count = (long)data;
> >>  
> >> -	seq_printf(m, "%s", name);
> >> +	seq_puts(m, name);
> >
> > Again, this is wrong and dangerous.
> 
> I'm pretty sure it's neither :-)

Ah you're correct. I was thinking of it as a printf and not a puts.

Never mind ;-) /me needs to work on only 3 different projects at once,
not 4. :-p

-- Steve

