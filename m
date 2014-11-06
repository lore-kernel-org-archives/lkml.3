Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075AbaKFPNY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 10:13:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54193 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046AbaKFPNS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 10:13:18 -0500
Date: Thu, 6 Nov 2014 16:13:14 +0100
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 07/12 v3] tracing: Have seq_buf use full buffer
Message-ID: <20141106151314.GG2001@dhcp128.suse.cz>
References: <20141104155237.228431433@goodmis.org>
 <20141104160222.502133196@goodmis.org>
 <20141105163150.GI4570@pathway.suse.cz>
 <20141105152130.09779ccf@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141105152130.09779ccf@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2014-11-05 15:21:30, Steven Rostedt wrote:
> On Wed, 5 Nov 2014 17:31:50 +0100
> Petr Mladek <pmladek@suse.cz> wrote:
> 
> 
> > >  /**
> > >   * seq_buf_print_seq - move the contents of seq_buf into a seq_file
> > > @@ -55,7 +55,7 @@ int seq_buf_vprintf(struct seq_buf *s, const char *fmt, va_list args)
> > >  
> > >  	if (s->len < s->size) {
> > >  		len = vsnprintf(s->buffer + s->len, s->size - s->len, fmt, args);
> > > -		if (s->len + len < s->size) {
> > > +		if (s->len + len <= s->size) {
> > 
> > This is always true because we limit vsnprintf() to write (s->size -
> > s->len) bytes. Similar problem is also in the other parts of this
> > patch.
> 
> No, len is the length of bytes that should have been written, not the
> amount that has been written.

That is cool! I did not know that there was also this variant of the
printf() functions. I am still learning.

Best Regards,
Petr
