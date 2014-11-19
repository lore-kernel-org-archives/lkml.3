Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750AbaKSOkQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 09:40:16 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57912 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754697AbaKSOkN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 09:40:13 -0500
Date: Wed, 19 Nov 2014 15:40:05 +0100
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 2/2] tracing: Use trace_seq_used() and seq_buf_used()
 instead of len
Message-ID: <20141119144004.GB2332@dhcp128.suse.cz>
References: <20141115045847.712848224@goodmis.org>
 <20141115050603.904875201@goodmis.org>
 <20141117123250.10f6f57c@gandalf.local.home>
 <20141117141215.2dbd5f12@gandalf.local.home>
 <20141118163354.GK23958@pathway.suse.cz>
 <20141118123732.462b1ad8@gandalf.local.home>
 <20141119114017.GA2332@dhcp128.suse.cz>
 <20141119084800.524beb62@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141119084800.524beb62@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2014-11-19 08:48:00, Steven Rostedt wrote:
> On Wed, 19 Nov 2014 12:40:17 +0100
> Petr Mladek <pmladek@suse.cz> wrote:
> 
> > > > 
> > > > There is one more dangerous usage in trace_printk_seq(). It is on
> > > > three lines there.
> > > 
> > > You totally confused me. What usage in trace_printk_seq(), and what
> > > three lines?
> > > 
> > The confusion is caused by the 'k' ("print" vs. "printk") in the
> > function name. I was talking about the following function from
> > kernel/trace/trace.c:
> 
> Silly 'k', Trix are for kids!

:-)
 
> > 
> > void
> > trace_printk_seq(struct trace_seq *s)
> > {
> > 	/* Probably should print a warning here. */
> > 	if (s->seq.len >= TRACE_MAX_PRINT)
> > 		s->seq.len = TRACE_MAX_PRINT;
> > 
> > 	/* should be zero ended, but we are paranoid. */
> > 	s->buffer[s->seq.len] = 0;
> > 
> > 	printk(KERN_TRACE "%s", s->buffer);
> > 
> > 	trace_seq_init(s);
> > }
> > 
> > I found it when checking the applied patches in origin/rfc/seq-buf
> > branch. I hope that it was the correct place.
> 
> Yes, that's the working branch for this code.
> 
> Anyway, I saw this and thought about using trace_seq_used(), but then I
> realized that this is trace_seq code which has a hard coded buffer
> length of PAGE_SIZE which on all archs is more than 1000
> (TRACE_MAX_PRINT).
> 
> Regardless of overflow or not (or even if trace_seq is full), that if
> statement will prevent this from doing any buffer overflows.
> 
> s->seq.len will never be more than s->seq.size after the test against
> TRACE_MAX_PRINT. So I see no harm here.

Ah, I see. Well, I would feel more comfortable if it uses
trace_seq_used() or if there is some explanation in a comment.
But you are right, it is safe as it is. Feel free to leave it.

Reviewed-by: Petr Mladek <pmladek@suse.cz>

Best Regards,
Petr
