Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676AbaKEUVe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 15:21:34 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:6404 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751122AbaKEUVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 15:21:33 -0500
Date: Wed, 5 Nov 2014 15:21:30 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr Mladek <pmladek@suse.cz>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 07/12 v3] tracing: Have seq_buf use full buffer
Message-ID: <20141105152130.09779ccf@gandalf.local.home>
In-Reply-To: <20141105163150.GI4570@pathway.suse.cz>
References: <20141104155237.228431433@goodmis.org>
	<20141104160222.502133196@goodmis.org>
	<20141105163150.GI4570@pathway.suse.cz>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Nov 2014 17:31:50 +0100
Petr Mladek <pmladek@suse.cz> wrote:


> >  /**
> >   * seq_buf_print_seq - move the contents of seq_buf into a seq_file
> > @@ -55,7 +55,7 @@ int seq_buf_vprintf(struct seq_buf *s, const char *fmt, va_list args)
> >  
> >  	if (s->len < s->size) {
> >  		len = vsnprintf(s->buffer + s->len, s->size - s->len, fmt, args);
> > -		if (s->len + len < s->size) {
> > +		if (s->len + len <= s->size) {
> 
> This is always true because we limit vsnprintf() to write (s->size -
> s->len) bytes. Similar problem is also in the other parts of this
> patch.

No, len is the length of bytes that should have been written, not the
amount that has been written.

> 
> I wonder if we want this change at all. It means that we are not able to
> detect overflow in some functions. It is pity because the users
> might want to increase the buffer size and try again if the print
> was incomplete.

What do you mean we can't detect overflow? That's what
seq_buf_has_overflowed() does.

> 
> I think that we need to leave the one byte for the overflow detection
> if we want to detect it properly.

I don't.

-- Steve
