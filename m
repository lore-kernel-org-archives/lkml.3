Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935128AbaFTRMr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 13:12:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59692 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934676AbaFTRMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 13:12:46 -0400
Date: Fri, 20 Jun 2014 10:12:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        Michal Hocko <mhocko@suse.cz>, Jan Kara <jack@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Anderson <anderson@redhat.com>, Petr Mladek <pmladek@suse.cz>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC][PATCH 1/3] trace_seq: Move the trace_seq code to lib/
Message-Id: <20140620101244.a1f4534e.akpm@linux-foundation.org>
In-Reply-To: <20140620125823.5acb12dd@gandalf.local.home>
References: <20140619213329.478113470@goodmis.org>
	<20140619213952.058255809@goodmis.org>
	<20140619220607.c6da2540.akpm@linux-foundation.org>
	<20140620125823.5acb12dd@gandalf.local.home>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jun 2014 12:58:23 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:

>
> ...
>
> > 
> > > + * Writes a ASCII representation of a bitmask string into @s.
> > > + */
> > > +int
> > > +trace_seq_bitmask(struct trace_seq *s, const unsigned long *maskp,
> > > +		  int nmaskbits)
> > > +{
> > > +	int len = (PAGE_SIZE - 1) - s->len;
> > > +	int ret;
> > > +
> > > +	if (s->full || !len)
> > > +		return 0;
> > > +
> > > +	ret = bitmap_scnprintf(s->buffer, len, maskp, nmaskbits);
> > > +	s->len += ret;
> > > +
> > > +	return 1;
> > > +}
> > > +EXPORT_SYMBOL_GPL(trace_seq_bitmask);
> > 
> > More dittos.
> 
> Confused. What dittos is this dittoing?

Unneeded newline, poorly considered choice of types.

>
> ...
>
> > > + * buffer (@s). Then the output may be either used by
> > > + * the sequencer or pulled into another buffer.
> > > + */
> > > +int
> > > +trace_seq_vprintf(struct trace_seq *s, const char *fmt, va_list args)
> > > +{
> > > +	int len = (PAGE_SIZE - 1) - s->len;
> > > +	int ret;
> > > +
> > > +	if (s->full || !len)
> > > +		return 0;
> > > +
> > > +	ret = vsnprintf(s->buffer + s->len, len, fmt, args);
> > > +
> > > +	/* If we can't write it all, don't bother writing anything */
> > > +	if (ret >= len) {
> > > +		s->full = 1;
> > > +		return 0;
> > > +	}
> > > +
> > > +	s->len += ret;
> > > +
> > > +	return len;
> > > +}
> > > +EXPORT_SYMBOL_GPL(trace_seq_vprintf);
> > 
> > Several dittos.
> 
> Oh, just on the function. You're not dittoing a comment about the
> EXPORT_SYMBOL_GPL() that you forgot to add, are you?

yup.  Unneded newline, types, EXPORT_ confusion.

>
> ...
>
> > 
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

There's always that.  There's also googling for the original list
dicsussion.  But it's a bit user-unfriendly, particularly when then
code has aged was subsequently altered many times.

>
> ...
>
> 
> Hey! Thanks for the review. Much appreciated. And maybe you should read
> those messages in your /dev/null folder that I cc you with. :-)

I sometimes do.
