Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432AbaCJIhe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 04:37:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54607 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752411AbaCJIha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 04:37:30 -0400
Date: Mon, 10 Mar 2014 09:37:29 +0100
From: Petr =?iso-8859-1?Q?Ml=E1dek?= <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 4/4] x86: Fix order of warning messages when ftrace
 modifies code
Message-ID: <20140310083728.GA14361@pathway.suse.cz>
References: <1392650573-3390-1-git-send-email-pmladek@suse.cz>
 <1392650573-3390-5-git-send-email-pmladek@suse.cz>
 <20140307131831.0eefb839@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140307131831.0eefb839@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 07-03-14 13:18:31, Steven Rostedt wrote:
> H. Peter,
> 
> I just added this to my 3.16 queue. But can you give an Acked-by for it
> too. That way I don't forget to ask you later (3.16 is a ways away ;-)
> 
> I'd add it to my 3.15 queue, but I'm trying not to make changes to it
> unless they are more significant.

Sure, it makes sense.

Acked-by: Petr Mladek <pmladek@suse.cz>

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
