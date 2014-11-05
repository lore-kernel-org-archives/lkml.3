Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930AbaKEU0U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 15:26:20 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:5225 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751339AbaKEU0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 15:26:18 -0500
Date: Wed, 5 Nov 2014 15:26:07 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr Mladek <pmladek@suse.cz>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 08/12 v3] tracing: Add seq_buf_get_buf() and
 seq_buf_commit() helper functions
Message-ID: <20141105152607.6fcf7be5@gandalf.local.home>
In-Reply-To: <20141105165125.GJ4570@pathway.suse.cz>
References: <20141104155237.228431433@goodmis.org>
	<20141104160222.644881406@goodmis.org>
	<20141105165125.GJ4570@pathway.suse.cz>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Nov 2014 17:51:25 +0100
Petr Mladek <pmladek@suse.cz> wrote:


> > +
> > +/**
> > + * seq_buf_commit - commit data to the buffer
> > + * @s: the seq_buf handle
> > + * @num: the number of bytes to commit
> > + *
> > + * Commit @num bytes of data written to a buffer previously acquired
> > + * by seq_buf_get.  To signal an error condition, or that the data
> > + * didn't fit in the available space, pass a negative @num value.
> > + */
> > +static inline void seq_buf_commit(struct seq_buf *s, int num)
> > +{
> > +	if (num < 0) {
> > +		s->len = s->size;
> 
> I guess that you want to get the buffer into an overflow state. If
> yes, it should be:
> 
> 		s->len = s->size + 1;
> 
> or even better
> 
> 		seq_buf_set_overflow(s);

Yeah, I agree with using the seq_buf_set_overflow().

> 
> 
> Note that this whole patch depends on the decision about the 7th patch
> ("tracing: Have seq_buf use full buffer").

Which I have decided to do.

> 
> It might make sense to move the SEQ_BUF_LEFT, SEQ_BUF_USED macros to
> this header and use them in these two function. Or move the functions
> to seq_file.c.
> 

I moved SEQ_BUF_LEFT as a static inline seq_buf_buffer_left() and have
used it in trace_seq.c in the TRACE_SEQ_BUF_LEFT macro.

-- Steve
