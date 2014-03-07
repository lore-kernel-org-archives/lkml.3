Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552AbaCGInd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 03:43:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42921 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925AbaCGInb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 03:43:31 -0500
Date: Fri, 7 Mar 2014 09:43:29 +0100
From: Petr =?iso-8859-1?Q?Ml=E1dek?= <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH 4/4] x86: Fix order of warning messages when ftrace
 modifies code
Message-ID: <20140307084329.GD19132@pathway.suse.cz>
References: <1392650573-3390-1-git-send-email-pmladek@suse.cz>
 <1392650573-3390-5-git-send-email-pmladek@suse.cz>
 <20140306181953.25681923@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140306181953.25681923@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 06-03-14 18:19:53, Steven Rostedt wrote:
> 
> I'm digging through older email, and notice you dropped this patch
> from your last series. It is a rather trivial patch, and I don't really
> care if it gets applied or not. But was there a reason to drop it? Or
> do you not care either?

I wanted to keep the last patch set short and easy to apply, so I kept
only the most important changes in it.

This patch is nice to have but it is rather cosmetic. I do not mind
that much about it. Feel free to drop, accept, or just merge into
any other commit.

Best Regards,
Petr

> -- Steve
> 
> 
> On Mon, 17 Feb 2014 16:22:53 +0100
> Petr Mladek <pmladek@suse.cz> wrote:
> 
> > The colon at the end of the printk message suggests that it should get printed
> > before the details printed by ftrace_bug().
> > 
> > When touching the line, let's use the preferred pr_warn() macro as suggested
> > by checkpatch.pl.
> > 
> > Signed-off-by: Petr Mladek <pmladek@suse.cz>
> > ---
> >  arch/x86/kernel/ftrace.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
> > index 525a9f954c8b..ad7c38f5206b 100644
> > --- a/arch/x86/kernel/ftrace.c
> > +++ b/arch/x86/kernel/ftrace.c
> > @@ -622,8 +622,8 @@ void ftrace_replace_code(int enable)
> >  	return;
> >  
> >   remove_breakpoints:
> > +	pr_warn("Failed on %s (%d):\n", report, count);
> >  	ftrace_bug(ret, rec ? rec->ip : 0);
> > -	printk(KERN_WARNING "Failed on %s (%d):\n", report, count);
> >  	for_ftrace_rec_iter(iter) {
> >  		int err;
> >  
> 
