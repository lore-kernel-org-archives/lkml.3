Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751267AbaFVHiO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 03:38:14 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:41612 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027AbaFVHiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 03:38:13 -0400
Message-ID: <1403422685.4418.4.camel@jlt4.sipsolutions.net>
Subject: Re: [RFC][PATCH 1/3] trace_seq: Move the trace_seq code to lib/
From: Johannes Berg <johannes@sipsolutions.net>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        Michal Hocko <mhocko@suse.cz>, Jan Kara <jack@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Anderson <anderson@redhat.com>, Petr Mladek <pmladek@suse.cz>
Date: Sun, 22 Jun 2014 09:38:05 +0200
In-Reply-To: <20140620125823.5acb12dd@gandalf.local.home>
References: <20140619213329.478113470@goodmis.org>
	 <20140619213952.058255809@goodmis.org>
	 <20140619220607.c6da2540.akpm@linux-foundation.org>
	 <20140620125823.5acb12dd@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-06-20 at 12:58 -0400, Steven Rostedt wrote:

> > > +#define HEX_CHARS		(MAX_MEMHEX_BYTES*2 + 1)
> > > +
> > > +int trace_seq_putmem_hex(struct trace_seq *s, const void *mem, size_t len)
> > > +{
> > > +	unsigned char hex[HEX_CHARS];
> > > +	const unsigned char *data = mem;
> > > +	int i, j;
> > > +
> > > +	if (s->full)
> > > +		return 0;
> > 
> > What's this ->full thing all about anyway?  Some central comment which
> > explains the design is needed.
> 
> Comment? What? Git blame isn't good enough for ya? ;-)
> 
> > 
> > Is this test really needed?  trace_seq_putmem() will handle this.
> 
> It was added as an optimization, because once it filled up, you could
> still have multiple calls to the trace_seq() functions that would waste
> time trying to write the buffer.
> 
> It seemed like a good idea at the time. I Cc'd Johannes Berg as he's
> the one that implemented.
> 
> Johannes, is this really needed, should we bother keeping it?

Honestly, I don't remember, sorry.

Looking at the code though, I'm not sure it's a pure optimisation - if
you do say putc() after a failed puts(), without this code the putc()
would succeed? I can't tell right now if that's really a problem, but it
seems you could get some odd behaviour out of it.

johannes

