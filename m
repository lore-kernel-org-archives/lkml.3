Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081AbaKJRjQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 12:39:16 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:47086 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753629AbaKJRi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 12:38:59 -0500
Date: Mon, 10 Nov 2014 12:38:57 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr Mladek <pmladek@suse.cz>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 04/12 v3] tracing: Convert seq_buf_path() to be
 like seq_path()
Message-ID: <20141110123857.733b6d7f@gandalf.local.home>
In-Reply-To: <20141110140324.GD2160@pathway.suse.cz>
References: <20141104155237.228431433@goodmis.org>
	<20141104160222.048795666@goodmis.org>
	<20141106150143.GF2001@dhcp128.suse.cz>
	<20141107133413.6e37755e@gandalf.local.home>
	<20141110140324.GD2160@pathway.suse.cz>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Nov 2014 15:03:25 +0100
Petr Mladek <pmladek@suse.cz> wrote:

> On Fri 2014-11-07 13:34:13, Steven Rostedt wrote:
> > 
> > I made a few touch ups on this patch.
> > 
> > -- Steve
> > 
> > From 309e8ce4cc1605d3038b16b8e43219a2867f47b1 Mon Sep 17 00:00:00 2001
> > From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> > Date: Wed, 29 Oct 2014 13:48:37 -0400
> > Subject: [PATCH] tracing: Convert seq_buf_path() to be like seq_path()
> > 
> > Rewrite seq_buf_path() like it is done in seq_path() and allow
> > it to accept any escape character instead of just "\n".
> > 
> > Making seq_buf_path() like seq_path() will help prevent problems
> > when converting seq_file to use the seq_buf logic.
> > 
> > Link: http://lkml.kernel.org/r/20141104160222.048795666@goodmis.org
> > 
> > Tested-by: Jiri Kosina <jkosina@suse.cz>
> > Acked-by: Jiri Kosina <jkosina@suse.cz>
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > ---
> >  include/linux/seq_buf.h  |  2 +-
> >  kernel/trace/seq_buf.c   | 26 +++++++++++++++-----------
> >  kernel/trace/trace_seq.c |  4 ++--
> >  3 files changed, 18 insertions(+), 14 deletions(-)
> > 
> > diff --git a/include/linux/seq_buf.h b/include/linux/seq_buf.h
> > index 64bf5a43411e..aec09b126082 100644
> > --- a/include/linux/seq_buf.h
> > +++ b/include/linux/seq_buf.h
> > @@ -70,7 +70,7 @@ extern int seq_buf_putc(struct seq_buf *s, unsigned char c);
> >  extern int seq_buf_putmem(struct seq_buf *s, const void *mem, unsigned int len);
> >  extern int seq_buf_putmem_hex(struct seq_buf *s, const void *mem,
> >  			      unsigned int len);
> > -extern int seq_buf_path(struct seq_buf *s, const struct path *path);
> > +extern int seq_buf_path(struct seq_buf *s, const struct path *path, const char *esc);
> >  
> >  extern int seq_buf_bitmask(struct seq_buf *s, const unsigned long *maskp,
> >  			   int nmaskbits);
> > diff --git a/kernel/trace/seq_buf.c b/kernel/trace/seq_buf.c
> > index 88738b200bf3..ac6eb864c946 100644
> > --- a/kernel/trace/seq_buf.c
> > +++ b/kernel/trace/seq_buf.c
> > @@ -272,28 +272,32 @@ int seq_buf_putmem_hex(struct seq_buf *s, const void *mem,
> >   * seq_buf_path - copy a path into the sequence buffer
> >   * @s: seq_buf descriptor
> >   * @path: path to write into the sequence buffer.
> > + * @esc: set of characters to escape in the output
> >   *
> >   * Write a path name into the sequence buffer.
> >   *
> >   * Returns zero on success, -1 on overflow
> 
> This should be
> 
>    * Returns the number of written bytes on success, -1 on overflow

Yep.

> 
> 
> This is just a minor issue. I believe the you would fix it. Feel free to add:
> 
> Reviewed-by: Petr Mladek <pmladek@suse.cz>

Thanks,

-- Steve

