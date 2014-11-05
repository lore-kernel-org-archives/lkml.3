Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317AbaKEUO5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 15:14:57 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:21365 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752284AbaKEUO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 15:14:56 -0500
Date: Wed, 5 Nov 2014 15:14:46 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr Mladek <pmladek@suse.cz>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 05/12 v3] tracing: Convert seq_buf fields to be
 like seq_file fields
Message-ID: <20141105151446.5c4adb7f@gandalf.local.home>
In-Reply-To: <20141105155710.GG4570@pathway.suse.cz>
References: <20141104155237.228431433@goodmis.org>
	<20141104160222.195301024@goodmis.org>
	<20141105155710.GG4570@pathway.suse.cz>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Nov 2014 16:57:11 +0100
Petr Mladek <pmladek@suse.cz> wrote:

> On Tue 2014-11-04 10:52:42, Steven Rostedt wrote:
> > From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> > 
> > In facilitating the conversion of seq_file to use seq_buf,
> > have the seq_buf fields match the types used by seq_file.
> > 
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > ---
> >  include/linux/seq_buf.h | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/include/linux/seq_buf.h b/include/linux/seq_buf.h
> > index 6d1c57d6073f..a4d114e6f740 100644
> > --- a/include/linux/seq_buf.h
> > +++ b/include/linux/seq_buf.h
> > @@ -19,10 +19,10 @@
> >   * @overflow:	Set if more bytes should have been written to buffer
> >   */
> >  struct seq_buf {
> > -	unsigned char		*buffer;
> > -	unsigned int		size;
> > -	unsigned int		len;
> > -	unsigned int		readpos;
> > +	char			*buffer;
> 
> It would make sense to use "char" from the beginning. In fact, it is
> already used on many locations in seq_buf.c. Or we might want to get
> rid of "unsigned char" in seq_buf.c here as well.

I could, but I'm being lazy ;-) No reason to change the patch series for
something as small as this. It doesn't break bisect.

> 
> > +	size_t			size;
> > +	size_t			len;
> > +	loff_t			readpos;
> 
> I have just noticed that the variable is called "read_pos" in
> seq_file. Are you going to sync the name later?

Yeah, I purposely kept them different to find the two when needed.

> 
> Also I am a bit curious that "readpos" use another type than "len"
> and "size". Well, this is not in the scope of this patchset. I am fine
> with keeping "loff_t" at this point.

Again, seq_file has been around for a long time with these types. But
as you said, it's out of scope for this patch series. I'm just trying
to keep with what's been the norm here.

-- Steve
