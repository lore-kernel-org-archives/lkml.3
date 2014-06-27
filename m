Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbaF0O40 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 10:56:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60536 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753842AbaF0O4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 10:56:25 -0400
Date: Fri, 27 Jun 2014 16:56:22 +0200
From: Petr =?iso-8859-1?Q?Ml=E1dek?= <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Michal Hocko <mhocko@suse.cz>,
        Jan Kara <jack@suse.cz>, Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Anderson <anderson@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: [RFC][PATCH 2/5 v2] tracing: Create seq_buf layer in trace_seq
Message-ID: <20140627145622.GH23205@pathway.suse.cz>
References: <20140626214901.596791200@goodmis.org>
 <20140626220129.620409461@goodmis.org>
 <20140627134538.GB23205@pathway.suse.cz>
 <20140627102134.5d2cae41@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140627102134.5d2cae41@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-06-27 10:21:34, Steven Rostedt wrote:
> On Fri, 27 Jun 2014 15:45:38 +0200
> Petr Mládek <pmladek@suse.cz> wrote:
> 
> > ad 4th:
> > 
> >    Both "full" and "overflow" flags seems to have the same meaning.
> >    For example, trace_seq_printf() sets "full" on failure even
> >    when s->seq.len != s->size.
> > 
> > 
> > Best Regards,
> > Petr
> > 
> > [...]
> 
> 
> BTW, you shouldn't sign off if you have more comments, I usually stop
> reading when I see someone's signature. Or at the very least, state
> that you have more comments below.

Shame on me. I was about to send the mail but then I decided to add
more comments into the code. :-)
 
> > 
> > > +#define MAX_MEMHEX_BYTES	8U
> > > +#define HEX_CHARS		(MAX_MEMHEX_BYTES*2 + 1)
> > > +
> > > +/**
> > > + * seq_buf_putmem_hex - write raw memory into the buffer in ASCII hex
> > > + * @s: seq_buf descriptor
> > > + * @mem: The raw memory to write its hex ASCII representation of
> > > + * @len: The length of the raw memory to copy (in bytes)
> > > + *
> > > + * This is similar to seq_buf_putmem() except instead of just copying the
> > > + * raw memory into the buffer it writes its ASCII representation of it
> > > + * in hex characters.
> > > + *
> > > + * Returns how much it wrote to the buffer.
> > > + */
> > > +int seq_buf_putmem_hex(struct seq_buf *s, const void *mem,
> > > +		       unsigned int len)
> > > +{
> > > +	unsigned char hex[HEX_CHARS];
> > > +	const unsigned char *data = mem;
> > > +	unsigned int start_len;
> > > +	int i, j;
> > > +	int cnt = 0;
> > > +
> > > +	while (len) {
> > > +		start_len = min(len, HEX_CHARS - 1);
> > 
> > I would do s/start_len/end_len/
> > 
> > I know that it depends on the point of view. But iteration between "0"
> > and "end" is better understandable for me :-)
> 
> Yeah, I didn't like the name of that variable. I guess end_len is
> better, but still not exactly what I want to call it. Unfortunately, I
> don't know what exactly I want to call it ;-)

Yup, the code is tricky :-) The names like break_len, wrap_len,
split_len, block_len come to my mind.

I would prefer wrap_len after all. But the choice it yours.

Best Regards,
Petr
