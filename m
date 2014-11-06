Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358AbaKFOYP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 09:24:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52390 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712AbaKFOYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 09:24:11 -0500
Date: Thu, 6 Nov 2014 15:24:09 +0100
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 05/12 v3] tracing: Convert seq_buf fields to be like
 seq_file fields
Message-ID: <20141106142409.GD2001@dhcp128.suse.cz>
References: <20141104155237.228431433@goodmis.org>
 <20141104160222.195301024@goodmis.org>
 <20141105155710.GG4570@pathway.suse.cz>
 <20141105151446.5c4adb7f@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141105151446.5c4adb7f@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2014-11-05 15:14:46, Steven Rostedt wrote:
> On Wed, 5 Nov 2014 16:57:11 +0100
> Petr Mladek <pmladek@suse.cz> wrote:
> 
> > On Tue 2014-11-04 10:52:42, Steven Rostedt wrote:
> > > From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> > > 
> > > In facilitating the conversion of seq_file to use seq_buf,
> > > have the seq_buf fields match the types used by seq_file.
> > > 
> > > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > > ---
> > >  include/linux/seq_buf.h | 8 ++++----
> > >  1 file changed, 4 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/include/linux/seq_buf.h b/include/linux/seq_buf.h
> > > index 6d1c57d6073f..a4d114e6f740 100644
> > > --- a/include/linux/seq_buf.h
> > > +++ b/include/linux/seq_buf.h
> > > @@ -19,10 +19,10 @@
> > >   * @overflow:	Set if more bytes should have been written to buffer
> > >   */
> > >  struct seq_buf {
> > > -	unsigned char		*buffer;
> > > -	unsigned int		size;
> > > -	unsigned int		len;
> > > -	unsigned int		readpos;
> > > +	char			*buffer;
> > 
> > It would make sense to use "char" from the beginning. In fact, it is
> > already used on many locations in seq_buf.c. Or we might want to get
> > rid of "unsigned char" in seq_buf.c here as well.
> 
> I could, but I'm being lazy ;-) No reason to change the patch series for
> something as small as this. It doesn't break bisect.
> 
> > 
> > > +	size_t			size;
> > > +	size_t			len;
> > > +	loff_t			readpos;
> > 
> > I have just noticed that the variable is called "read_pos" in
> > seq_file. Are you going to sync the name later?
> 
> Yeah, I purposely kept them different to find the two when needed.

I see. And if I get it right, you want to use "seq_buf" in "file_seq", so
there will be only one variable and no confusion in the end.

> >
> > Also I am a bit curious that "readpos" use another type than "len"
> > and "size". Well, this is not in the scope of this patchset. I am fine
> > with keeping "loff_t" at this point.
> 
> Again, seq_file has been around for a long time with these types. But
> as you said, it's out of scope for this patch series. I'm just trying
> to keep with what's been the norm here.

Fair enough. I am fine with the explanation.

Reviewed-by: Petr Mladek <pmladek@suse.cz>

Best Regards,
Petr
