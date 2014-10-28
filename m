Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225AbaJ1Obk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 10:31:40 -0400
Received: from smtprelay0039.hostedemail.com ([216.40.44.39]:36795 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751955AbaJ1Obh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 10:31:37 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:2895:3138:3139:3140:3141:3142:3353:3622:3865:3867:3868:3871:3872:4321:5007:6119:6261:6742:7903:8660:10004:10400:10848:10967:11026:11232:11473:11658:11914:12043:12296:12517:12519:12740:13069:13148:13230:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: stick52_64ed00c64ed53
X-Filterd-Recvd-Size: 2662
Message-ID: <1414506692.6643.2.camel@perches.com>
Subject: Re: [PATCH 5/7] fs: Convert show_fdinfo functions to void
From: Joe Perches <joe@perches.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Petr Mladek <pmladek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
        Jeff Layton <jlayton@poochiereds.net>,
        "J. Bruce Fields" <bfields@fieldses.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Date: Tue, 28 Oct 2014 07:31:32 -0700
In-Reply-To: <20141028101158.3dde9880@gandalf.local.home>
References: <20140929124246.3e39dac8@gandalf.local.home>
	 <cover.1412031505.git.joe@perches.com>
	 <e37e6e7b76acbdcc3bb4ab2a57c8f8ca1ae11b9a.1412031505.git.joe@perches.com>
	 <20141028101158.3dde9880@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-28 at 10:11 -0400, Steven Rostedt wrote:
> On Mon, 29 Sep 2014 16:08:25 -0700
> Joe Perches <joe@perches.com> wrote:
> 
> > seq_printf functions shouldn't really check the return value.
> > Checking seq_is_full occasionally is used instead.
> > 
> > Update vfs documentation.
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> 
> 
> >  
> > -#ifdef CONFIG_PROC_FS
> > -static int eventfd_show_fdinfo(struct seq_file *m, struct file *f)
> > +static void eventfd_show_fdinfo(struct seq_file *m, struct file *f)
> >  {
> > +#ifdef CONFIG_PROC_FS
> >  	struct eventfd_ctx *ctx = f->private_data;
> > -	int ret;
> >  
> >  	spin_lock_irq(&ctx->wqh.lock);
> > -	ret = seq_printf(m, "eventfd-count: %16llx\n",
> > -			 (unsigned long long)ctx->count);
> > +	seq_printf(m, "eventfd-count: %16llx\n",
> > +		   (unsigned long long)ctx->count);
> >  	spin_unlock_irq(&ctx->wqh.lock);
> > -
> > -	return ret;
> > -}
> >  #endif
> > +}
> >  
> >  static const struct file_operations eventfd_fops = {
> > -#ifdef CONFIG_PROC_FS
> >  	.show_fdinfo	= eventfd_show_fdinfo,
> > -#endif
> 
> I wouldn't change logic on this. There's no reason to call this
> function if it isn't doing anything.
> 
> I'll change this to just do the update and not change logic like this.

Fewer #ifdefs


