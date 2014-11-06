Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751269AbaKFAiU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 19:38:20 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:18610 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750860AbaKFAiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 19:38:19 -0500
Date: Wed, 5 Nov 2014 19:38:17 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Joe Perches <joe@perches.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Julia Lawall <Julia.Lawall@lip6.fr>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] trace: Replace seq_printf by simpler equivalents
Message-ID: <20141105193817.0d2cfaf3@gandalf.local.home>
In-Reply-To: <1415227908.6634.30.camel@perches.com>
References: <1410513954-28909-1-git-send-email-linux@rasmusvillemoes.dk>
	<1410513954-28909-5-git-send-email-linux@rasmusvillemoes.dk>
	<20141105173454.7aa47289@gandalf.local.home>
	<1415227908.6634.30.camel@perches.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Nov 2014 14:51:48 -0800
Joe Perches <joe@perches.com> wrote:

> On Wed, 2014-11-05 at 17:34 -0500, Steven Rostedt wrote:
> > On Fri, 12 Sep 2014 11:25:52 +0200 Rasmus Villemoes <linux@rasmusvillemoes.dk> wrote:
> > > Using seq_printf to print a simple string or a single character is a
> > > lot more expensive than it needs to be, since seq_puts and seq_putc
> > > exist.
> []
> > > diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> []
> > @@ -556,13 +556,13 @@ static int function_stat_cmp(void *p1, void *p2)
> > >  static int function_stat_headers(struct seq_file *m)
> > >  {
> > >  #ifdef CONFIG_FUNCTION_GRAPH_TRACER
> > > -	seq_printf(m, "  Function                               "
> > > -		   "Hit    Time            Avg             s^2\n"
> > > -		      "  --------                               "
> > > -		   "---    ----            ---             ---\n");
> > > +	seq_puts(m,
> > > +		 "  Function                               " "Hit    Time            Avg             s^2\n"
> > > +		 "  --------                               " "---    ----            ---             ---\n");
> > 
> > Please keep the original format. I know that it's considered bad form
> > to split strings like this, but I consider this one of the exceptions
> > to the rule.
> 
> Why is that?
> 
> btw: when the strings fragments are put on the same line,
> it's nicer to take out the intermediate joining " " bits too.
> 
> I'd've probably used 2 seq_puts calls like:
> 
> 	seq_puts(m, "  Function                               Hit    Time            Avg             s^2\n");
> 	seq_puts(m, "  --------                               ---    ----            ---             ---\n");
> 

In this case it's just that I hate that big white space followed by
content.

Maybe I'll change my mind in the future, but for now, I'd rather just
leave it as is.

-- Steve


